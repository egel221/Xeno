:: Not made by me (Rizve)

@echo off
:: Capture the script's directory before elevation
set "script_dir=%~dp0"

:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires Administrator privileges. Relaunching as Administrator...
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "Start-Process '%~f0' -ArgumentList '-elevated' -Verb RunAs"
    exit /b
)

:: Now running as Administrator
echo Running with Administrator privileges...

:: Check for Visual C++ Redistributable
echo Checking for Visual C++ Redistributable...
reg query "HKLM\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64" >nul 2>&1
if %errorlevel% neq 0 (
    echo Visual C++ Redistributable not found. Downloading...
    curl -L -o vc_redist.x64.exe "https://aka.ms/vs/17/release/vc_redist.x64.exe"
    echo Installing Visual C++ Redistributable...
    vc_redist.x64.exe /quiet /norestart
) else (
    echo Visual C++ Redistributable is already installed.
)

:: Check for .NET SDK
echo Checking for .NET SDK...
dotnet --list-sdks >nul 2>&1
if %errorlevel% neq 0 (
    echo .NET SDK not found. Downloading...
    curl -L -o dotnet-sdk-installer.exe "https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/sdk-8.0.100-windows-x64-installer"
    echo Installing .NET SDK...
    dotnet-sdk-installer.exe /quiet /norestart
) else (
    echo .NET SDK is already installed.
)

pause
