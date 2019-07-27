# Script for adding RDP firewall rule(s) restrictions
#
# Note:
#       Can't use NetFirewall cmdlets on 2008R2 systems
#


# Needs a hash or nested hash table with rule name and netsh cmd to be executed
# or some other way


$firewallPort = ""
$firewallRuleName = ""

write-host "Checking for '$firewallRuleName' firewall rule on port '$firewallPort' now...."
if ($(Get-NetFirewallRule –DisplayName $firewallRuleName | Get-NetFirewallPortFilter | Where { $_.LocalPort -eq $firewallPort }))
{
    write-host "Firewall rule for '$firewallRuleName' on port '$firewallPort' already exists, not creating new rule"
}
else
{
    write-host "Firewall rule for '$firewallRuleName' on port '$firewallPort' does not already exist, creating new rule now..."
    New-NetFirewallRule -DisplayName "Octopus Deploy Tentacle" -Direction Inbound -Profile Domain,Private,Public -Action Allow -Protocol TCP -LocalPort $firewallPort -RemoteAddress Any
    write-host "Firewall rule for '$firewallRuleName' on port '$firewallPort' created successfully"
}

=====
function isFirewallPortOpen {
    param( [int] $port )
                                                                                                                                                     2,1           Top
function isFirewallPortOpen {
    param( [int] $port )
    $fw = New-Object -ComObject hnetcfg.fwpolicy2
    if ($fw.Rules | Where {$_.LocalPorts -eq $port }) {
        return [bool]$true
    } else {
        return [bool]$false
    }
}

function existsFirewallRule {
    param( [string] $name )
    $fw = New-Object -ComObject hnetcfg.fwpolicy2
    if ($fw.Rules | Where { $_.Name -eq $name }) {
        return [bool]$true
    } else {
        return [bool]$false
    }
}

function addFirewallRule {
    param(
        [string] $name,
        [int] $port,
        [int] $protocol
    )
    $fw = New-Object -ComObject hnetcfg.fwpolicy2
    if (isFirewallPortOpen $port -or existsFirewallRule $name) {
        Write-Host -ForegroundColor:Red "**Rule Already Exists or Port Already Open."
    } else {
        $rule = New-Object -ComObject HNetCfg.FWRule

        $rule.Name = $name
        $rule.Protocol = $protocol # 6=NET_FW_IP_PROTOCOL_TCP and 17=NET_FW_IP_PROTOCOL_UDP
        $rule.LocalPorts = $port
        $rule.Enabled = $true
        $rule.Grouping = "SQL Server"
        $rule.Profiles = 7 # all
        $rule.Action = 1 # NET_FW_ACTION_ALLOW
        $rule.EdgeTraversal = $false

        $fw.Rules.Add($rule)
        Write-Host -ForegroundColor:Blue "A rule named '$name' has been added to Windows' Firewall."
    }
}

addFirewallRule -name:"Transact SQL Debugger" -port:135 -protocol:6
addFirewallRule -name:"SQL Traffic" -port:1433 -protocol:6
addFirewallRule -name:"SQL Browser Traffic" -port:1434 -protocol:17
addFirewallRule -name:"SQL Analytics Traffic" -port:2383 -protocol:6
addFirewallRule -name:"SQL Broker Traffic" -port:4022 -protocol:6

