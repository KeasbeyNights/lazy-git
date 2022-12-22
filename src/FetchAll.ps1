function FetchAll() {
    $env:GitRepo = [Environment]::GetEnvironmentVariable('GitRepo', 'User')
    $i = 0

    $directories = Get-ChildItem –Path $env:GitRepo -Directory
    foreach ($directory in $directories) {
        $i++
        Write-Progress -activity "Fetching all repos..." -status "Fetching: $($directory.Name) ($i of $($directories.Count))" -percentComplete (($i / $directories.Count) * 100)
        git -C $directory fetch;
    }    
}