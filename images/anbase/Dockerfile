FROM nvidia/cuda:11.0-base

ARG DEBIAN_FRONTEND=noninteractive
COPY repo /repo
COPY project /project

RUN apt-get update && apt-get install -yq wget git vim python3-pip python3.8-venv
RUN pip install --upgrade pip
RUN pip install wheel

WORKDIR /project


