ARG  IMAGE=debian
ARG  TAG=latest

FROM ${IMAGE}:${TAG}

LABEL maintainer="Timo Sutterer <hi@timo-sutterer.de>"

# install locales (might be required by some packages)
RUN apt-get update && apt-get install -y locales && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# update and install packages
RUN apt-get update && apt-get install -qq \
    software-properties-common \
    curl \
    git \
    zsh
