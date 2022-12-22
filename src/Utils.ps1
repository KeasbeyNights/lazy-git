function Add-LazyGitToProfile {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()]
        [switch]
        $AllHosts,

        [Parameter()]
        [switch]
        $AllUsers,

        [Parameter()]
        [string]
        $GitDirectory,

        [Parameter()]
        [switch]
        $Force
    )

    $profileName = $(if ($AllUsers) { 'AllUsers' } else { 'CurrentUser' }) `
        + $(if ($AllHosts) { 'AllHosts' } else { 'CurrentHost' })
    Write-Verbose "`$profileName = '$profileName'"

    $profilePath = $PROFILE.$profileName
    Write-Verbose "`$profilePath = '$profilePath'"

    if (!$profilePath) {
        Write-Warning "No profile found at '$profilePath'"
        return
    }

    $alreadyInProfile = Test-LazyGitImportedInScript $profilePath

    if (!$Force -AND ($alreadyInProfile)) {
        Write-Warning "lazy-git already imported into '$profilePath'"
        return 
    }
    else {
        CopyModule
    }

    $env:GitRepo = [Environment]::GetEnvironmentVariable('GitRepo', 'User')
    if ((!$GitDirectory) -AND !(Test-Path $env:GitRepo)) {
        $GitDirectory = Read-Host -Prompt "Directory containing all git repos"
    }
    
    if (![string]::IsNullOrEmpty($GitDirectory)) {
        if (!(Test-Path $GitDirectory)) {
            Write-Warning "$GitDirectory does not exist"
            return
        }
        
        Set-GitRepositoryEnv $GitDirectory
    }

    AddModuleToProfile $profilePath
    Write-Host 'lazy-git installed' -f Green
}

function Test-LazyGitImportedInScript {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Path
    )

    if (!$Path -or !(Test-Path -LiteralPath $Path)) {
        return $false
    }

    $match = (@(Get-Content $Path -ErrorAction SilentlyContinue) -match 'lazy-git').Count -gt 0
    if ($match) {
        Write-Verbose "lazy-git found in '$Path'" 
    }
    $match
}

function CopyModule() {
    #TODO allow user to override modules path
    $moduleDirectories = $ENV:PSModulePath -split ';'
    $selectedModuleDirectory = $moduleDirectories[0];

    Write-Verbose "`$selectedModuleDirectory = '$selectedModuleDirectory'"
    $modulePath = $selectedModuleDirectory + "\lazy-git"
    Write-Verbose "`$modulePath = '$modulePath'"
    Write-Verbose "`$PSScriptRoot = '$PSScriptRoot'"

    $moduleDirectory = "$selectedModuleDirectory\lazy-git"
    if (!(Test-Path $moduleDirectory)) {
        New-item -Name "lazy-git" -Type directory -Path $selectedModuleDirectory
    }
    Copy-Item -Path "$PSScriptRoot\*" -Destination $moduleDirectory -Recurse
}

function Set-GitRepositoryEnv {
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param
    (
        # Path to file
        [Parameter(Mandatory = $true)]
        [string] $repoPath
    )

    if ($PSCmdlet.ShouldProcess($profileDir, "Create current user PowerShell profile directory")) {

        Write-Verbose "Setting environment variable GitRepo to $repoPath for current user"
        [Environment]::SetEnvironmentVariable('GitRepo', $repoPath)
    }
}

function AddModuleToProfile([Parameter(Mandatory = $true)]
    [string] $profilePath) {
    $profileContent = "Import-Module lazy-git"
    
    if (Select-String -Path $profilePath -Pattern $profileContent -Quiet) {
        Write-Verbose "lazy-git already imported to profile"
        return
    }
    
    Write-Verbose "Adding lazy-git to $profilePath"    
    Add-Content -LiteralPath $profilePath -Value "`n$profileContent" -Encoding UTF8
}