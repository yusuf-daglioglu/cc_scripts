# RESERVED CUSTOM EXIT CODE: 1011000 - 1012000
# RESERVED STANDART EXIT CODE: -

c_port_open_serving_string_HELP_ONLY() {

   ___print_screen "-l --> creates server connection"
   ___print_screen "-n --> do not lookup DNS"
   ___print_screen "-v --> verbose output"
   ___print_title 'printf '%s' "TEXT TO SHARE" | nc -n -v -l PORT; c_notify_user 2 "port closed"'
}

c_port_kill_all_processes_by_port_number_HELP_ONLY() {

   ___print_screen "-t --> show only process ID"
   ___print_screen "-i --> show only internet connections related process"
   ___print_screen "-9 --> kill forcefully"
   ___print_title 'kill -9 $(lsof -t -i:PORT_NUMBER)'
}

c_port_details_HELP_ONLY() {
   ___print_screen "ss --all --processes --tcp --udp | color_line"
   ___print_screen "netstat -p -u -t -a | color_line"
}

c_host_names_and_local_ip_addresses_HELP_ONLY() {
   ___print_screen
   ___print_screen "list of all full host names"
   ___execute hostname -A

   ___print_screen
   ___print_screen "list of all IP addresses for this host"
   ___execute hostname -I
   ___print_screen

   HOST_FILE="/etc/hosts"
   ___execute_and_color_line cat "$HOST_FILE"
   
   ___print_screen
   ___print_title "edit host file" 
   ___print_screen "sudo gnome-text-editor $HOST_FILE"
}

c_ip_external() {
   ___execute dig +short myip.opendns.com @resolver1.opendns.com
}

c_ip_HELP_ONLY() {
   ___print_title "PARAMETERS" 
   ___print_screen "COLORFUL OUTPUT = -c"
   ___print_screen "SHOW ALL INTERFACES = -a"
   ___print_screen
   ___print_screen "ip -c a"
   ___print_screen
   ___print_title "If you need a json to see what is each value, use below command and format it with any json pritifier (text editor)."
   ___print_screen "ip -j a"
   ___print_screen
   ___print_title "Deprecated command:"
   ___print_screen "ifconfig -a"
}
