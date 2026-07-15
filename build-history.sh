#!/bin/bash
# Script to build realistic commit history

set -e  # Exit on error

cd "$(dirname "$0")"

echo "🚀 Building Git history for merge conflicts practice..."
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Always clean up any existing feature branches first (even if src/ doesn't exist)
echo -e "${BLUE}🧹 Cleaning up any existing feature branches...${NC}"
for branch in feature/task-priority feature/task-categories feature/due-dates feature/ui-redesign feature/offline-support experimental/drag-and-drop hotfix/date-format-bug; do
    git branch -D "$branch" 2>/dev/null || true
done

# Check if src/ directory already exists
if [ -d "src" ]; then
    echo -e "${YELLOW}⚠️  Warning: Practice environment already exists${NC}"
    read -p "Delete and rebuild? This will reset all practice work. (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborting. Run script again when ready to reset."
        exit 1
    fi
    
    echo -e "${BLUE}🧹 Cleaning up existing practice environment...${NC}"
    
    # Clean up directories
    rm -rf src/ docs/ tests/
    
    # Reset to origin/master to remove practice commits
    git reset --hard origin/master 2>/dev/null || git reset --hard HEAD~20 2>/dev/null || true
    
    # Clean up any existing feature branches
    git branch | grep -v "^\*" | grep -v "master" | grep -v "main" | xargs -r git branch -D 2>/dev/null || true
    
    echo -e "${GREEN}✅ Cleanup complete${NC}"
    echo ""
fi

echo -e "${BLUE}📁 Creating project structure...${NC}"

# Create project structure
mkdir -p src tests docs

# Create initial files
cat > src/ui.js << 'EOF'
// UI Components

const UI = {
  renderTaskList(tasks) {
    const container = document.getElementById('task-list');
    container.innerHTML = tasks.map(task => `
      <div class="task ${task.completed ? 'completed' : ''}">
        <h3>${task.title}</h3>
        <p>${task.description}</p>
      </div>
    `).join('');
  }
};

module.exports = UI;
EOF

cat > src/utils.js << 'EOF'
// Utility Functions

function formatDate(date) {
  return new Date(date).toLocaleDateString();
}

function generateId() {
  return Date.now();
}

module.exports = { formatDate, generateId };
EOF

cat > src/styles.css << 'EOF'
/* Task Manager Styles */

body {
  font-family: Arial, sans-serif;
  margin: 20px;
  background-color: #f5f5f5;
}

.task {
  background: white;
  padding: 15px;
  margin: 10px 0;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.task.completed {
  opacity: 0.6;
  text-decoration: line-through;
}
EOF

# Commit utility files
git add src/ui.js src/utils.js src/styles.css
GIT_AUTHOR_NAME="Marcus Rodriguez" GIT_AUTHOR_EMAIL="marcus@example.com" \
GIT_COMMITTER_NAME="Marcus Rodriguez" GIT_COMMITTER_EMAIL="marcus@example.com" \
GIT_AUTHOR_DATE="2024-01-16T09:30:00" GIT_COMMITTER_DATE="2024-01-16T09:30:00" \
git commit -m "Add UI components and utilities"

# Add API file
cat > src/api.js << 'EOF'
// API Service Layer

const API = {
  baseUrl: 'http://localhost:3000/api',
  
  async fetchTasks() {
    const response = await fetch(`${this.baseUrl}/tasks`);
    return response.json();
  },
  
  async createTask(task) {
    const response = await fetch(`${this.baseUrl}/tasks`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(task)
    });
    return response.json();
  }
};

module.exports = API;
EOF

git add src/api.js
GIT_AUTHOR_NAME="Aisha Patel" GIT_AUTHOR_EMAIL="aisha@example.com" \
GIT_COMMITTER_NAME="Aisha Patel" GIT_COMMITTER_EMAIL="aisha@example.com" \
GIT_AUTHOR_DATE="2024-01-17T14:00:00" GIT_COMMITTER_DATE="2024-01-17T14:00:00" \
git commit -m "Add API service layer"

# Update app.js with more features
cat > src/app.js << 'EOF'
// Task Manager Application
// Main application logic

const TaskManager = {
  tasks: [],
  
  init() {
    console.log('Task Manager initialized');
    this.loadTasks();
    this.setupEventListeners();
  },
  
  setupEventListeners() {
    // Event listeners will be added here
  },
  
  loadTasks() {
    // Load tasks from storage
    const stored = localStorage.getItem('tasks');
    if (stored) {
      this.tasks = JSON.parse(stored);
    }
  },
  
  addTask(title, description) {
    const task = {
      id: Date.now(),
      title: title,
      description: description,
      completed: false,
      createdAt: new Date().toISOString()
    };
    
    this.tasks.push(task);
    this.saveTasks();
    return task;
  },
  
  deleteTask(id) {
    this.tasks = this.tasks.filter(t => t.id !== id);
    this.saveTasks();
  },
  
  saveTasks() {
    localStorage.setItem('tasks', JSON.stringify(this.tasks));
  }
};

module.exports = TaskManager;
EOF

git add src/app.js
GIT_AUTHOR_NAME="Sarah Chen" GIT_AUTHOR_EMAIL="sarah@example.com" \
GIT_COMMITTER_NAME="Sarah Chen" GIT_COMMITTER_EMAIL="sarah@example.com" \
GIT_AUTHOR_DATE="2024-01-18T10:15:00" GIT_COMMITTER_DATE="2024-01-18T10:15:00" \
git commit -m "Add event listeners and delete functionality"

# Add documentation
mkdir -p docs
cat > docs/README.md << 'EOF'
# Task Manager Documentation

## Overview

A simple task management application built with vanilla JavaScript.

## Features

- Create tasks
- View task list
- Mark tasks as complete
- Delete tasks

## Getting Started

```bash
npm install
npm start
```
EOF

git add docs/README.md
GIT_AUTHOR_NAME="Jake Thompson" GIT_AUTHOR_EMAIL="jake@example.com" \
GIT_COMMITTER_NAME="Jake Thompson" GIT_COMMITTER_EMAIL="jake@example.com" \
GIT_AUTHOR_DATE="2024-01-19T16:00:00" GIT_COMMITTER_DATE="2024-01-19T16:00:00" \
git commit -m "Add project documentation"

# Create feature branch for priorities
git checkout -b feature/task-priority

# Add priority field
cat > src/app.js << 'EOF'
// Task Manager Application
// Main application logic

const TaskManager = {
  tasks: [],
  
  init() {
    console.log('Task Manager initialized');
    this.loadTasks();
    this.setupEventListeners();
  },
  
  setupEventListeners() {
    // Event listeners will be added here
  },
  
  loadTasks() {
    // Load tasks from storage
    const stored = localStorage.getItem('tasks');
    if (stored) {
      this.tasks = JSON.parse(stored);
    }
  },
  
  addTask(title, description, priority = 'medium') {
    const task = {
      id: Date.now(),
      title: title,
      description: description,
      priority: priority,
      completed: false,
      createdAt: new Date().toISOString()
    };
    
    this.tasks.push(task);
    this.saveTasks();
    return task;
  },
  
  deleteTask(id) {
    this.tasks = this.tasks.filter(t => t.id !== id);
    this.saveTasks();
  },
  
  sortByPriority() {
    const priorityOrder = { high: 1, medium: 2, low: 3 };
    this.tasks.sort((a, b) => priorityOrder[a.priority] - priorityOrder[b.priority]);
  },
  
  saveTasks() {
    localStorage.setItem('tasks', JSON.stringify(this.tasks));
  }
};

module.exports = TaskManager;
EOF

git add src/app.js
GIT_AUTHOR_NAME="Sarah Chen" GIT_AUTHOR_EMAIL="sarah@example.com" \
GIT_COMMITTER_NAME="Sarah Chen" GIT_COMMITTER_EMAIL="sarah@example.com" \
GIT_AUTHOR_DATE="2024-01-20T11:00:00" GIT_COMMITTER_DATE="2024-01-20T11:00:00" \
git commit -m "Add priority field to tasks"

# Update UI for priorities
cat >> src/ui.js << 'EOF'

const priorityColors = {
  high: '#ff4444',
  medium: '#ffaa44',
  low: '#44ff44'
};
EOF

git add src/ui.js
GIT_AUTHOR_NAME="Sarah Chen" GIT_AUTHOR_EMAIL="sarah@example.com" \
GIT_COMMITTER_NAME="Sarah Chen" GIT_COMMITTER_EMAIL="sarah@example.com" \
GIT_AUTHOR_DATE="2024-01-20T14:30:00" GIT_COMMITTER_DATE="2024-01-20T14:30:00" \
git commit -m "Add priority colors to UI"

# Switch back to main and make different changes
git checkout master

# Update config on main
cat > src/config.js << 'EOF'
// Application Configuration

const config = {
  appName: 'Task Manager Pro',
  version: '1.1.0',
  maxTasks: 100,
  defaultView: 'list',
  autoSave: true
};

module.exports = config;
EOF

git add src/config.js
GIT_AUTHOR_NAME="Marcus Rodriguez" GIT_AUTHOR_EMAIL="marcus@example.com" \
GIT_COMMITTER_NAME="Marcus Rodriguez" GIT_COMMITTER_EMAIL="marcus@example.com" \
GIT_AUTHOR_DATE="2024-01-21T09:00:00" GIT_COMMITTER_DATE="2024-01-21T09:00:00" \
git commit -m "Update app name and add autosave config"

# Create category feature branch
git checkout -b feature/task-categories

# Add categories to app.js (THIS WILL CONFLICT)
cat > src/app.js << 'EOF'
// Task Manager Application
// Main application logic

const TaskManager = {
  tasks: [],
  categories: ['Work', 'Personal', 'Shopping', 'Health'],
  
  init() {
    console.log('Task Manager initialized');
    this.loadTasks();
    this.setupEventListeners();
  },
  
  setupEventListeners() {
    // Event listeners will be added here
  },
  
  loadTasks() {
    // Load tasks from storage
    const stored = localStorage.getItem('tasks');
    if (stored) {
      this.tasks = JSON.parse(stored);
    }
  },
  
  addTask(title, description, category = 'Personal') {
    const task = {
      id: Date.now(),
      title: title,
      description: description,
      category: category,
      completed: false,
      createdAt: new Date().toISOString()
    };
    
    this.tasks.push(task);
    this.saveTasks();
    return task;
  },
  
  filterByCategory(category) {
    return this.tasks.filter(t => t.category === category);
  },
  
  deleteTask(id) {
    this.tasks = this.tasks.filter(t => t.id !== id);
    this.saveTasks();
  },
  
  saveTasks() {
    localStorage.setItem('tasks', JSON.stringify(this.tasks));
  }
};

module.exports = TaskManager;
EOF

git add src/app.js
GIT_AUTHOR_NAME="Aisha Patel" GIT_AUTHOR_EMAIL="aisha@example.com" \
GIT_COMMITTER_NAME="Aisha Patel" GIT_COMMITTER_EMAIL="aisha@example.com" \
GIT_AUTHOR_DATE="2024-01-21T10:30:00" GIT_COMMITTER_DATE="2024-01-21T10:30:00" \
git commit -m "Add category system for tasks"

git checkout master

# Add test file
mkdir -p tests
cat > tests/app.test.js << 'EOF'
// Test Suite for Task Manager

describe('TaskManager', () => {
  test('should create new task', () => {
    const task = TaskManager.addTask('Test', 'Description');
    expect(task).toBeDefined();
  });
});
EOF

git add tests/app.test.js
GIT_AUTHOR_NAME="Jake Thompson" GIT_AUTHOR_EMAIL="jake@example.com" \
GIT_COMMITTER_NAME="Jake Thompson" GIT_COMMITTER_EMAIL="jake@example.com" \
GIT_AUTHOR_DATE="2024-01-22T09:00:00" GIT_COMMITTER_DATE="2024-01-22T09:00:00" \
git commit -m "Add initial test suite"

# Update app.js on master with search feature
cat > src/app.js << 'EOF'
// Task Manager Application
// Main application logic

const TaskManager = {
  tasks: [],
  
  init() {
    console.log('Task Manager initialized');
    this.loadTasks();
    this.setupEventListeners();
  },
  
  setupEventListeners() {
    // Event listeners will be added here
  },
  
  loadTasks() {
    // Load tasks from storage
    const stored = localStorage.getItem('tasks');
    if (stored) {
      this.tasks = JSON.parse(stored);
    }
  },
  
  addTask(title, description) {
    const task = {
      id: Date.now(),
      title: title,
      description: description,
      completed: false,
      createdAt: new Date().toISOString()
    };
    
    this.tasks.push(task);
    this.saveTasks();
    return task;
  },
  
  searchTasks(query) {
    return this.tasks.filter(t => 
      t.title.toLowerCase().includes(query.toLowerCase()) ||
      t.description.toLowerCase().includes(query.toLowerCase())
    );
  },
  
  deleteTask(id) {
    this.tasks = this.tasks.filter(t => t.id !== id);
    this.saveTasks();
  },
  
  saveTasks() {
    localStorage.setItem('tasks', JSON.stringify(this.tasks));
  }
};

module.exports = TaskManager;
EOF

git add src/app.js
GIT_AUTHOR_NAME="Sarah Chen" GIT_AUTHOR_EMAIL="sarah@example.com" \
GIT_COMMITTER_NAME="Sarah Chen" GIT_COMMITTER_EMAIL="sarah@example.com" \
GIT_AUTHOR_DATE="2024-01-22T11:00:00" GIT_COMMITTER_DATE="2024-01-22T11:00:00" \
git commit -m "Add search functionality"

# Update CSS with new styles
cat >> src/styles.css << 'EOF'

.search-box {
  margin: 20px 0;
  padding: 10px;
  width: 100%;
  font-size: 16px;
  border: 2px solid #ddd;
  border-radius: 5px;
}

.task-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.delete-button {
  background-color: #ff4444;
  color: white;
  border: none;
  padding: 5px 10px;
  border-radius: 3px;
  cursor: pointer;
}
EOF

git add src/styles.css
GIT_AUTHOR_NAME="Marcus Rodriguez" GIT_AUTHOR_EMAIL="marcus@example.com" \
GIT_COMMITTER_NAME="Marcus Rodriguez" GIT_COMMITTER_EMAIL="marcus@example.com" \
GIT_AUTHOR_DATE="2024-01-22T14:00:00" GIT_COMMITTER_DATE="2024-01-22T14:00:00" \
git commit -m "Update styles for search and delete buttons"

# Add API update method
cat >> src/api.js << 'EOF'

  async updateTask(id, updates) {
    const response = await fetch(`${this.baseUrl}/tasks/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(updates)
    });
    return response.json();
  },
  
  async deleteTask(id) {
    const response = await fetch(`${this.baseUrl}/tasks/${id}`, {
      method: 'DELETE'
    });
    return response.json();
  }
};

module.exports = API;
EOF

git add src/api.js
GIT_AUTHOR_NAME="Aisha Patel" GIT_AUTHOR_EMAIL="aisha@example.com" \
GIT_COMMITTER_NAME="Aisha Patel" GIT_COMMITTER_EMAIL="aisha@example.com" \
GIT_AUTHOR_DATE="2024-01-23T09:30:00" GIT_COMMITTER_DATE="2024-01-23T09:30:00" \
git commit -m "Add update and delete API methods"

# Create feature/ui-redesign branch
git checkout -b feature/ui-redesign

# Major UI overhaul
cat > src/ui.js << 'EOF'
// UI Components - Redesigned

const UI = {
  renderTaskList(tasks) {
    const container = document.getElementById('task-list');
    container.innerHTML = tasks.map(task => `
      <div class="task ${task.completed ? 'completed' : ''}" data-task-id="${task.id}">
        <div class="task-header">
          <h3>${task.title}</h3>
          <button class="delete-btn" onclick="deleteTask(${task.id})">×</button>
        </div>
        <p class="task-description">${task.description}</p>
        <div class="task-footer">
          <span class="task-date">${this.formatDate(task.createdAt)}</span>
          <label>
            <input type="checkbox" ${task.completed ? 'checked' : ''} 
                   onchange="toggleTask(${task.id})">
            Complete
          </label>
        </div>
      </div>
    `).join('');
  },
  
  formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', { 
      month: 'short', 
      day: 'numeric', 
      year: 'numeric' 
    });
  },
  
  showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.textContent = message;
    document.body.appendChild(notification);
    setTimeout(() => notification.remove(), 3000);
  }
};

module.exports = UI;
EOF

git add src/ui.js
GIT_AUTHOR_NAME="Sarah Chen" GIT_AUTHOR_EMAIL="sarah@example.com" \
GIT_COMMITTER_NAME="Sarah Chen" GIT_COMMITTER_EMAIL="sarah@example.com" \
GIT_AUTHOR_DATE="2024-01-23T13:00:00" GIT_COMMITTER_DATE="2024-01-23T13:00:00" \
git commit -m "Redesign task list UI with modern look"

# Update styles for new UI
cat > src/styles.css << 'EOF'
/* Task Manager Styles - Redesigned */

:root {
  --primary-color: #3498db;
  --danger-color: #e74c3c;
  --success-color: #2ecc71;
  --bg-color: #ecf0f1;
}

body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  margin: 0;
  padding: 20px;
  background-color: var(--bg-color);
}

.task {
  background: white;
  padding: 20px;
  margin: 15px 0;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  transition: all 0.3s ease;
}

.task:hover {
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  transform: translateY(-2px);
}

.task.completed {
  opacity: 0.6;
}

.task-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.task-header h3 {
  margin: 0;
  color: #2c3e50;
}

.delete-btn {
  background-color: var(--danger-color);
  color: white;
  border: none;
  width: 30px;
  height: 30px;
  border-radius: 50%;
  cursor: pointer;
  font-size: 20px;
  line-height: 1;
  transition: background-color 0.2s;
}

.delete-btn:hover {
  background-color: #c0392b;
}

.task-description {
  color: #555;
  margin: 10px 0;
}

.task-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 15px;
  padding-top: 15px;
  border-top: 1px solid #eee;
}

.task-date {
  color: #999;
  font-size: 0.9em;
}

.notification {
  position: fixed;
  top: 20px;
  right: 20px;
  padding: 15px 20px;
  border-radius: 5px;
  color: white;
  animation: slideIn 0.3s ease;
}

.notification.success {
  background-color: var(--success-color);
}

.notification.error {
  background-color: var(--danger-color);
}

@keyframes slideIn {
  from {
    transform: translateX(400px);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}
EOF

git add src/styles.css
GIT_AUTHOR_NAME="Marcus Rodriguez" GIT_AUTHOR_EMAIL="marcus@example.com" \
GIT_COMMITTER_NAME="Marcus Rodriguez" GIT_COMMITTER_EMAIL="marcus@example.com" \
GIT_AUTHOR_DATE="2024-01-23T15:00:00" GIT_COMMITTER_DATE="2024-01-23T15:00:00" \
git commit -m "Add CSS variables and animations"

# Go back to master for more changes
git checkout master

# Update utils with more functions
cat >> src/utils.js << 'EOF'

function sortByDate(tasks) {
  return tasks.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
}

function filterCompleted(tasks) {
  return tasks.filter(t => t.completed);
}

function filterIncomplete(tasks) {
  return tasks.filter(t => !t.completed);
}

module.exports = { formatDate, generateId, sortByDate, filterCompleted, filterIncomplete };
EOF

git add src/utils.js
GIT_AUTHOR_NAME="Aisha Patel" GIT_AUTHOR_EMAIL="aisha@example.com" \
GIT_COMMITTER_NAME="Aisha Patel" GIT_COMMITTER_EMAIL="aisha@example.com" \
GIT_AUTHOR_DATE="2024-01-24T10:00:00" GIT_COMMITTER_DATE="2024-01-24T10:00:00" \
git commit -m "Add sorting and filtering utilities"

# Update config with more options
cat >> src/config.js << 'EOF'

config.theme = 'light';
config.notifications = true;
config.soundEffects = false;

module.exports = config;
EOF

git add src/config.js
GIT_AUTHOR_NAME="Jake Thompson" GIT_AUTHOR_EMAIL="jake@example.com" \
GIT_COMMITTER_NAME="Jake Thompson" GIT_COMMITTER_EMAIL="jake@example.com" \
GIT_AUTHOR_DATE="2024-01-24T14:00:00" GIT_COMMITTER_DATE="2024-01-24T14:00:00" \
git commit -m "Add theme and notification settings"

# Create feature/due-dates branch
git checkout -b feature/due-dates

# Add due date functionality
cat > src/app.js << 'EOF'
// Task Manager Application
// Main application logic with due dates

const TaskManager = {
  tasks: [],
  
  init() {
    console.log('Task Manager initialized');
    this.loadTasks();
    this.setupEventListeners();
    this.checkDueDates();
  },
  
  setupEventListeners() {
    // Event listeners will be added here
  },
  
  loadTasks() {
    // Load tasks from storage
    const stored = localStorage.getItem('tasks');
    if (stored) {
      this.tasks = JSON.parse(stored);
    }
  },
  
  addTask(title, description, dueDate = null) {
    const task = {
      id: Date.now(),
      title: title,
      description: description,
      dueDate: dueDate,
      completed: false,
      createdAt: new Date().toISOString()
    };
    
    this.tasks.push(task);
    this.saveTasks();
    return task;
  },
  
  checkDueDates() {
    const now = new Date();
    const overdue = this.tasks.filter(t => {
      return !t.completed && t.dueDate && new Date(t.dueDate) < now;
    });
    
    if (overdue.length > 0) {
      console.log(`Warning: ${overdue.length} overdue tasks`);
    }
  },
  
  searchTasks(query) {
    return this.tasks.filter(t => 
      t.title.toLowerCase().includes(query.toLowerCase()) ||
      t.description.toLowerCase().includes(query.toLowerCase())
    );
  },
  
  deleteTask(id) {
    this.tasks = this.tasks.filter(t => t.id !== id);
    this.saveTasks();
  },
  
  saveTasks() {
    localStorage.setItem('tasks', JSON.stringify(this.tasks));
  }
};

module.exports = TaskManager;
EOF

git add src/app.js
GIT_AUTHOR_NAME="Sarah Chen" GIT_AUTHOR_EMAIL="sarah@example.com" \
GIT_COMMITTER_NAME="Sarah Chen" GIT_COMMITTER_EMAIL="sarah@example.com" \
GIT_AUTHOR_DATE="2024-01-25T09:00:00" GIT_COMMITTER_DATE="2024-01-25T09:00:00" \
git commit -m "Add due date support and overdue warnings"

# Update UI for due dates
cat >> src/ui.js << 'EOF'

  renderDueDateBadge(dueDate) {
    if (!dueDate) return '';
    
    const due = new Date(dueDate);
    const now = new Date();
    const isOverdue = due < now;
    
    return `<span class="due-date ${isOverdue ? 'overdue' : ''}">
      ${isOverdue ? '⚠️ ' : '📅 '}Due: ${this.formatDate(dueDate)}
    </span>`;
  }
};

module.exports = UI;
EOF

git add src/ui.js
GIT_AUTHOR_NAME="Marcus Rodriguez" GIT_AUTHOR_EMAIL="marcus@example.com" \
GIT_COMMITTER_NAME="Marcus Rodriguez" GIT_COMMITTER_EMAIL="marcus@example.com" \
GIT_AUTHOR_DATE="2024-01-25T11:00:00" GIT_COMMITTER_DATE="2024-01-25T11:00:00" \
git commit -m "Add visual indicators for due dates"

# Add due date styles
cat >> src/styles.css << 'EOF'

.due-date {
  display: inline-block;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.85em;
  background-color: #e8f5e9;
  color: #2e7d32;
}

.due-date.overdue {
  background-color: #ffebee;
  color: #c62828;
}
EOF

git add src/styles.css
GIT_AUTHOR_NAME="Marcus Rodriguez" GIT_AUTHOR_EMAIL="marcus@example.com" \
GIT_COMMITTER_NAME="Marcus Rodriguez" GIT_COMMITTER_EMAIL="marcus@example.com" \
GIT_AUTHOR_DATE="2024-01-25T13:00:00" GIT_COMMITTER_DATE="2024-01-25T13:00:00" \
git commit -m "Style due date badges"

# Switch to master and add tags feature
git checkout master

# Add tagging system
cat > src/app.js << 'EOF'
// Task Manager Application
// Main application logic with tags

const TaskManager = {
  tasks: [],
  
  init() {
    console.log('Task Manager initialized');
    this.loadTasks();
    this.setupEventListeners();
  },
  
  setupEventListeners() {
    // Event listeners will be added here
  },
  
  loadTasks() {
    // Load tasks from storage
    const stored = localStorage.getItem('tasks');
    if (stored) {
      this.tasks = JSON.parse(stored);
    }
  },
  
  addTask(title, description, tags = []) {
    const task = {
      id: Date.now(),
      title: title,
      description: description,
      tags: tags,
      completed: false,
      createdAt: new Date().toISOString()
    };
    
    this.tasks.push(task);
    this.saveTasks();
    return task;
  },
  
  addTagToTask(taskId, tag) {
    const task = this.tasks.find(t => t.id === taskId);
    if (task && !task.tags.includes(tag)) {
      task.tags.push(tag);
      this.saveTasks();
    }
  },
  
  filterByTag(tag) {
    return this.tasks.filter(t => t.tags.includes(tag));
  },
  
  searchTasks(query) {
    return this.tasks.filter(t => 
      t.title.toLowerCase().includes(query.toLowerCase()) ||
      t.description.toLowerCase().includes(query.toLowerCase())
    );
  },
  
  deleteTask(id) {
    this.tasks = this.tasks.filter(t => t.id !== id);
    this.saveTasks();
  },
  
  saveTasks() {
    localStorage.setItem('tasks', JSON.stringify(this.tasks));
  }
};

module.exports = TaskManager;
EOF

git add src/app.js
GIT_AUTHOR_NAME="Aisha Patel" GIT_AUTHOR_EMAIL="aisha@example.com" \
GIT_COMMITTER_NAME="Aisha Patel" GIT_COMMITTER_EMAIL="aisha@example.com" \
GIT_AUTHOR_DATE="2024-01-26T10:00:00" GIT_COMMITTER_DATE="2024-01-26T10:00:00" \
git commit -m "Implement task tagging system"

# Add tag UI
cat >> src/ui.js << 'EOF'

  renderTags(tags) {
    if (!tags || tags.length === 0) return '';
    return tags.map(tag => 
      `<span class="tag">${tag}</span>`
    ).join('');
  }
};

module.exports = UI;
EOF

git add src/ui.js
GIT_AUTHOR_NAME="Sarah Chen" GIT_AUTHOR_EMAIL="sarah@example.com" \
GIT_COMMITTER_NAME="Sarah Chen" GIT_COMMITTER_EMAIL="sarah@example.com" \
GIT_AUTHOR_DATE="2024-01-26T13:00:00" GIT_COMMITTER_DATE="2024-01-26T13:00:00" \
git commit -m "Add tag rendering in UI"

# Style tags
cat >> src/styles.css << 'EOF'

.tag {
  display: inline-block;
  padding: 2px 8px;
  margin: 0 4px;
  border-radius: 12px;
  font-size: 0.8em;
  background-color: #3498db;
  color: white;
}
EOF

git add src/styles.css
GIT_AUTHOR_NAME="Marcus Rodriguez" GIT_AUTHOR_EMAIL="marcus@example.com" \
GIT_COMMITTER_NAME="Marcus Rodriguez" GIT_COMMITTER_EMAIL="marcus@example.com" \
GIT_AUTHOR_DATE="2024-01-26T15:00:00" GIT_COMMITTER_DATE="2024-01-26T15:00:00" \
git commit -m "Add tag styling"

# Create hotfix branch
git checkout -b hotfix/date-format-bug

# Fix date formatting bug
cat > src/utils.js << 'EOF'
// Utility Functions - Fixed date formatting

function formatDate(date) {
  const d = new Date(date);
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  const year = d.getFullYear();
  return `${month}/${day}/${year}`;
}

function generateId() {
  return `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
}

function sortByDate(tasks) {
  return tasks.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
}

function filterCompleted(tasks) {
  return tasks.filter(t => t.completed);
}

function filterIncomplete(tasks) {
  return tasks.filter(t => !t.completed);
}

module.exports = { formatDate, generateId, sortByDate, filterCompleted, filterIncomplete };
EOF

git add src/utils.js
GIT_AUTHOR_NAME="Jake Thompson" GIT_AUTHOR_EMAIL="jake@example.com" \
GIT_COMMITTER_NAME="Jake Thompson" GIT_COMMITTER_EMAIL="jake@example.com" \
GIT_AUTHOR_DATE="2024-01-27T09:00:00" GIT_COMMITTER_DATE="2024-01-27T09:00:00" \
git commit -m "Fix: Properly pad date components and improve ID generation"

# Add tests for date formatting
cat >> tests/app.test.js << 'EOF'

describe('Date Formatting', () => {
  test('should format dates with leading zeros', () => {
    const formatted = formatDate('2024-01-05');
    expect(formatted).toBe('01/05/2024');
  });
  
  test('should handle different timezones', () => {
    const formatted = formatDate('2024-12-25T00:00:00Z');
    expect(formatted).toMatch(/\d{2}\/\d{2}\/2024/);
  });
});
EOF

git add tests/app.test.js
GIT_AUTHOR_NAME="Jake Thompson" GIT_AUTHOR_EMAIL="jake@example.com" \
GIT_COMMITTER_NAME="Jake Thompson" GIT_COMMITTER_EMAIL="jake@example.com" \
GIT_AUTHOR_DATE="2024-01-27T10:00:00" GIT_COMMITTER_DATE="2024-01-27T10:00:00" \
git commit -m "Add tests for date formatting"

# Back to master, add analytics
git checkout master

# Add analytics tracking
cat > src/analytics.js << 'EOF'
// Analytics Module

const Analytics = {
  events: [],
  
  trackEvent(category, action, label = '') {
    const event = {
      timestamp: new Date().toISOString(),
      category,
      action,
      label
    };
    
    this.events.push(event);
    this.saveEvents();
    
    console.log('Event tracked:', event);
  },
  
  trackTaskCreated(taskId) {
    this.trackEvent('Task', 'Created', taskId);
  },
  
  trackTaskCompleted(taskId) {
    this.trackEvent('Task', 'Completed', taskId);
  },
  
  trackTaskDeleted(taskId) {
    this.trackEvent('Task', 'Deleted', taskId);
  },
  
  getEventStats() {
    const stats = {};
    this.events.forEach(event => {
      const key = `${event.category}:${event.action}`;
      stats[key] = (stats[key] || 0) + 1;
    });
    return stats;
  },
  
  saveEvents() {
    localStorage.setItem('analytics', JSON.stringify(this.events));
  },
  
  loadEvents() {
    const stored = localStorage.getItem('analytics');
    if (stored) {
      this.events = JSON.parse(stored);
    }
  }
};

module.exports = Analytics;
EOF

git add src/analytics.js
GIT_AUTHOR_NAME="Aisha Patel" GIT_AUTHOR_EMAIL="aisha@example.com" \
GIT_COMMITTER_NAME="Aisha Patel" GIT_COMMITTER_EMAIL="aisha@example.com" \
GIT_AUTHOR_DATE="2024-01-28T09:00:00" GIT_COMMITTER_DATE="2024-01-28T09:00:00" \
git commit -m "Add analytics tracking module"

# Update docs with API information
cat > docs/API.md << 'EOF'
# Task Manager API Documentation

## Endpoints

### GET /api/tasks
Returns all tasks for the current user.

**Response:**
```json
{
  "tasks": [
    {
      "id": 123456,
      "title": "Buy groceries",
      "description": "Milk, eggs, bread",
      "completed": false,
      "createdAt": "2024-01-15T10:00:00Z"
    }
  ]
}
```

### POST /api/tasks
Creates a new task.

**Request Body:**
```json
{
  "title": "Task title",
  "description": "Task description"
}
```

### PUT /api/tasks/:id
Updates an existing task.

### DELETE /api/tasks/:id
Deletes a task.

## Authentication

All API requests require a valid JWT token in the Authorization header:

```
Authorization: Bearer <token>
```

## Rate Limiting

API requests are limited to 100 requests per hour per user.
EOF

git add docs/API.md
GIT_AUTHOR_NAME="Marcus Rodriguez" GIT_AUTHOR_EMAIL="marcus@example.com" \
GIT_COMMITTER_NAME="Marcus Rodriguez" GIT_COMMITTER_EMAIL="marcus@example.com" \
GIT_AUTHOR_DATE="2024-01-28T11:00:00" GIT_COMMITTER_DATE="2024-01-28T11:00:00" \
git commit -m "Add comprehensive API documentation"

# Create feature/offline-support branch
git checkout -b feature/offline-support

# Add offline detection
cat > src/offline.js << 'EOF'
// Offline Support Module

const OfflineManager = {
  isOnline: navigator.onLine,
  pendingSync: [],
  
  init() {
    window.addEventListener('online', () => this.handleOnline());
    window.addEventListener('offline', () => this.handleOffline());
  },
  
  handleOnline() {
    console.log('Connection restored');
    this.isOnline = true;
    this.syncPendingChanges();
  },
  
  handleOffline() {
    console.log('Connection lost - working offline');
    this.isOnline = false;
  },
  
  queueForSync(action, data) {
    this.pendingSync.push({ action, data, timestamp: Date.now() });
    localStorage.setItem('pendingSync', JSON.stringify(this.pendingSync));
  },
  
  async syncPendingChanges() {
    if (this.pendingSync.length === 0) return;
    
    console.log(`Syncing ${this.pendingSync.length} pending changes...`);
    
    for (const item of this.pendingSync) {
      try {
        await this.syncItem(item);
      } catch (error) {
        console.error('Sync failed:', error);
      }
    }
    
    this.pendingSync = [];
    localStorage.removeItem('pendingSync');
  },
  
  async syncItem(item) {
    // Sync logic here
    console.log('Syncing:', item);
  }
};

module.exports = OfflineManager;
EOF

git add src/offline.js
GIT_AUTHOR_NAME="Aisha Patel" GIT_AUTHOR_EMAIL="aisha@example.com" \
GIT_COMMITTER_NAME="Aisha Patel" GIT_COMMITTER_EMAIL="aisha@example.com" \
GIT_AUTHOR_DATE="2024-01-29T10:00:00" GIT_COMMITTER_DATE="2024-01-29T10:00:00" \
git commit -m "Add offline detection and sync queue"

# Add service worker
cat > src/service-worker.js << 'EOF'
// Service Worker for offline support

const CACHE_NAME = 'task-manager-v1';
const urlsToCache = [
  '/',
  '/src/app.js',
  '/src/ui.js',
  '/src/styles.css'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => response || fetch(event.request))
  );
});
EOF

