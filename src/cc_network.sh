# RESERVED CUSTOM EXIT CODE: 1011000 - 1012000
# RESERVED STANDART EXIT CODE: -

c_tor_run_with_command() {

   local -r TOR_CONFIG_FILE="$CC_STANDALONE_APPS_PATH_ROOT/../tor_config.txt"
   local -r TOR_EXECUTABLE="$CC_STANDALONE_APPS_PATH_ROOT/tor/usr/bin/tor"
   local -r LIB_EVENT_PATH="$CC_STANDALONE_APPS_PATH_ROOT/libevent-2.1-6_2.1.8-stable-4build1_amd64/usr/lib/x86_64-linux-gnu"

   ___do_executables_exist "$TOR_EXECUTABLE" "cp" "read" || return

   # getting default configs
   ___execute cp "$CC_STANDALONE_APPS_PATH_ROOT/tor/etc/tor/torrc" "$TOR_CONFIG_FILE" || {
      ___errorHandler "$?" 1011001
      return
   }

   # adding custom configs
   ___stdout_using_format "\n%s\n%s" 'ControlPort 9051 # "torsocks" will connect this port as default.' 'CookieAuthentication 0' >>"$TOR_CONFIG_FILE" || {
      ___errorHandler "$?" 1011002
      return
   }

   COMMAND__TO_RUN_ON_NEW_SHELL="export LD_LIBRARY_PATH=\"$LIB_EVENT_PATH\"; \"$TOR_EXECUTABLE\" --defaults-torrc \"$TOR_CONFIG_FILE\""

   ___print_title "run below command on another terminal window:"
   ___print_screen "$COMMAND__TO_RUN_ON_NEW_SHELL"
   ___print_screen
   ___print_screen "check the other terminal if tor started (connected to any bridge) properly. if yes, then type 'y', otherwise 'n'."
   read userChoice

   if [ "$userChoice" = "y" ]; then
      # default settings are enough to run
      export TORSOCKS_CONF_FILE="$CC_STANDALONE_APPS_PATH_ROOT/torsocks/etc/tor/torsocks.conf"
      ___execute_with_eval "LD_PRELOAD=\"$CC_STANDALONE_APPS_PATH_ROOT/torsocks/usr/lib/x86_64-linux-gnu/torsocks/libtorsocks.so\" $@"
      ___print_screen "Close the other terminal window with CTRL+C. Otherwise it will work background."
   else
      ___print_screen "script will exit"
   fi
}

c_port_open_serving_string_HELP_ONLY() {

   ___print_screen "-l --> creates server connection"
   ___print_screen "-n --> do not lookup DNS"
   ___print_screen "-v --> verbose output"
   ___print_screen 'printf '%s' "TEXT TO SHARE" | nc -n -v -l PORT; c_notify_user 2 "port closed"'
}

c_port_kill_all_processes_by_port_number_HELP_ONLY() {

   ___print_screen "-t --> show only process ID"
   ___print_screen "-i --> show only internet connections related process"
   ___print_screen "-9 --> kill forcefully"
   ___print_screen 'kill -9 $(lsof -t -i:PORT_NUMBER)'
}

c_port_details_HELP_ONLY() {
   ___print_screen "ss --all --processes --tcp --udp | color_line"
   ___print_screen "netstat -p -u -t -a | color_line"
}

c_host_file_edit_or_view_HELP_ONLY() {
   HOST_FILE="/etc/hosts"
   ___execute_and_color_line cat "$HOST_FILE"
   ___print_screen "sudo gedit $HOST_FILE"
}

c_host_names_and_local_ip_addresses_HELP_ONLY() {
   ___print_screen "list of all full host names"
   ___execute hostname -A
   ___print_screen "list of all IP addresses for this host"
   ___execute hostname -I
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
   ___print_title "If you need a json to see what is each value, use below command and format it with ny json pritifier."
   ___print_screen "ip -j a"
   ___print_screen
   ___print_screen "ifconfig -a"
}
