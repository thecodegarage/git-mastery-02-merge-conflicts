# Git Cheat Sheet - Complete Reference

Comprehensive Git command reference with focus on merge conflicts.

---

## 🎯 Quick Reference - Merge Conflicts

**Most common commands for this topic:**

```bash
# Start merge
git merge <branch-name>

# Check conflicts
git status                    # See conflicted files
git diff                      # View conflict details

# View versions
git show :2:<file>            # Ours (current branch)
git show :3:<file>            # Theirs (merging branch)

# Resolve
# 1. Edit file, remove conflict markers (<<<<<<< ======= >>>>>>>)
# 2. Stage resolved file
git add <file>
# 3. Complete merge
git commit

# Abort if needed
git merge --abort
```

**Conflict markers in file:**
```
<<<<<<< HEAD
Your version (current branch)
=======
Their version (merging branch)
>>>>>>> branch-name
```

---

## 📚 Complete Git Command Reference

Below is a comprehensive reference for all essential Git commands.

---

## ⚙️ Configuration

```bash
# Set your identity
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Set default editor
git config --global core.editor "code --wait"  # VS Code
git config --global core.editor "vim"          # Vim

# View configuration
git config --list
git config user.name
git config user.email

# Configuration levels
git config --global   # User-level (~/.gitconfig)
git config --local    # Repository-level (.git/config)
git config --system   # System-level
```

## 📦 Creating Repositories

```bash
# Initialize new repository
git init

# Clone existing repository
git clone <url>
git clone <url> <folder-name>

# Clone specific branch
git clone -b <branch-name> <url>
```

## 📊 Status & Information

```bash
# Check repository status
git status
git status -s  # Short format

# View commit history
git log
git log --oneline
git log --oneline --graph --all
git log --stat                    # Show files changed
git log -p                        # Show actual changes
git log -n 5                      # Last 5 commits
git log --author="Name"
git log --grep="search term"
git log --since="2 weeks ago"
git log --until="yesterday"

# View specific commit
git show <commit-hash>
git show HEAD
git show HEAD~1  # Previous commit
git show HEAD~2  # 2 commits ago

# View file history
git log -- <file>
git log -p -- <file>

# Count commits
git rev-list --count HEAD
```

## ➕ Staging & Committing

```bash
# Stage files
git add <file>
git add <file1> <file2>
git add .              # All files in current directory
git add -A             # All files in repository
git add *.js           # All JS files
git add src/           # All files in directory

# View staged changes
git diff --staged
git diff --cached

# Unstage files
git restore --staged <file>
git reset HEAD <file>           # Old way

# Commit
git commit -m "Commit message"
git commit                      # Opens editor for message
git commit -am "Message"        # Stage all tracked files and commit

# Amend last commit
git commit --amend -m "New message"
git commit --amend --no-edit    # Keep same message
```

## 🔍 Viewing Changes

```bash
# View unstaged changes
git diff
git diff <file>

# View staged changes
git diff --staged
git diff --cached

# Compare commits
git diff <commit1> <commit2>
git diff HEAD~1 HEAD

# Compare branches
git diff <branch1>..<branch2>
git diff master..feature-branch

# Show changed files only
git diff --name-only
git diff --name-status

# View conflicts with color
git diff --color-words
```

## ↩️ Undoing Changes

```bash
# Discard changes in working directory
git restore <file>
git checkout -- <file>          # Old way

# Unstage files
git restore --staged <file>
git reset HEAD <file>           # Old way

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Revert a commit (creates new commit)
git revert <commit-hash>

# Reset to specific commit
git reset --hard <commit-hash>  # DANGEROUS: loses changes
git reset --soft <commit-hash>  # Keep changes staged
git reset --mixed <commit-hash> # Keep changes unstaged
```

## 🌿 Branching

```bash
# List branches
git branch              # Local branches
git branch -r           # Remote branches
git branch -a           # All branches
git branch -v           # With last commit

# Create branch
git branch <branch-name>

# Switch branch
git switch <branch-name>
git checkout <branch-name>      # Old way

# Create and switch
git switch -c <branch-name>
git checkout -b <branch-name>   # Old way

# Rename branch
git branch -m <old-name> <new-name>
git branch -m <new-name>        # Rename current branch

# Delete branch
git branch -d <branch-name>     # Safe delete (must be merged)
git branch -D <branch-name>     # Force delete

# Show current branch
git branch --show-current
```

## 🔀 Merging

