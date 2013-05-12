#!/bin/bash

# the pwd is something like /home/node/node-service/releases/$date
# an npm package is here, waiting to be started.  Its dependencies
# are built, and ready to go.

# Some work needs to be done to ensure that the correct version of
# node gets used to start the server.

# If the required version is 0.4.0 or higher, then great.  Just
# symlink /opt/nodejs/<version>/bin/* into ./node_modules/.bin/
# and do `npm start`.  The require paths and such will be handled
# automatically according to the rules described in the node docs.

set -e
#set -x
NODE=/opt/local/bin/node
PARENT_PID=$$

# If we get a SIGUSR1 from the child process, then fail out.
trap exit_fail SIGUSR1
exit_fail () {
  exit 1
}


# make this a function so that it's not reliant on the PATH environ
npm () {
  $NODE /opt/local/bin/npm "$@" \
  || echo "failed" && return 1
}

ulimit -n 10241

( echo "Starting $$, Parent: $PARENT_PID"
  ENV=production PORT=80 $NODE app
  kill -SIGUSR1 $PARENT_PID
) &
sleep 1
exit 0