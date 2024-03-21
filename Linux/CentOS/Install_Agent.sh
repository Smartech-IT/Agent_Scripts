#!/bin/bash
#author: https://github.com/MrGulczu
stty size | perl -ale 'print "-"x$F[1]'
echo "Agent installation"

read -p "Do You want to continue? [Y/N] : " Start
if [ "$Start" == "N" ] || [ "$Start" == "n" ];
    then
        exit 0
    fi
stty size | perl -ale 'print "-"x$F[1]'
curl -o wazuh-agent-4.7.2-1.x86_64.rpm https://packages.wazuh.com/4.x/yum/wazuh-agent-4.7.2-1.x86_64.rpm && sudo WAZUH_MANAGER='83.168.108.76' WAZUH_AGENT_GROUP='Agent_Group' WAZUH_AGENT_NAME='Agent_Name' rpm -ihv wazuh-agent-4.7.2-1.x86_64.rpm
isok=true
while $isok
do
    read -p "Enter provided client port: " clientport
    read -p "Enter provided enrollment port: " enrollmentport
    read -p "Enter name for Wazuh Agent: " wazuhagentname
    read -p "Enter group name for Wazuh Agent: " wazuhagentgroup
    read -p "Those are correct? [Y/N]: " yesorno
    if [ "$yesorno" == "Y" ] || [ "$yesorno" == "y" ];
    then
        isok=false
    fi
done
stty size | perl -ale 'print "-"x$F[1]'

ConfigFile="/var/ossec/etc/ossec.conf"

sed -i "s/<port>1514<\/port>/<port>$clientport<\/port>/g" $ConfigFile
sed -i "s/<agent_name>Agent_Name<\/agent_name>/<agent_name>$wazuhagentname<\/agent_name>\n      <port>$enrollmentport<\/port>/g" $ConfigFile
sed -i "s/<groups>Agent_Group<\/groups>/<groups>$wazuhagentgroup<\/groups>/g" $ConfigFile

systemctl daemon-reload
systemctl enable wazuh-agent
systemctl start wazuh-agent
