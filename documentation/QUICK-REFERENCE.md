# Active Directory Lab - Quick Reference Guide

## Essential PowerShell Commands

### User Management
\\\powershell
# Create new user
New-ADUser -Name "John Doe" -SamAccountName "jdoe" -UserPrincipalName "jdoe@lab.local" -Path "OU=Sales-Users,OU=Sales,OU=Departments,DC=lab,DC=local" -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) -Enabled $true

# List all users
Get-ADUser -Filter * | Select-Object Name, SamAccountName, Enabled

# Reset user password
Set-ADAccountPassword -Identity "jdoe" -NewPassword (ConvertTo-SecureString "NewP@ss123!" -AsPlainText -Force) -Reset

# Disable user account
Disable-ADAccount -Identity "jdoe"
\\\

### Group Management
\\\powershell
# Create security group
New-ADGroup -Name "Project-Team" -GroupScope Global -GroupCategory Security -Path "OU=IT-Groups,OU=IT-Administration,DC=lab,DC=local"

# Add user to group
Add-ADGroupMember -Identity "Sales-Department" -Members "jdoe"

# List group members
Get-ADGroupMember -Identity "Sales-Department" | Select-Object Name

# Remove user from group
Remove-ADGroupMember -Identity "Sales-Department" -Members "jdoe" -Confirm:$false
\\\

### Group Policy Management
\\\powershell
# List all GPOs
Get-GPO -All | Select-Object DisplayName, GpoStatus

# Create new GPO
New-GPO -Name "New-Policy" -Comment "Description here"

# Link GPO to OU
New-GPLink -Name "New-Policy" -Target "OU=Workstations,DC=lab,DC=local"

# Force GPO update on client
Invoke-GPUpdate -Computer "CLIENT01" -Force

# Generate GPO report
Get-GPOReport -Name "Workstation-Security-Baseline" -ReportType Html -Path "C:\Reports\GPO-Report.html"
\\\

### OU Management
\\\powershell
# Create new OU
New-ADOrganizationalUnit -Name "Marketing" -Path "OU=Departments,DC=lab,DC=local"

# Move user to different OU
Move-ADObject -Identity "CN=John Doe,OU=Sales-Users,OU=Sales,OU=Departments,DC=lab,DC=local" -TargetPath "OU=Marketing-Users,OU=Marketing,OU=Departments,DC=lab,DC=local"

# List all OUs
Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName
\\\

## Documentation Commands

\\\powershell
# Generate complete documentation
& "C:\Scripts\Documentation\Generate-ADDocumentation.ps1"

# Quick user report
Get-ADUser -Filter * -Properties Department | Select-Object Name, SamAccountName, Department, Enabled | Export-Csv "C:\Reports\Users-20251023.csv" -NoTypeInformation

# Quick group report
Get-ADGroup -Filter * | Select-Object Name, GroupScope, GroupCategory | Export-Csv "C:\Reports\Groups-20251023.csv" -NoTypeInformation

# GPO inventory
Get-GPO -All | Select-Object DisplayName, CreationTime, ModificationTime | Export-Csv "C:\Reports\GPOs-20251023.csv" -NoTypeInformation
\\\

## Troubleshooting Commands

### GPO Troubleshooting
\\\powershell
# Check GPO application on local computer
gpresult /r

# Generate detailed HTML report
gpresult /h "C:\Reports\GPResult.html"

# Test GPO from DC perspective
Get-GPResultantSetOfPolicy -ReportType Html -Path "C:\Reports\RSOP.html" -User "lab\juser" -Computer "CLIENT01"

# Force GPO update
gpupdate /force
\\\

### Replication Troubleshooting
\\\powershell
# Check replication status
repadmin /replsummary

# Force replication
repadmin /syncall /AeD

# Show replication partners
repadmin /showrepl
\\\

### AD Health Check
\\\powershell
# Domain controller diagnostics
dcdiag /v

# DNS diagnostics
dcdiag /test:dns

# Check FSMO roles
netdom query fsmo
\\\

## Common File Locations

### Scripts
- Documentation: \C:\Scripts\Documentation\Generate-ADDocumentation.ps1\
- Health Monitoring: \C:\Scripts\HealthMonitoring\Get-SystemHealth.ps1\
- OU Management: \C:\Scripts\OU-Management\
- GPO Management: \C:\Scripts\GPO-Management\

### Reports
- Generated Reports: \C:\Scripts\Documentation\Reports\
- GPO Reports: \C:\Scripts\Documentation\Reports\GPO-Reports\
- Health Data: \C:\Scripts\health-data.json\

### Logs
- PowerShell Logs: \C:\Logs\
- Event Logs: Event Viewer → Windows Logs

## IP Address Reference

| System | Hostname | IP Address | Role |
|--------|----------|------------|------|
| Domain Controller | DC01-HQ | 10.1.0.10 | AD DS, DNS, DHCP |
| Automation Server | Linux-Auto | 10.1.0.20 | Python, Monitoring |
| Gateway | - | 10.1.0.1 | Network Gateway |

## Service Accounts

| Account | UPN | Purpose | Groups |
|---------|-----|---------|--------|
| psautomation | psautomation@lab.local | PowerShell automation | Domain Admins |
| Administrator | administrator@lab.local | Built-in admin | Domain Admins |

## Web Interfaces

- **Health Dashboard**: http://10.1.0.20:8080
- **Documentation Portal**: http://10.1.0.20:8081

## Support & Documentation

- Full Documentation: \C:\Scripts\Documentation\Reports\README.md\
- Portfolio: \C:\Scripts\Documentation\PORTFOLIO.md\
- Diagrams: \C:\Scripts\Documentation\AD-DIAGRAMS.md\

---
**Last Updated**: 2025-10-23 13:28:46
