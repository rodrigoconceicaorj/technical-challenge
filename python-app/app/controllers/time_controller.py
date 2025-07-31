from fastapi import APIRouter, HTTPException
from app.services.time_service import TimeService
import structlog

logger = structlog.get_logger()
router = APIRouter()
time_service = TimeService()

# Python - health_check deve retornar texto fixo
@router.get("/health_check")
async def health_check():
    return "app em Python está em execução by:rod"

@router.get("/time")
async def get_time():
    """Get current server time with Redis cache"""
    try:
        current_time = await time_service.get_current_time()
        return {"time": current_time}
    except Exception as e:
        logger.error("Failed to get time", error=str(e))
        raise HTTPException(status_code=500, detail="Failed to get time")