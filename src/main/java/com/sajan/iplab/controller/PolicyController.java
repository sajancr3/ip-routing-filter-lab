package com.sajan.iplab.controller;

import com.sajan.iplab.model.PolicyLog;
import com.sajan.iplab.repository.PolicyLogRepository;
import com.sajan.iplab.service.PolicyService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class PolicyController {

    private final PolicyService service;
    private final PolicyLogRepository repository;

    public PolicyController(PolicyService service, PolicyLogRepository repository) {
        this.service = service;
        this.repository = repository;
    }

    @PostMapping("/icmp/block")
    public String blockIcmp() {
        return service.applyPolicy("block", "icmp", null);
    }

    @PostMapping("/icmp/allow")
    public String allowIcmp() {
        return service.applyPolicy("allow", "icmp", null);
    }

    @PostMapping("/tcp/block/{port}")
    public String blockTcp(@PathVariable String port) {
        return service.applyPolicy("block", "tcp", port);
    }

    @PostMapping("/tcp/allow/{port}")
    public String allowTcp(@PathVariable String port) {
        return service.applyPolicy("allow", "tcp", port);
    }

    @GetMapping("/logs")
    public List<PolicyLog> getLogs() {
        return repository.findAll();
    }
}