git add src/service-worker.js
GIT_AUTHOR_NAME="Jake Thompson" GIT_AUTHOR_EMAIL="jake@example.com" \
GIT_COMMITTER_NAME="Jake Thompson" GIT_COMMITTER_EMAIL="jake@example.com" \
GIT_AUTHOR_DATE="2024-01-29T13:00:00" GIT_COMMITTER_DATE="2024-01-29T13:00:00" \
git commit -m "Add service worker for caching"

# Back to master, add validation
git checkout master

# Add input validation
cat > src/validation.js << 'EOF'
// Input Validation Module

const Validator = {
  validateTask(task) {
    const errors = [];
    
    if (!task.title || task.title.trim().length === 0) {
      errors.push('Title is required');
    }
    
    if (task.title && task.title.length > 100) {
      errors.push('Title must be less than 100 characters');
    }
    
    if (task.description && task.description.length > 500) {
      errors.push('Description must be less than 500 characters');
    }
    
    return {
      isValid: errors.length === 0,
      errors
    };
  },
  
  sanitizeInput(input) {
    return input
      .trim()
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#x27;');
  }
};

module.exports = Validator;
EOF

git add src/validation.js
GIT_AUTHOR_NAME="Sarah Chen" GIT_AUTHOR_EMAIL="sarah@example.com" \
GIT_COMMITTER_NAME="Sarah Chen" GIT_COMMITTER_EMAIL="sarah@example.com" \
GIT_AUTHOR_DATE="2024-01-30T09:00:00" GIT_COMMITTER_DATE="2024-01-30T09:00:00" \
git commit -m "Add input validation and sanitization"