```bash
# Merge branch into current branch
git merge <branch-name>

# Merge with no fast-forward
git merge --no-ff <branch-name>

# Merge with commit message
git merge <branch-name> -m "Merge message"

# Abort merge
git merge --abort

# Continue merge after resolving conflicts
git merge --continue

# View merged branches
git branch --merged
git branch --no-merged

# Choose strategy for conflicts
git merge -X ours <branch>      # Favor our changes
git merge -X theirs <branch>    # Favor their changes
```

## 🔧 Merge Conflict Resolution

```bash
# Check which files have conflicts
git status
git diff --name-only --diff-filter=U

# View different versions
git show :1:<file>  # Base (common ancestor)
git show :2:<file>  # Ours (current branch)
git show :3:<file>  # Theirs (merging branch)

# Use merge tool
git mergetool
git mergetool --tool=vimdiff

# Choose version for entire file
git checkout --ours <file>      # Keep our version
git checkout --theirs <file>    # Keep their version
git add <file>

# After resolving conflicts
git add <resolved-file>
git commit                      # Complete merge

# Abort and start over
git merge --abort
```

## 🔄 Rebasing

```bash
# Rebase current branch onto another
git rebase <branch>
git rebase master

# Interactive rebase (edit history)
git rebase -i HEAD~3            # Last 3 commits
git rebase -i <commit-hash>

# During rebase conflicts:
# 1. Resolve conflicts
# 2. Stage files
git add <file>
# 3. Continue
git rebase --continue

# Skip commit during rebase
git rebase --skip

# Abort rebase
git rebase --abort

# Rebase onto specific point
git rebase --onto <new-base> <old-base> <branch>
```

## 🌐 Remote Repositories

```bash
# View remotes
git remote
git remote -v
git remote show origin

# Add remote
git remote add <name> <url>
git remote add origin https://github.com/user/repo.git

# Remove remote
git remote remove <name>
git remote rm <name>

# Rename remote
git remote rename <old> <new>

# Fetch from remote
git fetch <remote>
git fetch origin
git fetch --all

# Pull (fetch + merge)
git pull <remote> <branch>
git pull origin master
git pull                        # From tracking branch
git pull --rebase              # Pull with rebase instead of merge

# Push to remote
git push <remote> <branch>
git push origin master
git push -u origin master       # Set upstream tracking
git push                        # To tracking branch

# Push all branches
git push --all origin

# Push tags
git push --tags

# Force push (DANGEROUS on shared branches)
git push --force
git push --force-with-lease    # Safer force push

# View remote branches
git branch -r
git ls-remote
```

## 🏷️ Tags

```bash
# List tags
git tag
git tag -l "v1.*"

# Create lightweight tag
git tag <tag-name>
git tag v1.0.0

# Create annotated tag
git tag -a <tag-name> -m "Message"
git tag -a v1.0.0 -m "Release version 1.0.0"

# Tag specific commit
git tag <tag-name> <commit-hash>

# View tag details
git show <tag-name>

# Delete tag
git tag -d <tag-name>

# Push tag to remote
git push origin <tag-name>
git push origin --tags
```

## 🙈 Ignoring Files

```bash
# Create .gitignore
touch .gitignore

# Common patterns
node_modules/     # Ignore directory
*.log             # Ignore all .log files
!important.log    # Exception (don't ignore this)
build/            # Build artifacts
.env              # Environment files
*.tmp             # Temporary files

# Check if file is ignored
git check-ignore <file>
git check-ignore -v <file>  # Show which rule

# List ignored files
git status --ignored

# Remove tracked file now in .gitignore
git rm --cached <file>
git rm -r --cached <directory>
```

## 🔧 Stashing

```bash
# Save work in progress
git stash
git stash save "Message"

# List stashes
git stash list

# Apply most recent stash
git stash apply
git stash pop  # Apply and remove

# Apply specific stash
git stash apply stash@{1}

# View stash contents
git stash show
git stash show -p  # Show diff

# Delete stash
git stash drop stash@{0}
git stash clear  # Delete all

# Create branch from stash
git stash branch <branch-name>
```

## 🍒 Cherry-picking

```bash
# Apply specific commit to current branch
git cherry-pick <commit-hash>

# Cherry-pick without committing
git cherry-pick -n <commit-hash>
git cherry-pick --no-commit <commit-hash>

# Cherry-pick range
git cherry-pick <commit1>..<commit2>

# Abort cherry-pick
git cherry-pick --abort

# Continue after resolving conflicts
git cherry-pick --continue
```

## 🔍 Searching & Debugging

