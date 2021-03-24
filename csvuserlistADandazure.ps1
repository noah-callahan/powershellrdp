$userList = Import-Csv -Path 'C:\Users\administrator.HAGLEY\Documents\Guide Email List.csv'

$userCount = $userList | Measure-Object

$count = 0

$symbolArr =  '!','@','#','%','&','*'

function Generate-Password([String] $accountName){

    #not included for security

}

while($count -le ($userCount.Count - 1)){
    

    $fname = $userList[$count].FirstName
    $lname = $userList[$count].LastName


    $accountName = $fname.ToLower()[0] + $lname.ToLower()

    

    $adUser = Get-ADUser -filter {sAMAccountName -eq $accountName}

    if(!$adUser){

        Write-Output "Creating User"

        $plainpass = Generate-Password($accountName) 

        "{0},{1},{2},{3}" -f "$fname $lname","$accountname","$accountname@hagley.org","$plainpass" | add-content -path C:\Users\administrator.HAGLEY\Documents\tempuserlistfinal.csv

        $pass = ConvertTo-SecureString $plainpass –asplaintext –force 

        New-ADUser -Name "$fname $lname" -SamAccountName $accountName -AccountPassword $pass -DisplayName "$fname $lname" -Enabled $True -GivenName $fname -Surname $lname -UserPrincipalName "$accountName@Hagley.org" -Path "OU=PartTime,OU=Hagley Users,DC=Hagley,DC=org"

        
    
    } elseif ($adUser) {
    
        Write-Output "$accountName - The user already exists."
    
    }

    $count++


}

#Location and licensing

$userList = Import-Csv -Path 'C:\Users\administrator.HAGLEY\Documents\tempuserlistfinal.csv'

Connect-AzureAD -Credential $o365Creds

#$LicensedUser = Get-AzureADUser -ObjectId "  "
$License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense 
$License.SkuId = $LicensedUser.AssignedLicenses.SkuId 
$Licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses 
$Licenses.AddLicenses = $License



while($count -le ($userCount.Count - 1)){

    try{

        $uname = $userList[$count].Username
    
        $NewADUser = Get-AzureADUser -ObjectId "$uname@Hagley.org" 

        #Set-AzureADUser -ObjectId $NewADUser.ObjectId -UsageLocation US

        Set-AzureADUserLicense -ObjectId $NewADUser.ObjectId -AssignedLicenses $Licenses


        $count++

        Write-Output "$uname OK"
    
    
    } catch {
    
    
        Write-Output "$uname NOT OK"
    
    
    }


    $count++

}
