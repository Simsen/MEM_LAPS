## Local Administrator Password Solution
## Made by Jesper Voss and Simon Eriksen - Globeteam

Add-type -AssemblyName System.Web

$userName = "LAPSservice"
$fullName = "LAPS service"
$userDescription = "Local admin"
$adminDomainGroup = "Administrators"

$minLength = 30
$maxLength = 40
$length = Get-Random -Minimum $minLength -Maximum $maxLength
$nonAlphaChars = 5
$password = [System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars)
Write-Host $password
$password = ConvertTo-SecureString $password -asplaintext -force

$user = Get-LocalUser $userName -ErrorAction SilentlyContinue
if($user -eq $null){
$user = New-LocalUser $userName -Password $password -FullName $fullName -Description $userDescription -PasswordNeverExpires:$true
}else{
Set-LocalUser -Name $userName -Password $password
}

$admins = (Get-LocalGroupMember -Group $adminDomainGroup).Name | ? { $_.EndsWith("\$($user.Name)") }
if($admins.Count -eq 0){
Add-LocalGroupMember -Group $adminDomainGroup -Member $userName
}
