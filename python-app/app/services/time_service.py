import redis
import asyncio
from datetime import datetime
from prometheus_client import Counter
import structlog

logger = structlog.get_logger()

# Métricas Prometheus
time_requests_counter = Counter('time_requests_total', 'Total number of time requests')

class TimeService:
    def __init__(self):
        self.redis_client = redis.Redis(
            host='redis',
            port=6379,
            db=0,
            decode_responses=True,
            socket_connect_timeout=2,
            socket_timeout=2
        )
        self.cache_key = "python_app_current_time"
        self.cache_ttl = 60  # 60 segundos (1 minuto)

    async def get_current_time(self):
        """Get current time with Redis cache (TTL: 60 seconds)"""
        try:
            # Incrementar métrica
            time_requests_counter.inc()
            
            # Tentar buscar do cache
            cached_time = self.redis_client.get(self.cache_key)
            
            if cached_time:
                logger.info("Time retrieved from cache")
                return cached_time
            
            # Se não estiver em cache, gerar novo
            current_time = datetime.now().isoformat()
            
            # Salvar no cache
            self.redis_client.setex(self.cache_key, self.cache_ttl, current_time)
            
            logger.info("Time generated and cached", cache_ttl=self.cache_ttl)
            return current_time
            
        except redis.RedisError as e:
            logger.warning("Redis connection failed, returning uncached time", error=str(e))
            # Fallback: retornar tempo sem cache
            return datetime.now().isoformat()
        except Exception as e:
            logger.error("Error getting current time", error=str(e))
            raise