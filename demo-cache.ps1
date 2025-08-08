# Script de Demonstracao do Cache Redis
# Para usar na apresentacao - mostra o comportamento do cache visualmente

Write-Host "=== DEMONSTRACAO DO CACHE REDIS ===" -ForegroundColor Green
Write-Host ""

# Funcao para fazer requisicao e mostrar resultado
function Test-CacheEndpoint {
    param(
        [string]$Url,
        [string]$AppName
    )
    
    Write-Host "Testando $AppName" -ForegroundColor Yellow
    Write-Host "URL: $Url" -ForegroundColor Gray
    
    try {
        $response = Invoke-WebRequest -Uri $Url -UseBasicParsing
        $timestamp = ($response.Content | ConvertFrom-Json).time
        Write-Host "Timestamp: $timestamp" -ForegroundColor Cyan
        return $timestamp
    }
    catch {
        Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Funcao para mostrar chaves do Redis
function Show-RedisKeys {
    Write-Host "Verificando chaves no Redis:" -ForegroundColor Magenta
    try {
        $keys = docker exec redis redis-cli keys "*"
        if ($keys) {
            Write-Host "Chaves encontradas: $keys" -ForegroundColor Green
            
            # Mostrar valor da chave Python
            $pythonValue = docker exec redis redis-cli get "python_app_current_time"
            if ($pythonValue) {
                Write-Host "Cache Python: $pythonValue" -ForegroundColor Green
            }
        } else {
            Write-Host "Nenhuma chave encontrada" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Erro ao acessar Redis: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Demonstracao Python (TTL: 60 segundos)
Write-Host "=== TESTE APLICACAO PYTHON (TTL: 60s) ===" -ForegroundColor Blue

Write-Host "1. Primeira requisicao (gera novo timestamp):" -ForegroundColor White
$timestamp1 = Test-CacheEndpoint "http://localhost:8000/api/v1/time" "Python App"
Show-RedisKeys

Write-Host "2. Segunda requisicao (deve usar cache):" -ForegroundColor White
$timestamp2 = Test-CacheEndpoint "http://localhost:8000/api/v1/time" "Python App"

if ($timestamp1 -eq $timestamp2) {
    Write-Host "CACHE HIT! Mesmo timestamp retornado" -ForegroundColor Green
} else {
    Write-Host "CACHE MISS! Timestamps diferentes" -ForegroundColor Red
}

Write-Host "3. Terceira requisicao (ainda em cache):" -ForegroundColor White
$timestamp3 = Test-CacheEndpoint "http://localhost:8000/api/v1/time" "Python App"

if ($timestamp1 -eq $timestamp3) {
    Write-Host "CACHE HIT! Ainda usando o mesmo timestamp" -ForegroundColor Green
} else {
    Write-Host "CACHE MISS! Timestamp mudou" -ForegroundColor Red
}

Show-RedisKeys

Write-Host "=== DEMONSTRACAO CONCLUIDA ===" -ForegroundColor Green
Write-Host "RESUMO:" -ForegroundColor White
Write-Host "- Python App: TTL de 60 segundos" -ForegroundColor Cyan
Write-Host "- Java App: TTL de 10 segundos" -ForegroundColor Cyan
Write-Host "- Redis armazena timestamps com TTL automatico" -ForegroundColor Cyan
Write-Host "- Cache reduz processamento e melhora performance" -ForegroundColor Cyan