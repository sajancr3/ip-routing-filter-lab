# API-Driven IP Routing and Policy Enforcement Lab

This project demonstrates a programmable network security lab using Linux network namespaces, iptables, Spring Boot APIs, and MySQL logging.

---

## 🚀 What This Project Does

- Simulates real network routing using Linux namespaces  
- Applies firewall policies (ICMP/TCP) via REST API  
- Logs every action in MySQL  
- Verifies behavior using ping and packet capture  

---

## 🧠 Core Idea

Control network traffic like a real firewall system, but using:
- API → triggers policy  
- Script → applies iptables rule  
- Network → behavior changes  
- Database → logs everything  

---

## ⚙️ System Running (Spring Boot + API)

![Spring Boot Running](images/spring-boot.png)

Spring Boot application runs on port 8080 and exposes REST endpoints for policy control.

---

## 🌐 Network Connectivity (Before Policy)

![Ping Success](images/ping-success.png)

- Client successfully reaches server  
- ICMP packets are allowed  
- Network topology is working correctly  

---

## 🚫 Blocking Traffic via API

![Block ICMP](images/block-icmp.png)

Command:
```bash
curl -X POST http://localhost:8080/api/icmp/block
