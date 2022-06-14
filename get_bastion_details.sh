TMP_FILE=bastion_session_id
YOUR_PRIVATE_KEY_LOCATION=YOUR_PRIVATE_KEY
cat $TMP_FILE |  xargs oci bastion session get --session-id | grep "command" | sed -e 's/"command": //' -e "s:<privateKey>:$YOUR_PRIVATE_KEY_LOCATION:" -e 's/<localPort>/6443/'  -e 's/"//g' -e 's/ssh //' | xargs ssh 
