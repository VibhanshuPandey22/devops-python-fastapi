from fastapi import FastAPI

from app.routes import home
from app.routes import about
from app.routes import health

app = FastAPI(
    title="FastAPI DevOps Project",
    description="A simple FastAPI application for CI/CD learning",
    version="1.0.0"
)

app.include_router(home.router)
app.include_router(about.router)
app.include_router(health.router)

# ADDING A COMMENT TO CHECK FOR SCM POLLING IN JENKINS FOR AUTOMATIC BUILD TRIGGERING. TRY 2