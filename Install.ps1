param([switch]$WhatIf = $false, [Alias('d')][string]$GitDirectory, [Alias('f')][switch]$Force = $false, [Alias('v')][switch]$Verbose)

$installDir = Split-Path $MyInvocation.MyCommand.Path -Parent

Import-Module $installDir\src\lazy-git.psd1
Add-LazyGitToProfile -WhatIf:$WhatIf -GitDirectory:$GitDirectory -Force:$Force -Verbose:$Verbose
