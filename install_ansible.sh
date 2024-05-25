#!/bin/bash

# Update the package list and install prerequisites
sudo apt-get update
sudo apt-get install -y software-properties-common

# Add Ansible PPA and install Ansible dependencies
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible python3 python3-pip

# Install Ansible using pip
pip3 install ansible
