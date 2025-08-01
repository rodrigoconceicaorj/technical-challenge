
# Desafio Técnico – DevOps Sênior

Infraestrutura completa com duas aplicações (Java e Python), cache distribuído, observabilidade e automação via Docker Compose.

## ✅ Funcionalidades Implementadas

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
- **arquitetura.svg**: Diagrama completo da arquitetura
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

## 📊 Análise da Infraestrutura

### ✅ Pontos Fortes:

1. **Microserviços bem definidos**
   - Separação clara de responsabilidades
   - Escalabilidade independente
   - Tecnologias diferentes (Java/Python)

2. **Cache otimizado**
   - TTLs diferentes baseados no uso (10s vs 60s)
   - Redis com persistência
   - Cache distribuído

3. **Observabilidade completa**
   - Métricas (Prometheus)
   - Logs centralizados (Loki)
   - Visualização (Grafana)
   - Coleta automática (Promtail)

4. **Facilidade de execução**
   - Docker Compose com um comando
   - Infraestrutura como código
   - Portabilidade total

5. **Load balancing**
   - Nginx como proxy reverso
   - Roteamento inteligente
   - Alta disponibilidade

### 🔧 Pontos de Melhoria:

#### 1. Segurança
- **HTTPS/TLS**: Implementar certificados SSL
- **Autenticação**: JWT ou OAuth2 entre serviços
- **Secrets**: Vault ou Docker Secrets para senhas
- **Network policies**: Isolamento de redes
- **Security scanning**: Vulnerabilidades em containers

#### 2. Escalabilidade
- **Múltiplas réplicas**: Configurar replicação horizontal
- **Auto-scaling**: HPA (Horizontal Pod Autoscaler)
- **Load balancing avançado**: Sticky sessions, health checks
- **Database clustering**: Redis Cluster para alta disponibilidade

#### 3. Monitoramento e Alertas
- **Alertmanager**: Configurar alertas no Prometheus
- **Dashboards customizados**: Métricas de negócio
- **SLOs/SLIs**: Service Level Objectives/Indicators
- **APM**: Application Performance Monitoring
- **Tracing distribuído**: Jaeger ou Grafana Tempo

#### 4. CI/CD Pipeline
- **Build automatizado**: GitHub Actions ou GitLab CI
- **Testes automatizados**: Unit, integration, e2e
- **Security scanning**: Trivy, Snyk
- **Deploy automatizado**: Blue-Green ou Rolling updates

#### 5. Backup e Disaster Recovery
- **Backup automático**: Redis, volumes
- **Multi-region**: Deploy em múltiplas regiões
- **Recovery procedures**: Documentação de recuperação

## 🔄 Estratégias de Atualização

### 1. Blue-Green Deployment
```bash
# Fluxo:
1. Deploy nova versão (Green)
2. Testes na Green
3. Switch traffic (Nginx config)
4. Descomissionar Blue
```

### 2. Rolling Updates
```yaml
# docker-compose.yml com rolling updates
services:
  java-app:
    deploy:
      replicas: 3
      update_config:
        parallelism: 1
        delay: 10s
        order: start-first
        failure_action: rollback
```

### 3. CI/CD Pipeline Sugerido
```yaml
# .github/workflows/deploy.yml
name: Deploy to Production
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build and test
        run: |
          docker-compose build
          docker-compose up -d
          # Run tests
      - name: Security scan
        run: |
          # Scan vulnerabilities
      - name: Deploy
        run: |
          # Blue-Green deployment
```

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

## 🐙 Organização do Git

### Commits Organizados:
```bash
feat: implement Java application with Spring Boot
feat: implement Python application with FastAPI
feat: add Redis caching layer with different TTLs
feat: implement Nginx load balancer
feat: add Prometheus metrics collection
feat: add Loki log aggregation
feat: add Grafana dashboards
feat: add Promtail log collection agent
docs: create architecture diagram
docs: update README with analysis and improvements
```

### Branches Sugeridas:
```bash
main (produção)
├── develop (integração)
├── feature/java-app-improvements
├── feature/python-app-improvements
├── feature/observability-enhancements
└── hotfix/security-patch
```

## 🎯 Próximos Passos

1. **Implementar HTTPS** com certificados SSL
2. **Configurar alertas** no Prometheus
3. **Criar dashboards customizados** no Grafana
4. **Implementar CI/CD pipeline** automatizado
5. **Adicionar testes automatizados**
6. **Configurar backup automático**
7. **Implementar auto-scaling**

## 👨‍💻 Autor

**Rodrigo Conceição** – DevOps Sênior

---

*Este projeto demonstra uma arquitetura completa de microserviços com observabilidade, cache distribuído e automação, seguindo as melhores práticas de DevOps.*
