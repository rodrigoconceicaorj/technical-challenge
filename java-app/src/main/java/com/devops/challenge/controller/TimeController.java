package com.devops.challenge.controller;

import com.devops.challenge.service.TimeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class TimeController {
    
    @Autowired
    private TimeService timeService;
    
    @GetMapping("/health_check")
    public ResponseEntity<String> healthCheck() {
        return ResponseEntity.ok("app em JAVA está em execução by:rod");
    }
    
    @GetMapping("/time")
    public ResponseEntity<Map<String, String>> getTime() {
        String time = timeService.getCurrentTime();
        return ResponseEntity.ok(Map.of("time", time));
    }
}