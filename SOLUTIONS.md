# Exercise Solutions - Merge Conflicts

Detailed solutions for all exercises. **Try exercises yourself first!**

## 🟢 Beginner Solutions

### Exercise 1: Simple Line Conflict

**Solution:**
```bash
# 1. Start merge
git checkout master
git merge feature/task-priority

# 2. Git reports conflict in src/app.js

# 3. Open src/app.js
code src/app.js

# 4. Look for conflict (probably in addTask function):
# <<<<<<< HEAD
#   addTask(title, description) {
# =======
#   addTask(title, description, priority = 'medium') {
# >>>>>>> feature/task-priority

# 5. Resolution - Keep the priority feature:
  addTask(title, description, priority = 'medium') {

# 6. Complete merge
git add src/app.js
git commit -m "Merge task priority feature"
```

**Key Points:**
- Both versions modified the `addTask` function signature
- Priority feature adds new parameter - safe to keep
- Remove all markers, keep the enhanced version

---

### Exercise 2: Multiple Files

**Solution:**
```bash
# 1. Start fresh
git checkout master
git reset --hard c84caf1

# 2. Merge first feature
git merge feature/task-priority
# Should succeed

# 3. Merge second feature
git merge feature/task-categories
# Conflicts!

# 4. Check conflicted files
git status
# Likely: src/app.js (both modified addTask)

# 5. Open src/app.js
# Find conflict in addTask function:
# <<<<<<< HEAD
#   addTask(title, description, priority = 'medium') {
# =======
#   addTask(title, description, category = 'Personal') {
# >>>>>>> feature/task-categories

# 6. Resolution - Combine both features:
  addTask(title, description, priority = 'medium', category = 'Personal') {
    const task = {
      id: Date.now(),
      title: title,
      description: description,
      priority: priority,
      category: category,
      completed: false,
      createdAt: new Date().toISOString()
    };
    
    this.tasks.push(task);
    this.saveTasks();
    return task;
  },

# 7. Also need to include both methods:
  sortByPriority() { ... },  # From priority branch
  filterByCategory() { ... }, # From category branch

# 8. Complete merge
git add src/app.js
git commit -m "Merge priority and category features"
```

**Key Points:**
- Both features are independent - can coexist
- Combine parameters: `addTask(title, desc, priority, category)`
- Include all new methods from both branches
- Test that both features work together

---

## 🟡 Intermediate Solutions

### Exercise 3: Deletion vs Modification

**Solution:**
```bash
# After setup creates the scenario

# 1. Attempt merge
git checkout feature/add-utils
git merge feature/remove-utils
# CONFLICT (modify/delete): src/utils.js

# 2. Decision needed: File has new function, so keep it
git add src/utils.js

# 3. Complete merge
git commit -m "Keep utils.js with new capitalize function"

# Alternative: If deletion was correct
# git rm src/utils.js
# git commit -m "Remove utils.js as planned"
```

**Decision Factors:**
- Why was file deleted? (check commit message)
- Is new function needed elsewhere?
- Talk to team member who deleted it
- Can function go in different file?

**Key Points:**
- Can't automatically resolve delete vs modify
- Must explicitly choose: `git add` or `git rm`
- Consider why each side made their change

---

### Exercise 4: Complex Multi-Line Conflict

**Solution:**
```bash
# After setup

# 1. Merge
git checkout feature/search
git merge feature/update
# Conflict at end of TaskManager object

# 2. Open src/app.js
# Conflict looks like:
# <<<<<<< HEAD
#   searchTasks(query) {
#     return this.tasks.filter(t => 
#       t.title.includes(query) || t.description.includes(query)
#     );
#   },
# =======
#   updateTask(id, updates) {
#     const task = this.tasks.find(t => t.id === id);
#     if (task) {
#       Object.assign(task, updates);
#       this.saveTasks();
#     }
#   },
# >>>>>>> feature/update

# 3. Resolution - Keep BOTH methods:
  searchTasks(query) {
    return this.tasks.filter(t => 
      t.title.includes(query) || t.description.includes(query)
    );
  },
  
  updateTask(id, updates) {
    const task = this.tasks.find(t => t.id === id);
    if (task) {
      Object.assign(task, updates);
      this.saveTasks();
    }
  },
  
  saveTasks() {
    localStorage.setItem('tasks', JSON.stringify(this.tasks));
  }
};

# 4. Watch for:
# - Comma after searchTasks
# - Both methods before closing brace
# - saveTasks() stays after both

# 5. Validate syntax
node -c src/app.js

# 6. Complete merge
git add src/app.js
git commit -m "Merge search and update features"
```

**Key Points:**
- Both methods are useful - keep both
- Critical: proper comma placement
- Ensure closing braces align
- Test syntax before committing

---

### Exercise 5: Both Sides Modified Same Lines

