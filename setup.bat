@echo off
echo ========================================
echo Phase-III AI ChatBot - First Time Setup
echo ========================================
echo.

REM Get the directory where this script is located
set SCRIPT_DIR=%~dp0

echo Step 1: Installing Backend Dependencies...
echo ----------------------------------------
cd /d "%SCRIPT_DIR%New2_phase2_heckathone\backend"
call .\venv\Scripts\activate
pip install openai==1.12.0 jsonschema==4.21.1
echo.
echo Backend dependencies installed!
echo.

echo Step 2: Checking Frontend Dependencies...
echo ----------------------------------------
cd /d "%SCRIPT_DIR%New2_phase2_heckathone\frontend"
if not exist "node_modules\" (
    echo Installing frontend dependencies...
    call npm install
) else (
    echo Frontend dependencies already installed!
)
echo.

echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo IMPORTANT: Before running the servers, make sure you:
echo 1. Added your OpenAI API key to backend\.env
echo 2. Replace: OPENAI_API_KEY=sk-your-openai-api-key-here
echo 3. With your real key from: https://platform.openai.com/api-keys
echo.
echo After adding your API key, run: start-servers.bat
echo.
pause
