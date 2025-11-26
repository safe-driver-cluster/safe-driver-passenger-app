# 🎯 VS Code Settings for Automated Task Tracking

## Recommended Extensions

Install these VS Code extensions for optimal task tracking:

```vscode-extensions
GitHub.vscode-pull-request-github,Gruntfuggly.todo-tree,aaron-bond.better-comments
```

## VS Code Settings Configuration

Add these settings to your VS Code workspace or user settings:

```json
{
  "todo-tree.regex.regex": "((//|#|<!--|;|/\\*|^)\\s*($TAGS)\\s*:?\\s*(.*?)(?=\\*/|-->|$))",
  "todo-tree.regex.regexCaseSensitive": false,
  "todo-tree.general.tags": [
    "TODO",
    "FIXME", 
    "HACK",
    "NOTE",
    "BUG",
    "XXX",
    "ISSUE"
  ],
  "todo-tree.highlights.defaultHighlight": {
    "type": "text",
    "foreground": "#ffffff",
    "background": "#ffcc00",
    "opacity": 50,
    "iconColour": "#ffcc00"
  },
  "todo-tree.highlights.customHighlight": {
    "TODO": {
      "background": "#ffcc00",
      "iconColour": "#ffcc00"
    },
    "FIXME": {
      "background": "#ff6b6b", 
      "iconColour": "#ff6b6b"
    },
    "HACK": {
      "background": "#ffa500",
      "iconColour": "#ffa500" 
    },
    "NOTE": {
      "background": "#4ecdc4",
      "iconColour": "#4ecdc4"
    },
    "BUG": {
      "background": "#ff4757",
      "iconColour": "#ff4757"
    }
  },
  "githubIssues.queries": [
    {
      "label": "My Issues",
      "query": "default"
    },
    {
      "label": "Created Issues", 
      "query": "author:${user} state:open repo:${owner}/${repository} sort:created-desc"
    },
    {
      "label": "Recent Issues",
      "query": "state:open repo:${owner}/${repository} sort:updated-desc"
    }
  ],
  "githubPullRequests.queries": [
    {
      "label": "Waiting For My Review",
      "query": "is:open is:pr review-requested:${user}"
    },
    {
      "label": "Assigned To Me", 
      "query": "is:open is:pr assignee:${user}"
    },
    {
      "label": "Created By Me",
      "query": "is:open is:pr author:${user}"
    }
  ]
}
```

## Quick Actions Setup

### Command Palette Shortcuts

Set up these keyboard shortcuts in VS Code (`Ctrl+K Ctrl+S`):

```json
[
  {
    "key": "ctrl+shift+i",
    "command": "githubIssues.createIssueFromSelection",
    "when": "editorHasSelection"
  },
  {
    "key": "ctrl+shift+t",
    "command": "todo-tree.toggleStatusBarHighlight"
  },
  {
    "key": "ctrl+shift+alt+t", 
    "command": "todo-tree.showTree"
  }
]
```

### Snippets for TODO Comments

Create a `dart.json` file in your VS Code snippets folder:

```json
{
  "TODO Comment": {
    "prefix": "todo",
    "body": [
      "// TODO: $1"
    ],
    "description": "Insert TODO comment"
  },
  "FIXME Comment": {
    "prefix": "fixme", 
    "body": [
      "// FIXME: $1"
    ],
    "description": "Insert FIXME comment"
  },
  "Issue Reference": {
    "prefix": "issue",
    "body": [
      "// See issue #$1 for details"
    ],
    "description": "Reference GitHub issue"
  },
  "Feature TODO": {
    "prefix": "feat-todo",
    "body": [
      "// TODO: Implement $1",
      "// - [ ] $2", 
      "// - [ ] $3",
      "// Issue: #$4"
    ],
    "description": "Detailed feature TODO"
  }
}
```

## Git Integration

### Commit Message Templates

Create a `.gitmessage` file in your repository root:

```
# <type>(<scope>): <subject>
#
# <body>
#
# Closes #<issue-number>
# 
# Type should be one of the following:
# * feat: A new feature
# * fix: A bug fix  
# * docs: Documentation changes
# * style: Changes that do not affect the code meaning
# * refactor: A code change that neither fixes a bug nor adds a feature
# * test: Adding missing tests or correcting existing tests
# * chore: Changes to the build process or auxiliary tools
#
# Examples:
# feat(auth): add OAuth2 integration - closes #123
# fix(dashboard): resolve loading spinner issue - fixes #456
# docs(api): update authentication endpoints - addresses #789
```

Configure git to use this template:
```bash
git config commit.template .gitmessage
```

### Git Hooks for Automation

Create `.git/hooks/commit-msg` (make it executable):

```bash
#!/bin/sh
# Check if commit message follows conventional format

commit_regex='^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .{1,50}'

if ! grep -qE "$commit_regex" "$1"; then
    echo "Invalid commit message format!"
    echo "Please use: type(scope): description"
    echo "Example: feat(auth): add login functionality"
    exit 1
fi
```

## Dashboard Integration

### Custom Status Bar

Add this to your VS Code settings for a custom status bar showing GitHub info:

```json
{
  "githubIssues.workingIssue.enabled": true,
  "githubPullRequests.showInSCM": true,
  "git.showPushSuccessNotification": true
}
```

## Workspace Configuration

Create `.vscode/settings.json` in your repository:

```json
{
  "files.exclude": {
    "**/.git": false,
    "**/.github": false
  },
  "search.exclude": {
    "**/node_modules": true,
    "**/build": true,
    "**/.dart_tool": true
  },
  "todo-tree.tree.showScanOpenFilesOrWorkspaceButton": true,
  "todo-tree.tree.showRefreshButton": true,
  "githubIssues.createIssueTriggers": [
    "TODO",
    "FIXME", 
    "HACK"
  ]
}
```

---

This configuration will optimize your VS Code environment for seamless integration with the automated task tracking system!