FROM ubuntu:20.04

# install any command you need.
# DEBIAN_FRONTEND=noninteractive --> do not ask for validation
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y nano curl

# If below lines are after "RUN apt-get *" command, docker will not run "RUN apt-get *" everytime cc_script change.
ADD infinity_loop.sh /cc_scripts/infinity_loop.sh
RUN chmod +x /cc_scripts/infinity_loop.sh

# The most commonly changing files must be in the most recent order in dockerfile.
ADD cc_scripts.sh /cc_scripts/cc_scripts.sh

ENTRYPOINT ["/cc_scripts/infinity_loop.sh"]
