
powershell.exe -Version 2
Get-EventLog -LogName System -Source Microsoft-Windows-GroupPolicy -EntryType Error | ($_.EventID -eq 10016)