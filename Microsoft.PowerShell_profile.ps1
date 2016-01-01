function Prompt ($param1, $param2)
{
    $isGit = Get-GitDirectory
    if($isGit) {
        Write-Host "GIT " -NoNewline
    } else {
        Write-Host "PS " -NoNewline
    }
    
    Write-Host "$($executionContext.SessionState.Path.CurrentLocation.Path.Replace($env:HOME, "~"))" -NoNewline
    
    if($isGit) {
        Write-VcsStatus
    }
    
    "$('>' * ($nestedPromptLevel + 1)) "
}