# 🤖 Automated Task Tracking System for SafeDriver Project

This guide explains how to use the automated task tracking system that connects your VS Code work to your GitHub project board.

## 📋 Overview

The automation system provides:
- ✅ **Automatic issue creation** from VS Code
- ✅ **Auto-add to project board** when issues/PRs are created
- ✅ **TODO comment tracking** - converts code TODOs to GitHub issues
- ✅ **Commit-based task linking** - links commits to issues automatically
- ✅ **Smart labeling** based on content and file changes
- ✅ **Auto-closing issues** when work is completed

## 🚀 Quick Start Guide

### 1. Creating Tasks from VS Code

**Method 1: Using GitHub Issues Extension**
1. Press `Ctrl+Shift+P` (Windows) or `Cmd+Shift+P` (Mac)
2. Type "GitHub Issues: Create Issue"
3. Fill in title and description
4. ✨ **Auto-magic**: Issue appears on your GitHub project board!

**Method 2: TODO Comments (Automatic)**
Write TODO comments in your code:

```dart
// TODO: Implement driver drowsiness detection algorithm
// FIXME: Fix memory leak in camera module
// HACK: Temporary solution for GPS accuracy issue
```

✨ **Auto-magic**: These become GitHub issues when you push to main/develop branches!

**Method 3: Commit Message Creation**
Include `[create-issue]` in commit messages:

```bash
git commit -m "[create-issue] Add user authentication flow to dashboard"
```

✨ **Auto-magic**: Creates an issue with commit details!

### 2. Linking Work to Issues

**Link commits to existing issues:**
```bash
# Reference an issue (adds comment to issue)
git commit -m "Implement camera integration #15"

# Close an issue automatically
git commit -m "Fixes #15 - Camera integration completed"
git commit -m "Closes #23 - Resolved GPS accuracy"
git commit -m "Resolves #42 - Authentication bug fixed"
```

**Link Pull Requests:**
```markdown
## Pull Request Title
Fix dashboard loading issue

## Description
This PR fixes #15 and closes #23
- Fixed camera initialization
- Improved GPS accuracy
- Updated authentication flow
```

✨ **Auto-magic**: PRs get auto-labeled and linked to issues!

### 3. Smart Automation Features

**Auto-Labeling Based on Content:**
- Issue title contains "bug/error/fix" → `bug` label
- Issue title contains "feature/add/implement" → `enhancement` label  
- Issue title contains "ui/design" → `ui/ux` label
- Issue title contains "backend/firebase/api" → `backend` label
- Issue title contains "urgent/critical" → `priority: high` label

**Auto-Labeling Based on File Changes:**
- Changes in `lib/presentation/` → `ui/ux` label
- Changes in `backend/functions/` → `backend` label
- Changes in `.dart` files → `flutter` label
- Changes in test files → `testing` label

## 🎯 Workflow Examples

### Example 1: New Feature Development
```bash
# 1. Create feature branch
git checkout -b feature/driver-monitoring

# 2. Write code with TODOs
# TODO: Add driver eye tracking algorithm
# TODO: Implement fatigue detection model

# 3. Commit with issue reference
git commit -m "Add driver monitoring base structure #24"

# 4. Push (TODOs become issues automatically)
git push origin feature/driver-monitoring

# 5. Create PR that closes the issue
# PR title: "Implement driver monitoring system - Closes #24"
```

**Result**: 
- ✅ Original issue #24 gets commit comments
- ✅ New issues created from TODO comments
- ✅ PR auto-labeled as `flutter`, `enhancement`
- ✅ All items appear on project board
- ✅ Issue #24 closes when PR merges

### Example 2: Bug Fix Workflow
```bash
# 1. Create issue from VS Code
# Title: "Dashboard crashes on location permission denied"

# 2. Fix the bug
git commit -m "Handle location permission gracefully - Fixes #31"

# 3. Push
git push origin bugfix/location-permission
```

