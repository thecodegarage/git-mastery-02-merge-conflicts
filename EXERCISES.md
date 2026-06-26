# Merge Conflicts - Exercises 🎯

12 hands-on exercises to master merge conflict resolution.

## Exercise Format

Each exercise includes:
- **Objective**: What you'll learn
- **Scenario**: The problem setup
- **Tasks**: Step-by-step instructions
- **Validation**: How to verify success
- **Learning Points**: Key takeaways

## 🟢 Beginner Exercises

### Exercise 1: Simple Line Conflict

**Objective**: Resolve a basic single-line conflict

**Scenario**: Two team members updated the app name in different ways.

**Tasks**:
1. Ensure you're on the `master` branch
   ```bash
   git checkout master
   git status
   ```

2. Try to merge the priority feature
   ```bash
   git merge feature/task-priority
   ```

3. Git will report a conflict. View the conflict:
   ```bash
   git status
   # Shows conflicted files in red
   ```

4. Open `src/app.js` in your editor. Look for conflict markers:
   ```
   <<<<<<< HEAD
   // Your version
   =======
   // Their version
   >>>>>>> feature/task-priority
   ```

5. Decide what to keep, remove the markers, and save

6. Mark as resolved and complete the merge:
   ```bash
   git add src/app.js
   git status  # Should show "all conflicts fixed"
   git commit  # Complete the merge
   ```

**Validation**:
```bash
# Check merge was successful
git log --oneline -1
# Should show merge commit

# Verify file doesn't have conflict markers
grep -n "<<<" src/app.js  # Should return nothing
```

**Learning Points**:
- ✅ Conflict markers show both versions
- ✅ `git status` guides you through resolution
- ✅ Must `git add` to mark as resolved
- ✅ Use `git merge --abort` if you want to start over

---

### Exercise 2: Multiple File Conflicts

**Objective**: Handle conflicts across several files simultaneously

**Scenario**: The categories feature conflicts with the priority feature in multiple files.

**Tasks**:
1. Reset to clean state:
   ```bash
   git reset --hard master
   ```

2. Merge both feature branches to create multiple conflicts:
   ```bash
   git merge feature/task-priority
   # First merge succeeds
   
   git merge feature/task-categories
   # This creates conflicts!
   ```

3. Check which files have conflicts:
   ```bash
   git status
   # Lists all conflicted files
   ```

4. Resolve each file:
   - Open each conflicted file
   - Find conflict markers
   - Decide resolution (maybe keep both features!)
   - Remove markers
   - Save file

5. Mark all as resolved:
   ```bash
   git add src/app.js
   git add [other-files]
   # Or: git add .
   ```

6. Complete the merge:
   ```bash
   git commit -m "Merge categories and priorities features"
   ```

**Validation**:
```bash
# Verify both features work
grep -i "priority" src/app.js
grep -i "category" src/app.js
# Both should appear in the file

# Check no conflict markers remain
find . -type f -name "*.js" | xargs grep -l "<<<<<<<"
# Should return nothing
```

**Learning Points**:
- ✅ Multiple files can conflict in same merge
- ✅ Resolve each file independently
- ✅ Can combine both changes (not just choose one)
- ✅ `git add .` adds all resolved files

---

## 🟡 Intermediate Exercises

### Exercise 3: Deletion vs Modification Conflict

**Objective**: Handle case where file is deleted in one branch but modified in another

**Setup**:
Create this scenario:
```bash
# Reset to clean master
git checkout master
git reset --hard c84caf1  # Commit before branches diverged

# Create branch that deletes a file
git checkout -b feature/remove-utils
git rm src/utils.js
git commit -m "Remove unused utils file"

# Go back and create branch that modifies it
git checkout master
git checkout -b feature/add-utils
# Modify src/utils.js
echo "  capitalize(str) { return str.toUpperCase(); }" >> src/utils.js
git add src/utils.js
git commit -m "Add capitalize function to utils"
```

**Tasks**:
1. Try to merge:
   ```bash
   git checkout feature/add-utils
   git merge feature/remove-utils
   ```

2. Git reports: "CONFLICT (modify/delete)"

