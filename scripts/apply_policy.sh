#!/bin/bash
set -e

ACTION=$1
PROTOCOL=$2
PORT=$3

if [ -z "$ACTION" ] || [ -z "$PROTOCOL" ]; then
  echo "Usage:"
  echo "./scripts/apply_policy.sh block icmp"
  echo "./scripts/apply_policy.sh allow icmp"
  echo "./scripts/apply_policy.sh block tcp 8080"
  echo "./scripts/apply_policy.sh allow tcp 8080"
  exit 1
fi

if [ "$ACTION" = "block" ] && [ "$PROTOCOL" = "icmp" ]; then
  sudo ip netns exec router iptables -C FORWARD -p icmp -j DROP 2>/dev/null || \
  sudo ip netns exec router iptables -A FORWARD -p icmp -j DROP
  echo "[+] ICMP blocked"
  exit 0
fi

if [ "$ACTION" = "allow" ] && [ "$PROTOCOL" = "icmp" ]; then
  while sudo ip netns exec router iptables -C FORWARD -p icmp -j DROP 2>/dev/null; do
    sudo ip netns exec router iptables -D FORWARD -p icmp -j DROP
  done
  echo "[+] ICMP allowed"
  exit 0
fi

if [ "$ACTION" = "block" ] && [ "$PROTOCOL" = "tcp" ] && [ -n "$PORT" ]; then
  sudo ip netns exec router iptables -C FORWARD -p tcp --dport "$PORT" -j DROP 2>/dev/null || \
  sudo ip netns exec router iptables -A FORWARD -p tcp --dport "$PORT" -j DROP
  echo "[+] TCP port $PORT blocked"
  exit 0
fi

if [ "$ACTION" = "allow" ] && [ "$PROTOCOL" = "tcp" ] && [ -n "$PORT" ]; then
  while sudo ip netns exec router iptables -C FORWARD -p tcp --dport "$PORT" -j DROP 2>/dev/null; do
    sudo ip netns exec router iptables -D FORWARD -p tcp --dport "$PORT" -j DROP
  done
  echo "[+] TCP port $PORT allowed"
  exit 0
fi

echo "[-] Invalid input"
exit 1
