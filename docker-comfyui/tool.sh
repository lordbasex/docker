#!/usr/bin/bash

# Create folders and set permissions
mkdir -p ./user-data/models ./user-data/input ./user-data/output
chown -R 1000:1000 ./user-data
