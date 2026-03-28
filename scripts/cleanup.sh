#!/bin/bash
sudo ip netns del client 2>/dev/null
sudo ip netns del router 2>/dev/null
sudo ip netns del server 2>/dev/null
echo "Cleaned up namespaces."
