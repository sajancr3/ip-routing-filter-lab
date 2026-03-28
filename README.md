# API-Driven IP Routing and Policy Enforcement Lab

A hands-on network engineering project that simulates routed network topologies and enforces traffic policies dynamically using Linux networking primitives, exposed through a Spring Boot API and backed by MySQL logging.

---

## What This Project Solves

Traditional firewall setups are:
- manually configured  
- hard to test  
- not programmatically controlled  

This project builds a **mini programmable network control system** where:

- API defines policy  
- Linux kernel enforces policy (iptables)  
- Database records every action  

---

## Core Idea

Convert low-level network control into an API-driven system.

Client Request → Spring Boot API → Shell Script → iptables → Network Behavior Change → MySQL Log

---

## Key Capabilities

- Simulates real network routing using Linux namespaces  
- Applies ICMP and TCP filtering using iptables  
- Exposes REST endpoints for dynamic policy control  
- Logs all actions in MySQL for traceability  
- Supports multi-hop routing (2-router topology)  
- Validates behavior using ping and tcpdump  

---

## Network Topology

### Single Router

client (10.0.1.2)  
   |  
router (10.0.1.1 / 10.0.2.1)  
   |  
server (10.0.2.2)  

---

### Two Router (Multi-hop)

client (10.0.1.2)  
   |  
r1 (10.0.1.1 / 10.0.12.1)  
   |  
r2 (10.0.12.2 / 10.0.2.1)  
   |  
server (10.0.2.2)  

---

## Tech Stack

- Java 17  
- Spring Boot  
- MySQL / MariaDB  
- Linux networking (namespaces, iptables)  
- tcpdump  
- Docker / Docker Compose  
- Swagger  

---

## End-to-End Flow

1. User sends API request  
2. Spring Boot processes request  
3. Shell script executes firewall rule  
4. iptables applies rule inside namespace  
5. Network behavior changes immediately  
6. Action is logged in MySQL  

---

## API Endpoints

POST /api/icmp/block  
POST /api/icmp/allow  
POST /api/tcp/block/{port}  
POST /api/tcp/allow/{port}  
GET  /api/logs  

Swagger UI:  
http://localhost:8080/swagger-ui/index.html  

---

## Demo: Full Working Proof

### 1. Setup Network

sudo ./scripts/setup_2router.sh  

---

### 2. Verify Connectivity

sudo ip netns exec client ping -c 3 10.0.2.2  

Expected:  
3 packets transmitted, 3 received  

---

### 3. Block ICMP via API

curl -X POST http://localhost:8080/api/icmp/block  

What happens internally:
- Spring Boot receives request  
- Script executes  
- iptables rule inserted  

---

### 4. Verify Traffic is Blocked

sudo ip netns exec client ping -c 3 10.0.2.2  

Expected:  
100% packet loss  

---

### 5. Restore Traffic

curl -X POST http://localhost:8080/api/icmp/allow  

---

## Firewall Rule Verification

sudo ip netns exec router iptables -L FORWARD -n --line-numbers  

Example:

DROP  icmp  --  0.0.0.0/0  0.0.0.0/0  
DROP  tcp   --  0.0.0.0/0  0.0.0.0/0  tcp dpt:8080  

---

## MySQL Logging

mysql -u iplab -p  
USE iplab;  
SELECT * FROM policy_log;  

Example:

action: block  
protocol: icmp  
status: SUCCESS  
timestamp: <time>  

Every API action is recorded.

---

## Packet Capture (Validation)

sudo tcpdump -i any  

Used to:
- confirm traffic before blocking  
- confirm packet drop after blocking  
- debug routing  

---

## Project Structure

ip-routing-filter-lab/  
├── src/main/java/com/sajan/iplab/  
├── scripts/  
│   ├── setup_topology.sh  
│   ├── setup_2router.sh  
│   ├── apply_policy.sh  
│   ├── apply_policy_2router.sh  
│   └── capture.sh  
├── docker-compose.yml  
├── Dockerfile  
├── pom.xml  
└── README.md  

---

## Why This Project Is Strong

This project demonstrates:

- Real IP routing (not just theory)  
- Kernel-level firewall enforcement  
- API-driven infrastructure control  
- Multi-hop routing logic  
- Persistent audit logging  
- End-to-end validation  

---

## Engineering Concepts Applied

- Linux network namespaces  
- Packet forwarding and routing  
- iptables firewall chains  
- REST-based control plane  
- State logging and persistence  
- Network debugging and analysis  

---

## Future Improvements

- OSPF / BGP using FRRouting  
- Router-specific API control  
- Authentication and access control  
- Frontend dashboard  
- Cloud deployment  

---

## Author

sajancr3
