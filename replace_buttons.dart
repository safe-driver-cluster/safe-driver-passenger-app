import 'dart:io';

void main() {
  final directory = Directory('lib/presentation');
  if (!directory.existsSync()) {
    print('Directory not found');
    return;
  }

  final files = directory
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  int replacedCount = 0;

  for (final file in files) {
    String content = file.readAsStringSync();
    bool modified = false;

    // Pattern for standard AppBar leading
    // leading: IconButton(
    //   icon: const Icon(Icons.arrow_back, color: Colors.white),
    //   onPressed: () => Navigator.pop(context),
    // ),
    final pattern1 = RegExp(
        r'leading:\s*IconButton\s*\(\s*icon:\s*const\s*Icon\s*\(\s*Icons\.arrow_back\s*(?:_ios)?(?:_rounded)?(?:_new)?(?:,\s*color:\s*Colors\.white)?\s*\)\s*,\s*onPressed:\s*\(\)\s*=>\s*Navigator\.pop\(context\)\s*,\s*\)',
        multiLine: true);

    if (pattern1.hasMatch(content)) {
      content = content.replaceAll(
          pattern1, 'leading: const CustomBackButton(color: Colors.white)');
      modified = true;
    }

    // Pattern for generic Row back buttons with white color
    final pattern2 = RegExp(
        r'IconButton\s*\(\s*onPressed:\s*\(\)\s*=>\s*Navigator\.pop\(context\)\s*,\s*icon:\s*const\s*Icon\s*\(\s*Icons\.arrow_back\s*(?:_ios)?(?:_rounded)?(?:_new)?(?:,\s*color:\s*Colors\.white)?\s*\)\s*,\s*\)',
        multiLine: true);

    if (pattern2.hasMatch(content)) {
      content = content.replaceAll(
          pattern2, 'const CustomBackButton(color: Colors.white)');
      modified = true;
    }

    // Pattern for the typical back arrow but without explicit color definition
    final pattern3 = RegExp(
        r'icon:\s*const\s*Icon\s*\(\s*Icons\.arrow_back\s*(?:_ios)?(?:_rounded)?(?:_new)?\s*\)',
        multiLine: true);

    if (modified) {
      // Add import if missing
      if (!content.contains('custom_back_button.dart')) {
        // Find last import
        final importIdx = content.lastIndexOf(RegExp(r"import '.*';"));
        if (importIdx != -1) {
          final endLine = content.indexOf('\n', importIdx);
          content =
              "${content.substring(0, endLine + 1)}import 'package:safedriver_passenger_app/presentation/widgets/common/custom_back_button.dart';\n${content.substring(endLine + 1)}";
        } else {
          content =
              "import 'package:safedriver_passenger_app/presentation/widgets/common/custom_back_button.dart';\n$content";
        }
      }
      file.writeAsStringSync(content);
      print('Updated: ${file.path}');
      replacedCount++;
    }
  }

  print('Total files updated: $replacedCount');
}
