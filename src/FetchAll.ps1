function FetchAll() {
    $repoDirectory = Split-Path ($PSScriptRoot)

    Write-Host 'Fetching all repos in' $repoDirectory -f Yellow
    Get-ChildItem –Path $repoDirectory -Directory |

    Foreach-Object {
        Write-Host '-->'Fetching $_.FullName'<--' -f DarkGreen
        git -C $_.FullName fetch;
    }
}