#!/bin/sh
while true; do
  if [ -d .git ]; then
    git pull
  else
    git clone --recurse-submodules -j8 https://github.com/ivancarlosti/parkingpage.git .
  fi
  sleep 1800  # Sleep for 30 minutes (1800 seconds)
done
