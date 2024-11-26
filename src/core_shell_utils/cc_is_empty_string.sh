___is_empty_string() {

   # -z -> checks if it is empty
   if [ -z "$1" ]; then
      return 0
   fi

   # NULL is a custom string which is using in this project. it's not a standard.
   if [ "$1" = "NULL" ]; then
      return 0
   fi

   return 1
}