# Add validation tests
cat >> tests/app.test.js << 'EOF'

describe('Validation', () => {
  test('should reject empty title', () => {
    const result = Validator.validateTask({ title: '' });
    expect(result.isValid).toBe(false);
    expect(result.errors).toContain('Title is required');
  });
  
  test('should reject long title', () => {
    const result = Validator.validateTask({ 
      title: 'a'.repeat(101) 
    });
    expect(result.isValid).toBe(false);
  });
  
  test('should sanitize HTML', () => {
    const clean = Validator.sanitizeInput('<script>alert("xss")</script>');
    expect(clean).not.toContain('<script>');
  });
});
EOF

git add tests/app.test.js
GIT_AUTHOR_NAME="Jake Thompson" GIT_AUTHOR_EMAIL="jake@example.com" \
GIT_COMMITTER_NAME="Jake Thompson" GIT_COMMITTER_EMAIL="jake@example.com" \
GIT_AUTHOR_DATE="2024-01-30T11:00:00" GIT_COMMITTER_DATE="2024-01-30T11:00:00" \
git commit -m "Add validation test suite"

# Update config with security settings
cat >> src/config.js << 'EOF'

config.security = {
  enableXSSProtection: true,
  enableCSRFProtection: true,
  maxTitleLength: 100,
  maxDescriptionLength: 500
};