```bash
# Search for text in files
git grep "search term"
git grep -n "search term"  # Show line numbers
git grep -i "search term"  # Case insensitive

# Find who changed a line
git blame <file>
git blame -L 10,20 <file>  # Lines 10-20

# Find commit that introduced a bug
git bisect start
git bisect bad           # Current commit is bad
git bisect good <commit> # Known good commit
# Git checks out commits to test
git bisect reset         # When done

# View reflog (recover lost commits)
git reflog
git reflog show <branch>
```

## 🧹 Cleanup

```bash
# Remove untracked files
git clean -n              # Dry run (show what would be deleted)
git clean -f              # Delete untracked files
git clean -fd             # Delete untracked files and directories
git clean -fX             # Delete only ignored files
git clean -fx             # Delete ignored and untracked files

# Prune remote tracking branches
git remote prune origin
git fetch --prune

# Garbage collection
git gc
git gc --aggressive
```

## 📚 Help & Documentation

```bash
# Get help
git help <command>
git <command> --help
git <command> -h       # Quick help

# Examples
git help commit
git help merge
git log --help
```

## 🎯 Common Workflows

### Resolving Merge Conflicts
```bash
git merge feature-branch     # Creates conflict
git status                   # See conflicted files
# Edit files, remove markers
git add <resolved-files>
git commit                   # Complete merge
```

### Starting Work
```bash
git status              # Check current state
git pull                # Get latest changes
git switch -c feature   # Create feature branch
# ... make changes ...
git add .
git commit -m "Add feature"
git push -u origin feature
```

### Daily Workflow
```bash
git status              # What's changed?
git diff                # Review changes
git add <files>         # Stage changes
git commit -m "Message" # Commit
git push                # Share with team
```

### Before Switching Branches
```bash
git status              # Any uncommitted changes?
git stash               # Save work in progress
git switch <branch>     # Switch branch
git stash pop           # Restore work
```

## ⚠️ Dangerous Commands

These commands can lose work - use carefully!

```bash
# Resets and discards work
git reset --hard
git clean -fd
git checkout -- <file>

# Rewrites history (bad for shared branches)
git commit --amend
git rebase
git reset
git filter-branch

# Force push (overwrites remote)
git push --force
git push --force-with-lease  # Safer alternative
```

## 💡 Pro Tips

```bash
# Create aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual 'log --oneline --graph --all'

# Now use shortcuts
git st      # Instead of git status
git co      # Instead of git checkout
git visual  # Pretty log
```

## 🚀 Quick Reference Table

| Command | Purpose |
|---------|---------|
| `git status` | Check what's changed |
| `git add <file>` | Stage file |
| `git commit -m "msg"` | Commit changes |
| `git push` | Upload to remote |
| `git pull` | Download from remote |
| `git log` | View history |
| `git diff` | See changes |
| `git branch` | List branches |
| `git switch <branch>` | Change branch |
| `git merge <branch>` | Merge branch |
| `git merge --abort` | Cancel merge |
| `git restore <file>` | Discard changes |

---

**Remember:** `git status` is your friend - use it constantly to understand where you are!

## 🍒 Cherry-Pick Conflicts

```bash
# Cherry-pick a commit
git cherry-pick <commit-hash>

# If conflict occurs:
# 1. Resolve conflict
# 2. Stage file:
git add <file>

# 3. Continue:
git cherry-pick --continue

# Abort cherry-pick
git cherry-pick --abort
```

## 📊 Understanding Conflicts

```bash
# Find merge base (common ancestor)
git merge-base <branch1> <branch2>

# See commits on both branches since divergence
git log --oneline --graph --all

# See what changed in their branch
git log HEAD..MERGE_HEAD

# See what changed in our branch
git log MERGE_HEAD..HEAD

# View commit from branch being merged
git show MERGE_HEAD
```

## 🔧 Conflict Markers

When you open a conflicted file, you'll see:

```
<<<<<<< HEAD
Your current branch's content
This is what's in your branch now
=======
The incoming branch's content
This is what they want to merge in
>>>>>>> branch-name
```

**Your job:**
1. Decide what to keep
2. Edit to desired final version
3. Remove ALL markers (`<<<<<<<`, `=======`, `>>>>>>>`)
4. Save file

## 💡 Resolution Strategies

```bash
# Keep ours (current branch version)
git checkout --ours <file>
git add <file>

# Keep theirs (incoming branch version)
git checkout --theirs <file>
git add <file>

# Interactive resolution (best for complex)
# Edit file manually, remove markers
git add <file>
```

