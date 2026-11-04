#!/usr/bin/env python3
"""
Convert markdown table test steps to fully formatted bullet points
This script converts pipe-formatted table rows to clean bullet point format
"""

import os
import re

test_case_dir = r"g:\SafeDriver Project\safe-driver-passenger-app\test_cases"

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
        print(f"⚠️  Skipping {filename}")
        continue
    
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    new_lines = []
    i = 0
    while i < len(lines):
        line = lines[i]
        
        # Check if this is a table row (starts with |, contains steps)
        if line.strip().startswith('|') and '|' in line:
            # Parse the pipe-delimited row
            parts = [p.strip() for p in line.split('|')]
            # Remove empty first and last elements (from | at start/end)
            parts = [p for p in parts if p]
            
            # If it looks like a step row (has 3 parts: step#, action, result)
            if len(parts) >= 3:
                step_num = parts[0]
                action = parts[1]
                result = parts[2] if len(parts) > 2 else ""
                
                # Check if step_num is numeric
                if step_num and (step_num[0].isdigit() or step_num.startswith('•')):
                    # Format as bullet point
                    bullet_line = f"• **Step {step_num}:** {action}\n"
                    if result:
                        bullet_line += f"  Expected: {result}\n"
                    new_lines.append(bullet_line)
                    i += 1
                    continue
        
        new_lines.append(line)
        i += 1
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.writelines(new_lines)
    
    print(f"✅ Fully converted: {filename}")

print("\n✨ All test steps converted to bullet point format!")
print("🎉 Ready for GitHub copy-paste!")
