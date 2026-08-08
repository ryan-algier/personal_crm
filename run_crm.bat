@echo off
cd /d "%~dp0"

echo Starting Docker Desktop...
start "" "%LOCALAPPDATA%\Programs\DockerDesktop\Docker Desktop.exe"

echo Waiting for Docker to be ready...
:waitloop
docker info >nul 2>&1
if errorlevel 1 (
    timeout /t 2 /nobreak >nul
    goto waitloop
)

echo Docker is ready. Starting containers...
start "" cmd /c "timeout /t 7 /nobreak >nul && start "" http://localhost:5000"
docker compose up