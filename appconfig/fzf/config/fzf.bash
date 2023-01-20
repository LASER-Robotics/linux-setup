# Setup fzf
# ---------
if [[ ! "$PATH" == */home/tiagopn/tiago_git/linux-setup/submodules/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}${HOME}/tiago_git/linux-setup/submodules/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${HOME}/tiago_git/linux-setup/submodules/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
# source "${HOME}/tiago_git/linux-setup/submodules/fzf/shell/key-bindings.bash"
