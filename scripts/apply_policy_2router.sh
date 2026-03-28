#!/bin/bash
set -e

TARGET=$1
ACTION=$2
PROTOCOL=$3
PORT=$4

if [ -z "$TARGET" ] || [ -z "$ACTION" ] || [ -z "$PROTOCOL" ]; then
  echo "Usage:"
  echo "./scripts/apply_policy_2router.sh r1 block icmp"
  echo "./scripts/apply_policy_2router.sh r1 allow icmp"
  echo "./scripts/apply_policy_2router.sh r2 block tcp 8080"
  echo "./scripts/apply_policy_2router.sh r2 allow tcp 8080"
  exit 1
fi

if [ "$ACTION" = "block" ] && [ "$PROTOCOL" = "icmp" ]; then
  sudo ip netns exec "$TARGET" iptables -C FORWARD -p icmp -j DROP 2>/dev/null || \
  sudo ip netns exec "$TARGET" iptables -A FORWARD -p icmp -j DROP
  echo "[+] ICMP blocked on $TARGET"
  exit 0
fi

if [ "$ACTION" = "allow" ] && [ "$PROTOCOL" = "icmp" ]; then
  while sudo ip netns exec "$TARGET" iptables -C FORWARD -p icmp -j DROP 2>/dev/null; do
    sudo ip netns exec "$TARGET" iptables -D FORWARD -p icmp -j DROP
  done
  echo "[+] ICMP allowed on $TARGET"
  exit 0
fi

if [ "$ACTION" = "block" ] && [ "$PROTOCOL" = "tcp" ] && [ -n "$PORT" ]; then
  sudo ip netns exec "$TARGET" iptables -C FORWARD -p tcp --dport "$PORT" -j DROP 2>/dev/null || \
  sudo ip netns exec "$TARGET" iptables -A FORWARD -p tcp --dport "$PORT" -j DROP
  echo "[+] TCP port $PORT blocked on $TARGET"
  exit 0
fi

if [ "$ACTION" = "allow" ] && [ "$PROTOCOL" = "tcp" ] && [ -n "$PORT" ]; then
  while sudo ip netns exec "$TARGET" iptables -C FORWARD -p tcp --dport "$PORT" -j DROP 2>/dev/null; do
    sudo ip netns exec "$TARGET" iptables -D FORWARD -p tcp --dport "$PORT" -j DROP
  done
  echo "[+] TCP port $PORT allowed on $TARGET"
  exit 0
fi

echo "[-] Invalid input"
exit 1
