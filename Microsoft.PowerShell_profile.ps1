# Create profile file
# > New-Item -path $profile -type file -force
# Set execution policy
# > Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

# Reload profile
# . $PROFILE

Set-PSReadlineKeyHandler -Key Tab -Function Complete

function Write-BranchName () {
  try {
    $branch = git symbolic-ref --short -q HEAD

    if ($branch -ne $null) {
      Write-Host " ($branch)" -ForegroundColor "cyan" -NoNewline
    }
    else {
      # Detached state
      $branch = git rev-parse --short HEAD
      Write-Host " ($branch)" -ForegroundColor "red" -NoNewline
    }
  } catch {
    Write-Host " (unkown)" -ForegroundColor "yellow" -NoNewline
  }
}

# Add git branch to prompt
function prompt {
  $Host.UI.RawUI.WindowTitle = "$pwd".replace('C:\git\','')
  $base = ""
  $path = "$($executionContext.SessionState.Path.CurrentLocation)"

  if (Test-Path .git) {
    Write-Host $path -NoNewline -ForegroundColor "blue"
    Write-BranchName
    Write-Host "`r`n>" -NoNewline -ForegroundColor "blue"
  }
  else {
    Write-Host $path -NoNewline -ForegroundColor "blue"
    Write-Host "`r`n>" -NoNewline -ForegroundColor "blue"
  }

  return " "
}

# Autocomplete '..' to '..\' when tabbing
Copy Function:TabExpansion2 Function:OriginalTabExpansion
function TabExpansion([string] $line, [string] $lastword) {
  if ($lastword.EndsWith('..')) {
    return $lastword + '\'
  } else {
    OriginalTabExpansion $line $lastword | Out-Host
  }
}

# Fast node manager
# fnm env --use-on-cd | Out-String | Invoke-Expression

function gitStatus { git status }
Set-Alias gs gitStatus

del alias:gl -Force
function gitPull { git pull }
Set-Alias gl gitPull

del alias:gp -Force
function gitPush { git push }
Set-Alias gp gitPush

function gitCheckout { git checkout $args }
Set-Alias gco gitCheckout

function gitAddCommit {
    $commandLine = $MyInvocation.Line
    $message = $commandLine -replace '^gac\s+', ''
    git add -A
    git commit -m "$message"
}
Set-Alias gac gitAddCommit

del alias:gc -Force
function gitCommit { git commit -m "$args" }
Set-Alias gc gitCommit
