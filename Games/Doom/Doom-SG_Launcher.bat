@echo off

rem ==========================
rem ===== Doom Launcher ======
rem === by Splendead Goose ===
rem == Released: 2023-05-19 ==
rem ==========================

rem ==========================
rem === Update: 2023-05-20 ===
rem == Added Portable Saves ==
rem === Added Release Info ===
rem ==========================

rem ==========================
rem === Update: 2023-05-21 ===
rem === Added Portable ini ===
rem === Added Sanity Check ===
rem ==========================

rem ==========================
rem === Update: 2023-05-22 ===
rem === Added Chex Quest 3 ===
rem ==========================

rem ==========================
rem === Set Some Variables ===
rem ==========================

:SetVariables
set ver=1.3
set lname=Doom Launcher v%ver%

set gzdoombin=gzdoom.exe
set SaveDir=saves
set iniFile=gzdoom.ini

set CQGameName=CHEX3.WAD
set CQSaves=%SaveDir%\Chex
set CQWadHash=3D01573607B600BB1FDB1FBDBC81C23722706D09F685F4ED4FBB83EE46F53A69

set D1GameName=DOOM.WAD
set D1ModPath=d1_mods
set D1Saves=%SaveDir%\Doom1
set D1WadHash=6FDF361847B46228CFEBD9F3AF09CD844282AC75F3EDBB61CA4CB27103CE2E7F

set D2GameName=DOOM2.WAD
set D2ModPath=d2_mods
set D2Saves=%SaveDir%\Doom2
set D2WadHash=10D67824B11025DDD9198E8CFC87CA335EE6E2D3E63AF4180FA9B8A471893255

set ModList=modlist.txt
set ModPath=modpath.txt

call:CheckGameFiles "%CQGameName%" "%CQWadHash%"
call:CheckGameFiles "%D1GameName%" "%D1WadHash%"
call:CheckGameFiles "%D2GameName%" "%D2WadHash%"
call:GetMods

rem ==========================
rem === List Doom and Mods ===
rem ==========================

:ListMods
title %lname%
cls
set /a NUMBER=0
set /a FCOUNT=0
set /a DCOUNT=0
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
echo 	C.  Chex Quest 3 (with 1 and 2)
echo 	D1. Doom - Ultimate (v1.9ud)
echo 	D2. Doom II (v1.9)
echo.
echo Other Options:
echo 	A. About
echo 	0. Exit Doom Launcher
echo.
set /P NUMBER=Enter Number or Letter: 
echo.
if /i {%NUMBER%}=={0} (goto :0)
if /i {%NUMBER%}=={C} (call:StartDoom "%CQGameName%" "%CQSaves%")
if /i {%NUMBER%}=={D1} (call:StartDoom "%D1GameName%" "%D1Saves%")
if /i {%NUMBER%}=={D2} (call:StartDoom "%D2GameName%" "%D2Saves%")
if /i {%NUMBER%}=={A} (call:About)
if not {!FLINE[%NUMBER%]!}=={} (call:StartMod "!FLINE[%NUMBER%]!" "!DLINE[%NUMBER%]!")
endlocal
goto :ListMods

rem ==========================
rem === Start Regular Doom ===
rem ==========================

:StartDoom
title %lname% - Starting %~1
echo Starting %~1
"%gzdoombin%" -config %iniFile% -savedir "%~2" -iwad "%~1"
goto :EOF

rem =======================
rem === Start Doom Mods ===
rem =======================

:StartMod
title %lname% - Starting %~1
echo Starting %~1
if /i {%~2}=={%D1ModPath%} (set BaseDoom=%D1GameName%)
if /i {%~2}=={%D2ModPath%} (set BaseDoom=%D2GameName%)
"%gzdoombin%" -config %iniFile% -savedir "%SaveDir%\%~1" -iwad "%BaseDoom%" -file "%~2\%~1"
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
powershell -executionpolicy bypass "Get-ChildItem -Path %D1ModPath%, %D2ModPath% -Include *.pk3, *.wad -File -Recurse -ErrorAction SilentlyContinue | foreach { $_.Name } > %ModList%"
powershell -executionpolicy bypass "Get-ChildItem -Path %D1ModPath%, %D2ModPath% -Include *.pk3, *.wad -File -Recurse -ErrorAction SilentlyContinue | foreach { $_.Directory.Name } > %ModPath%"
goto :EOF

rem =====================
rem === About Section ===
rem =====================

:About
title %lname% - About
echo Brought to you by: ~ SplendeadGoose ~
echo.
echo Compatible Mods: .pk3 .wad
echo Doom Mods Go Here: %D1ModPath%
echo Doom II Mods Here: %D2ModPath%
echo.
echo Portable Save Dir: %SaveDir%
echo.
echo Release: 2023-05-19
echo Updated: 2023-05-22
echo Version: v%ver%
echo.
echo GZDoom Version: 4.10.0 x64
echo Special Thanks to the GZDoom Team
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