#!/bin/bash
set -e

echo "[+] Cleaning old namespaces..."
sudo ip netns del client 2>/dev/null || true
sudo ip netns del r1 2>/dev/null || true
sudo ip netns del r2 2>/dev/null || true
sudo ip netns del server 2>/dev/null || true

echo "[+] Creating namespaces..."
sudo ip netns add client
sudo ip netns add r1
sudo ip netns add r2
sudo ip netns add server

echo "[+] Creating veth pairs..."
sudo ip link add veth-client type veth peer name veth-r1-client
sudo ip link add veth-r1-r2 type veth peer name veth-r2-r1
sudo ip link add veth-r2-server type veth peer name veth-server

echo "[+] Moving interfaces into namespaces..."
sudo ip link set veth-client netns client
sudo ip link set veth-r1-client netns r1
sudo ip link set veth-r1-r2 netns r1
sudo ip link set veth-r2-r1 netns r2
sudo ip link set veth-r2-server netns r2
sudo ip link set veth-server netns server

echo "[+] Assigning IP addresses..."
sudo ip netns exec client ip addr add 10.0.1.2/24 dev veth-client
sudo ip netns exec r1 ip addr add 10.0.1.1/24 dev veth-r1-client

sudo ip netns exec r1 ip addr add 10.0.12.1/24 dev veth-r1-r2
sudo ip netns exec r2 ip addr add 10.0.12.2/24 dev veth-r2-r1

sudo ip netns exec r2 ip addr add 10.0.2.1/24 dev veth-r2-server
sudo ip netns exec server ip addr add 10.0.2.2/24 dev veth-server

echo "[+] Bringing interfaces up..."
sudo ip netns exec client ip link set lo up
sudo ip netns exec client ip link set veth-client up

sudo ip netns exec r1 ip link set lo up
sudo ip netns exec r1 ip link set veth-r1-client up
sudo ip netns exec r1 ip link set veth-r1-r2 up

sudo ip netns exec r2 ip link set lo up
sudo ip netns exec r2 ip link set veth-r2-r1 up
sudo ip netns exec r2 ip link set veth-r2-server up

sudo ip netns exec server ip link set lo up
sudo ip netns exec server ip link set veth-server up

echo "[+] Enabling IP forwarding..."
sudo ip netns exec r1 sysctl -w net.ipv4.ip_forward=1
sudo ip netns exec r2 sysctl -w net.ipv4.ip_forward=1

echo "[+] Adding routes..."
sudo ip netns exec client ip route add default via 10.0.1.1
sudo ip netns exec server ip route add default via 10.0.2.1

sudo ip netns exec r1 ip route add 10.0.2.0/24 via 10.0.12.2
sudo ip netns exec r2 ip route add 10.0.1.0/24 via 10.0.12.1

echo "[+] 2-router topology ready"
