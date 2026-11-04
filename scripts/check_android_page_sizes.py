"""Inspect every 64-bit ELF library in an APK/AAB for 16 KB compatibility.

Usage: python scripts/check_android_page_sizes.py path/to/app.aab
APK inputs additionally check ZIP offsets for uncompressed native libraries.
AAB ZIP offsets are not APK offsets: verify bundle configuration and generated
APKs with bundletool/zipalign separately. No third-party Python packages needed.
"""

import argparse
import hashlib
import json
from pathlib import Path
import struct
import sys
import zipfile

PAGE_SIZE = 16384


def inspect_elf(data):
    if data[:4] != b"\x7fELF":
        raise ValueError("Native library is not an ELF file")
    if data[4] == 1:
        return None  # The Play requirement applies to 64-bit devices.
    if data[4] != 2 or data[5] not in (1, 2):
        raise ValueError("Unsupported ELF class or byte order")
    endian = "<" if data[5] == 1 else ">"
    phoff = struct.unpack_from(endian + "Q", data, 32)[0]
    phsize, phnum = struct.unpack_from(endian + "HH", data, 54)
    if phsize < 56 or phnum == 0:
        raise ValueError("Missing or invalid ELF program headers")
    loads, load_ranges, relro_ranges, errors = [], [], [], []
    for index in range(phnum):
        kind, _, offset, address, _, _, memory_size, alignment = struct.unpack_from(
            endian + "IIQQQQQQ", data, phoff + index * phsize
        )
        if kind == 1:  # PT_LOAD
            loads.append(alignment)
            load_ranges.append((address, address + memory_size))
            if alignment < PAGE_SIZE or alignment & (alignment - 1):
                errors.append(f"LOAD alignment {alignment} is not 16 KB-compatible")
            if (address - offset) % PAGE_SIZE:
                errors.append("LOAD address/file offset mismatch on 16 KB pages")
        elif kind == 0x6474E552:  # PT_GNU_RELRO
            relro_ranges.append((address, address + memory_size))
    # A RELRO suffix can safely protect the tail of a LOAD segment: there is
    # no writable data after it in that segment. Do not flag Flutter's suffix
    # layout merely because its logical RELRO end has 4 KB padding.
    relro = []
    for start, end in relro_ranges:
        suffix = any(load_start <= start < load_end <= end
                     for load_start, load_end in load_ranges)
        relro.append({"end_remainder": end % PAGE_SIZE, "is_load_suffix": suffix})
        if end % PAGE_SIZE and not suffix:
            errors.append("GNU_RELRO is not a LOAD suffix and its end is not 16 KB-aligned")
    if not loads:
        errors.append("No LOAD segments found")
    return {"load_alignments": loads, "relro_segments": relro, "errors": errors}


def check_archive(path):
    rows = []
    is_apk = path.suffix.lower() == ".apk"
    with zipfile.ZipFile(path) as archive, path.open("rb") as raw:
        for entry in archive.infolist():
            if not entry.filename.endswith(".so"):
                continue
            result = inspect_elf(archive.read(entry))
            if result is None:
                continue
            if is_apk and entry.compress_type == zipfile.ZIP_STORED:
                raw.seek(entry.header_offset)
                header = raw.read(30)
                name_size, extra_size = struct.unpack_from("<HH", header, 26)
                offset = entry.header_offset + 30 + name_size + extra_size
                result["zip_data_offset"] = offset
                if offset % PAGE_SIZE:
                    result["errors"].append("Uncompressed APK library ZIP offset is not 16 KB-aligned")
            rows.append({"library": entry.filename, **result})
    if not rows:
        raise ValueError("No 64-bit native libraries found; cannot validate this Flutter release")
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return {"artifact": str(path.resolve()), "sha256": digest.hexdigest(),
            "passed": all(not row["errors"] for row in rows), "libraries": rows}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("artifact", type=Path)
    parser.add_argument("--json-output", type=Path)
    args = parser.parse_args()
    try:
        report = check_archive(args.artifact)
    except (OSError, ValueError, struct.error, zipfile.BadZipFile) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        return 1
    for row in report["libraries"]:
        status = "FAIL" if row["errors"] else "PASS"
        print(f"{status}: {row['library']} (LOAD: {row['load_alignments']})")
        for error in row["errors"]:
            print(f"  {error}")
    if args.json_output:
        args.json_output.parent.mkdir(parents=True, exist_ok=True)
        args.json_output.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"{'PASS' if report['passed'] else 'FAIL'}: {len(report['libraries'])} 64-bit libraries checked")
    if args.artifact.suffix.lower() == ".aab":
        print("AAB packaging still requires bundletool config and generated-APK verification.")
    return 0 if report["passed"] else 1


if __name__ == "__main__":
    sys.exit(main())
