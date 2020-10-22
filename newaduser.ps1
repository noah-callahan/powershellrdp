do {$fname = read-host "User FirstName"}
 until (($fname -match '^[a-zA-Z]+$' -eq $TRUE))

do {$lname = read-host "User LastName"}
 until (($lname -match '^[a-zA-Z]+$' -eq $TRUE))

$username = $fname.ToLower().Substring(0,1) + $lname.ToLower()

New-ADUser `
    -Name "$fname $lname" `
    -GivenName "$fname" `
    -Surname "$lname" `
    -DisplayName "$fname $lname" `
    -SamAccountName "$username" `
    -UserPrincipalName "$($username)@TESTLAB.local" `
    -AccountPassword (Read-Host -AsSecureString "Input User Password") `
    -Path "OU=Domain Users, DC=TESTLAB,DC=local" `
    -Enabled $True `
    -HomeDrive "K" `
    -HomeDirectory "\\192.168.15.2\users\$($username)"

try {

New-Item -Path "C:\Data\users\" -Name "$username" -ItemType "directory"

$Acl = Get-Acl "C:\Data\users\$($username)"
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("TESTLAB\$($username)", "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
$Acl.SetAccessRule($Ar)
Set-Acl "C:\Data\users\$($username)" $Acl


} catch {

Write-Output "An error occured during the user folder creation process."


}