module.exports = config;
EOF

git add src/config.js
GIT_AUTHOR_NAME="Marcus Rodriguez" GIT_AUTHOR_EMAIL="marcus@example.com" \
GIT_COMMITTER_NAME="Marcus Rodriguez" GIT_COMMITTER_EMAIL="marcus@example.com" \
GIT_AUTHOR_DATE="2024-01-30T14:00:00" GIT_COMMITTER_DATE="2024-01-30T14:00:00" \
git commit -m "Add security configuration options"

# Create experimental branch
git checkout -b experimental/drag-and-drop

# Add drag and drop
cat > src/dragdrop.js << 'EOF'
// Drag and Drop Module

const DragDrop = {
  draggedElement: null,
  
  init() {
    this.setupDragListeners();
  },
  
  setupDragListeners() {
    document.addEventListener('dragstart', e => {
      if (e.target.classList.contains('task')) {
        this.draggedElement = e.target;
        e.target.style.opacity = '0.5';
      }
    });
    
    document.addEventListener('dragend', e => {
      if (e.target.classList.contains('task')) {
        e.target.style.opacity = '1';
      }
    });
    
    document.addEventListener('dragover', e => {
      e.preventDefault();
    });
    
    document.addEventListener('drop', e => {
      e.preventDefault();
      if (this.draggedElement && e.target.classList.contains('task')) {
        this.reorderTasks(this.draggedElement, e.target);
      }
    });
  },
  
  reorderTasks(dragged, target) {
    const draggedId = dragged.dataset.taskId;
    const targetId = target.dataset.taskId;
    console.log(`Moving task ${draggedId} before ${targetId}`);
    // Reorder logic here
  }
};

