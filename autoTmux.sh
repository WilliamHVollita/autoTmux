#!/bin/bash -i

# Get a list of existing tmux sessions:
TMUX_SESSIONS=$(tmux ls | awk -F: '{print $1}')

# Get runtime
TIMI=$(date +"%Y-%m-%d_%H-%M-%S")

# Define a function to let user name a new session, with a key-word "time" which would automatically name the new session after current time
function name_new_session() {
    echo "####  Enter name for new session, type 'time' to name it after current time  ####"
    read -p " >> " new_session_name
    if [[ "$new_session_name" == "time" ]]; then
        tmux new -s $TIMI
        exit
    else
        tmux new -s $new_session_name
        exit
    fi
    exit
}

# If there are no existing sessions:
if [[ -z $TMUX_SESSIONS ]]; then
    echo "####  No existing tmux sessions. Creating a new session  ####"
    name_new_session
    exit
else
    # Present a menu to the user:
    echo "####  Existing tmux sessions  ####"
    cnt=0
    while IFS= read -r line; do
        ((cnt++))
        echo " $cnt: $line"
    done <<< "$TMUX_SESSIONS"
    echo " "
    # Update: i want user only to input the code number of wanted session, so that it could be much simpler (though simplicity is not really for coder  XD
    echo "####  Enter the code number of the session you want to attach to, 'new' to create a new session, or 'exit' to quit  ####"

    # WARR: just noticed that "tmux attach -t XXX" can not work properly inside a while structure, so i'm gonna setup
    mark_if_in="false"
    while [[ "$mark_if_in" == "false" ]]; do
        read -p " >> " user_input
        if [[ "$user_input" == "new" ]]; then
            name_new_session
            exit
        elif [[ "$user_input" =~ ^[0-9]+$ && "$user_input" -le "$cnt" ]]; then
            re_cnt=0
            while IFS= read -r line; do
                ((re_cnt++))
                if [[ "$re_cnt" -eq "$user_input" ]]; then
                    mark_if_in="$line"
                    break
                fi
            done <<< "$TMUX_SESSIONS"
        # Suggested by AI assistant, maybe i should simply add an "Elegent" way to let user choose whether to quit  XD
        elif [[ "$user_input" == "exit" ]]; then
            exit
        fi
        # If none of the conditions above were reached, that would mean an invalid input
        if [[ "$mark_if_in" == "false" ]]; then
            echo "####  ERR: Invalid input, please type the code number of an existing session  ####"
        fi
    done

    # If out, it means wanted session has been targeted, and now we can simply get in!  :)
    tmux attach -t "$mark_if_in"
    exit
fi
