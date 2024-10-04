c_docker_list_all_containers() {
   ___print_screen SHOW ALL CONTAINERS = -a
   ___print_screen LIST THE CONTAINERS = ps
   ___execute_and_color_line docker ps -a
}

c_docker_stop_force_all_containers() {
   ___print_screen ONLY DISPLAY NUMERIC ID S = -q
   ___print_screen SHOW ALL CONTAINERS = -a
   ___print_screen LIST THE CONTAINERS = ps
   ___print_screen FORCE REMOVE RUNNING CONTAINER = -f
   ___print_screen REMOVE CONTAINER = rm
   ___execute_with_eval 'docker stop $(docker ps -a -q)'
}

c_docker_remove_force_all_containers() {

   ___print_screen ONLY DISPLAY NUMERIC ID S = -q
   ___print_screen SHOW ALL CONTAINERS = -a
   ___print_screen LIST THE CONTAINERS = ps
   ___execute_with_eval 'docker stop $(docker ps -a -q)'
   ___execute_with_eval 'docker rm -f $(docker ps -a -q)'
}