module.exports = DragDrop;
EOF

git add src/dragdrop.js
GIT_AUTHOR_NAME="Sarah Chen" GIT_AUTHOR_EMAIL="sarah@example.com" \
GIT_COMMITTER_NAME="Sarah Chen" GIT_COMMITTER_EMAIL="sarah@example.com" \
GIT_AUTHOR_DATE="2024-01-31T10:00:00" GIT_COMMITTER_DATE="2024-01-31T10:00:00" \
git commit -m "Implement drag and drop reordering"

# Add drag styles
cat >> src/styles.css << 'EOF'

.task[draggable="true"] {
  cursor: move;
}

.task.dragging {
  opacity: 0.5;
}

.task.drag-over {
  border-top: 3px solid var(--primary-color);
}
EOF

git add src/styles.css
GIT_AUTHOR_NAME="Marcus Rodriguez" GIT_AUTHOR_EMAIL="marcus@example.com" \
GIT_COMMITTER_NAME="Marcus Rodriguez" GIT_COMMITTER_EMAIL="marcus@example.com" \
GIT_AUTHOR_DATE="2024-01-31T12:00:00" GIT_COMMITTER_DATE="2024-01-31T12:00:00" \
git commit -m "Add drag and drop visual feedback"

# Final commit on master - update README
git checkout master

