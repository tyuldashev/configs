# Bash-like completion with an interactive menu
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

Set-PSReadLineOption -EditMode Emacs

# Invoke-Expression (&starship init powershell)
# Invoke-Expression (& { (zoxide init powershell | Out-String) })

Set-Alias -Name v -Value nvim
