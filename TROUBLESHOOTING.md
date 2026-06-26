# Troubleshooting - Merge Conflicts

Common issues and how to fix them.

## 🚨 Common Problems

### "I don't see any conflict markers!"

**Symptom**: File looks normal, but `git status` shows conflict.

**Causes**:
1. Wrong file opened
2. Already resolved but not staged
3. Binary file conflict (no markers in binary files)

**Solutions**:
```bash
# List conflicted files
git status
# or
git diff --name-only --diff-filter=U

# Check if binary file
file <filename>

# For binary conflicts, choose version:
git checkout --ours <file>  # or --theirs
git add <file>
```

---

### "I staged the file but Git still shows conflict!"

**Symptom**: After `git add`, `git status` still shows unmerged paths.

**Causes**:
1. Other files still have conflicts
2. Conflict markers still in file
3. Staged wrong file

**Solutions**:
```bash
# Check for remaining conflicts
git status

# Search for conflict markers
grep -r "<<<<<<< HEAD" .

# Verify the right file
git diff --cached <file>

# If markers found, fix them:
# 1. Remove markers
# 2. Stage again
git add <file>
```

---

### "Git commit won't work after resolving!"

**Symptom**: `git commit` gives error or does nothing.

**Possible Errors**:
- "fatal: cannot do a partial commit during a merge"
- "You have not concluded your merge"

**Solutions**:
```bash
# Check merge status
git status

# If files still conflicted:
git add <remaining-files>

# Complete the merge
git commit  # No message needed, uses default
# or
git commit -m "Your message"

# If stuck, check merge state
cat .git/MERGE_HEAD  # Should exist during merge
```

---

### "I accidentally committed with conflict markers!"

**Symptom**: Conflict markers (`<<<<<<<`, etc.) are in committed code.

**Solutions**:

**If not pushed yet:**
```bash
# Fix the file
code <file>  # Remove markers properly

# Amend the commit
git add <file>
git commit --amend

# Or reset and redo
git reset HEAD~1
# Fix file
git add <file>
git commit -m "Properly resolved merge"
```

**If already pushed:**
```bash
# Fix file
code <file>

# Commit fix
git add <file>
git commit -m "Fix: remove conflict markers from merged code"
git push
```

---

### "I chose the wrong version!"

**Symptom**: Merged wrong version, need to redo.

**Solutions**:

**Merge not committed yet:**
```bash
# Abort and start over
git merge --abort
git merge branch-name
# Resolve correctly this time
```

**Merge already committed:**
```bash
# Undo the merge commit
git reset --hard HEAD~1

# Or revert it (safer if pushed)
git revert -m 1 HEAD

# Then merge again correctly
git merge branch-name
```

---

### "Too many conflicts, overwhelmed!"

**Symptom**: Dozens of conflicted files.

**Strategies**:

```bash
# Abort and reconsider approach
git merge --abort

# Option 1: Update feature branch first
git checkout feature-branch
git merge master  # or git rebase master
# Resolve conflicts in feature branch
git checkout master
git merge feature-branch  # Should be clean now

# Option 2: Merge in stages
# Cherry-pick commits one at a time

# Option 3: Use merge strategy
git merge -X ours branch  # Prefer your version
# or
git merge -X theirs branch  # Prefer their version
# Still stops for genuine conflicts
```

---

### "Merge tool not opening!"

**Symptom**: `git mergetool` gives error or opens wrong tool.

**Solutions**:
```bash
# Check current config
git config --global merge.tool

# List available tools
git mergetool --tool-help

# Configure VS Code
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'

# Or use vimdiff (built-in)
git config --global merge.tool vimdiff

# Try again
git mergetool
```

---

### "Rebase keeps having conflicts!"

**Symptom**: Resolving conflicts one commit at a time, seems endless.

**Explanation**: Rebase applies each commit sequentially, so multiple conflicts expected.

**Solutions**:
```bash
# Continue through each conflict
# 1. Resolve conflict
# 2. git add <file>
# 3. git rebase --continue
# 4. Repeat for next conflict

# If too many conflicts:
git rebase --abort

# Try merge instead of rebase
git merge master  # Resolves all at once

# Or interactive rebase to squash first
git rebase -i HEAD~10  # Combine commits
# Then rebase onto master
```

---

### "File deleted but Git says conflict!"

**Symptom**: "CONFLICT (modify/delete)" - file deleted in one branch, modified in other.

**Solutions**:
```bash
# View the situation
git status  # Shows deleted file

# Option 1: Keep the file (accept modifications)
git add <file>

# Option 2: Confirm deletion
git rm <file>

# Then complete merge
git commit
```

**Decision Guide**:
- Was deletion intentional? (Check commit message)
- Are modifications important?
- Ask team member who deleted/modified

---

### "Cannot figure out what to keep!"

**Symptom**: Both versions look important, confused about resolution.

**Solutions**:

