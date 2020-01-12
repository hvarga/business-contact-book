#!/bin/sh

xhost local:root
docker run -it --rm --privileged \
    -e USER_ID=$(id -u) \
    -e GROUP_ID=$(id -g) \
    -e USER_NAME=$(id -un) \
    -e GROUP_NAME=$(id -gn) \
    -v /etc/localtime:/etc/localtime \
    -v $(pwd):/opt/workspace \
    -e DISPLAY="$DISPLAY" \
    -e XAUTHORITY=/var/run/xauthority \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$HOME"/.Xauthority:/var/run/xauthority \
    -v /dev/shm:/dev/shm \
    hvarga/business-contact-book
