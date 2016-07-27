
hostscan() {
    touch hostlist.txt
    echo ">> Please enter IP/range"
       read ip_input
    echo $ip_input > hostlist.txt
    echo "$(tput setaf 3)[+]$(tpu sgr0) Running ping sweep on $ip_input"
       nmap -sP -iL hostlist.txt -oG pingscan > /dev/null
       grep Up pingscan | awk '{print$2}' > /root/Desktop/SCanResult/uplist
       grep Down pingscan | awk '{print$2}' > /root/Desktop/ScanResult/downlist
       cat /root/Desktop/ScanResult/uplist
    echo "$(tput setaf 2)[+]$(tput sgr0)Hosts that are up from '$ip_input'"
      rm hostlist.txt
}

portknock() {
    HOST=$1
    shift
    for ARG in "$@"
    do
        nmap -Pn --host_timeout 100 -T4 0 -p $ARG $HOST
    done
}

webscan() {
    clear

    # Check for Root
    function rootcheck() {
    if [[ $USER != "root" ]] ; then
    echo "Please Note: This script must be run as root!"
    exit 1
    fi
    echo -e " Checking for Root or Sudo: ${g}PASSED!${endc}"
    }
    rootcheck
    HOST=$1
    echo "=================================================="
    echo "=== Scanning $HOST. Please wait...======="
    echo "=================================================="
    sleep 2
    nmap -sS -p- $HOST -Pn -n --open
    sleep 2
    echo "   "
    echo "$(tput setaf 3)[+]$(tput sgr0) Now scanning port 80 for any web directories"
    sleep 2
    dirb http://$HOST
    echo "     "
    echo "$(tput setaf 2)[+]$(tput sgr0) Scan Complete!"
}

zonetransfer() {
    clear

    echo "Enter the domain name/URL"
    read domain

    dig NS $domain +short | sed -e "s/\.$//g" | while read nameserver; do echo "Testing $domain @ $nameserver"; dig AXFR $domain "@$nameserver"; done
}
