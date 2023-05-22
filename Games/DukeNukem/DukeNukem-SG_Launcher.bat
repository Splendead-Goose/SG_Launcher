@echo off

rem ==========================
rem ===== Duke Launcher ======
rem === by Splendead Goose ===
rem == Released: 2023-05-21 ==
rem ==========================

rem ==========================
rem === Set Some Variables ===
rem ==========================

:SetVariables
set ver=1.0
set lname=Duke Nukem 3D Launcher v%ver%

set engine=eduke32.exe
set edukebin=eduke32.exe
set legacybin=eduke32-legacy.exe

set DNGameName=DUKE3D.GRP
set DNModPath=mods
set DNLegacyMod=LegacyE.zip
set DNGrpHash=5EAEE377B4D4BC3D541555F216032FBE22444A20D80108923FBA97E5144C2FBA

set ModList=modlist.txt
set ModPath=modpath.txt

call:CheckGameFiles "%DNGameName%" "%DNGrpHash%"
call:GetMods

rem ==========================
rem === List Duke and Mods ===
rem ==========================

:ListMods
title %lname%
cls
set /a NUMBER=0
set /a FCOUNT=0
color F

echo %lname% - A Special Splendead Release
echo.
echo Available Mods:
setlocal EnableDelayedExpansion
for /f "delims=" %%a in ('type "%ModList%"') do (
	set /a FCOUNT+=1
	set FLINE[!FCOUNT!]=%%a
	set FMOD[!FCOUNT!}==%%b
)
for /f "delims=" %%c in ('type "%ModPath%"') do (
	set /a DCOUNT+=1
	set DLINE[!DCOUNT!]=%%c
	set DMOD[!DCOUNT!}==%%d
)
for /L %%i in (1,1,%FCOUNT%) do (
	echo 	%%i. !FLine[%%i]!
)
echo.
echo Available Games:
echo 	D1. Duke Nukem 3D - Atomic Edition (v1.5)
echo.
echo Other Options:
echo 	A. About
echo 	0. Exit Duke Nukem 3D Launcher
echo.
set /P NUMBER=Enter Number or Letter: 
echo.
if /i {%NUMBER%}=={0} (goto :0)
if /i {%NUMBER%}=={D1} (call:StartDoom "%DNGameName%")
if /i {%NUMBER%}=={A} (call:About)
if not {!FLINE[%NUMBER%]!}=={} (call:StartMod "!FLINE[%NUMBER%]!" "!DLINE[%NUMBER%]!")
endlocal
goto :ListMods

rem ==========================
rem === Start Regular Duke ===
rem ==========================

:StartDoom
title %lname% - Starting %~1
echo Starting %~1
"%edukebin%" -grp "%~1"
goto :EOF

rem =======================
rem === Start Duke Mods ===
rem =======================

:StartMod
title %lname% - Starting %~1
echo Starting %~1
if /i "%~1"=="%DNLegacyMod%" (set engine=%legacybin%) else (set engine=%edukebin%)
if /i "%~2"=="%DNModPath%" (set BaseMod=%DNModPath%) else (set BaseMod=%DNModPath%\%~2)
"%engine%" -grp "%BaseMod%\%~1"
goto :EOF

rem ========================
rem === Check Game Files ===
rem ========================

:CheckGameFiles
title %lname% - Checking Game Files
echo Checking %~1 Game File...
setlocal EnableDelayedExpansion
if exist %~1 (
	for /f %%h in ('powershell -executionpolicy bypass "Get-FileHash %~1 | foreach { $_.Hash }"') do (
		if not {%%h}=={%~2} (call:Error "File %~1 hash does not match")
	)
) else (
	call:Error "File %~1 does not exist"
)
endlocal
goto :EOF

rem ==========================
rem === Get Installed Mods ===
rem ==========================

:GetMods
title %lname% - Checking Mods
echo Checking Mods...
powershell -executionpolicy bypass "Get-ChildItem -Path %DNModPath% -Include *.grp, *.pk3, *.zip -File -Recurse -ErrorAction SilentlyContinue | foreach { $_.Name } > %ModList%"
powershell -executionpolicy bypass "Get-ChildItem -Path %DNModPath% -Include *.grp, *.pk3, *.zip -File -Recurse -ErrorAction SilentlyContinue | foreach { $_.Directory.Name } > %ModPath%"
goto :EOF

rem =====================
rem === About Section ===
rem =====================

:About
title %lname% - About
echo Brought to you by: ~ SplendeadGoose ~
echo.
echo Compatible Mods: .grp .pk3 .zip
echo Duke Nukem 3D Mods Go Here: %DNModPath%
echo.
echo Release: 2023-05-21
echo Version: v%ver%
echo.
echo eduke32 Version: 20230517-10240 x64
echo Special Thanks to the eduke32 Team
echo.
pause
goto :EOF

rem =============
rem === Error ===
rem =============

:Error
title %lname% - Error
color 4
echo.
echo ERROR - %~1
echo.
pause

rem ===================
rem === Exit Script ===
rem ===================

:0