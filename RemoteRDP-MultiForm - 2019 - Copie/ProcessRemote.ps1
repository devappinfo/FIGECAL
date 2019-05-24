<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.150
	 Created on:   	23/05/2019 11:46
	 Created by:   	administrateur
	 Organization: 	
	 Filename:     	ProcessRemote.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

param (
	$serveur,
	$user
)

Write-Host $serveur
Write-Host $user

$form = New-Object System.Windows.Forms.Form
$label = New-Object System.Windows.Forms.Label

Import-Module RemoteDesktop
$grid = Get-WmiObject -Class Win32_Process -ComputerName $serveur | Where-Object { $_.GetOwner().User -eq $user } | Select-Object ProcessName, ProcessId, $serveur, $user | Out-GridView -Title "Select the process to kill" -PassThru
foreach ($elem in $grid)
{
	Invoke-Command -computername $serveur -ArgumentList $elem.ProcessId { Stop-Process -Force -Id $args[0] }
	$label.Text = "Processus {0} tué." -f $elem.ProcessName
	$label.AutoSize = $false
	$label.TextAlign = 'MiddleCenter'
	$label.Dock = 'Fill'
	$form.Text = "Opération effectuée"
	$form.Controls.Add($label)
	$form.AutoSize = $true
	$form.Show()
	
}

