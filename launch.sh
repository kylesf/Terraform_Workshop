#!/bin/bash

# Initialize just in case
terraform init

# Remove older server file compression if it exists
if [ -f "server_files.tar.gz" ]
then
    rm server_files.tar.gz
fi

# Compress server files
tar czf server_files.tar.gz resources/

# run terraform
terraform apply -auto-approve -var random_s3_name=$RANDOM