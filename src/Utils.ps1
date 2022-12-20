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

    if (!$Force) {
        $alreadyInProfile = Test-LazyGitImportedInScript $profilePath
        if ($alreadyInProfile) {
            Write-Warning "lazy-git already imported into '$profilePath'"
            return
        }    
    }

    #TODO allow user to override modules path
    $moduleDirectories = $ENV:PSModulePath -split ';'
    $selectedModuleDirectory = $moduleDirectories[0];
    $profileContent = "`nImport-Module lazy-git"

    Write-Verbose "`$selectedModuleDirectory = '$selectedModuleDirectory'"
    $modulePath = $selectedModuleDirectory + "\lazy-git"
    Write-Verbose "`$modulePath = '$modulePath'"
    
    if ($PSCmdlet.ShouldProcess($selectedModuleDirectory, "Create current user PowerShell profile directory")) {
        Copy-Item $PSScriptRoot\ -Destination $modulePath -PassThru -Recurse;
    }

    if ($PSCmdlet.ShouldProcess($profilePath, "Add 'Import-Module lazy-git' to profile")) {
        Add-Content -LiteralPath $profilePath -Value $profileContent -Encoding UTF8
    }
}

function Test-LazyGitImportedInScript {
    param (
        [Parameter(Position = 0)]
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