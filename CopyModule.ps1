
#TODO allow user to override modules path
$moduleDirectories = $ENV:PSModulePath -split ';'
$selectedModuleDirectory = $moduleDirectories[0];

Write-Output "`$selectedModuleDirectory = '$selectedModuleDirectory'"
$modulePath = $selectedModuleDirectory + "\lazy-git"
Write-Output "`$modulePath = '$modulePath'"
Write-Output "`$PSScriptRoot = '$PSScriptRoot'"

$moduleDirectory = "$selectedModuleDirectory\lazy-git"
if (!(Test-Path $moduleDirectory)) {
    New-item -Name "lazy-git" -Type directory -Path $selectedModuleDirectory
}
Copy-Item -Path "$PSScriptRoot\src\*" -Destination $moduleDirectory -Recurse
Write-Output "lazy-git copied to $moduleDirectory"