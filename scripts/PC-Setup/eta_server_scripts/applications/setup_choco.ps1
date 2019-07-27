Write-Host "`n"
Write-Host "Getting Execution Policy"
Get-ExecutionPolicy
Start-Sleep 1
Set-ExecutionPolicy RemoteSigned
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
Start-Sleep 1
