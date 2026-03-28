package com.sajan.iplab.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
public class PolicyLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String action;
    private String protocolName;
    private Integer portNumber;
    private String status;
    private LocalDateTime createdAt;

    public PolicyLog() {}

    public PolicyLog(String action, String protocolName, Integer portNumber, String status) {
        this.action = action;
        this.protocolName = protocolName;
        this.portNumber = portNumber;
        this.status = status;
        this.createdAt = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public String getAction() { return action; }
    public String getProtocolName() { return protocolName; }
    public Integer getPortNumber() { return portNumber; }
    public String getStatus() { return status; }
    public LocalDateTime getCreatedAt() { return createdAt; }

    public void setAction(String action) { this.action = action; }
    public void setProtocolName(String protocolName) { this.protocolName = protocolName; }
    public void setPortNumber(Integer portNumber) { this.portNumber = portNumber; }
    public void setStatus(String status) { this.status = status; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
