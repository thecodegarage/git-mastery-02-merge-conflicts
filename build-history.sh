#!/bin/bash
# Script to build realistic commit history

cd "$(dirname "$0")"

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

echo "Created 10 commits across main and 2 feature branches"
git checkout master
