#!/bin/bash
set +e

echo "[+] Cleaning old namespaces..."
ip netns del client
ip netns del router
ip netns del server

echo "[+] Cleanup complete."
