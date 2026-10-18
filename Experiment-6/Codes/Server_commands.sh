
#!/bin/bash

# Experiment 6: Secure Remote Login Using SSH
# Side: Ubuntu Server

# Step 1: Install the OpenSSH server
sudo apt install openssh-server

# Step 2: Start the SSH service
sudo systemctl start ssh

# Step 3: Check the SSH service status
sudo systemctl status ssh

# Step 4: Verify that SSH is listening on port 22
sudo ss -tlnp | grep ':22'

# Step 5: Display the server username
whoami

# Step 6: Display the server hostname
hostname

# Step 7: Display the server IP address
hostname -I

# Step 8: Display the fingerprint of the server's SSH host public key
sudo ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub
