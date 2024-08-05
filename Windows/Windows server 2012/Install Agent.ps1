#author https://github.com/MrGulczu
$Console_Width = [System.Console]::WindowWidth
$line = '-'*$Console_Width

Write-Host $line
Write-Host "Agent installation"

$Start = Read-Host -Prompt "Do You want to continue? [Y/N] "
Write-Host $line
if ($Start.ToUpper() -eq "N")
{
    Exit 5
}

Invoke-WebRequest -Uri https://packages.wazuh.com/4.x/windows/wazuh-agent-4.8.0-1.msi -OutFile ${env.tmp}\wazuh-agent; msiexec.exe /i ${env.tmp}\wazuh-agent /q WAZUH_MANAGER='83.168.108.76' WAZUH_AGENT_GROUP='AgentGroup' WAZUH_AGENT_NAME='Agentname' 
$Insert_Test = $true
Write-Host ""
Write-Host "Provide necessary information:"
Write-Host ""
Write-Host $line
while ($Insert_Test) {
    $Client_port = Read-Host -Prompt "Enter provided client port "
    $Enrollment_port = Read-Host -Prompt "Enter provided enrollment port "
    $Agent_name = Read-Host -Prompt "Enter name for Wazuh Agent "
    $Wazuh_Agent_Group = Read-Host -Prompt "Enter group name for Wazuh Agent "
    Write-Host ""
    $YesorNo = Read-Host -Prompt "Those are correct? [Y/N] "
    Write-Host ""
    if ($YesorNo.ToUpper() -eq "Y")
    {
        $Insert_Test = $false
    }
}
Write-Host $line
Start-Sleep -s 15
$content = Get-Content -Path "C:\Program Files (x86)\ossec-agent\ossec.conf"

$content[10] = "      <address>83.168.108.76</address>"
$content[11] = "      <port>$Client_port</port>"
$content[18] = "      <enrollment>`n      <manager_address>83.168.108.76</manager_address>`n        <port>$Enrollment_port</port>`n        <agent_name>$Agent_name</agent_name>`n        <groups>$Wazuh_Agent_Group</groups>`n      </enrollment>`n  </client>"

Set-Content -Path "C:\Program Files (x86)\ossec-agent\ossec.conf" -Value $content

NET START WazuhSvc

Write-Host $line
Write-Host "In case of any problems, please contact us at support@smartech-it.eu"
Write-Host $line

