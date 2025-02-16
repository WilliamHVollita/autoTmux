# autoTmux
sh script for automatically enable tmux environment when logged into shell

## !!! Warning !!!
### make sure you have another user(preferably root) able to log in, since bugs within all actions below may cause your user to be permanently unable to log in.

## Usage: 
### put autoTmux.sh in your home dir, then add following lines to your .xshrc (e.g. .bashrc, .zshrc): 
```
# If not inside a tmux session, and if the shell is interactive, then run the tmux menu script
if which tmux >/dev/null 2>&1 && [[ -z "$TMUX" ]] && [[ $- == *i* ]]; then
    ~/.autoTmux.sh
    exit
fi
```
