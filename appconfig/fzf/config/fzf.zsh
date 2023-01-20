# Setup fzf
# ---------
if [[ ! "$PATH" == */home/klaxalk/git/linux-setup/submodules/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}${HOME}/tiago_git/linux-setup/submodules/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${HOME}/tiago_git/linux-setup/submodules/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
# source "${HOME}/tiago_git/linux-setup/submodules/fzf/shell/key-bindings.zsh"
