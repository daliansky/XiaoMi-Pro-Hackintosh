@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
echo Requesting administrative privileges... 
goto request
) else (goto start)

:request
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params = %*:"=""
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /b

:start
pushd %~dp0bin
echo Xiaomi Mi Notebook Pro BIOS write unlock patch by _Cyb_
echo Tested on 0603 BIOS
h2ouve -gv pchsetup_my.txt -n PchSetup
if exist "pchsetup_my.txt" (
    echo Successfully read variables
) else (
    echo Failed to read variables!
    pause
    exit /b
)
powershell set-executionpolicy remotesigned
powershell ./patchscript_bud
if exist "pchsetup_patched.txt" (
    echo Writing patched variables
    h2ouve -sv pchsetup_patched.txt -n PchSetup
    echo Done! Do not forget to reboot!
) else (
    echo FAILED!
)
echo.
pause