. $PSScriptRoot\PullAll.ps1
. $PSScriptRoot\FetchAll.ps1
. $PSScriptRoot\Utils.ps1

function CheckLazyGit() {
    Write-Host "Lazy git imported! 4" -f Magenta
}

function PullMain([Alias('r')][switch]$reset) {

    if ($reset) {
        git reset --hard
    }
    
    git checkout main
    git pull
}

function Checkout(
    [Parameter(mandatory = $true)]
    [string]$branch) {
    git checkout $branch;
    git fetch;
}

function Open {
    Invoke-Item .
};

$exportModuleMemberParams = @{
    Function = @(
        'Add-LazyGitToProfile',
        'CheckLazyGit',
        'PullMain',
        'Checkout',
        'Open',
        'Thing',
        'PullAll',
        'FetchAll'
    )
}

Export-ModuleMember @exportModuleMemberParams