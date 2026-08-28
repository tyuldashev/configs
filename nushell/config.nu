# config.nu
#
# Installed by:
# version = "0.114.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# -------------------------
# Display / formatting
# -------------------------
$env.config = ($env.config | merge {
  show_banner: false
  float_precision: 3
})


# -------------------------
# Common apps
# -------------------------

alias v = nvim

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	^yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != $env.PWD and ($cwd | path exists) {
		cd $cwd
	}
	rm -fp $tmp
}

# -------------------------
# Git commands
# -------------------------
alias gf = git fetch
def gs [] { git status }
def ga [file] { git add $file }
def gb [] { git branch }
def gco [branch] { git checkout $branch }

def gc [msg] { git commit -m $msg }

def gundo [] { git reset --soft HEAD~1 }

def gd [] { git diff }

def gl [] { git log --oneline --graph --decorate }
def gll [] { git log --stat }

def gp [] { git push }
def gpl [] { git pull }

# fzf-powered
def gbf [] {
    let branch = (
        git for-each-ref --format="%(refname:short)" refs/heads refs/remotes
        | fzf --accept-nth 1 
        | str trim
    )

    if $branch != "" {
        git checkout $branch
    }
}

def gcf [] {
    let commit = (git log --oneline | fzf | split row " " | get 0)
    if $commit != "" { git checkout $commit }
}

def gaf [] {
    let file = (git status --short | fzf | split row " " | get 1)
    if $file != "" { git add $file }
}


# -------------------------
# Navigation
# -------------------------
def .. [] { cd .. }
def ... [] { cd ../.. }
def .... [] { cd ../../.. }

alias ll = ls -la

source .zoxide.nu
