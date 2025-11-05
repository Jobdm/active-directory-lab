<#
.SYNOPSIS
    Collects comprehensive system health metrics
.DESCRIPTION
    Gathers CPU, Memory, Disk, Network, and Service metrics for monitoring
#>

function Get-SystemHealth {
    [CmdletBinding()]
    param()

    try {
        # Get system information
        $ComputerInfo = Get-ComputerInfo

        # Get performance counters
        $CPU = Get-Counter "\Processor(_Total)\% Processor Time" -SampleInterval 1 -MaxSamples 3 |
                Select-Object -ExpandProperty CounterSamples |
                Measure-Object -Property CookedValue -Average |
                Select-Object -ExpandProperty Average

        # Get memory information
        $Memory = Get-CimInstance -ClassName Win32_OperatingSystem
        $MemoryUsagePercent = [math]::Round((($Memory.TotalVisibleMemorySize - $Memory.FreePhysicalMemory) / $Memory.TotalVisibleMemorySize) * 100, 2)

        # Get disk information
        $Disks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
            [PSCustomObject]@{
                Drive = $_.DeviceID
                SizeGB = [math]::Round($_.Size / 1GB, 2)
                FreeGB = [math]::Round($_.FreeSpace / 1GB, 2)
                UsedPercent = [math]::Round((($_.Size - $_.FreeSpace) / $_.Size) * 100, 2)
            }
        }

        # Get network adapters
        $NetworkAdapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object Name, LinkSpeed

        # Get critical services
        $CriticalServices = Get-Service | Where-Object {
            $_.Name -in @('ADWS', 'DNS', 'DHCP', 'Netlogon', 'W32Time', 'KDC', 'NTDS')
        } | Select-Object Name, Status

        # Get recent errors from event log
        $RecentErrors = Get-WinEvent -FilterHashtable @{LogName='System'; Level=2; StartTime=(Get-Date).AddHours(-1)} -MaxEvents 5 -ErrorAction SilentlyContinue |
                        Select-Object TimeCreated, Id, LevelDisplayName, Message

        # Create health report object
        $HealthReport = [PSCustomObject]@{
            ComputerName = $env:COMPUTERNAME
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Uptime = (Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
            CPU = @{
                UsagePercent = [math]::Round($CPU, 2)
                ProcessorCount = $ComputerInfo.CsProcessors.Count
            }
            Memory = @{
                TotalGB = [math]::Round($Memory.TotalVisibleMemorySize / 1MB, 2)
                FreeGB = [math]::Round($Memory.FreePhysicalMemory / 1MB, 2)
                UsedPercent = $MemoryUsagePercent
            }
            Disks = $Disks
            Network = $NetworkAdapters
            Services = $CriticalServices
            RecentErrors = $RecentErrors
            Domain = @{
                Role = $ComputerInfo.CsDomainRole
                Domain = $ComputerInfo.CsDomain
            }
        }

        return $HealthReport
    }
    catch {
        Write-Error "Failed to collect system health: $($_.Exception.Message)"
        return $null
    }
}

# Execute the function and convert to JSON
$HealthData = Get-SystemHealth
if ($HealthData) {
    $HealthData | ConvertTo-Json -Depth 5
} else {
    Write-Output "Failed to collect health data"
}
