#!/bin/bash

#Source our config file.  Should contain the following lines:
#server - IP address of the server that is running the logparser script and is hosting the parsed log file
#password - The user's password to login as an authenticated user on the proxy server
source .config

#Pull in our list of ips/names and put it into an array, then break this up into sub arrays
curl $server:3000/log > testarray

cat testarray | awk '{print $1}' > ip
cat testarray | awk '{print $2}' > name


declare -a ip_array=()

declare -a name_array=()

#loop over list of ip addresses adding each to an array
while read -r ip; do
        ip_array+=($ip)
done < ./ip

#loop over list of names adding each to an array
while read -r name; do
        name_array+=($name)
done < ./name


length=`wc -l ip | sed "s/ip//g"`

echo $length

#For each entry in our list, send a POST request to the login page of the smoothwall proxy server.  This can only be done on the smoothwall itself.
#If it was done from another server then the X-Forwarded-For header would not be preserved and the login would be assigned to whatever IP address was making
#the request.
ITERATION=0
while [ $ITERATION -lt $length ]; do
echo 'curl --header "X-Forwarded-For: '${ip_array[$ITERATION]}'" -d "USERNAME='${name_array[$ITERATION]}'&PASSWORD='${password}'&submit=Login" http://192.168.8.21/ilogin' | bash;
	let ITERATION=ITERATION+1
done
