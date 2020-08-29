$thiccCreds = Get-Credential
$comps = Get-ADComputer -Filter * | Where-Object {$_.name -ne $env:computername}

foreach ($comp in $comps){
   
    Invoke-Command -ComputerName $comp.Name -Credential $thiccCreds -ScriptBlock {

        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0;
        Add-LocalGroupMember -Group "Remote Desktop Users" -Member "TESTLAB\rdp-users";
        Set-NetFirewallRule -DisplayGroup "Remote Desktop" -Profile Domain,Private -Enabled True
        Restart-Computer -Force
    }

}
