#!/bin/bash
# Dark Theme Batch Fix Script
# This script applies ThemeHelper fixes to all Dart files

# Color output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Dark Theme Batch Fix Script ===${NC}"
echo "Fixing hardcoded colors across all pages..."

# Function to add ThemeHelper import
add_theme_import() {
    local file=$1
    if ! grep -q "import.*theme_helper" "$file"; then
        # Find the last import line
        last_import=$(grep -n "^import" "$file" | tail -1 | cut -d: -f1)
        if [ -n "$last_import" ]; then
            sed -i "${last_import}a import '../../../core/utils/theme_helper.dart';" "$file"
            echo -e "${GREEN}✓${NC} Added ThemeHelper import to $(basename $file)"
        fi
    fi
}

# Function to add ThemeHelper initialization in build
add_theme_init() {
    local file=$1
    if grep -q "Widget build(BuildContext context)" "$file"; then
        if ! grep -q "final th = ThemeHelper.of(context)" "$file"; then
            # This requires more complex sed, will be done manually
            echo -e "${BLUE}→${NC} Manual check needed for $(basename $file) - build method"
        fi
    fi
}

# Process all dart files in presentation/pages
echo -e "\n${BLUE}Processing pages...${NC}"
for file in lib/presentation/pages/**/*.dart; do
    if [ -f "$file" ]; then
        # Skip already fixed files
        if [[ "$file" == *"splash_page"* ]] || [[ "$file" == *"faq_page"* ]]; then
            continue
        fi
        
        add_theme_import "$file"
        add_theme_init "$file"
    fi
done

echo -e "\n${GREEN}Batch fix complete!${NC}"
echo "Next steps:"
echo "1. Run: dart analyze lib/"
echo "2. Manually add 'final th = ThemeHelper.of(context);' to build methods"
echo "3. Replace hardcoded colors with theme-aware alternatives"
