# Demonstracao simples de alerta
Write-Host "=== DEMONSTRACAO RAPIDA DE ALERTA ===" -ForegroundColor Cyan
Write-Host ""

# Verificar status inicial
Write-Host "1. Status inicial dos servicos:" -ForegroundColor Yellow
$response = Invoke-WebRequest -Uri "http://localhost:9090/api/v1/targets" -UseBasicParsing
$targets = ($response.Content | ConvertFrom-Json).data.activeTargets
foreach ($target in $targets) {
    $status = if ($target.health -eq "up") { "OK" } else { "FALHA" }
    $color = if ($target.health -eq "up") { "Green" } else { "Red" }
    Write-Host "  $status $($target.labels.job)" -ForegroundColor $color
}

Write-Host ""
Write-Host "2. Verificando alertas ativos:" -ForegroundColor Yellow
$alertResponse = Invoke-WebRequest -Uri "http://localhost:9090/api/v1/alerts" -UseBasicParsing
$alerts = ($alertResponse.Content | ConvertFrom-Json).data.alerts
if ($alerts.Count -eq 0) {
    Write-Host "  Nenhum alerta ativo" -ForegroundColor Green
} else {
    foreach ($alert in $alerts) {
        Write-Host "  ALERTA: $($alert.labels.alertname) - $($alert.labels.severity)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "3. Simulando queda do servico Python..." -ForegroundColor Magenta
docker stop python-app | Out-Null
Write-Host "  Servico Python parado" -ForegroundColor Yellow

Write-Host ""
Write-Host "4. Aguardando 45 segundos para alerta ser disparado..." -ForegroundColor Gray
Start-Sleep -Seconds 45

Write-Host ""
Write-Host "5. Verificando alertas apos queda:" -ForegroundColor Yellow
$alertResponse2 = Invoke-WebRequest -Uri "http://localhost:9090/api/v1/alerts" -UseBasicParsing
$alerts2 = ($alertResponse2.Content | ConvertFrom-Json).data.alerts
if ($alerts2.Count -eq 0) {
    Write-Host "  Nenhum alerta ativo" -ForegroundColor Green
} else {
    foreach ($alert in $alerts2) {
        $severity = $alert.labels.severity
        $alertType = $alert.labels.alert_type
        $color = switch ($severity) {
            "critical" { "Red" }
            "high" { "Yellow" }
            "medium" { "Cyan" }
            default { "White" }
        }
        Write-Host "  ALERTA DISPARADO: [$alertType] $($alert.labels.alertname)" -ForegroundColor $color
        Write-Host "    Severidade: $severity" -ForegroundColor $color
        Write-Host "    Descricao: $($alert.annotations.summary)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "6. Restaurando servico Python..." -ForegroundColor Green
docker start python-app | Out-Null
Write-Host "  Servico Python restaurado" -ForegroundColor Green

Write-Host ""
Write-Host "=== DEMONSTRACAO CONCLUIDA ===" -ForegroundColor Cyan
Write-Host "Acesse http://localhost:9090/alerts para ver a interface do Prometheus" -ForegroundColor Yellow