**Solution:**
```bash
# After setup creates scenario

# 1. Merge
git checkout feature/error-handling
git merge feature/loading-indicator
# Conflict in loadTasks method

# 2. View conflict - both modified same function

# 3. Resolution - Combine BOTH features:
  loadTasks() {
    this.showLoading(true);  # From loading-indicator
    try {
      const stored = localStorage.getItem('tasks');
      if (stored) {
        this.tasks = JSON.parse(stored);
      }
    } catch (error) {
      console.error('Failed to load tasks:', error);
      this.tasks = [];
    } finally {
      this.showLoading(false);  # From loading-indicator
    }
  },

# 4. If showLoading doesn't exist yet, add it:
  showLoading(show) {
    // Implementation
    const loader = document.getElementById('loader');
    if (loader) {
      loader.style.display = show ? 'block' : 'none';
    }
  },

# 5. Complete merge
git add src/app.js
git commit -m "Combine error handling and loading indicator"
```

**Key Points:**
- Both improvements are valuable
- Try-catch-finally structure supports both
- May need to add supporting code
- Think about UX: loading indicator + error handling = good

---

## 🔴 Advanced Solutions

### Exercise 6: CSS Conflicts

**Solution:**
```bash
# After setup

# 1. Merge
git checkout feature/blue-theme
git merge feature/green-theme
# Entire .task-item rule conflicts

# 2. View conflict
# <<<<<<< HEAD
# .task-item {
#   padding: 15px;
#   border: 2px solid #0066cc;
#   background: #f0f8ff;
#   box-shadow: 0 2px 4px rgba(0,102,204,0.2);
# }
# =======
# .task-item {
#   padding: 20px;
#   border: 1px solid #00cc66;
#   background: #f0fff4;
#   box-shadow: 0 3px 6px rgba(0,204,102,0.3);
# }
# >>>>>>> feature/green-theme

# 3. Resolution Option A - Choose one theme:
.task-item {
  padding: 20px;
  margin: 10px 0;
  border: 2px solid #0066cc;
  border-radius: 8px;
  background: #f0f8ff;
  box-shadow: 0 2px 4px rgba(0,102,204,0.2);
}

# 3. Resolution Option B - Create neutral theme:
.task-item {
  padding: 18px;
  margin: 10px 0;
  border: 1px solid #666;
  border-radius: 6px;
  background: #f9f9f9;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

# 3. Resolution Option C - Use CSS variables (best):
:root {
  --primary-color: #0066cc;
  --bg-color: #f0f8ff;
}

.task-item {
  padding: 18px;
  margin: 10px 0;
  border: 1px solid var(--primary-color);
  border-radius: 6px;
  background: var(--bg-color);
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

# 4. Complete merge
git add src/styles.css
git commit -m "Merge themes with CSS variables for flexibility"
```

**Key Points:**
- Design decision, not just code
- CSS variables allow theme switching later
- Test visual appearance after merge
- Consider UX/accessibility

---

### Exercise 7: JSON Conflicts

**Solution:**
```bash
# After setup

# 1. Merge
git checkout feature/config-update-1
git merge feature/config-update-2
# Conflict in config.json

# 2. View conflict
# Both changed version, appName, and features

# 3. Resolution - Combine features, pick latest version:
{
  "appName": "Task Manager Pro",
  "version": "1.2.0",
  "features": {
    "darkMode": true,
    "notifications": true,
    "sync": true,
    "export": true
  }
}

# CRITICAL: Validate JSON syntax
# - No trailing commas
# - Proper quotes
# - Valid structure

# 4. Validate before committing
python -m json.tool config.json
# Or:
node -e "JSON.parse(require('fs').readFileSync('config.json', 'utf8'))"

# 5. If valid, complete merge
git add config.json
git commit -m "Merge config updates with sync and export features"
```

**Key Points:**
- JSON syntax must be perfect
- No trailing commas (common mistake)
- Always validate before committing
- Consider feature dependencies

---

### Exercise 8: Three-Way Merge

**Solution (Conceptual):**
```bash
# 1. Find merge base
MERGE_BASE=$(git merge-base master feature/task-priority)
echo $MERGE_BASE

# 2. View three versions
git show $MERGE_BASE:src/app.js > /tmp/base.js
git show master:src/app.js > /tmp/ours.js
git show feature/task-priority:src/app.js > /tmp/theirs.js

# 3. Compare
diff /tmp/base.js /tmp/ours.js   # What we changed
diff /tmp/base.js /tmp/theirs.js # What they changed

# 4. Understand:
# - Base: Original addTask(title, description)
# - Ours: Added autosave config
# - Theirs: Added priority parameter
# - Conflict: Both modified addTask in different ways
# - Resolution: Combine both changes

# 5. Merge with understanding
git merge feature/task-priority
# Resolve knowing what each side intended
```

**Key Points:**
- Understanding WHY conflict occurred helps resolve correctly
- Git compares to common ancestor, not just two branches
- Both changes may be important
- Context matters for good resolution

---

### Exercise 9: Rebase Conflicts

