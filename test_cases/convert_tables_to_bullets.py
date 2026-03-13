#!/usr/bin/env python3
"""
Convert markdown table test steps to bullet point format
Usage: python3 convert_tables_to_bullets.py
"""

import os
import re

test_case_dir = r"g:\SafeDriver Project\safe-driver-passenger-app\test_cases"

# List of test case files to convert
test_files = [
    "TC_002_Onboarding_Profile.md",
    "TC_003_Feedback_System.md",
    "TC_004_Dashboard_Navigation.md",
    "TC_005_Location_Maps.md",
    "TC_006_Notifications_Settings.md",
    "TC_007_Safety_Emergency.md"
]

for filename in test_files:
    filepath = os.path.join(test_case_dir, filename)
    
    if not os.path.exists(filepath):
        print(f"⚠️  Skipping {filename} - file not found")
        continue
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Pattern to find and remove empty table headers
    # Match: table header line + separator line + empty space
    pattern = r'\n\| Step \| Action \| Expected Result \|\n\|[\-]+\|[\-]+\|[\-]+\|\n'
    content = re.sub(pattern, '\n', content)
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"✅ Converted: {filename}")

print("\n✨ All test case files have been converted!")
print("📝 Tables removed. Steps are now in bullet point format for easy GitHub copy-paste.")
