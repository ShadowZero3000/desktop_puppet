@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

REM Instead of using powershell to install puppet, just use choco. Requires you download and install choco though
REM bitsadmin /transfer puppet /download /priority normal https://downloads.puppetlabs.com/windows/puppet-latest.msi c:\puppet.msi
REM msiexec /qn /norestart /i c:\puppet.msi PUPPET_AGENT_STARTUP_MODE=Disabled

SET DIR=%~dp0%

::download chocolatey (install.ps1)
rem %systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "((new-object net.webclient).DownloadFile('https://chocolatey.org/install.ps1','install.ps1'))"
::run chocolatey installer
rem %systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%DIR%install.ps1' %*"
rem rm %DIR%install.ps1
choco install puppet 
call puppet module install chocolatey-chocolatey 
echo "You are now ready to run the puppet apply"
echo "Don't forget to change ownership of c:\programdata"
pause