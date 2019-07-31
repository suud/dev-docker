FROM ubuntu

# install packages
RUN apt update && apt -y upgrade
RUN apt -y install git python3 python3-pip

# create mount dir
RUN mkdir /mnt/host
# use as workdir
WORKDIR /mnt/host
