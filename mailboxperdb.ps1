$databases = get-mailboxdatabase

foreach ($database in $databases) {
    Get-MailboxStatistics -Database $database.name | Sort-Object -Property totalitemsize -Descending | Select-Object displayname,totalitemsize | export-csv "C:\Users\administrator.AFI\Desktop\test\$($database.name).csv"
}