cat >> docs/README.md << 'EOF'

## Recent Updates

### Version 1.1.0
- Added search functionality
- Improved UI/UX
- Added analytics tracking
- Added input validation
- Comprehensive API documentation

### Version 1.2.0 (Upcoming)
- Task tagging system
- Due date support
- Offline capability
- Drag and drop reordering (experimental)

## Contributing

Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.
EOF

git add docs/README.md
GIT_AUTHOR_NAME="Marcus Rodriguez" GIT_AUTHOR_EMAIL="marcus@example.com" \
GIT_COMMITTER_NAME="Marcus Rodriguez" GIT_COMMITTER_EMAIL="marcus@example.com" \
GIT_AUTHOR_DATE="2024-02-01T09:00:00" GIT_COMMITTER_DATE="2024-02-01T09:00:00" \
git commit -m "Update documentation with version history"

# Add package.json
cat > package.json << 'EOF'
{
  "name": "task-manager",
  "version": "1.1.0",
  "description": "A simple task management application",
  "main": "src/app.js",
  "scripts": {
    "start": "node server.js",
    "test": "jest",
    "lint": "eslint src/**/*.js"
  },
  "keywords": ["tasks", "productivity", "todo"],
  "author": "The Dev Team",
  "license": "MIT",
  "devDependencies": {
    "jest": "^29.0.0",
    "eslint": "^8.0.0"
  }
}
EOF

