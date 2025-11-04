# Ansible Essentials — Lab Index

This repository contains a comprehensive series of hands-on Ansible labs designed to take you from beginner to advanced level. Each lab is a standalone Markdown file with individual command blocks optimized for GitHub's copy functionality.

## Labs Overview

### **[Lab 01 — Installing and Configuring Ansible](./Lab_01.md)**
- Set up Ansible control node on AWS EC2
- Configure SSH key authentication
- Create inventory and test connectivity
- **Topics**: Installation, SSH keys, inventory, ad-hoc commands

### **[Lab 02 — Exploring Ad-Hoc Commands](./Lab_02.md)**
- Master Ansible ad-hoc command syntax
- Work with common modules (command, user, file, copy)
- Practice privilege escalation
- **Topics**: Ad-hoc commands, modules, privilege escalation

### **[Lab 03 — Implementing Ansible Playbooks](./Lab_03.md)**
- Create your first Ansible playbook
- Install and configure Apache web server
- Understand YAML syntax and structure
- **Topics**: Playbooks, YAML, service management, file operations

### **[Lab 04 — Working with Variables and Facts](./Lab_04.md)**
- Learn variable types and precedence
- Use system facts and custom variables
- Create dynamic configurations
- **Topics**: Variables, facts, precedence, registered variables

### **[Lab 05 — Ansible Vault for Secrets Management](./Lab_05.md)**
- Encrypt sensitive data with Ansible Vault
- Use vault files in playbooks
- Implement secure password management
- **Topics**: Encryption, vault operations, security best practices

### **[Lab 06 — Ansible Templates with Jinja2](./Lab_06.md)**
- Create dynamic configuration files
- Master Jinja2 templating syntax
- Implement conditional rendering and loops
- **Topics**: Templates, Jinja2, dynamic content, configuration management

### **[Lab 07 — Conditional Execution and Loops](./Lab_07.md)**
- Implement conditional logic in playbooks
- Master various loop constructs
- Use advanced control structures
- **Topics**: Conditionals, loops, control flow, fact-based decisions

### **[Lab 08 — Handlers and Notifications](./Lab_08.md)**
- Implement service restart automation
- Create handler groups and dependencies
- Build robust notification systems
- **Topics**: Handlers, notifications, service management, error handling

### **[Lab 09 — Error Handling and Debugging](./Lab_09.md)**
- Master error handling strategies
- Implement retry logic and recovery
- Debug playbooks effectively
- **Topics**: Error handling, debugging, retry mechanisms, troubleshooting

### **[Lab 10 — Ansible Roles - Organization and Reusability](./Lab_10.md)**
- Create modular, reusable Ansible roles
- Implement role-based architecture
- Build complete application stacks
- **Topics**: Roles, modularity, reusability, best practices

## Quick Start Commands

### View a lab file (PowerShell):
```powershell
notepad .\Lab_01.md
```

### Print to terminal:
```powershell
Get-Content .\Lab_01.md | Out-Host
```

### Open in VS Code:
```powershell
code .
```

## Repository Features

✅ **Copy-Friendly Commands**: Every command is in individual code blocks for easy copying  
✅ **Progressive Learning**: Labs build upon each other systematically  
✅ **Real-World Examples**: Practical scenarios you'll encounter in production  
✅ **Best Practices**: Industry-standard approaches and security considerations  
✅ **Troubleshooting**: Common issues and solutions included  

## Prerequisites

- Basic Linux command line knowledge
- AWS account for EC2 instances (Lab 1)
- SSH client installed
- Text editor (VS Code recommended)

## Learning Path

1. **Foundations** (Labs 1-3): Installation, basic commands, first playbooks
2. **Core Concepts** (Labs 4-6): Variables, security, templates
3. **Advanced Features** (Labs 7-9): Control flow, handlers, debugging
4. **Best Practices** (Lab 10): Roles and organization

## Support

Each lab includes:
- Clear objectives and prerequisites
- Step-by-step instructions
- Key concepts summary
- Troubleshooting section
- Best practices

---

**Last Updated**: November 4, 2025  
**Version**: 2.0 - Optimized for GitHub copy functionality