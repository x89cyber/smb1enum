#!/bin/bash

#################################################################################
# smb1enum.sh
#     by xoltar89
#
# Uses smbclient null session login to SMB V1 to enumerate smb shares on a
# windows machine.
# 
# This script is useful to find share names when smb credentials are not known
# and smbclient does not list the available shares with this command:
#
# smbclient -L [ip]
#
# Modify the "shares" array to include other common share names.
# 
# Usage:
# ./smb1enum.sh <ip address> [port]
#################################################################################

shares=("C$" "D$" "ADMIN$" "IPC$" "PRINT$" "FAX$" "SYSVOL" "NETLOGON" "SHARE")

if [ $# -lt 1 ]; then
    echo "Usage: $0 <IP_address> [port]"
    exit 1
else
    ip="$1"
    port="${2:-445}"  #if port is supplied use it else default to 445

    echo "Connecting to $ip:$port..."
    for share in ${shares[*]}; do
        echo "calling: smbclient -U '%' -N \\\\$ip\\$share -c '' -p $port"
        output=$(smbclient -U '%' -N \\\\$ip\\$share -c '' -p $port 2>&1) #redirect stderr to stdout 
        
        if [[ $output != *"NT_STATUS"* ]]; then #if output doesn't have "NT_STATUS" assume null session connected 
            echo "[+] $share is available" 
        elif [[ $output == *"NT_STATUS_ACCESS_DENIED" ]]; then
	    echo "[*] $share is available - could not login with null session!"	
	elif [[ $output == *"NT_STATUS_BAD_NETWORK_NAME" ]]; then
	    echo "[-] $share was not be found"
        else
            echo "[-] $output"  #unhandled error - output message
        fi
    done
fi