3. Decide: Keep the file or delete it?
   
   **Option A - Keep the file:**
   ```bash
   # File already exists (your version)
   git add src/utils.js
   ```
   
   **Option B - Delete the file:**
   ```bash
   git rm src/utils.js
   ```

4. Complete the merge:
   ```bash
   git commit -m "Resolve modify/delete conflict"
   ```

**Validation**:
```bash
# Check resolution
ls src/utils.js 2>/dev/null && echo "File kept" || echo "File deleted"

# Verify merge commit exists
git log --oneline -1
```

**Learning Points**:
- ✅ Deletion conflicts require explicit decision
- ✅ Use `git add` to keep file
- ✅ Use `git rm` to accept deletion
- ✅ Think about why file was deleted before deciding

---

### Exercise 4: Complex Multi-Line Conflict

**Objective**: Resolve conflicts in adjacent but non-overlapping code

**Scenario**: Two developers added different methods to the same class in nearby locations.

**Setup**:
```bash
git checkout master
# Branch 1: Add search method
git checkout -b feature/search
cat >> src/app.js << 'EOF'

  searchTasks(query) {
    return this.tasks.filter(t => 
      t.title.includes(query) || t.description.includes(query)
    );
  },
EOF
git add src/app.js
git commit -m "Add search functionality"

# Branch 2: Add update method
git checkout master
git checkout -b feature/update
cat >> src/app.js << 'EOF'

  updateTask(id, updates) {
    const task = this.tasks.find(t => t.id === id);
    if (task) {
      Object.assign(task, updates);
      this.saveTasks();
    }
  },
EOF
git add src/app.js
git commit -m "Add update functionality"
```

**Tasks**:
1. Merge both features:
   ```bash
   git checkout feature/search
   git merge feature/update
   # Likely conflicts
   ```

2. Open `src/app.js` and look carefully at the conflict
   - Both added code at the end
   - You likely want BOTH methods

3. Resolve by keeping both, ensuring proper syntax:
   - Proper comma placement
   - Closing braces align
   - No duplicate code

4. Test syntax if possible:
   ```bash
   node -c src/app.js  # Check syntax
   ```

5. Complete merge:
   ```bash
   git add src/app.js
   git commit -m "Merge search and update features"
   ```

**Validation**:
```bash
# Verify both methods exist
grep "searchTasks" src/app.js
grep "updateTask" src/app.js

# Check syntax
node -c src/app.js  # Should show no errors
```

**Learning Points**:
- ✅ Adjacent changes often conflict
- ✅ Can keep both by carefully combining
- ✅ Watch for syntax errors (commas, braces)
- ✅ Test code after resolving

---

### Exercise 5: Both Sides Modified Same Lines

**Objective**: Handle case where both branches changed the exact same lines differently

**Scenario**: Two developers improved the same function with different approaches.

**Setup**:
```bash
git checkout master

# Branch 1: Add error handling
git checkout -b feature/error-handling
# Modify loadTasks() to add try-catch
cat > temp_app.js << 'EOF'
  loadTasks() {
    try {
      const stored = localStorage.getItem('tasks');
      if (stored) {
        this.tasks = JSON.parse(stored);
      }
    } catch (error) {
      console.error('Failed to load tasks:', error);
      this.tasks = [];
    }
  },
EOF
# (Insert into actual file - simplified for exercise)
git add src/app.js
git commit -m "Add error handling to loadTasks"

# Branch 2: Add loading indicator
git checkout master  
git checkout -b feature/loading-indicator
# Modify loadTasks() to show loading
# (Similar approach)
git add src/app.js
git commit -m "Add loading indicator to loadTasks"
```

**Tasks**:
1. Attempt merge:
   ```bash
   git checkout feature/error-handling
   git merge feature/loading-indicator
   ```

2. Both modified the same function - decide:
   - Keep one approach?
   - Combine both features?
   - Rewrite to include both?

3. Recommended: Combine both error handling AND loading indicator

4. Complete merge:
   ```bash
   git add src/app.js
   git commit -m "Combine error handling and loading indicator"
   ```

**Validation**:
```bash
# Check both features present
grep "try" src/app.js
grep "catch" src/app.js
grep "loading" src/app.js  # If you included it

# Verify logic flow makes sense
```

