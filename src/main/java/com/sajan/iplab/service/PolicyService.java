package com.sajan.iplab.service;

import com.sajan.iplab.model.PolicyLog;
import com.sajan.iplab.repository.PolicyLogRepository;
import org.springframework.stereotype.Service;

@Service
public class PolicyService {

    private final PolicyLogRepository repository;

    public PolicyService(PolicyLogRepository repository) {
        this.repository = repository;
    }

    public String applyPolicy(String action, String protocol, String port) {
        try {
            ProcessBuilder pb;

            if (port != null) {
                pb = new ProcessBuilder(
                        "bash",
                        "scripts/apply_policy.sh",
                        action,
                        protocol,
                        port
                );
            } else {
                pb = new ProcessBuilder(
                        "bash",
                        "scripts/apply_policy.sh",
                        action,
                        protocol
                );
            }

            pb.redirectErrorStream(true);
            Process process = pb.start();
            int exitCode = process.waitFor();

            String status = exitCode == 0 ? "SUCCESS" : "FAILED";

            repository.save(new PolicyLog(
                    action,
                    protocol,
                    port != null ? Integer.parseInt(port) : null,
                    status
            ));

            return "Policy applied (" + status + ")";

        } catch (Exception e) {
            repository.save(new PolicyLog(action, protocol, null, "FAILED"));
            return "Error: " + e.getMessage();
        }
    }
}
