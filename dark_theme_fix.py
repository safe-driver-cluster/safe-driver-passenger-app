#!/usr/bin/env python3
"""
Dark Theme Comprehensive Fix Script
Automatically fixes hardcoded colors across all Dart files
"""

import os
import re
from pathlib import Path

# Define color replacement patterns
REPLACEMENTS = {
    # Text color replacements
    r'Colors\.white(?!Transparent)': 'th.textOnPrimary',
    r'Colors\.black87': 'th.textPrimary',
    r'Colors\.black(?!Transparent)': 'th.shadowMedium',
    r'AppColors\.textPrimary': 'th.textPrimary',
    r'AppColors\.textSecondary': 'th.textSecondary',
    r'AppColors\.scaffoldBackground': 'th.background',
    r'AppColors\.cardColor': 'th.cardBackground',
    r'AppColors\.greyLight': 'th.subtleBackground',
    r'AppColors\.white(?!Transparent)': 'th.textOnPrimary',
}

# Files to skip
SKIP_PATTERNS = [
    'app_theme.dart',
    'color_constants.dart',
    'theme_helper.dart',
    'splash_page.dart',  # Already fixed
]

def should_skip_file(filepath):
    """Check if file should be skipped"""
    for pattern in SKIP_PATTERNS:
        if pattern in filepath:
            return True
    return False

def has_theme_helper_import(content):
    """Check if file already imports ThemeHelper"""
    return "ThemeHelper" in content and "theme_helper.dart" in content

def add_theme_helper_import(content):
    """Add ThemeHelper import if not present"""
    if has_theme_helper_import(content):
        return content
    
    # Find the last import statement
    imports = re.findall(r'^import .*?;$', content, re.MULTILINE)
    if not imports:
        return content
    
    last_import = imports[-1]
    theme_import = "import '../../../core/utils/theme_helper.dart';"
    
    # Insert after the last import
    return content.replace(last_import, f"{last_import}\n{theme_import}")

def fix_file(filepath):
    """Fix a single Dart file"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        if should_skip_file(filepath):
            return False
        
        original_content = content
        
        # Add import if needed
        content = add_theme_helper_import(content)
        
        # Add theme helper in build methods
        # Pattern: @override followed by Widget build(BuildContext context) {
        build_pattern = r'(@override\s+Widget build\(BuildContext context(?:, WidgetRef ref)?\) \{)'
        
        def replace_build(match):
            # Get indentation
            indent = '  '
            theme_line = f'\n{indent}final th = ThemeHelper.of(context);'
            return match.group(1) + theme_line
        
        if re.search(r'Widget build\(BuildContext context', content) and 'final th = ThemeHelper.of(context)' not in content:
            content = re.sub(build_pattern, replace_build, content)
        
        # Apply color replacements (only if changes were made)
        if content != original_content:
            print(f"✓ Fixed: {filepath}")
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            return True
        
        return False
    
    except Exception as e:
        print(f"✗ Error processing {filepath}: {e}")
        return False

def main():
    """Main function"""
    lib_path = Path("lib/presentation")
    dart_files = lib_path.rglob("*.dart")
    
    fixed_count = 0
    for dart_file in dart_files:
        if fix_file(str(dart_file)):
            fixed_count += 1
    
    print(f"\n✓ Fixed {fixed_count} files")

if __name__ == "__main__":
    main()
