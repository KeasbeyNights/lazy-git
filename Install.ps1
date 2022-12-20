param([switch]$WhatIf = $false, [Alias('f')][switch]$Force = $false, [Alias('v')][switch]$Verbose)

$installDir = Split-Path $MyInvocation.MyCommand.Path -Parent

Import-Module $installDir\src\lazy-git.psd1
Add-LazyGitToProfile -WhatIf:$WhatIf -Force:$Force -Verbose:$Verbose
