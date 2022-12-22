
$colourOptions = @('DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkMagenta', 'DarkYellow', 'Cyan', 'Magenta'); #, 'Blue', 'Green', 'Yellow')
$global:colours = @();
$env:GitRepo = [Environment]::GetEnvironmentVariable('GitRepo', 'User')

function SelectColour() {
    
    if ($global:colours.Count -lt 1) {
        $global:colours = $colourOptions;
    }
    
    $selectedColour = ($global:colours.Count -eq 1) ? $global:colours : (Get-random $global:colours);
    $global:colours = $global:colours | Where-Object { $_ -ne $selectedColour };

    return $selectedColour;
}

function PullAll([Alias('r')][switch]$reset) {
    Get-ChildItem –Path $env:GitRepo -Directory |
    Foreach-Object {
        $colour = SelectColour;
        Write-Host '-->'$_.Name'<--' -f $colour;
    
        if (($reset) -AND ($_.FullName -ne $PSScriptRoot)) {
            Write-Host 'Resetting branch...' -f $colour;
            git -C $_.FullName reset --hard
        }
        
        Write-Host 'Pulling main...' -f $colour;
        git -C $_.FullName checkout main;
        git -C $_.FullName pull;
    }
}