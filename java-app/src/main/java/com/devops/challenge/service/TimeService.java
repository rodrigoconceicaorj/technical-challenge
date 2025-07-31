package com.devops.challenge.service;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
public class TimeService {
    
    private final Counter timeRequestsCounter;
    
    @Autowired
    public TimeService(MeterRegistry meterRegistry) {
        this.timeRequestsCounter = Counter.builder("time_requests_total")
            .description("Total number of time requests")
            .register(meterRegistry);
    }
    
    @Cacheable(value = "timeCache", key = "'current_time'")
    public String getCurrentTime() {
        timeRequestsCounter.increment();
        return LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    }
}