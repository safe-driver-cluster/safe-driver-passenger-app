#!/usr/bin/env python3
"""
Format test steps so each line gets its own bullet point
Converts grouped steps to line-by-line format
"""

import os
import re

test_case_dir = r"g:\SafeDriver Project\safe-driver-passenger-app\test_cases"

test_files = [
    "TC_001_Authentication.md",
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
        print(f"⚠️  Skipping {filename}")
        continue
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find all bullet points with steps
    # Pattern: • **Step X:** [action]
    #   Expected: [result]
    pattern = r'• \*\*Step (\d+):\*\* ([^\n]+)\n\s+Expected: ([^\n]+)'
    
    def replace_func(match):
        step_num = match.group(1)
        action = match.group(2)
        expected = match.group(3)
        
        # Format with each line as a bullet
        return f"• **Step {step_num}:** {action}\n• **Expected:** {expected}"
    
    new_content = re.sub(pattern, replace_func, content)
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print(f"✅ Formatted line-by-line: {filename}")

print("\n✨ All test steps formatted with line-by-line bullets!")