**Result**:
- ✅ Issue #31 automatically closes
- ✅ Commit details added to issue
- ✅ Task moves to "Done" on project board

### Example 3: Code Review Integration
```bash
# When creating PR:
# Title: "Refactor authentication service"
# Body: "This PR improves #18 and addresses #22"
```

**Result**:
- ✅ Issues #18 and #22 get PR linked comments
- ✅ PR gets auto-labeled based on changed files
- ✅ All stakeholders notified

## 📊 Project Board Integration

Your tasks automatically flow through the board:
```
📝 Backlog → 🚧 In Progress → 👀 Hold → ✅ QA → ✅ Done
```

**Automatic Status Updates:**
- New issues → `Backlog`
- PR created → `In Progress` 
- PR merged + "Closes #X" → `Done`
- Manual moves work as usual

## 🏷️ Available Labels

The system automatically applies these labels:

**Type Labels:**
- `bug` - Bug reports and fixes
- `enhancement` - New features
- `ui/ux` - User interface changes
- `backend` - Backend/API changes
- `flutter` - Flutter/mobile changes
- `testing` - Test-related work

**Priority Labels:**
- `priority: high` - Urgent work
- `priority: medium` - Normal priority
- `priority: low` - Nice to have

**Auto Labels:**
- `todo` - Created from TODO comments
- `auto-created` - System-generated issues
- `from-commit` - Created from commit messages

## 🛠️ Advanced Tips

### 1. Batch Issue Creation
Create multiple TODOs in one commit:
```dart
// TODO: Implement user profile validation
// TODO: Add password strength checker  
// FIXME: Memory leak in image processing
// HACK: Temporary GPS fallback logic
```

### 2. Issue Templates
Use consistent formats for better automation:
```
Title: [Component] Brief description
Example: [Dashboard] Add driver fatigue indicator

Body: 
- **What**: What needs to be done
- **Why**: Business justification  
- **Acceptance Criteria**: Definition of done
```

### 3. Commit Message Best Practices
```bash
# Good commit messages for automation:
git commit -m "feat(auth): implement OAuth login - addresses #15"
git commit -m "fix(dashboard): resolve loading spinner issue - fixes #23" 
git commit -m "docs(api): update authentication endpoints - closes #31"
```

### 4. Using Issue Numbers in Code
```dart
// Reference issues directly in code comments:
// See issue #15 for detailed requirements
// Implementation follows design in #23
// TODO: Optimize query performance (issue #31)
```

## 🚨 Troubleshooting

**Issue not appearing on project board?**
- Check if the project URL in workflows is correct
- Ensure repository has access to the organization project

**TODOs not converting to issues?**
- Make sure you push to `main`, `develop`, or `feature/*` branches
- Check that TODO format matches: `// TODO: description` or `# TODO: description`

**Auto-closing not working?**
- Use exact keywords: `fixes`, `closes`, `resolves` 
- Format: `fixes #123` or `closes #456`
- Works only when merging to main branch

## 🔧 Configuration

### Updating Project URL
Edit `.github/workflows/add-to-project.yml`:
```yaml
project-url: https://github.com/orgs/safe-driver-cluster/projects/YOUR_PROJECT_NUMBER
```

### Customizing Labels
Edit `.github/workflows/add-to-project.yml` in the `label_new_issues` job to add custom labeling rules.

### Changing TODO Keywords
Edit `.github/workflows/todo-to-issues.yml` to modify what keywords trigger issue creation.

---

## 🎉 You're All Set!

Your SafeDriver project now has a fully automated task tracking system. Every code change, commit, and PR will automatically update your GitHub project board, keeping your team informed and your project organized.

**Next Steps:**
1. Try creating an issue from VS Code
2. Write a TODO comment in your code
3. Make a commit with issue reference
4. Watch the magic happen on your project board! ✨

Happy coding! 🚀