# Active Directory Lab Environment - Technical Portfolio

## Project Overview
Designed and implemented a comprehensive Active Directory lab environment demonstrating enterprise-level skills in directory services, Group Policy management, and cross-platform automation.

## Environment Architecture

### Infrastructure Components
- **Domain Controller**: Windows Server 2022 (DC01-HQ)
- **Automation Server**: Ubuntu 22.04 LTS (Linux-Auto)
- **Domain**: lab.local
- **Network**: Dual-network architecture (10.1.0.0/24 lab network + NAT internet access)

### Key Statistics
- **Organizational Units**: 26
- **User Accounts**: 11
- **Security Groups**: 57
- **Group Policy Objects**: 5

## Technical Implementation

### Active Directory Structure
Implemented enterprise-standard organizational hierarchy:
- **IT-Administration**: IT department users, computers, and groups
- **Departments**: Business units (Sales, HR, Engineering) with sub-OUs for users and computers
- **Servers**: Categorized server infrastructure (Application, File, Management)
- **Workstations**: End-user devices (Desktop and Laptop classifications)
- **Service-Accounts**: Non-interactive service and automation accounts

### Group Policy Management
Created layered GPO strategy with inheritance and filtering:
- **Workstation-Security-Baseline**: Security hardening for all workstations
- **Sales-Desktop-Config**: Department-specific desktop restrictions
- **Engineering-Tools-Access**: Developer tool permissions and access

### Automation & Integration
Built cross-platform automation system:
- **PowerShell Scripts**: Automated AD management, documentation generation, and reporting
- **Python Integration**: Remote PowerShell execution via WinRM from Linux
- **Web Dashboard**: Flask-based real-time monitoring and visualization
- **RESTful API**: JSON endpoints for system health and AD data

## Skills Demonstrated

### Active Directory Administration
- Domain controller deployment and configuration
- Organizational unit design and implementation
- Group Policy creation, linking, and management
- User and group administration at scale
- DNS and DHCP services configuration
- Domain security and authentication

### Automation & Scripting
- **PowerShell**: 800+ lines of production-quality scripts
  - AD automation and bulk operations
  - GPO reporting and documentation
  - System health monitoring
- **Python**: Cross-platform integration and web development
  - WinRM client for remote PowerShell execution
  - Flask web applications
  - Data visualization with Plotly
  - REST API development

### System Administration
- Windows Server 2022 administration
- Ubuntu Linux server management
- KVM/QEMU virtualization
- Network design and implementation
- Service monitoring and alerting
- Technical documentation

## Technical Challenges & Solutions

### Challenge 1: Cross-Platform Authentication
**Problem**: Enabling secure PowerShell remoting from Linux to Windows domain controller  
**Solution**: Configured WinRM with domain-based authentication, implemented proper credential formats (UPN), and secured communication channels

### Challenge 2: Network Architecture
**Problem**: VMs needed both internet access and isolated lab network  
**Solution**: Designed dual-network architecture with virbr0 for internet and dedicated lab network (10.1.0.0/24) for domain services

### Challenge 3: Automated Documentation
**Problem**: Manual documentation becomes outdated quickly  
**Solution**: Created PowerShell script that automatically generates comprehensive documentation in multiple formats (CSV, JSON, HTML, Markdown)

## Automation Scripts

### Generate-ADDocumentation.ps1
Comprehensive documentation generator that produces:
- Domain and forest information
- Complete OU structure inventory
- User accounts with group memberships
- Security groups and membership relationships
- GPO inventory with link information
- Detailed HTML reports for each GPO
- Executive summary in Markdown format

### PowerShell-Python Integration
Cross-platform monitoring system features:
- Remote script execution via WinRM
- Real-time system health collection
- Web-based dashboard with live charts
- Historical data tracking (24-hour retention)
- REST API for programmatic access

## Project Deliverables
✅ Production-ready Active Directory environment  
✅ Automated documentation system  
✅ Cross-platform monitoring solution  
✅ Comprehensive technical documentation  
✅ Reusable automation scripts  
✅ Web-based management interface  

## Technologies Used
**Infrastructure**: Windows Server 2022, Ubuntu 22.04 LTS, KVM/QEMU, Active Directory  
**Scripting**: PowerShell 5.1, Python 3.12  
**Integration**: WinRM, pywinrm, RESTful APIs  
**Web Development**: Flask, Plotly, HTML/CSS  
**Services**: DNS, DHCP, Group Policy, PowerShell Remoting  
**Tools**: Visual Studio Code, Git, virt-manager  

## Future Enhancements
- Multi-site Active Directory replication with DC02-Branch
- Certificate Services (AD CS) implementation
- Advanced GPO features (WMI filtering, loopback processing)
- Disaster recovery and backup automation
- Azure AD Connect for hybrid identity
- Advanced security monitoring and SIEM integration

---

**Author**: [Your Name]  
**Date**: 2025-10-23  
**Contact**: [Your Email/LinkedIn]  

**GitHub Repository**: [Link to repository]  
**Live Demo**: [Link to demo environment if applicable]
