#!/bin/bash

# Deploy the app to servers in ./ansible/hosts

ansible-playbook --private-key=~/.vagrant.d/insecure_private_key -u vagrant -i ansible/hosts ansible/app.yml
