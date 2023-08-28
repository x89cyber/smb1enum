# smb1enum
Enumerate a list of SMB share names using SMB v1 null session

smbclient must be installed

Uses smbclient null session login to SMB V1 to enumerate shares on a windows system.

This script is useful to find share names when smb credentials are not known and smbclient does not list the available shares for a null session:

smbclient -L [ip]

Modify the "shares" array to include other common names.

Usage:
smb1enum.sh [ip] [optional: port]