**Learning Points**:
- ✅ Same-line conflicts need careful thought
- ✅ Often best to combine features
- ✅ Understand WHAT each change does, not just HOW
- ✅ Test thoroughly after complex resolutions

---

## 🔴 Advanced Exercises

### Exercise 6: CSS/Styling Conflicts

**Objective**: Resolve conflicts in CSS files

**Scenario**: Two designers styled the same component differently.

**Setup**:
```bash
git checkout master

# Branch 1: Blue theme
git checkout -b feature/blue-theme
cat > src/styles.css << 'EOF'
.task-item {
  padding: 15px;
  margin: 10px 0;
  border: 2px solid #0066cc;
  border-radius: 8px;
  background: #f0f8ff;
  box-shadow: 0 2px 4px rgba(0,102,204,0.2);
}
EOF
git add src/styles.css
git commit -m "Apply blue theme to tasks"

# Branch 2: Green theme
git checkout master
git checkout -b feature/green-theme
cat > src/styles.css << 'EOF'
.task-item {
  padding: 20px;
  margin: 10px 0;
  border: 1px solid #00cc66;
  border-radius: 5px;
  background: #f0fff4;
  box-shadow: 0 3px 6px rgba(0,204,102,0.3);
}
EOF
git add src/styles.css
git commit -m "Apply green theme to tasks"
```

**Tasks**:
1. Merge and observe conflict:
   ```bash
   git checkout feature/blue-theme
   git merge feature/green-theme
   ```

2. CSS conflicts show entire rule block in conflict

3. Decide on design:
   - Pick one theme?
   - Create new theme combining best of both?
   - Use CSS variables for theming?

4. Resolve and commit

**Validation**:
```bash
# Verify valid CSS
# No conflict markers
grep "<<<" src/styles.css  # Should be empty

# CSS is valid
# (Could use CSS validator if available)
```

**Learning Points**:
- ✅ CSS conflicts can be entire rule blocks
- ✅ Design decisions matter, not just code
- ✅ Consider creating variables/themes for future
- ✅ Test visual appearance after resolving

---

### Exercise 7: JSON Configuration Conflicts

**Objective**: Resolve conflicts in JSON files (tricky due to syntax)

**Setup**:
```bash
git checkout master

# Create config.json
cat > config.json << 'EOF'
{
  "appName": "Task Manager",
  "version": "1.0.0",
  "features": {
    "darkMode": false,
    "notifications": true
  }
}
EOF
git add config.json
git commit -m "Add JSON configuration"

# Branch 1: Add more features
git checkout -b feature/config-update-1
cat > config.json << 'EOF'
{
  "appName": "Task Manager Pro",
  "version": "1.1.0",
  "features": {
    "darkMode": true,
    "notifications": true,
    "sync": true
  }
}
EOF
git add config.json
git commit -m "Update config with sync feature"

# Branch 2: Different updates
git checkout master
git checkout -b feature/config-update-2
cat > config.json << 'EOF'
{
  "appName": "Task Manager Plus",
  "version": "1.2.0",
  "features": {
    "darkMode": false,
    "notifications": true,
    "export": true
  }
}
EOF
git add config.json
git commit -m "Update config with export feature"
```

**Tasks**:
1. Merge and see conflict:
   ```bash
   git checkout feature/config-update-1
   git merge feature/config-update-2
   ```

2. **CRITICAL**: JSON syntax must be perfect
   - Valid quotes
   - Commas in right places
   - No trailing commas
   - Proper nesting

3. Resolve conflict combining features

4. **Validate JSON before committing**:
   ```bash
   # Check JSON is valid
   cat config.json | python -m json.tool
   # Or: node -e "JSON.parse(require('fs').readFileSync('config.json'))"
   ```

5. Complete merge only if JSON is valid

**Validation**:
```bash
# Validate JSON
python -m json.tool config.json
# OR
node -e "JSON.parse(require('fs').readFileSync('config.json', 'utf8'))"

# Should not error

# Check has both features
grep "sync" config.json
grep "export" config.json
```

