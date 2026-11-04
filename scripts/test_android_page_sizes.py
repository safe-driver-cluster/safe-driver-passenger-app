"""Regression tests for ELF validation used by the release audit."""

import struct
import unittest

from check_android_page_sizes import inspect_elf


def elf(*headers):
    data = bytearray(64 + 56 * len(headers))
    data[:6] = b"\x7fELF\x02\x01"
    struct.pack_into("<Q", data, 32, 64)
    struct.pack_into("<HH", data, 54, 56, len(headers))
    for index, header in enumerate(headers):
        struct.pack_into("<IIQQQQQQ", data, 64 + 56 * index, *header)
    return data


class PageSizeTests(unittest.TestCase):
    def test_aligned_load(self):
        result = inspect_elf(elf((1, 6, 0, 0, 0, 0x8000, 0x8000, 0x4000)))
        self.assertEqual(result["errors"], [])

    def test_four_kilobyte_load_fails(self):
        result = inspect_elf(elf((1, 6, 0, 0, 0, 0x8000, 0x8000, 0x1000)))
        self.assertTrue(result["errors"])

    def test_offset_mismatch_fails_even_with_aligned_header(self):
        result = inspect_elf(elf((1, 6, 0, 0x1000, 0, 0x8000, 0x8000, 0x4000)))
        self.assertTrue(result["errors"])

    def test_relro_prefix_with_unaligned_end_fails(self):
        result = inspect_elf(elf(
            (1, 6, 0, 0, 0, 0x8000, 0x8000, 0x4000),
            (0x6474E552, 4, 0, 0, 0, 0x1000, 0x1000, 1),
        ))
        self.assertTrue(result["errors"])

    def test_relro_suffix_with_unaligned_end_passes(self):
        result = inspect_elf(elf(
            (1, 6, 0, 0, 0, 0x5000, 0x5000, 0x4000),
            (0x6474E552, 4, 0x4000, 0x4000, 0, 0x1000, 0x1000, 1),
        ))
        self.assertEqual(result["errors"], [])

    def test_invalid_native_file_fails(self):
        with self.assertRaises(ValueError):
            inspect_elf(b"invalid library")


if __name__ == "__main__":
    unittest.main()
