#!/bin/bash
set -e

mkdir -p captures
sudo ip netns exec router tcpdump -i any -w captures/router_capture.pcap