**Learning Points**:
- ✅ JSON conflicts are syntax-sensitive
- ✅ Always validate JSON after resolving
- ✅ Watch for trailing commas (invalid JSON)
- ✅ Use a validator before committing

---

### Exercise 8: Three-Way Merge Understanding

**Objective**: Understand the three-way merge algorithm

**Scenario**: Learn what Git compares when merging.

**Concepts**:
When Git merges, it looks at three versions:
1. **Base** (common ancestor commit)
2. **Ours** (current branch HEAD)
3. **Theirs** (branch being merged)

**Tasks**:
1. Find the merge base:
   ```bash
   git checkout master
   git merge-base master feature/task-priority
   # Shows common ancestor commit
   ```

2. View all three versions:
   ```bash
   MERGE_BASE=$(git merge-base master feature/task-priority)
   
   # Base version
   git show $MERGE_BASE:src/app.js
   
   # Our version (master)
   git show master:src/app.js
   
   # Their version (feature branch)
   git show feature/task-priority:src/app.js
   ```

3. Try the merge:
   ```bash
   git merge feature/task-priority
   ```

4. If conflict, understand:
   - What changed in master since base?
   - What changed in feature since base?
   - Why Git couldn't auto-resolve?

**Validation**:
Understanding, not code:
- Can you identify what changed in each branch?
- Can you explain why Git couldn't auto-merge?

**Learning Points**:
- ✅ Git compares three versions, not two
- ✅ Common ancestor is the comparison baseline
- ✅ Both branches' changes relative to base matter
- ✅ Understanding this helps resolve complex conflicts

---

### Exercise 9: Rebase Conflicts (Different from Merge)

**Objective**: Resolve conflicts during rebase (interactive resolution)

**Scenario**: Rebasing applies commits one-by-one, so conflicts resolve differently.

**Setup**:
```bash
git checkout master

# Create feature branch with multiple commits
git checkout -b feature/multi-commit
echo "// Change 1" >> src/app.js
git add src/app.js
git commit -m "First change"

echo "// Change 2" >> src/app.js
git add src/app.js
git commit -m "Second change"

echo "// Change 3" >> src/app.js
git add src/app.js
git commit -m "Third change"

# Make conflicting change on master
git checkout master
echo "// Master change" >> src/app.js
git add src/app.js
git commit -m "Master update"
```

**Tasks**:
1. Rebase feature branch onto master:
   ```bash
   git checkout feature/multi-commit
   git rebase master
   # Conflict on first commit!
   ```

2. **Key difference**: Rebase applies commits one at a time
   - Resolve conflict for current commit
   - Continue to next commit
   - May have more conflicts

3. Resolve the conflict:
   ```bash
   # Edit conflicted file
   # Remove markers, decide resolution
   
   git add src/app.js
   git rebase --continue
   # May prompt for next conflict!
   ```

4. Keep resolving until rebase completes

5. **If stuck or made mistake**:
   ```bash
   git rebase --abort  # Start over
   ```

**Validation**:
```bash
# Check rebase completed
git log --oneline --graph

# Feature branch should be ahead of master
git rev-list --count master..feature/multi-commit
# Should show 3 (your 3 commits)
```

**Learning Points**:
- ✅ Rebase applies commits sequentially
- ✅ May resolve multiple conflicts
- ✅ Use `git rebase --continue` after each resolution
- ✅ `git rebase --abort` to cancel
- ✅ Different from merge which resolves once

---

### Exercise 10: Cherry-Pick Conflicts

**Objective**: Resolve conflicts when cherry-picking specific commits

**Scenario**: Want to apply single commit from one branch to another.

**Setup**:
```bash
git checkout master

# Create feature with multiple commits
git checkout -b feature/mixed-changes
echo "// Feature A" >> src/app.js
git add src/app.js
git commit -m "Add feature A"

echo "// Feature B" >> src/app.js
git add src/app.js
git commit -m "Add feature B"

echo "// Feature C" >> src/app.js
git add src/app.js
git commit -m "Add feature C"

# Make conflicting change on master
git checkout master
echo "// Conflicting change" >> src/app.js
git add src/app.js
git commit -m "Master change that will conflict"
```

