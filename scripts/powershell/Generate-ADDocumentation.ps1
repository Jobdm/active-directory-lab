<#
.SYNOPSIS
    Active Directory Environment Documentation Generator
.DESCRIPTION
    Generates comprehensive documentation of AD structure, GPOs, users, and groups
.AUTHOR
    Your Name
.DATE
    {0}
#>

param(
    [string]$OutputPath = "C:\Scripts\Documentation\Reports"
)

# Create output directory
New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null

Write-Host "=== Active Directory Documentation Generator ===" -ForegroundColor Cyan
Write-Host "Output Directory: $OutputPath`n" -ForegroundColor Yellow

# 1. Domain Information
Write-Host "[1/8] Collecting Domain Information..." -ForegroundColor Green
$Domain = Get-ADDomain
$Forest = Get-ADForest

$DomainInfo = [PSCustomObject]@{
    DomainName = $Domain.Name
    DomainDNSName = $Domain.DNSRoot
    ForestName = $Forest.Name
    DomainMode = $Domain.DomainMode
    ForestMode = $Forest.ForestMode
    DomainControllers = ($Domain.ReplicaDirectoryServers -join ", ")
    Created = $Domain.CreationTime
    Modified = $Domain.Modified
}

$DomainInfo | Export-Csv -Path "$OutputPath\Domain-Info.csv" -NoTypeInformation
$DomainInfo | ConvertTo-Json | Out-File "$OutputPath\Domain-Info.json"

# 2. Organizational Units
Write-Host "[2/8] Documenting Organizational Units..." -ForegroundColor Green
$OUs = Get-ADOrganizationalUnit -Filter * -Properties Description, Created, Modified, ProtectedFromAccidentalDeletion |
    Select-Object Name, DistinguishedName, Description, Created, Modified, ProtectedFromAccidentalDeletion |
    Sort-Object DistinguishedName

$OUs | Export-Csv -Path "$OutputPath\OUs.csv" -NoTypeInformation
Write-Host "  Found $($OUs.Count) OUs" -ForegroundColor Gray

# 3. Users
Write-Host "[3/8] Documenting User Accounts..." -ForegroundColor Green
$Users = Get-ADUser -Filter * -Properties Department, Title, EmailAddress, Enabled, Created, Modified, LastLogonDate, MemberOf |
    Select-Object Name, SamAccountName, UserPrincipalName, Department, Title, Enabled, Created, Modified, LastLogonDate, 
        @{N='Groups';E={($_.MemberOf | ForEach-Object {(Get-ADGroup $_).Name}) -join "; "}},
        DistinguishedName |
    Sort-Object Name

$Users | Export-Csv -Path "$OutputPath\Users.csv" -NoTypeInformation
Write-Host "  Found $($Users.Count) users" -ForegroundColor Gray

# 4. Groups
Write-Host "[4/8] Documenting Security Groups..." -ForegroundColor Green
$Groups = Get-ADGroup -Filter * -Properties Description, Created, Modified, MemberOf, Members |
    Select-Object Name, GroupScope, GroupCategory, Description, Created, Modified,
        @{N='MemberCount';E={($_.Members).Count}},
        DistinguishedName |
    Sort-Object Name

$Groups | Export-Csv -Path "$OutputPath\Groups.csv" -NoTypeInformation
Write-Host "  Found $($Groups.Count) groups" -ForegroundColor Gray

# 5. Group Memberships
Write-Host "[5/8] Documenting Group Memberships..." -ForegroundColor Green
$GroupMemberships = @()
foreach ($Group in Get-ADGroup -Filter *) {
    $Members = Get-ADGroupMember -Identity $Group -ErrorAction SilentlyContinue
    foreach ($Member in $Members) {
        $GroupMemberships += [PSCustomObject]@{
            GroupName = $Group.Name
            MemberName = $Member.Name
            MemberType = $Member.ObjectClass
            MemberDN = $Member.DistinguishedName
        }
    }
}
$GroupMemberships | Export-Csv -Path "$OutputPath\Group-Memberships.csv" -NoTypeInformation
Write-Host "  Found $($GroupMemberships.Count) membership relationships" -ForegroundColor Gray

# 6. Group Policy Objects
Write-Host "[6/8] Documenting Group Policy Objects..." -ForegroundColor Green
$GPOs = Get-GPO -All | ForEach-Object {
    $Links = (Get-GPOReport -Guid $_.Id -ReportType Xml | Select-Xml -XPath "//LinksTo").Node.SOMPath
    
    [PSCustomObject]@{
        Name = $_.DisplayName
        Status = $_.GpoStatus
        Created = $_.CreationTime
        Modified = $_.ModificationTime
        Owner = $_.Owner
        LinkedTo = ($Links -join "; ")
        Description = $_.Description
        GUID = $_.Id
    }
} | Sort-Object Name

$GPOs | Export-Csv -Path "$OutputPath\GPOs.csv" -NoTypeInformation
Write-Host "  Found $($GPOs.Count) GPOs" -ForegroundColor Gray

# 7. Generate HTML Reports for GPOs
Write-Host "[7/8] Generating detailed GPO reports..." -ForegroundColor Green
$GPOReportDir = "$OutputPath\GPO-Reports"
New-Item -ItemType Directory -Path $GPOReportDir -Force | Out-Null

foreach ($GPO in Get-GPO -All) {
    $ReportPath = "$GPOReportDir\$($GPO.DisplayName -replace '[\\/:*?"<>|]', '_').html"
    Get-GPOReport -Guid $GPO.Id -ReportType Html -Path $ReportPath
}
Write-Host "  Generated detailed HTML reports for all GPOs" -ForegroundColor Gray

# 8. Create Summary Report
Write-Host "[8/8] Creating summary report..." -ForegroundColor Green
$Summary = @"
# Active Directory Environment Documentation
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Domain Information
- Domain: $($DomainInfo.DomainDNSName)
- Forest: $($DomainInfo.ForestName)
- Domain Mode: $($DomainInfo.DomainMode)
- Forest Mode: $($DomainInfo.ForestMode)

## Statistics
- Organizational Units: $($OUs.Count)
- User Accounts: $($Users.Count)
- Security Groups: $($Groups.Count)
- Group Policy Objects: $($GPOs.Count)

## Organizational Structure
### Top-Level OUs
$($OUs | Where-Object {$_.DistinguishedName -notlike "*,OU=*,DC=*"} | Select-Object -ExpandProperty Name | Out-String)

## Group Policy Objects
$($GPOs | Select-Object Name, LinkedTo | Format-Table -AutoSize | Out-String)

## Department Groups and Memberships
$($Groups | Where-Object {$_.Name -like "*-Department"} | Select-Object Name, MemberCount | Format-Table -AutoSize | Out-String)

## Files Generated
- Domain-Info.csv
- Domain-Info.json
- OUs.csv
- Users.csv
- Groups.csv
- Group-Memberships.csv
- GPOs.csv
- GPO-Reports/ (detailed HTML reports)

---
Documentation generated by AD Documentation Script
"@

$Summary | Out-File -FilePath "$OutputPath\README.md" -Encoding UTF8

Write-Host "`n=== Documentation Complete ===" -ForegroundColor Cyan
Write-Host "Reports saved to: $OutputPath" -ForegroundColor Yellow
Write-Host "`nGenerated Files:" -ForegroundColor Yellow
Get-ChildItem -Path $OutputPath -Recurse -File | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize

# Open the output directory
explorer.exe $OutputPath