**Solution:**
```bash
# After setup

# 1. Start rebase
git checkout feature/multi-commit
git rebase master
# CONFLICT on first commit

# 2. Resolve first conflict
code src/app.js
# Remove markers, combine changes
git add src/app.js
git rebase --continue

# 3. May hit second conflict
# CONFLICT on second commit
code src/app.js
# Resolve again
git add src/app.js
git rebase --continue

# 4. Continue until rebase completes
# Might be 3 conflicts (one per commit)

# 5. Verify
git log --oneline --graph
# Your 3 commits should now be after master's changes
```

**Key Points:**
- Rebase = apply commits one-by-one
- May resolve multiple conflicts (one per commit)
- Each resolution is for that specific commit's changes
- Use `git rebase --abort` if too complex

**When to abort:**
- Too many conflicts
- Losing track of changes
- Not sure what's happening
- Better to merge instead

---

### Exercise 10: Cherry-Pick Conflicts

**Solution:**
```bash
# After setup

# 1. Find Feature B commit
git log feature/mixed-changes --oneline
# Example output:
# abc123 Add feature C
# def456 Add feature B  <-- Want this one
# ghi789 Add feature A

# 2. Cherry-pick
git checkout master
git cherry-pick def456
# CONFLICT

# 3. Open src/app.js
# See feature B's changes in conflict

# 4. Resolution:
# Include ONLY feature B
# Not A or C
# Combine with master's changes

# 5. Complete
git add src/app.js
git cherry-pick --continue
```

**Key Points:**
- Cherry-pick applies single commit
- Only that commit's changes should be included
- Don't include other commits' changes
- Use `git show <commit>` to see what it changed

---

## 🟣 Expert Solutions

### Exercise 11: Using Merge Tools

**Solution:**
```bash
# 1. Configure tool
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'

# 2. Create any conflict (use previous exercise)
git merge feature-branch  # Causes conflict

# 3. Launch merge tool
git mergetool

# 4. VS Code opens showing:
# - Current Change (yours)
# - Incoming Change (theirs)
# - Result (what will be kept)

# 5. Click options:
# - Accept Current Change
# - Accept Incoming Change
# - Accept Both Changes
# - Compare Changes

# 6. Or manually edit in Result section

# 7. Save and close VS Code

# 8. Complete merge
git commit
```

**Tool Comparison:**
- **VS Code**: Great for developers, built-in
- **Meld**: Visual, intuitive, Linux-friendly
- **Kdiff3**: Powerful, shows all 3 versions
- **P4Merge**: Professional, from Perforce
- **Vimdiff**: Fast, keyboard-driven, built-in

---

### Exercise 12: Prevention Strategies

**Solution (Practices, not code):**

**1. Small, Frequent Merges:**
```bash
# Daily: Update feature branch
git checkout feature-branch
git fetch origin
git merge origin/master
# Resolve small conflicts as they arise
```

**2. Communication:**
- Morning standup: "I'm working on authentication module"
- Before starting: Check who's working on what
- Pull requests: Review promptly
- Slack/Teams: Heads up on big changes

**3. Modular Code:**
```javascript
// Bad: One big file everyone edits
// Good: Split into modules

// utils.js - Person A
// api.js - Person B
// ui.js - Person C

// Less likely to conflict!
```

**4. Pull Before Push:**
```bash
# ALWAYS before starting work:
git checkout master
git pull
git checkout -b new-feature

# Before pushing:
git fetch origin
git rebase origin/master
git push
```

**5. Feature Toggles:**
```javascript
const features = {
  newUI: false,  // Not ready yet
  syncFeature: true  // Ready!
};

if (features.newUI) {
  // Incomplete code can be merged
  // But disabled until ready
}
```

**Team Practices:**
- Code reviews catch duplicate work
- Pair programming reduces conflicts
- Architecture: define module boundaries
- Regular refactoring keeps code clean

---

## 🎯 General Tips

### Effective Resolution Process

1. **Understand before resolving**
   - What was the goal of each change?
   - Are they compatible?
   
2. **Consider all options**
   - Keep ours
   - Keep theirs
   - Combine both
   - Rewrite better

3. **Test after resolving**
   - Run tests
   - Check functionality
   - Verify no regression

4. **When in doubt, ask**
   - Talk to the developer
   - Get second opinion
   - Better safe than sorry

### Common Patterns

**Pattern 1: Add vs Add**
- Both add different features
- Usually: Keep both

**Pattern 2: Modify vs Modify**
- Both improve same code
- Usually: Combine improvements

**Pattern 3: Delete vs Modify**
- One removes, one improves
- Decide: Is deletion still needed?

**Pattern 4: Rename vs Modify**
- Usually: Keep rename + apply modifications

### Validation Checklist

Before committing resolution:
- [ ] All conflict markers removed
- [ ] Code compiles/runs
- [ ] Tests pass
- [ ] Functionality works
- [ ] No console errors
- [ ] Makes logical sense
- [ ] Team would approve

---

**Remember**: These are example solutions. Your conflicts may differ. The key is understanding the approach, not memorizing specific resolutions! 🎯

**Ready for more?** Take the quiz, then move to the next repository!
