
$colourOptions = @('DarkBlue', 'DarkGreen', 'DarkMagenta', 'DarkYellow', 'Cyan', 'Magenta'); #, 'DarkCyan', 'Blue', 'Green', 'Yellow')
$env:GitRepo = [Environment]::GetEnvironmentVariable('GitRepo', 'User')

function PullAll([Alias('r')][switch]$reset) {

    $colours = $colourOptions

    Get-ChildItem –Path $env:GitRepo -Directory |
    Foreach-Object {
        if ($colours.Count -lt 1) {
            $colours = $colourOptions;
        }
        
        $selectedColour = ($colours.Count -eq 1) ? $colours : (Get-random $colours);
        $colours = $colours | Where-Object { $_ -ne $selectedColour };

        Write-Host '-->'$_.Name ($selectedColour)'<--' -f $selectedColour;
    
        if (($reset) -AND ($_.FullName -ne $PSScriptRoot)) {
            Write-Host 'Resetting branch...' -f $selectedColour;
            git -C $_.FullName reset --hard
        }
        
        Write-Host 'Pulling main...' -f $selectedColour;
        git -C $_.FullName checkout main;
        git -C $_.FullName pull;
    }
}