# Use it inside docker (or any other container)

Add these steps inside any dockerfile:

```dockerfile
ADD "https://raw.githubusercontent.com/yusuf-daglioglu/cc_scripts/master/release/cc_scripts.sh" "/this_path/is_inside_docker/cc_scripts.sh"
```

or if __cc_scripts.sh__ file is being already downloaded on your local:

```sh
COPY "/this_path/is_inside/local_machine/cc_scripts.sh" "/this_path/is_inside_docker/cc_scripts.sh"
```

When you attach on docker and run this command:

```sh
source "/this_path/is_inside_docker/cc_scripts.sh"
```
