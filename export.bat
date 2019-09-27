@echo off

:: clean target folder
if exist images (
  del /Q images\*
) else (
  mkdir images
)

:: export all images
call :img spot cell
call :img power jumpproof
call :img power movediagonal
call :img power parasite
call :img power parasite_host
call :img power scavenger
call :img power sphere
exit /B %ERRORLEVEL%

:: export single image from vector
:img
  set target=images\%~1
  if not exist %target% md %target%
  inkscape --export-id=%~2 --export-id-only -a -128:-128:128:128 -e images/%~1/%~2.png res/piece_qr.svg
exit /B 0