## 🛠️ Merge Tools

```bash
# Configure merge tool
git config --global merge.tool <tool-name>

# Available tools:
# - vscode (Visual Studio Code)
# - vimdiff (Vim)
# - meld (Meld)
# - kdiff3
# - p4merge (Perforce)

# Example: VS Code
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'

# Launch merge tool
git mergetool

# Launch specific tool
git mergetool -t vscode
```

## 🔍 Inspection Commands

```bash
# List conflicted files
git diff --name-only --diff-filter=U

# Show conflicts only
git diff --check

# Count conflicts
git diff --name-only --diff-filter=U | wc -l

# See detailed conflict info
git ls-files -u

# Check if in middle of merge
git status | grep "You have unmerged paths"
```

## 📝 Special Cases

### Delete vs Modify Conflict

```bash
# File deleted in one branch, modified in other
# Git will show: "CONFLICT (modify/delete)"

# Keep the file:
git add <file>

# Delete the file:
git rm <file>

# Then complete merge:
git commit
```

### Binary File Conflicts

```bash
# Binary files can't be merged automatically
# Must choose one version

# Keep our version:
git checkout --ours <file>
git add <file>

# Keep their version:
git checkout --theirs <file>
git add <file>
```

### Renamed File Conflicts

```bash
# File renamed in one branch, modified in other
# Usually Git handles this, but sometimes conflicts

# Accept rename and changes:
git add <new-name>
git commit
```

## ⚡ Pro Tips

```bash
# See merge in progress
cat .git/MERGE_HEAD  # Shows commit being merged

# Rerere (Reuse Recorded Resolution)
# Git remembers how you resolved conflicts
git config --global rerere.enabled true
# Next time same conflict occurs, auto-resolves!

# Merge with strategy
git merge -X ours <branch>    # Prefer our version
git merge -X theirs <branch>  # Prefer their version
# (Still stops for conflicts it can't auto-resolve)

# See what automerge would do without doing it
git merge --no-commit --no-ff <branch>
git diff --cached  # See what would be merged
git merge --abort  # Undo the test
```

## 🎯 Quick Resolution Workflow

```bash
# 1. Attempt merge
git merge feature-branch

# 2. If conflict, check status
git status

# 3. Open conflicted file
code $(git diff --name-only --diff-filter=U)

# 4. Resolve conflicts
# - Find <<<<<<< markers
# - Decide what to keep
# - Remove markers
# - Save

# 5. Stage resolved files
git add .

# 6. Verify no markers remain
git diff --check

# 7. Complete merge
git commit
```

## 🆘 Emergency Commands

```bash
# I messed up the resolution!
git merge --abort
# Try again

# I committed but it was wrong!
git reset --hard HEAD~1
# Warning: Loses the bad merge commit

# I want to see the original conflicts again
git checkout -m <file>
# Re-creates conflict markers

# Show me what I'm merging before I do it
git log ..feature-branch  # Commits in feature not in current
git diff ...feature-branch  # Changes that would be merged
```

## 📖 Understanding Git Merge

Git performs a **three-way merge**:
1. Finds common ancestor (merge base)
2. Compares your changes to base
3. Compares their changes to base
4. Combines changes
5. Conflicts when both changed same lines

```bash
# See the three versions:
BASE=$(git merge-base HEAD other-branch)
git show $BASE:file.txt      # Original
git show HEAD:file.txt       # Yours
git show other-branch:file.txt  # Theirs
```

## 🔗 Related Commands

```bash
# Merge with log message
git merge --log <branch>

# Merge with squash (no merge commit)
git merge --squash <branch>
git commit -m "Merged features"

# See merge history
git log --merges

# See non-merge commits only
git log --no-merges

# Graphical log
git log --graph --oneline --all
```

---

## Quick Reference Card

| Task | Command |
|------|---------|
| Start merge | `git merge branch-name` |
| Check status | `git status` |
| View conflict | `code file` or `cat file` |
| Mark resolved | `git add file` |
| Complete merge | `git commit` |
| Abort merge | `git merge --abort` |
| Use merge tool | `git mergetool` |
| Keep ours | `git checkout --ours file` |
| Keep theirs | `git checkout --theirs file` |
| Continue rebase | `git rebase --continue` |
| Abort rebase | `git rebase --abort` |

---

**Remember**: Conflicts are normal! They mean Git needs your help deciding what the code should look like. Take your time, understand both changes, and choose wisely. 🎯
