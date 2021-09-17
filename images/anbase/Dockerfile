FROM nvidia/cuda:11.0-base

RUN apt-get update && apt-get install --yes wget git
RUN mkdir -p /project
RUN wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh

WORKDIR /project
