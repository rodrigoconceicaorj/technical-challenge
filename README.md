
# Desafio Técnico – DevOps Sênior

Infraestrutura completa com duas aplicações (Java e Python), cache distribuído, observabilidade e automação via Docker Compose.

## ▶️ Execução
**Pré-requisitos**:
- Docker 20.10+
- Docker Compose 2.0+
- 4GB RAM
- 10GB de espaço em disco

### Para executar:
```bash
docker-compose up --build
```

### Acessos:
```bash
Java app: http://localhost:8080
Python app: http://localhost:8000
Nginx (load balancer): http://localhost:80
Grafana: http://localhost:3000 (admin/admin)
Prometheus: http://localhost:9090
Loki: http://localhost:3100
```

## 🧪 Testes Rápidos
```bash
# Java App
curl http://localhost:8080/health_check
curl http://localhost:8080/time
curl http://localhost:8080/actuator/prometheus

# Python App
curl http://localhost:8000/api/v1/health_check
curl http://localhost:8000/api/v1/time
curl http://localhost:8000/metrics

# Via Nginx (load balancer)
curl http://localhost/health_check
curl http://localhost/time
curl http://localhost/api/v1/health_check
curl http://localhost/api/v1/time
```
## 🏗️ Arquitetura

### Diagrama da Infraestrutura
- **arquitetura.svg**: Diagrama completo da arquitetura (no repositório)
- **Fluxo de dados**: Cliente → Nginx → Apps → Redis
- **Observabilidade**: Apps → Prometheus/Loki → Grafana

### Componentes:
- **Cliente**: Requisições HTTP
- **Nginx**: Load balancer e proxy reverso
- **Java App**: Spring Boot na porta 8080
- **Python App**: FastAPI na porta 8000
- **Redis**: Cache com TTLs diferentes (10s/60s)
- **Prometheus**: Coleta de métricas
- **Promtail**: Agente de coleta de logs
- **Loki**: Agregador de logs
- **Grafana**: Dashboards e visualização

## 📁 Estrutura do Projeto

```
technical-challenge/
├── java-app/                 # Aplicação Java (Spring Boot)
│   ├── src/
│   ├── pom.xml
│   └── Dockerfile
├── python-app/              # Aplicação Python (FastAPI)
│   ├── app/
│   ├── requirements.txt
│   └── Dockerfile
├── nginx/                   # Configuração do load balancer
│   └── nginx.conf
├── prometheus/              # Configuração de métricas
│   └── prometheus.yml
├── promtail/                # Configuração de coleta de logs
│   └── promtail.yml
├── docker-compose.yml       # Orquestração completa
├── arquitetura.svg          # Diagrama da arquitetura
└── README.md               # Documentação
```

## 👨‍💻 Autor
**Rodrigo Conceição** – DevOps Sênior