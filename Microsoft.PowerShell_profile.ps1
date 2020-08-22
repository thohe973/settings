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
  $base = ""
  $path = "$($executionContext.SessionState.Path.CurrentLocation)"

  if (Test-Path .git) {
    Write-Host $path -NoNewline -ForegroundColor "blue"
    Write-BranchName
    Write-Host ">" -NoNewline -ForegroundColor "blue"
  }
  else {
    Write-Host $path -NoNewline -ForegroundColor "blue"
    Write-Host ">" -NoNewline -ForegroundColor "blue"
  }

  return " "
}

# Autocomplete 'cd ..' to 'cd ..\' when tabbing
Copy Function:TabExpansion2 Function:OriginalTabExpansion
function TabExpansion([string] $line, [string] $lastword) {
  if ($line -eq 'cd ..') {
    return '..\'
  } elseif ($line -eq 'cd ..\..') {
    return '..\..\'
  } elseif ($line -eq 'cd ..\..\..') {
    return '..\..\..\'
  } elseif ($line -eq 'cd ..\..\..\..') {
    return '..\..\..\..\'
  } else {
   OriginalTabExpansion $line $lastword | Out-Host
  }
}
