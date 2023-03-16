#!/usr/bin/env bash

sudo apt-get -y update

sudo apt-get install -y docker.io

sudo docker run -d -p 8080:8000 --restart always paulspartan/academy-sre-bootcamp-paul-mena:latest