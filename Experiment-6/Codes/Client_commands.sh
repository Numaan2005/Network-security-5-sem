#!/bin/bash

# Experiment 6: Secure Remote Login Using SSH
# Side: Kali Linux Client

# Step 1: Check the installed SSH client version
ssh -V

# Step 2: Connect to the Ubuntu server using password authentication
ssh hostname@192.168.125.129

# Commands executed inside the Ubuntu shell after Step 2
# Display the current username
whoami

# Display the Ubuntu server hostname
hostname

# Display the current working directory
pwd

# Return to the Kali Linux client
exit

# Step 3: Generate an Ed25519 SSH key pair
ssh-keygen -t ed25519 -C "student@lab"

# Step 4: Display the SSH key files
ls -l ~/.ssh/id_ed25519*

# Step 5: Display the fingerprint of the client's public key
ssh-keygen -lf ~/.ssh/id_ed25519.pub

# Step 6: Set restrictive permissions on the SSH directory
chmod 700 ~/.ssh

# Step 7: Set restrictive permissions on the private key
chmod 600 ~/.ssh/id_ed25519

# Step 8: Copy the public key to the Ubuntu server
ssh-copy-id -i ~/.ssh/id_ed25519.pub hostname@192.168.125.129

# Step 9: Test public-key authentication without password fallback
ssh -o PreferredAuthentications=publickey -o PasswordAuthentication=no tanish-sharma@192.168.125.129

# Commands executed inside the Ubuntu shell after Step 9
# Display the current username
whoami

# Display the Ubuntu server hostname
hostname

# Return to the Kali Linux client
exit

# Step 10: Start the SSH agent
eval "$(ssh-agent -s)"

# Step 11: Add the private key to the SSH agent
ssh-add ~/.ssh/id_ed25519

# Step 12: Connect to the Ubuntu server again
ssh hostname@192.168.125.129
