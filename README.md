# Developer Environment Docker Image

## Overview

This repository contains a Dockerfile and startup script to build a development environment with Ubuntu 24.04, XFCE desktop, VNC server, SSH, Python, Flask, and Visual Studio Code.

## Features

Ubuntu 24.04 base image

XFCE4 desktop environment with VNC support

Pre-installed Visual Studio Code

Python 3 with Flask, Gunicorn, and PostgreSQL client

SSH server for remote access

Non-root developer user with sudo access

# Setup and Usage

## 1. Build the Docker Image

docker build -t my-developer-image:latest .

## 2. Run the Container

docker run -d -p 5901:5901 -p 2200:22 --name developer-env my-developer-image:latest

## 3. Connect to the Container

SSH Access:

ssh developer@localhost -p 2200

Password: password

VNC Access:

Use a VNC client to connect to localhost:5901 with the password password.

## 4. Start Coding

Open a terminal in the container: xfce4-terminal

Activate the virtual environment: source /home/developer/venv/bin/activate

Start a Flask app: gunicorn --bind 0.0.0.0:5000 app:app
