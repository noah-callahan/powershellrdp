$mainpath = "C:\Shared\users"

$folders = Get-ChildItem -Path $mainpath



foreach ($folder in $folders) {
    
    $Acl = Get-Acl "$($mainpath)\$($folder.name)"
    $Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("TESTLAB\test1", "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
    $Acl.SetAccessRule($Ar)
    Set-Acl "$($mainpath)\$($folder.name)" $Acl
   
}
