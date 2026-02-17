@echo off
echo ========================================
echo Starting Phase-III AI Todo ChatBot
echo ========================================
echo.

REM Get the directory where this script is located
set SCRIPT_DIR=%~dp0

REM Start Backend Server in new window
echo Starting Backend Server...
start "Backend Server" cmd /k "cd /d "%SCRIPT_DIR%New2_phase2_heckathone\backend" && .\venv\Scripts\activate && echo Backend starting... && uvicorn src.main:app --reload --host 0.0.0.0 --port 8000"

REM Wait a moment for backend to start
timeout /t 3 /nobreak >nul

REM Start Frontend Server in new window
echo Starting Frontend Server...
start "Frontend Server" cmd /k "cd /d "%SCRIPT_DIR%New2_phase2_heckathone\frontend" && echo Frontend starting... && npm run dev"

echo.
echo ========================================
echo Both servers are starting!
echo ========================================
echo.
echo Backend:  http://localhost:8000
echo Frontend: http://localhost:3000
echo Chat UI:  http://localhost:3000/chat
echo.
echo Two new windows will open for each server.
echo Close those windows to stop the servers.
echo.
pause
