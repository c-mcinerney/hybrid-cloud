UUID=$(cat /dev/urandom | env LC_CTYPE=C tr -dc a-zA-Z0-9 | head -c 16; echo)
SSH_SWITCH_LIST=$PWD/.$${UUID}_switch
cat > $${SSH_SWITCH_LIST} <<EOL
${cisco_hostname}
EOL
SSH_PAYLOAD=$PWD/.$${UUID}_commands
cat > $${SSH_PAYLOAD} <<EOL
${cisco_commands}
EOL
SSH_EXEC_SCRIPT=/tmp/.$${UUID}_ssh-exec
cat > $${SSH_EXEC_SCRIPT} <<EOL
#!/bin/sh
touch .$${UUID}_status
COMMAND="docker run -v \$PWD:\$PWD -it bernadinm/crassh python crassh.py -s $SSH_SWITCH_LIST -c $SSH_PAYLOAD -U ${cisco_user} -P ${cisco_password}"
echo "please wait...Cisco SSH Agent starts ~5 mins...";
while [ 0 -eq \$(grep -c FINISHED .$${UUID}_status) ]; do \$COMMAND | sed -e 's/Connection Failed: timed out/waiting for Cisco SSH agent to start.../g' | sed -e 's/Unexpected.\+/waiting for Cisco SSH agent to start.../g' | tee .$${UUID}_status; sleep 30; done
rm .$${UUID}_status
EOL
chmod u+x $${SSH_EXEC_SCRIPT}
sh $${SSH_EXEC_SCRIPT}