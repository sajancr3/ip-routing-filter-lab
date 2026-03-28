#!/bin/bash
set -e

echo "[+] Starting HTTP server inside server namespace..."
ip netns exec server pkill -f "python3 -m http.server 8080" 2>/dev/null || true
ip netns exec server nohup python3 -m http.server 8080 >/tmp/http.log 2>&1 &

sleep 2

echo "[+] Testing ping from client to server..."
ip netns exec client ping -c 2 10.0.2.2 || true

echo "[+] Testing HTTP from client to server..."
ip netns exec client curl -I --max-time 5 http://10.0.2.2:8080 || true