**Tasks**:
1. Cherry-pick just the middle commit:
   ```bash
   # Find commit hash for "Add feature B"
   git log feature/mixed-changes --oneline
   
   # Cherry-pick it
   git cherry-pick <commit-hash-of-feature-B>
   # Conflict!
   ```

2. Resolve the conflict:
   - This is just feature B's changes
   - Don't include A or C
   - Combine with master's changes

3. Complete cherry-pick:
   ```bash
   git add src/app.js
   git cherry-pick --continue
   ```

**Validation**:
```bash
# Check only feature B is applied
git log --oneline -1
# Should mention "feature B"

# Verify features A and C not included
grep "Feature A" src/app.js  # Should not find
grep "Feature B" src/app.js  # Should find
grep "Feature C" src/app.js  # Should not find
```

**Learning Points**:
- ✅ Cherry-pick can create conflicts
- ✅ Only that commit's changes should be included
- ✅ Use `git cherry-pick --abort` if needed
- ✅ `git cherry-pick --continue` to complete

---

## 🟣 Expert Exercises

### Exercise 11: Using Merge Tools

**Objective**: Use visual merge tools for complex conflicts

**Tasks**:
1. Configure a merge tool:
   ```bash
   # VS Code as merge tool
   git config --global merge.tool vscode
   git config --global mergetool.vscode.cmd 'code --wait $MERGED'
   
   # Or use built-in vimdiff
   git config --global merge.tool vimdiff
   ```

2. Create a conflict (use any previous exercise)

3. Launch the merge tool:
   ```bash
   git mergetool
   ```

4. Use the tool to resolve:
   - Visual diff shows all versions
   - Pick changes with clicks/commands
   - Save and exit

5. Complete merge:
   ```bash
   git commit
   ```

**Validation**:
```bash
# Check merge completed
git log --oneline -1

# No conflict markers
find . -name "*.js" | xargs grep "<<<<<"
```

**Learning Points**:
- ✅ Visual tools help with complex conflicts
- ✅ Popular tools: VS Code, meld, kdiff3, p4merge
- ✅ Still need to understand the conflict
- ✅ Tools don't replace understanding

---

### Exercise 12: Conflict Prevention Strategies

**Objective**: Learn practices to minimize conflicts

**Concepts** (No coding, just understanding):

1. **Small, Frequent Merges**
   - Merge/rebase often
   - Don't let branches diverge long

2. **Communication**
   - Coordinate with team on same files
   - Use branch naming conventions
   - Code reviews prevent duplicate work

3. **Modular Code**
   - Small, focused functions
   - Each person works on different modules
   - Reduce same-file editing

4. **Pull Before Push**
   - Always pull latest before starting work
   - Rebase feature branches regularly

5. **Feature Toggles**
   - Incomplete features behind flags
   - Can merge without conflicts
   - Enable when ready

**Task**: Review your past conflicts and identify:
- What caused them?
- Could they have been prevented?
- What practice would have helped?

**Learning Points**:
- ✅ Best conflict is one that doesn't happen
- ✅ Team practices matter more than Git skills
- ✅ Communication reduces conflicts
- ✅ Architecture decisions affect merge difficulty

---

## 🎯 Completion

You've completed all exercises when you can:

- ✅ Resolve conflicts confidently
- ✅ Understand what caused each conflict
- ✅ Use `git status` to guide resolution
- ✅ Combine changes from both sides when needed
- ✅ Validate resolution (tests, syntax checks)
- ✅ Know when to abort and start over
- ✅ Use merge tools when helpful

## Next Steps

1. **Take the Quiz** - Test your knowledge
2. **Score 80%+?** - Move to next topic
3. **Need more practice?** - Reset repo and retry exercises
4. **Ready for more?** - Try [Rebasing](../02-rebasing/) next!

## Quick Reference

```bash
# Start merge
git merge <branch>

# Check status
git status

# Abort merge
git merge --abort

# After resolving conflicts
git add <file>
git commit

# For rebase
git rebase --continue
git rebase --abort

# For cherry-pick
git cherry-pick --continue
git cherry-pick --abort

# Use merge tool
git mergetool
```

---

Great job working through these exercises! Merge conflicts are a normal part of development. With practice, you'll resolve them quickly and confidently! 🚀
