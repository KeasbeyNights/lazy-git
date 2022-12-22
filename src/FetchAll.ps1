function FetchAll() {
    $env:GitRepo = [Environment]::GetEnvironmentVariable('GitRepo', 'User')
    Write-Progress 'Fetching all repos in' $env:GitRepo
    $i = 0    

    $directories = Get-ChildItem –Path $env:GitRepo -Directory
    foreach ($directory in $directories) {
        git -C $directory fetch;
        $i++
        Write-Progress -activity "Fetching all repos..." -status "Fetching: $directory.Name ($i of $($directories.Count))" -percentComplete (($i / $directories.Count) * 100)
    }    
}