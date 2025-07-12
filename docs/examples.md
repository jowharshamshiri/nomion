---
layout: default
title: Examples
---

# Refac Examples

Learn how to use Refac through practical, real-world examples. Each example includes the problem, solution, and step-by-step implementation.

## Table of Contents

1. [Modernizing Legacy JavaScript](#modernizing-legacy-javascript)
2. [Refactoring React Components](#refactoring-react-components)
3. [Python Code Cleanup](#python-code-cleanup)
4. [Large-Scale Renaming](#large-scale-renaming)
5. [Extract and Modularize](#extract-and-modularize)
6. [API Migration](#api-migration)

## Modernizing Legacy JavaScript

### Problem
You have legacy JavaScript code using outdated patterns:

```javascript
// legacy.js
var utils = {
  getUserData: function(id, callback) {
    var self = this;
    $.ajax({
      url: '/api/users/' + id,
      success: function(data) {
        callback(null, data);
      },
      error: function(err) {
        callback(err);
      }
    });
  }
};
```

### Solution

Step 1: Convert var to const/let
```bash
refac transform --pattern 'var' --replacement 'const' --path ./legacy.js
```

Step 2: Convert to arrow functions
```bash
refac modernize-functions --arrow --path ./legacy.js
```

Step 3: Replace jQuery with fetch
```bash
refac transform \
  --pattern '$.ajax({ url: $url, success: $success, error: $error })' \
  --replacement 'fetch($url).then($success).catch($error)' \
  --ast --path ./legacy.js
```

### Result
```javascript
// legacy.js (modernized)
const utils = {
  getUserData: async (id) => {
    try {
      const response = await fetch(`/api/users/${id}`);
      return await response.json();
    } catch (err) {
      throw err;
    }
  }
};
```

## Refactoring React Components

### Problem
You have React class components that should be converted to functional components:

```javascript
// UserProfile.jsx
import React, { Component } from 'react';

class UserProfile extends Component {
  constructor(props) {
    super(props);
    this.state = {
      loading: true,
      user: null
    };
  }

  componentDidMount() {
    this.fetchUser();
  }

  fetchUser = () => {
    fetch(`/api/users/${this.props.userId}`)
      .then(res => res.json())
      .then(user => this.setState({ user, loading: false }));
  }

  render() {
    if (this.state.loading) return <div>Loading...</div>;
    return <div>{this.state.user.name}</div>;
  }
}
```

### Solution

Step 1: Extract the data fetching logic
```bash
refac extract-method \
  --pattern 'fetch(`/api/users/${this.props.userId}`)' \
  --name 'useUserData' \
  --path ./UserProfile.jsx
```

Step 2: Convert to functional component
```bash
refac transform-react-component \
  --from class \
  --to functional \
  --hooks \
  --path ./UserProfile.jsx
```

### Result
```javascript
// UserProfile.jsx (refactored)
import React, { useState, useEffect } from 'react';

const useUserData = (userId) => {
  const [loading, setLoading] = useState(true);
  const [user, setUser] = useState(null);

  useEffect(() => {
    fetch(`/api/users/${userId}`)
      .then(res => res.json())
      .then(user => {
        setUser(user);
        setLoading(false);
      });
  }, [userId]);

  return { loading, user };
};

const UserProfile = ({ userId }) => {
  const { loading, user } = useUserData(userId);

  if (loading) return <div>Loading...</div>;
  return <div>{user.name}</div>;
};

export default UserProfile;
```

## Python Code Cleanup

### Problem
You have Python code with inconsistent naming and outdated patterns:

```python
# data_processor.py
def ProcessData(input_list):
    OutputList = []
    for i in range(len(input_list)):
        if input_list[i] > 0:
            OutputList.append(input_list[i] * 2)
    return OutputList

def calculate_average(numbersList):
    total = 0
    for num in numbersList:
        total = total + num
    return total / len(numbersList)
```

### Solution

Step 1: Fix naming conventions
```bash
refac enforce-naming --style snake_case --type functions --fix --path ./data_processor.py
refac enforce-naming --style snake_case --type variables --fix --path ./data_processor.py
```

Step 2: Modernize loops
```bash
refac transform \
  --pattern 'for i in range(len($list))' \
  --replacement 'for i, item in enumerate($list)' \
  --language python \
  --path ./data_processor.py
```

Step 3: Use list comprehensions
```bash
refac transform \
  --pattern 'for $item in $list: if $cond: $result.append($expr)' \
  --replacement '$result = [$expr for $item in $list if $cond]' \
  --ast --language python \
  --path ./data_processor.py
```

### Result
```python
# data_processor.py (cleaned up)
def process_data(input_list):
    return [item * 2 for item in input_list if item > 0]

def calculate_average(numbers_list):
    return sum(numbers_list) / len(numbers_list) if numbers_list else 0
```

## Large-Scale Renaming

### Problem
Your codebase uses inconsistent naming for API endpoints:

```javascript
// Multiple files across the codebase
getUserInfo()
fetchUserData()
loadUserDetails()
getUserProfile()
```

### Solution

Step 1: Find all variations
```bash
refac find-pattern '(get|fetch|load)User(Info|Data|Details|Profile)' \
  --language javascript \
  --output user-functions.txt
```

Step 2: Create a mapping file
```json
// rename-mapping.json
{
  "getUserInfo": "fetchUserProfile",
  "fetchUserData": "fetchUserProfile",
  "loadUserDetails": "fetchUserProfile",
  "getUserProfile": "fetchUserProfile"
}
```

Step 3: Apply bulk rename
```bash
refac bulk-rename --mapping rename-mapping.json --path ./src
```

Step 4: Update imports
```bash
refac update-imports --changed-functions rename-mapping.json --path ./src
```

## Extract and Modularize

### Problem
You have a large file with mixed concerns:

```javascript
// app.js (1000+ lines)
// Authentication logic
function login(username, password) { /* ... */ }
function logout() { /* ... */ }
function checkAuth() { /* ... */ }

// User management
function createUser(data) { /* ... */ }
function updateUser(id, data) { /* ... */ }
function deleteUser(id) { /* ... */ }

// Data processing
function processOrder(order) { /* ... */ }
function calculateTotals(items) { /* ... */ }
// ... many more functions
```

### Solution

Step 1: Identify function groups
```bash
refac analyze-functions --suggest-modules --path ./app.js
```

Step 2: Extract authentication module
```bash
refac extract-module \
  --functions 'login,logout,checkAuth' \
  --to './modules/auth.js' \
  --path ./app.js
```

Step 3: Extract user management module
```bash
refac extract-module \
  --pattern '*User*' \
  --to './modules/users.js' \
  --path ./app.js
```

Step 4: Extract data processing module
```bash
refac extract-module \
  --pattern 'process*,calculate*' \
  --to './modules/dataProcessing.js' \
  --path ./app.js
```

### Result
```javascript
// app.js (refactored)
import * as auth from './modules/auth.js';
import * as users from './modules/users.js';
import * as dataProcessing from './modules/dataProcessing.js';

// Clean, modular structure with proper separation of concerns
```

## API Migration

### Problem
You need to migrate from an old API to a new one across your entire codebase:

```javascript
// Old API usage scattered across files
api.getItems(callback);
api.saveItem(item, callback);
api.removeItem(id, callback);
```

### Solution

Step 1: Create transformation rules
```javascript
// api-migration.rules.js
module.exports = {
  rules: [
    {
      pattern: 'api.getItems($callback)',
      replacement: 'await newApi.items.list()',
      async: true
    },
    {
      pattern: 'api.saveItem($item, $callback)',
      replacement: 'await newApi.items.save($item)',
      async: true
    },
    {
      pattern: 'api.removeItem($id, $callback)',
      replacement: 'await newApi.items.delete($id)',
      async: true
    }
  ]
};
```

Step 2: Apply migrations
```bash
refac apply-rules --rules ./api-migration.rules.js --path ./src

# Add async/await where needed
refac add-async --where-await-used --path ./src
```

Step 3: Update imports
```bash
refac transform \
  --pattern "import api from './oldApi'" \
  --replacement "import newApi from './newApi'" \
  --path ./src
```

Step 4: Remove callback error handling
```bash
refac transform \
  --pattern 'if (err) { $errorHandler }' \
  --replacement 'try { $1 } catch (err) { $errorHandler }' \
  --context async-function \
  --path ./src
```

### Result
```javascript
// Migrated code
import newApi from './newApi';

async function loadData() {
  try {
    const items = await newApi.items.list();
    return items;
  } catch (err) {
    console.error('Failed to load items:', err);
  }
}
```

## Best Practices for Complex Refactoring

### 1. Plan Your Refactoring
```bash
# Analyze before refactoring
refac analyze --metrics --path ./src > analysis.txt

# Create a refactoring plan
refac plan --suggest --based-on analysis.txt > refactoring-plan.md
```

### 2. Test Continuously
```bash
#!/bin/bash
# safe-refactor.sh

# Run tests before
npm test || exit 1

# Apply refactoring
refac apply-rules --rules ./rules.js --path ./src

# Run tests after
npm test || {
  echo "Tests failed after refactoring"
  git checkout .
  exit 1
}
```

### 3. Incremental Approach
```bash
# Refactor one module at a time
for module in auth users orders payments; do
  echo "Refactoring $module..."
  refac modernize --path "./src/$module"
  npm test || break
  git add -A
  git commit -m "Refactor: modernize $module module"
done
```

### 4. Document Changes
```bash
# Generate refactoring report
refac report \
  --changes \
  --before-after \
  --output refactoring-report.md \
  --path ./src
```

## Conclusion

These examples demonstrate Refac's versatility in handling various refactoring scenarios. Remember to:

- Always preview changes before applying
- Use version control to track changes
- Run tests after each refactoring step
- Start with small, isolated changes before tackling large-scale refactoring

For more advanced usage, check out our [API Reference]({{ '/api-reference/' | relative_url }}) or join our [community discussions](https://github.com/jowharshamshiri/refac/discussions).