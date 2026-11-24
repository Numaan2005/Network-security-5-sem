#!/bin/bash

# EXPERIMENT 9: SET UP AN IPsec VPN IN TUNNEL MODE USING STRONGSWAN
#
# This file contains the commands used during the experiment.
# Run the commands on the specified gateway wherever indicated.
#
# Gateway A Outer IP: 192.168.229.128
# Gateway B Outer IP: 192.168.229.129
#
# Gateway A Inner IP: 10.10.1.1/32
# Gateway B Inner IP: 10.20.1.1/32
#
# IMPORTANT:
# - Replace the PSK placeholder with the same generated key on both gateways.
# - Never upload or share the actual PSK.
# - Commands are organized by step; do not execute the entire file at once.

# ------------------------------------------------------------
# 1. CHECK NETWORK CONNECTIVITY
# Run on both gateways
# ------------------------------------------------------------

# Display network interfaces and IP addresses.
ip -br address

# Test connectivity to the other gateway.
# Run on Gateway A:
ping -c 3 192.168.229.129

# Run on Gateway B:
ping -c 3 192.168.229.128

# Check the route to the other gateway.
# Run on Gateway A:
ip route get 192.168.229.129

# Run on Gateway B:
ip route get 192.168.229.128


# ------------------------------------------------------------
# 2. INSTALL AND START STRONGSWAN
# Run on both gateways
# ------------------------------------------------------------

# Update package information.
sudo apt update

# Install strongSwan, swanctl and tcpdump.
sudo apt install charon-systemd strongswan-swanctl tcpdump

# Enable and start the strongSwan service.
sudo systemctl enable --now strongswan

# Check the service status.
sudo systemctl status strongswan --no-pager

# Verify the swanctl version.
sudo swanctl --version

# Verify the running daemon version.
sudo swanctl --version --daemon


# ------------------------------------------------------------
# 3. CONFIGURE INNER LOOPBACK ADDRESSES
# ------------------------------------------------------------

# Run on Gateway A:
sudo ip address add 10.10.1.1/32 dev lo

# Run on Gateway B:
sudo ip address add 10.20.1.1/32 dev lo

# Verify the loopback interface on both gateways.
ip -br address show dev lo


# ------------------------------------------------------------
# 4. INSPECT FIREWALL CONFIGURATION
# Run on both gateways
# ------------------------------------------------------------

# Check UFW firewall status.
sudo ufw status

# Inspect nftables rules.
sudo nft list ruleset

# IPsec may require:
# UDP port 500  - IKE
# UDP port 4500 - NAT Traversal
# IP protocol 50 - ESP


# ------------------------------------------------------------
# 5. GENERATE A PRE-SHARED KEY (PSK)
# Run on one gateway only
# ------------------------------------------------------------

# Generate a random pre-shared key.
openssl rand -base64 33

# Copy the generated key securely to the other gateway.
# Use the same key on both gateways.
# Do not include the actual key in screenshots or GitHub.


# ------------------------------------------------------------
# 6. CONFIGURE GATEWAY A
# Run on Gateway A only
# ------------------------------------------------------------

# Open the strongSwan configuration file.
sudo nano /etc/swanctl/swanctl.conf

# Add the following configuration.
# Replace the PSK placeholder with the generated key.
#
# connections {
#     lab-vpn {
#         version = 2
#         local_addrs = 192.168.229.128
#         remote_addrs = 192.168.229.129
#
#         proposals = aes256gcm16-prfsha256-modp3072
#
#         local {
#             auth = psk
#             id = gw-a
#         }
#
#         remote {
#             auth = psk
#             id = gw-b
#         }
#
#         children {
#             lab-net {
#                 local_ts = 10.10.1.1/32
#                 remote_ts = 10.20.1.1/32
#                 esp_proposals = aes256gcm16
#             }
#         }
#     }
# }
#
# secrets {
#     ike-lab {
#         id = gw-a
#         secret = 0sREPLACE_WITH_GENERATED_PSK
#     }
# }


# ------------------------------------------------------------
# 7. CONFIGURE GATEWAY B
# Run on Gateway B only
# ------------------------------------------------------------

# Open the strongSwan configuration file.
sudo nano /etc/swanctl/swanctl.conf

# Add the following configuration.
# Use the same PSK generated earlier.
#
# connections {
#     lab-vpn {
#         version = 2
#         local_addrs = 192.168.229.129
#         remote_addrs = 192.168.229.128
#
#         proposals = aes256gcm16-prfsha256-modp3072
#
#         local {
#             auth = psk
#             id = gw-b
#         }
#
#         remote {
#             auth = psk
#             id = gw-a
#         }
#
#         children {
#             lab-net {
#                 local_ts = 10.20.1.1/32
#                 remote_ts = 10.10.1.1/32
#                 esp_proposals = aes256gcm16
#             }
#         }
#     }
# }
#
# secrets {
#     ike-lab {
#         id = gw-b
#         secret = 0sREPLACE_WITH_GENERATED_PSK
#     }
# }


# ------------------------------------------------------------
# 8. LOAD AND VERIFY CONFIGURATION
# Run on both gateways
# ------------------------------------------------------------

# Set secure permissions for the configuration file.
sudo chmod 600 /etc/swanctl/swanctl.conf

# Load the configuration.
sudo swanctl --load-all

# Display the loaded connections.
sudo swanctl --list-conns


# ------------------------------------------------------------
# 9. ESTABLISH THE IPsec VPN TUNNEL
# Run on Gateway A
# ------------------------------------------------------------

# Initiate the CHILD SA.
sudo swanctl --initiate --child lab-net

# Monitor strongSwan logs if required.
sudo journalctl -u strongswan -f

# Display established IKE and CHILD security associations.
sudo swanctl --list-sas


# ------------------------------------------------------------
# 10. VERIFY IPsec STATES AND POLICIES
# Run on both gateways
# ------------------------------------------------------------

# Display IPsec XFRM states.
sudo ip xfrm state

# Display IPsec XFRM policies.
sudo ip xfrm policy


# ------------------------------------------------------------
# 11. TEST PROTECTED COMMUNICATION
# ------------------------------------------------------------

# Run on Gateway A to ping Gateway B's inner address.
ping -I 10.10.1.1 -c 4 10.20.1.1

# Run on Gateway B to test communication in the reverse direction.
ping -I 10.20.1.1 -c 4 10.10.1.1

# Display the IPsec traffic counters.
sudo swanctl --list-sas


# ------------------------------------------------------------
# 12. OPTIONAL: CAPTURE IPsec NETWORK TRAFFIC
# ------------------------------------------------------------

# Identify the outer network interface.
ip -br address

# Replace OUTER_IF with the actual interface name.
# Capture IKE, NAT-T, ESP and AH traffic.
sudo tcpdump -ni OUTER_IF -w exp9-ipsec.pcap 'udp port 500 or udp port 4500 or proto 50 or proto 51'

# Stop the capture using Ctrl+C.
#
# Wireshark display filter:
# isakmp || esp || ah


# ------------------------------------------------------------
# 13. CLEANUP (OPTIONAL)
# ------------------------------------------------------------

# Terminate the CHILD SA from Gateway A.
sudo swanctl --terminate --child lab-net

# Remove the inner address from Gateway A.
sudo ip address del 10.10.1.1/32 dev lo

# Remove the inner address from Gateway B.
sudo ip address del 10.20.1.1/32 dev lo


# ------------------------------------------------------------
# END OF EXPERIMENT 9
# ------------------------------------------------------------
