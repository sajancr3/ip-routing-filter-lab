#!/bin/bash
set -e

echo "[+] Creating namespaces..."
ip netns add client 2>/dev/null || true
ip netns add router 2>/dev/null || true
ip netns add server 2>/dev/null || true

echo "[+] Creating veth pairs..."
ip link add veth-client type veth peer name veth-router1 2>/dev/null || true
ip link add veth-server type veth peer name veth-router2 2>/dev/null || true

echo "[+] Moving interfaces into namespaces..."
ip link set veth-client netns client 2>/dev/null || true
ip link set veth-router1 netns router 2>/dev/null || true
ip link set veth-server netns server 2>/dev/null || true
ip link set veth-router2 netns router 2>/dev/null || true

echo "[+] Assigning IP addresses..."
ip netns exec client ip addr add 10.0.1.2/24 dev veth-client 2>/dev/null || true
ip netns exec router ip addr add 10.0.1.1/24 dev veth-router1 2>/dev/null || true
ip netns exec router ip addr add 10.0.2.1/24 dev veth-router2 2>/dev/null || true
ip netns exec server ip addr add 10.0.2.2/24 dev veth-server 2>/dev/null || true

echo "[+] Bringing interfaces up..."
ip netns exec client ip link set lo up
ip netns exec client ip link set veth-client up

ip netns exec router ip link set lo up
ip netns exec router ip link set veth-router1 up
ip netns exec router ip link set veth-router2 up

ip netns exec server ip link set lo up
ip netns exec server ip link set veth-server up

echo "[+] Enabling IP forwarding on router..."
ip netns exec router sysctl -w net.ipv4.ip_forward=1

echo "[+] Adding default routes..."
ip netns exec client ip route add default via 10.0.1.1 2>/dev/null || true
ip netns exec server ip route add default via 10.0.2.1 2>/dev/null || true

echo "[+] Topology ready."