**1. Understand the changes:**
```bash
# See what each side changed
git show HEAD:<file>      # Your version
git show MERGE_HEAD:<file>  # Their version

# See the common ancestor
MERGE_BASE=$(git merge-base HEAD MERGE_HEAD)
git show $MERGE_BASE:<file>

# Compare to understand
diff <(git show HEAD:<file>) <(git show $MERGE_BASE:<file>)
```

**2. Talk to the developer:**
- Ask why they made their change
- Explain your change
- Decide together

**3. Keep both (if possible):**
- If different features, include both
- Refactor to make them work together

**4. Test after resolution:**
```bash
# Make sure code works
npm test  # or appropriate test command
```

---

### "Merge created bugs!"

**Symptom**: After merge, code doesn't work correctly.

**Common Causes**:
1. Kept one side that breaks other side
2. Combined incompatible changes
3. Missed a conflict in another file

**Solutions**:
```bash
# Find what broke
npm test  # Run tests
# or manually test features

# Check all files in merge
git diff HEAD~1 HEAD

# Might need to undo merge
git reset --hard HEAD~1

# Resolve more carefully
git merge branch-name
# This time, test after each file resolution
```

---

### "Lost code during merge!"

**Symptom**: After merge, some code is missing.

**Causes**:
1. Accidentally kept wrong version
2. Deleted needed code while resolving
3. Merged from wrong branch

**Recovery**:
```bash
# If not pushed, undo merge
git reset --hard HEAD~1

# View what was lost
git reflog  # Find commits before merge
git show <commit-hash>

# If pushed, find in history
git log --all -- <file>  # History of file
git show <commit>:<file>  # View old version

# Restore specific version
git checkout <commit> -- <file>
git commit -m "Restore lost code from merge"
```

---

### "Merge taking too long!"

**Symptom**: Still resolving conflicts after hours.

**Take a break:**
```bash
# Save your progress
git stash  # Won't work during merge, but...

# The merge state is saved!
# You can close terminal, reboot, etc.
# When you come back:
git status  # Shows you're still merging

# Continue where you left off
```

**Or abort and plan better:**
```bash
git merge --abort

# Break into smaller merges
# Or ask for help
# Or merge in feature branch first
```

---

## 🆘 Emergency Recovery

### "Everything is broken, start over!"

```bash
# Abort current merge
git merge --abort

# Return to known good state
git checkout master
git reset --hard origin/master

# Or to specific commit
git reset --hard <commit-hash>
```

### "Can't abort merge!"

```bash
# Force stop merge
git reset --hard HEAD

# Or to specific point
git reset --hard origin/master
```

### "Lost commits during merge!"

```bash
# Commits don't disappear! Find them:
git reflog

# Reflog shows all HEAD movements
# Find your lost commit
# Example output:
# abc1234 HEAD@{0}: merge: Merge made by...
# def5678 HEAD@{1}: commit: Lost commit!

# Restore it
git checkout def5678
git checkout -b recovery-branch

# Or cherry-pick it
git cherry-pick def5678
```

---

## 🔍 Diagnostic Commands

```bash
# Check if in middle of merge
ls .git/MERGE_HEAD && echo "Merge in progress" || echo "No merge"

# See what's being merged
cat .git/MERGE_HEAD

# List conflicted files
git diff --name-only --diff-filter=U

# Check for conflict markers in all files
find . -name "*.js" -o -name "*.css" | xargs grep -l "<<<<<<< HEAD"

# Verify file is actually conflicted
git ls-files -u | grep <filename>

# See merge state
cat .git/MERGE_MSG  # Default merge message
```

---

## 💡 Prevention Tips

**1. Keep branches up-to-date**
```bash
# Regularly merge/rebase from main
git checkout feature-branch
git merge main
# Resolve small conflicts incrementally
```

**2. Pull before starting work**
```bash
git checkout main
git pull
git checkout -b new-feature
```

**3. Communicate with team**
- "I'm working on file X"
- Review PRs promptly
- Don't let branches get stale

**4. Small, focused changes**
- Smaller PRs = fewer conflicts
- One feature per branch
- Merge frequently

**5. Use .gitattributes for merge strategies**
```bash
# In .gitattributes file
package-lock.json merge=ours
```

---

## 📚 When to Ask for Help

Ask teammate/mentor if:
- ❌ You don't understand what either version does
- ❌ Conflict has been ongoing for > 1 hour
- ❌ Multiple files conflict and seem related
- ❌ You're not sure if code will work after merge
- ❌ Conflict involves critical system code

**Better to ask than break production!**

---

## ✅ Verification Checklist

Before completing merge:
- [ ] All conflict markers removed
- [ ] Code syntactically valid
- [ ] Tests pass (if available)
- [ ] Code makes logical sense
- [ ] No console errors
- [ ] File saved
- [ ] Staged with `git add`
- [ ] Confident in resolution

---

## 🎓 Learning from Mistakes

After a difficult merge:
1. What caused the conflict?
2. Could it have been prevented?
3. What would you do differently?
4. Should team process change?

Document patterns you see for future reference!

---

**Remember**: Merge conflicts are learning opportunities. Every resolved conflict makes you better at the next one! 🚀
