# Repository 2: Merge Conflicts 🔀

**Master the art of resolving merge conflicts with confidence**

## 🎯 Learning Objectives

By completing this repository, you will:

- ✅ Understand what causes merge conflicts
- ✅ Identify conflicting sections in files
- ✅ Resolve conflicts using manual editing
- ✅ Handle conflicts in different file types
- ✅ Use merge strategies effectively
- ✅ Prevent conflicts when possible
- ✅ Recover from botched merges
- ✅ Work with merge tools

## 📊 Difficulty Level

🟡 **Intermediate** 

**Prerequisites:**
- Basic Git commands (add, commit, branch, checkout)
- Understanding of branches and HEAD
- Comfort with text editors
- Basic understanding of diff format

**Estimated Time:** 4-6 hours

## 🏗️ Repository Setup

This repository simulates a **Task Management App** project with contributions from multiple team members. The commit history includes:

- **45 commits** from 4 different developers
- **Multiple feature branches** with overlapping changes
- **Intentional conflicts** in various file types
- **Real-world scenarios** you'll encounter on teams

### Team Members (Fictional)
- **Sarah Chen** - Frontend lead
- **Marcus Rodriguez** - Backend developer  
- **Aisha Patel** - Full-stack developer
- **Jake Thompson** - DevOps engineer

## 📚 What's Included

- **EXERCISES.md** - 12 hands-on exercises (2-3 conflicts each)
- **GIT-CHEATSHEET.md** - Conflict resolution commands
- **SOLUTIONS.md** - Detailed solutions for each exercise
- **TROUBLESHOOTING.md** - Common issues and fixes

## 🚀 Getting Started

### 1. Verify Repository Setup

```bash
# You should be in this directory
pwd
# Should show: .../01-merge-conflicts

# Verify Git is initialized
git status

# View commit history
git log --oneline --graph --all
```

### 2. Understand the Project

This is a simple task management application with:

```
src/
├── app.js           # Main application logic
├── ui.js            # User interface components
├── api.js           # API service layer
├── utils.js         # Utility functions
├── config.js        # Configuration
└── styles.css       # Styling

docs/
├── README.md        # Project documentation
└── API.md           # API documentation

tests/
└── app.test.js      # Test suite
```

### 3. Explore Branches

```bash
# List all branches
git branch -a

# You should see:
# * main
#   feature/task-priority
#   feature/task-categories
#   feature/search
#   feature/ui-redesign
#   hotfix/date-bug
#   experimental/new-architecture
```

### 4. Start with Exercise 1

Open EXERCISES.md and begin!

```bash
code EXERCISES.md
# Or: cat EXERCISES.md
```

## 💡 Key Concepts

### What is a Merge Conflict?

A merge conflict occurs when Git cannot automatically reconcile differences between two commits. This typically happens when:

1. **Same lines modified** - Two branches change the same lines
2. **File deleted in one branch** - Modified in another
3. **Binary files conflict** - Non-text files changed differently

### Conflict Markers

When Git detects a conflict, it marks the file like this:

```
<<<<<<< HEAD
Your current branch's content
=======
The incoming branch's content
>>>>>>> branch-name
```

- `<<<<<<< HEAD` - Start of your changes
- `=======` - Separator
- `>>>>>>> branch-name` - End of incoming changes

### Your Job

1. **Examine both versions** - Understand what changed and why
2. **Decide what to keep** - May be one side, other side, or combination
3. **Remove conflict markers** - Clean up the `<<<<<<<`, `=======`, `>>>>>>>`
4. **Test the result** - Make sure it works!
5. **Mark as resolved** - `git add` the file
6. **Complete the merge** - `git commit` (or `git merge --continue`)

## 🎓 Learning Strategy

### Recommended Approach

1. **Do exercises in order** - They build on each other
2. **Try before peeking** - Attempt to solve first
3. **Understand why** - Don't just follow steps mechanically
4. **Experiment** - Try different approaches
5. **Use git status** - It guides you through the process
6. **Make mistakes** - Learn from breaking things!

### If You Get Stuck

1. **Read Git's output** - It often tells you what to do
2. **Check TROUBLESHOOTING.md** - Common issues covered
3. **Use git status** - Shows current state
4. **Check SOLUTIONS.md** - But try first!
5. **Abort and retry** - `git merge --abort` lets you start over

## 📈 Progress Tracking

Track your exercise completion:

- [ ] Exercise 1: Simple Conflict
- [ ] Exercise 2: Multiple Files
- [ ] Exercise 3: Delete vs Modify
- [ ] Exercise 4: Complex Multi-Line
- [ ] Exercise 5: Both Sides Modified
- [ ] Exercise 6: CSS Conflicts
- [ ] Exercise 7: JSON Conflicts
- [ ] Exercise 8: Three-Way Conflicts
- [ ] Exercise 9: Rebase Conflicts
- [ ] Exercise 10: Cherry-Pick Conflicts
- [ ] Exercise 11: Merge Tool Practice
- [ ] Exercise 12: Prevention Strategies

## ✅ Completion Criteria

You've mastered merge conflicts when you can:

1. ✅ Identify why a conflict occurred
2. ✅ Read and understand conflict markers
3. ✅ Resolve conflicts correctly
4. ✅ Complete a merge without data loss
5. ✅ Choose appropriate conflict resolution strategy
6. ✅ Use `git merge --abort` when needed
7. ✅ Score 80%+ on the Merge Conflicts quiz

## 🎯 Next Steps

After completing this repository:

1. **Take the quiz** - Test your knowledge
2. **Score 80%+?** - Move to next repository
3. **Below 80%?** - Retry exercises, retake quiz
4. **Want more practice?** - Delete repo and re-clone!

### Recommended Next Topics

- **Easier:** [Branching Strategies](../06-branching-strategies/)
- **Similar difficulty:** [Remote Workflows](../04-remote-workflows/)
- **More challenging:** [Rebasing](../02-rebasing/)

## 🛠️ Reset Instructions

### Start an Exercise Over

```bash
# Abort current merge
git merge --abort

# Return to clean state
git checkout main
git reset --hard origin/main  # If you have remote
```

### Reset Entire Repository

```bash
# From parent directory
cd ..
rm -rf 01-merge-conflicts
# Re-copy from original
```

## 📚 Additional Resources

- [Git Documentation - Basic Merge Conflicts](https://git-scm.com/docs/git-merge#_how_conflicts_are_presented)
- [Atlassian - Merge Conflicts](https://www.atlassian.com/git/tutorials/using-branches/merge-conflicts)
- Use `git help merge` in terminal

---

**Ready to start?** Open [EXERCISES.md](EXERCISES.md) and begin with Exercise 1!

**Questions?** Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues.
