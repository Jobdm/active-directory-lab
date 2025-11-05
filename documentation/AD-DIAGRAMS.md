# Active Directory Lab - Visual Documentation

## Organizational Unit Structure

\\\
lab.local
│
├── Domain Controllers (Built-in)
│   └── DC01-HQ
│
├── IT-Administration
│   ├── IT-Users
│   │   └── jadmin (Domain Admin)
│   ├── IT-Computers
│   └── IT-Groups
│       ├── IT-Department
│       ├── Laptop-Users
│       └── VPN-Users
│
├── Departments
│   ├── Sales
│   │   ├── Sales-Users
│   │   │   ├── juser
│   │   │   └── testuser1
│   │   └── Sales-Computers
│   │
│   ├── HR
│   │   ├── HR-Users
│   │   │   └── ahrmanager
│   │   └── HR-Computers
│   │
│   └── Engineering
│       ├── Engineering-Users
│       │   ├── bengineer
│       │   └── testuser2
│       └── Engineering-Computers
│
├── Servers
│   ├── Application-Servers
│   ├── File-Servers
│   └── Management-Servers
│
├── Workstations
│   ├── Desktop-Computers
│   └── Laptop-Computers
│
└── Service-Accounts
    └── psautomation (Automation account)
\\\

## Group Policy Object Hierarchy

\\\
Domain Level (lab.local)
│
├── Default Domain Policy (Built-in)
│   └── Password Policy
│       └── Account Lockout Policy
│
└── Organizational Unit Policies
    │
    ├── OU=Workstations
    │   └── Workstation-Security-Baseline
    │       ├── User Account Control (UAC)
    │       ├── Windows Update Settings
    │       └── Security Hardening
    │
    ├── OU=Sales
    │   └── Sales-Desktop-Config
    │       ├── Disable Control Panel
    │       ├── Desktop Restrictions
    │       └── Removable Storage Policy
    │
    └── OU=Engineering
        └── Engineering-Tools-Access
            └── Developer Tool Permissions
\\\

## Network Architecture

\\\
                    Internet
                       │
                       ↓
              [NAT Bridge - virbr0]
                 192.168.122.0/24
                       │
        ┌──────────────┴──────────────┐
        │                             │
        ↓                             ↓
┌─────────────────┐          ┌─────────────────┐
│   DC01-HQ       │          │  Linux-Auto     │
│  (10.1.0.10)    │◄────────►│  (10.1.0.20)    │
│                 │          │                 │
│ • AD DS         │          │ • Python        │
│ • DNS Server    │          │ • PowerShell    │
│ • DHCP Server   │   Lab    │   Integration   │
│ • Domain        │  Network │ • Monitoring    │
│   Controller    │ 10.1.0.0 │ • Web Dashboard │
│ • GPO Management│    /24   │ • Automation    │
└─────────────────┘          └─────────────────┘
        │                             │
        └──────────────┬──────────────┘
                       │
              [Future Expansion]
                       │
        ┌──────────────┴──────────────┐
        │                             │
   DC02-Branch                  WIN11-Client1
   (10.2.0.10)                  (10.1.0.50)
\\\

## Data Flow: Cross-Platform Monitoring

\\\
Linux-Auto (Python)
    │
    │ 1. Python Script Executes
    │    (health_monitor.py)
    │
    ↓
WinRM Connection
    │
    │ 2. Authenticate via WinRM
    │    (psautomation@lab.local)
    │
    ↓
DC01-HQ (PowerShell)
    │
    │ 3. Execute PowerShell Script
    │    (Get-SystemHealth.ps1)
    │
    ↓
Collect Metrics
    │
    │ 4. CPU, Memory, Disk, Services
    │    Event Logs, AD Health
    │
    ↓
Return JSON Data
    │
    │ 5. JSON formatted results
    │
    ↓
Linux-Auto (Processing)
    │
    │ 6. Store in health_history.json
    │    Generate charts and alerts
    │
    ↓
Web Dashboard (Flask)
    │
    │ 7. Display on http://10.1.0.20:8080
    │    Real-time charts and status
    │
    ↓
End User / Administrator
\\\

## Security Group Membership Flow

\\\
Department Groups
    │
    ├── IT-Department
    │   └── Members: jadmin
    │       └── Permissions: Domain Admin, Full AD access
    │
    ├── Sales-Department
    │   └── Members: juser, testuser1
    │       └── GPO Applied: Sales-Desktop-Config
    │       └── Access: CRM systems, shared drives
    │
    ├── Engineering-Department
    │   └── Members: bengineer, testuser2
    │       └── GPO Applied: Engineering-Tools-Access
    │       └── Access: Development tools, source control
    │
    └── HR-Department
        └── Members: ahrmanager
            └── Access: HR systems, confidential data
\\\

## Authentication Flow

\\\
User Login Request
    │
    ↓
Client Computer
    │
    │ 1. User enters credentials
    │
    ↓
Domain Controller (DC01-HQ)
    │
    │ 2. Kerberos Authentication
    │    - Verify credentials against AD
    │    - Check account status
    │    - Validate password policy
    │
    ↓
Group Policy Application
    │
    │ 3. Apply GPOs based on:
    │    - User OU location
    │    - Computer OU location  
    │    - Security group membership
    │    - GPO filtering rules
    │
    ↓
User Profile Load
    │
    │ 4. Load user settings
    │    - Desktop configuration
    │    - Drive mappings
    │    - Application settings
    │
    ↓
Desktop Session
    │
    │ 5. User logged in with:
    │    - Applied GPO settings
    │    - Group-based permissions
    │    - Network access
    │
    └──→ User Productivity
\\\

---
**Generated**: 2025-10-23 13:28:31
