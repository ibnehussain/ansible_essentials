#!/bin/bash

# 🚀 Ansible Installation Script for RHEL 9
# Based on Lab_01.md steps for setting up Ansible Control Node
# Author: Ansible Essentials Lab
# Date: November 2025

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "\n${BLUE}================================================${NC}"
    echo -e "${BLUE} $1${NC}"
    echo -e "${BLUE}================================================${NC}\n"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should not be run as root. Please run as a regular user with sudo privileges."
        exit 1
    fi
}

# Function to check OS compatibility
check_os() {
    if [[ -f /etc/redhat-release ]]; then
        OS_VERSION=$(cat /etc/redhat-release)
        print_status "Detected OS: $OS_VERSION"
        if [[ ! "$OS_VERSION" =~ "Red Hat Enterprise Linux".*"9" ]] && [[ ! "$OS_VERSION" =~ "CentOS".*"9" ]] && [[ ! "$OS_VERSION" =~ "Rocky".*"9" ]]; then
            print_warning "This script is optimized for RHEL 9 family. Your system may not be fully compatible."
            read -p "Do you want to continue? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
        fi
    else
        print_error "This script is designed for RHEL/CentOS/Rocky Linux systems."
        exit 1
    fi
}

# Main installation function
main() {
    print_header "🧠 ANSIBLE INSTALLATION SCRIPT"
    
    # Preliminary checks
    check_root
    check_os
    
    # Step 1: Set hostname
    print_header "🖥️ Step 1: Setting Hostname"
    print_status "Setting hostname to 'Control-Node'..."
    sudo hostnamectl set-hostname Control-Node
    print_success "Hostname set to: $(hostnamectl --static)"
    
    # Step 2: Check for updates
    print_header "📦 Step 2: Checking for Package Updates"
    print_status "Checking for available package updates..."
    sudo yum check-update || true  # Don't exit on update check
    print_success "Package update check completed"
    
    # Step 3: Install Python 3 pip
    print_header "🐍 Step 3: Installing Python 3 Package Manager"
    if command_exists pip3; then
        print_warning "pip3 is already installed"
        pip3 --version
    else
        print_status "Installing python3-pip..."
        sudo yum install python3-pip -y
        print_success "python3-pip installed successfully"
    fi
    
    # Step 4: Verify Python version
    print_status "Python version:"
    python3 --version
    
    # Step 5: Upgrade pip
    print_header "⬆️ Step 4: Upgrading pip"
    print_status "Upgrading pip to latest version..."
    sudo pip3 install --upgrade pip
    print_success "pip upgraded successfully"
    
    # Step 6: Install AWS SDKs
    print_header "☁️ Step 5: Installing AWS SDKs and Tools"
    print_status "Installing AWS CLI, boto, and boto3..."
    sudo pip3 install awscli boto boto3
    print_success "AWS SDKs installed successfully"
    
    # Step 7: Install Ansible
    print_header "🤖 Step 6: Installing Ansible"
    if command_exists ansible; then
        print_warning "Ansible is already installed"
        ansible --version
    else
        print_status "Installing latest stable version of Ansible..."
        sudo pip3 install ansible
        print_success "Ansible installed successfully"
    fi
    
    # Step 8: Display Ansible details
    print_status "Installed Ansible details:"
    pip show ansible
    
    # Step 9: Install Amazon AWS Ansible collection
    print_header "📚 Step 7: Installing Amazon AWS Ansible Collection"
    print_status "Installing amazon.aws collection..."
    ansible-galaxy collection install amazon.aws --upgrade
    print_success "Amazon AWS collection installed successfully"
    
    # Step 10: Install wget
    print_header "🌐 Step 8: Installing wget"
    if command_exists wget; then
        print_warning "wget is already installed"
    else
        print_status "Installing wget..."
        sudo yum install wget -y
        print_success "wget installed successfully"
    fi
    
    # Step 11: Create ansible directory structure
    print_header "📁 Step 9: Creating Ansible Directory Structure"
    print_status "Creating Ansible working directory..."
    mkdir -p ~/ansible-labs
    cd ~/ansible-labs
    print_success "Created ~/ansible-labs directory"
    
    # Step 12: Download managed nodes creation playbook
    print_header "📥 Step 10: Downloading Managed Nodes Creation Playbook"
    print_status "Downloading create_managed_nodes.yml playbook..."
    if [ -f "create_managed_nodes.yml" ]; then
        print_warning "create_managed_nodes.yml already exists. Backing up..."
        mv create_managed_nodes.yml create_managed_nodes.yml.backup.$(date +%Y%m%d_%H%M%S)
    fi
    
    wget https://raw.githubusercontent.com/ibnehussain/ansible_essentials/main/create_managed_nodes.yml
    if [ -f "create_managed_nodes.yml" ]; then
        print_success "Managed nodes creation playbook downloaded successfully"
    else
        print_error "Failed to download managed nodes playbook"
    fi
    
    # Final verification
    print_header "✅ Installation Verification"
    print_status "Verifying installation..."
    
    echo -e "\n${GREEN}=== INSTALLATION SUMMARY ===${NC}"
    echo -e "${GREEN}✅ Hostname:${NC} $(hostnamectl --static)"
    echo -e "${GREEN}✅ Python:${NC} $(python3 --version)"
    echo -e "${GREEN}✅ pip:${NC} $(pip3 --version | cut -d' ' -f1-2)"
    echo -e "${GREEN}✅ Ansible:${NC} $(ansible --version | head -n1)"
    echo -e "${GREEN}✅ AWS CLI:${NC} $(aws --version 2>&1 | cut -d' ' -f1)"
    echo -e "${GREEN}✅ Working Directory:${NC} ~/ansible-labs"
    
    print_header "🎉 INSTALLATION COMPLETED SUCCESSFULLY!"
    
    echo -e "\n${YELLOW}📋 NEXT STEPS:${NC}"
    echo -e "1. Configure AWS credentials: ${BLUE}aws configure${NC}"
    echo -e "2. Create managed nodes: ${BLUE}ansible-playbook create_managed_nodes.yml${NC}"
    echo -e "3. Test connectivity: ${BLUE}ansible all -m ping -i managed_nodes_inventory${NC}"
    echo -e "4. Navigate to working directory: ${BLUE}cd ~/ansible-labs${NC}"
    echo -e "5. Start managing your infrastructure with Ansible!"
    
    echo -e "\n${GREEN}🚀 Your Ansible Control Node is ready!${NC}\n"
}

# Script execution starts here
main "$@"