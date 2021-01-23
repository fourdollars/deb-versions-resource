FROM ubuntu:focal
RUN apt-get update
RUN apt-get full-upgrade --yes
RUN apt-get install --yes software-properties-common jq debian-archive-keyring distro-info
ADD /check /opt/resource/check
ADD /out /opt/resource/out
ADD /in /opt/resource/in
RUN chmod +x /opt/resource/*
