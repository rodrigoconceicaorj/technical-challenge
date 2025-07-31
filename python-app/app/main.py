from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from prometheus_client import make_asgi_app
import structlog

from app.controllers.time_controller import router as time_router

# Configurar logging estruturado
structlog.configure(
    processors=[
        structlog.stdlib.filter_by_level,
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.stdlib.PositionalArgumentsFormatter(),
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        structlog.processors.UnicodeDecoder(),
        structlog.processors.JSONRenderer()
    ],
    context_class=dict,
    logger_factory=structlog.stdlib.LoggerFactory(),
    wrapper_class=structlog.stdlib.BoundLogger,
    cache_logger_on_first_use=True,
)

logger = structlog.get_logger()

app = FastAPI(
    title="Python App - DevOps Challenge",
    description="FastAPI application with Redis cache and Prometheus metrics",
    version="1.0.0"
)

# Adicionar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Adicionar métricas Prometheus
metrics_app = make_asgi_app()
app.mount("/metrics", metrics_app)

# Incluir rotas
app.include_router(time_router, prefix="/api/v1")

@app.on_event("startup")
async def startup_event():
    logger.info("Python application starting up")

@app.on_event("shutdown")
async def shutdown_event():
    logger.info("Python application shutting down")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)