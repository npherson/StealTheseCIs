# EventID 1096 is logged when a system cannot update group policy, typically because the registry.pol file is corrupt.
powershell.exe -Version 2
Get-EventLog -LogName System -Source Microsoft-Windows-GroupPolicy -EntryType Error | Where-Object($_.EventID -eq 1096)
