@echo off

rem =======================
rem ===== SG Launcher =====
rem === Splendead Goose ===
rem === Rel: 2023-05-21 ===
rem =======================

rem ============================
rem ==== Update: 2023-05-22 ====
rem === Fixed PS Current Dir ===
rem ============================

rem ==========================
rem === Set Some Variables ===
rem ==========================

:SetVariables
set ver=1.1
set lname=SG Launcher v%ver%

set LaunchList=Conf\launchlist.txt
set LaunchPath=Conf\launchpath.txt
set GameDir=Games

call:GetLaunchers

rem ======================
rem === List Launchers ===
rem ======================

:ListLaunchers
title %lname%
cls
set /a NUMBER=0
set /a SGFCOUNT=0
set /a SGDCOUNT=0
color F
cd %~dp0

echo %lname% - A Special Splendead Release
echo.
echo Available Launchers:
setlocal EnableDelayedExpansion
for /f "delims=" %%a in ('type "%LaunchList%"') do (
	set /a SGFCOUNT+=1
	set SGFLINE[!SGFCOUNT!]=%%a
	set SGFMOD[!SGFCOUNT!}==%%b
)
for /f "delims=" %%c in ('type "%LaunchPath%"') do (
	set /a SGDCOUNT+=1
	set SGDLINE[!SGDCOUNT!]=%%c
	set SGDMOD[!SGDCOUNT!}==%%d
)
for /L %%i in (1,1,%SGFCOUNT%) do (
	echo 	%%i. !SGFLine[%%i]!
)
echo.
echo Other Options:
echo 	A. About
echo 	0. Exit SG Launcher
echo.
set /P NUMBER=Enter Number or Letter: 
echo.
if /i {%NUMBER%}=={0} (goto :0)
if /i {%NUMBER%}=={A} (call:About)
if not {!SGFLINE[%NUMBER%]!}=={} (
	cd "%GameDir%\!SGDLINE[%NUMBER%]!"
	call "!SGFLINE[%NUMBER%]!"
	)
endlocal
goto :ListLaunchers

rem =====================
rem === Get Launchers ===
rem =====================

:GetLaunchers
title %lname% - Checking Launchers
echo Checking Launchers...
powershell -executionpolicy bypass "Get-ChildItem -Path $CD -Include *-SG_Launcher.bat -File -Recurse -ErrorAction SilentlyContinue | foreach { $_.Name } > %LaunchList%"
powershell -executionpolicy bypass "Get-ChildItem -Path $CD -Include *-SG_Launcher.bat -File -Recurse -ErrorAction SilentlyContinue | foreach { $_.Directory.Name } > %LaunchPath%"
goto :EOF

rem =====================
rem === About Section ===
rem =====================

:About
title %lname% - About
echo Brought to you by: ~ SplendeadGoose ~
echo.
echo This is just a wrapper :)
echo.
echo Release: 2023-05-21
echo Updated: 2023-05-22
echo Version: v%ver%
echo.
pause
goto :EOF

rem ===================
rem === Exit Script ===
rem ===================

:0
exit