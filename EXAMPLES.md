# Cursor Automation Skill - Usage Examples

## Basic Usage

### 1. Code Generation
```json
{
  "content": "Write a Python function to calculate Fibonacci numbers up to n",
  "mode": "composer"
}
```

### 2. Code Refactoring
```json
{
  "content": "Refactor this JavaScript code to use async/await instead of callbacks",
  "mode": "chat"
}
```

### 3. Debugging Help
```json
{
  "content": "Why is my React component not re-rendering when the state changes?",
  "mode": "chat"
}
```

## Real-World Examples

### HTML/CSS Development
```json
{
  "content": "Create a responsive landing page with: 1. Navigation bar with logo and menu, 2. Hero section with headline and CTA button, 3. Features section with 3 cards, 4. Footer with social links. Use CSS Grid and modern design principles.",
  "mode": "composer"
}
```

### Python Development
```json
{
  "content": "Write a Flask web application with: 1. User authentication (login/register), 2. CRUD operations for a todo list, 3. REST API endpoints, 4. SQLite database integration. Include error handling and input validation.",
  "mode": "composer"
}
```

### JavaScript/React Development
```json
{
  "content": "Create a React component for a shopping cart with: 1. Add/remove items, 2. Quantity adjustment, 3. Total price calculation, 4. Local storage persistence, 5. Responsive design. Use hooks and context API.",
  "mode": "composer"
}
```

### Database Queries
```json
{
  "content": "Write SQL queries for: 1. Create users table with id, name, email, created_at, 2. Insert sample data, 3. Query to find users created in the last 7 days, 4. Update user email, 5. Delete inactive users.",
  "mode": "composer"
}
```

## Advanced Examples

### Code Review
```json
{
  "content": "Review this Python code for security vulnerabilities, performance issues, and best practices violations:\n\n```python\ndef process_user_input(data):\n    query = \"SELECT * FROM users WHERE id = \" + data\n    result = execute_query(query)\n    return result\n```",
  "mode": "chat"
}
```

### Architecture Design
```json
{
  "content": "Design a microservices architecture for an e-commerce platform. Include: 1. Service decomposition, 2. API gateway design, 3. Database per service pattern, 4. Event-driven communication, 5. Deployment strategy.",
  "mode": "chat"
}
```

### Algorithm Implementation
```json
{
  "content": "Implement Dijkstra's shortest path algorithm in Python. Include: 1. Graph representation using adjacency list, 2. Priority queue implementation, 3. Path reconstruction, 4. Time complexity analysis, 5. Test cases.",
  "mode": "composer"
}
```

## Integration Examples

### With OpenClaw Commands
```
User: 帮我写一个登录页面
Assistant: 好的，我来帮你创建一个登录页面。

{
  "content": "Create a modern login page with: 1. Email and password fields, 2. Remember me checkbox, 3. Login button, 4. Forgot password link, 5. Social login buttons (Google, GitHub), 6. Responsive design with gradient background. Include form validation with JavaScript.",
  "mode": "composer"
}
```

### Multi-step Tasks
```
User: 我需要一个完整的博客系统
Assistant: 我来帮你设计一个博客系统。

Step 1: Database schema
{
  "content": "Design a PostgreSQL database schema for a blog system with: users, posts, comments, categories, tags. Include relationships, indexes, and constraints.",
  "mode": "composer"
}

Step 2: Backend API
{
  "content": "Create Express.js REST API for the blog system with: user authentication (JWT), CRUD for posts and comments, pagination, search functionality, and admin routes.",
  "mode": "composer"
}

Step 3: Frontend
{
  "content": "Build a React frontend for the blog with: homepage showing latest posts, individual post pages, comment system, user dashboard, and admin panel.",
  "mode": "composer"
}
```

## Tips for Best Results

1. **Be Specific**: The more detailed your request, the better the output
2. **Use Appropriate Mode**: 
   - `composer` for code generation and editing
   - `chat` for explanations, debugging, and discussions
3. **Include Context**: If you're working on existing code, include relevant snippets
4. **Specify Technologies**: Mention specific frameworks, libraries, or tools
5. **Define Requirements**: Clearly state functional and non-functional requirements

## Common Use Cases

- **Learning New Technologies**: "Explain how React hooks work with examples"
- **Code Optimization**: "Optimize this SQL query for better performance"
- **Testing**: "Write unit tests for this Python function using pytest"
- **Documentation**: "Generate API documentation for this Node.js module"
- **Migration**: "Convert this jQuery code to vanilla JavaScript"
- **Security**: "Add input validation and sanitization to this PHP form"

Remember: Cursor must be open and maximized for the automation to work correctly!