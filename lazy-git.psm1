. $PSScriptRoot\Scripts\PullAll.ps1
. $PSScriptRoot\Scripts\FetchAll.ps1

function LazyGitCheck() {
    Write-Host "Lazy git imported!" -f Magenta
}

[CmdletBinding]
function PullMain([Alias('r')][switch]$reset) {

    if ($reset) {
        git reset --hard
    }
    
    git checkout main
    git pull
}

function Checkout([string]$branch) {
    Write-Host "MODULE 3" -f Magenta
    git checkout $branch;
    git fetch;
}

function Open {
    Invoke-Item .
};

$exportModuleMemberParams = @{
    Function = @(
        'LazyGitCheck',
        'PullMain',
        'Checkout',
        'Open',
        'Thing',
        'PullAll',
        'FetchAll'
    )
}

Export-ModuleMember @exportModuleMemberParams