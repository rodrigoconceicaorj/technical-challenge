
# Desafio Técnico – DevOps Sênior

Infraestrutura completa com duas aplicações (Java e Python), cache distribuído, observabilidade e automação via Docker Compose.

## ✅ Funcionalidades

- **Java (Spring Boot)**: `/health_check`, `/time`, cache Redis (10s)
- **Python (FastAPI)**: `/health_check`, `/time`, cache Redis (60s)
- **Redis**: Cache distribuído com persistência
- **Nginx**: Proxy reverso e balanceador de carga
- **Prometheus, Grafana, Loki**: Métricas, dashboards e logs centralizados
- **Docker Compose**: Orquestração completa com 1 comando

## ▶️ Execução

**Pré-requisitos**:
- Docker 20.10+
- Docker Compose 2.0+
- 4GB RAM
- 10GB de espaço em disco

## PARA RODAR
docker-compose up --build

## Acessos
Java app: http://localhost:8080
Python app: http://localhost:8000
Grafana: http://localhost:3000 (admin/admin)
Prometheus: http://localhost:9090

Logs (via Grafana + Loki)

## 🧪 Testes Rápidos
Via Nginx
curl http://localhost/health_check
curl http://localhost/api/v1/time

==============================================
## ACESSO DIRETO 
# Java
curl http://localhost:8080/health_check
curl http://localhost:8080/time
==============================================
# Python
curl http://localhost:8000/api/v1/health_check
curl http://localhost:8000/api/v1/time
==============================================


🧱 Arquitetura (em construção) 
https://excalidraw.com/#json=BWLBZ-_hraJz4_QdYPRnS,mtO4yczrMHtAEvWjo2CnSA

Cliente → Nginx → Java/Python → Redis
                 ↓
            Prometheus → Grafana
                 ↓
               Loki

🔄 Atualizações
Rolling Updates com health checks e rollback automático
Blue-Green Deployment descrito no diagrama
Pipeline sugerido: Build → Test → Scan → Deploy → Monitor

💡 Melhorias Futuras
HTTPS + Rate limiting

Secrets seguros (vault)

Auto-scaling (HPA ou keda))
Tracing distribuído (Jaeger/grafana tempo)
APM e métricas de negócio

📁 Arquivos
docker-compose.yml
src/ – Código das aplicações
Recommendations.md

👨‍💻 Autor
Rodrigo Conceição – DevOps Sênior