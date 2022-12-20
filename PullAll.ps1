
# $allColours = [enum]::GetValues([System.ConsoleColor])
$colourOptions = @('DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkMagenta', 'DarkYellow', 'Cyan', 'Magenta'); #, 'Blue', 'Green', 'Yellow')
$global:colours = @();
$repoDirectory = Split-Path $PSScriptRoot;

function SelectColour() {
    
    if ($global:colours.Count -lt 1) {
        $global:colours = $colourOptions;
    }
    
    # $selectedColour = if ($global:colours.Count -eq 1) { $global:colours } else { (Get-random $global:colours) };    
    $selectedColour = ($global:colours.Count -eq 1) ? $global:colours : (Get-random $global:colours);
    $global:colours = $global:colours | Where-Object { $_ -ne $selectedColour };

    return $selectedColour;
}

function PullAll([Alias('r')][switch]$reset){
    Write-Host 'MODULE:Pulling all repos in' $repoDirectory -f Yellow
    Get-ChildItem –Path $repoDirectory -Directory |
    
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