# API-Driven IP Routing and Policy Enforcement Lab

A programmable network security lab built with **Linux network namespaces**, **iptables**, **Spring Boot**, **MySQL**, **Swagger**, and **Docker**.

This project simulates routed network topologies and allows traffic filtering policies to be applied dynamically through a REST API, while logging every policy action in a database.

---

## Overview

This lab demonstrates how routing, packet filtering, backend API control, audit logging, and traffic validation can be combined into a practical network security project.

The project supports:

- Linux network namespace based topology simulation
- Single-router and two-router routed paths
- ICMP and TCP policy enforcement with `iptables`
- REST API control using Spring Boot
- Persistent policy logging in MySQL
- Swagger UI for interactive API testing
- Packet capture generation with `tcpdump`

---

## Features

### Network Topologies
- **Single-router topology**
  - `client -> router -> server`
- **Two-router topology**
  - `client -> r1 -> r2 -> server`

### Policy Enforcement
- Block or allow **ICMP**
- Block or allow **TCP traffic on selected ports**
- Per-router traffic enforcement in multi-hop topology

### Backend API
- Spring Boot REST endpoints for policy control
- Log retrieval endpoint
- Swagger UI documentation

### Persistence
- MySQL-backed audit logging
- Stores action, protocol, port, status, and timestamp

### Traffic Validation
- Packet capture support using `tcpdump`
- Evidence of before/after policy effects

---

## Tech Stack

- **Java 17**
- **Spring Boot**
- **MySQL / MariaDB**
- **JPA / Hibernate**
- **Linux network namespaces**
- **iptables**
- **tcpdump**
- **Docker / Docker Compose**
- **Swagger OpenAPI**

---

## Architecture

### Single-router topology

client (10.0.1.2)
   |
router (10.0.1.1 / 10.0.2.1)
   |
server (10.0.2.2)
Two-router topology
client (10.0.1.2)
   |
r1 (10.0.1.1 / 10.0.12.1)
   |
r2 (10.0.12.2 / 10.0.2.1)
   |
server (10.0.2.2)

Control flow
Client/API request
        |
        v
Spring Boot REST API
        |
        v
Policy script execution
        |
        v
iptables rules inside router namespaces
        |
        +--> network behavior changes
        |
        +--> MySQL policy_log entry



Main API Endpoints

Single-router policy control
	•	POST /api/icmp/block
	•	POST /api/icmp/allow
	•	POST /api/tcp/block/{port}
	•	POST /api/tcp/allow/{port}

Logs
	•	GET /api/logs

Swagger UI
	•	http://localhost:8080/swagger-ui/index.html



Example API Usage

Block ICMP

curl -X POST http://localhost:8080/api/icmp/block

Allow ICMP

curl -X POST http://localhost:8080/api/icmp/allow

Block TCP port 8080

curl -X POST http://localhost:8080/api/tcp/block/8080

Retrieve logs

curl http://localhost:8080/api/logs


Example Two-Router Test



sudo ./scripts/setup_2router.sh
sudo ip netns exec client ping -c 3 10.0.2.2

sudo ./scripts/apply_policy_2router.sh r1 block icmp
sudo ip netns exec client ping -c 3 10.0.2.2

sudo ./scripts/apply_policy_2router.sh r1 allow icmp
sudo ip netns exec client ping -c 3 10.0.2.2






Example Logged Output



[
  {
    "id": 1,
    "action": "block",
    "protocolName": "icmp",
    "portNumber": null,
    "status": "SUCCESS",
    "createdAt": "2026-03-28T09:13:53"
  },
  {
    "id": 2,
    "action": "block",
    "protocolName": "tcp",
    "portNumber": 8080,
    "status": "SUCCESS",
    "createdAt": "2026-03-28T09:13:53"
  }
]



ip-routing-filter-lab/
├── src/
│   └── main/
│       ├── java/com/sajan/iplab/
│       │   ├── controller/
│       │   ├── model/
│       │   ├── repository/
│       │   ├── service/
│       │   └── IpLabApplication.java
│       └── resources/
│           └── application.properties
├── scripts/
│   ├── apply_policy.sh
│   ├── apply_policy_2router.sh
│   ├── capture.sh
│   ├── setup_topology.sh
│   └── setup_2router.sh
├── docker-compose.yml
├── Dockerfile
├── pom.xml
└── README.md



Run Locally

Prerequisites
	•	Linux system
	•	Java 17
	•	Maven
	•	MySQL or MariaDB
	•	iproute2
	•	iptables
	•	tcpdump
	•	sudo privileges




Start Spring Boot
mvn clean spring-boot:run


Build single-router topology
sudo ./scripts/setup_topology.sh

Build two-router topology
sudo ./scripts/setup_2router.sh

Packet Capture
sudo ./scripts/capture.sh


Why This Project Matters

This project demonstrates practical experience in:
	•	IP routing and packet forwarding
	•	Linux namespace based network simulation
	•	Firewall rule management with iptables
	•	API-driven infrastructure control
	•	Audit logging and persistence
	•	Container-oriented deployment structure
	•	Multi-hop network behavior analysis

Future Improvements
	•	FRRouting integration with OSPF/BGP
	•	Router-aware API endpoints
	•	Authentication and authorization
	•	Frontend dashboard
	•	Automated integration tests
	•	Enhanced observability



  Author 
  Sajan CR