git add package.json
GIT_AUTHOR_NAME="Jake Thompson" GIT_AUTHOR_EMAIL="jake@example.com" \
GIT_COMMITTER_NAME="Jake Thompson" GIT_COMMITTER_EMAIL="jake@example.com" \
GIT_AUTHOR_DATE="2024-02-01T11:00:00" GIT_COMMITTER_DATE="2024-02-01T11:00:00" \
git commit -m "Add package.json with project metadata"

# Add .gitignore
cat > .gitignore << 'EOF'
node_modules/
.env
*.log
.DS_Store
dist/
build/
coverage/
EOF

git add .gitignore
GIT_AUTHOR_NAME="Jake Thompson" GIT_AUTHOR_EMAIL="jake@example.com" \
GIT_COMMITTER_NAME="Jake Thompson" GIT_COMMITTER_EMAIL="jake@example.com" \
GIT_AUTHOR_DATE="2024-02-01T13:00:00" GIT_COMMITTER_DATE="2024-02-01T13:00:00" \
git commit -m "Add .gitignore file"

echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo "Created 45+ commits across main and 6 feature branches"
echo ""
echo "Next steps:"
echo "  1. Verify setup: git log --oneline --graph --all"
echo "  2. Check branches: git branch -a"
echo "  3. Start exercises: open EXERCISES.md"
echo ""
echo "To reset and start over, just run ./build-history.sh again"

