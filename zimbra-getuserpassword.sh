#
# !/bin/bash
# Yucca Systems Inc.
# Description
# Get zimbra ldap password hashes for a given domain or user
#

usage()
{
  echo "Usage: $0 [ -u|-d USER_EMAIL|DOMAIN_NAME ] "
  exit 2
}

ZIMBRA_USER="zimbra"
ZMPROV=$(runuser -l $ZIMBRA_USER -c "which zmprov")

while getopts ":u:d:" opt; do
  case $opt in
    u) USER_EMAIL="$OPTARG"
    ;;
    d) DOMAIN="$OPTARG"
       USER_EMAIL=$($ZMPROV -l gaa $DOMAIN)
    ;;
    \?) echo "Invalid option -$OPTARG" >&2 && usage
    ;;
  esac
done

getuserPassword (){
for ACCOUNT in $USER_EMAIL;
        do
                $ZMPROV -l ga $ACCOUNT userPassword | sed '/^#\|^$/d' | awk -v user=$ACCOUNT -F: '{print "zmprov ma " user " "  $1 $2}'
        done
}

if [ -z "$USER_EMAIL" ] && [ -z "$DOMAIN" ]
then
   usage
   exit
else
   getuserPassword
fi
