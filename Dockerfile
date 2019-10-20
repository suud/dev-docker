FROM ubuntu:latest

# install packages
RUN apt-get update
RUN apt-get install -y git python3 python3-pip

WORKDIR /app

# install dependencies in separate step, for better caching
ADD requirements.txt .
RUN pip3 install -r requirements.txt

ADD . .
