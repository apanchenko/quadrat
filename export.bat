@echo off

:: clean target folder
if exist images (
  del /S /Q images\*
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
call :img piece body
call :colors piece active
call :colors piece ability
call :colors piece pimp
exit /B %ERRORLEVEL%

:: export piece-color images (folder, object)
:colors
  call :img %~1 %~2_white
  call :img %~1 %~2_black
exit /B 0

:: export single image from vector (folder, object)
:img
  set target=images\%~1
  if not exist %target% md %target%
  inkscape --export-id=%~2 --export-id-only -a -128:-128:128:128 -e images/%~1/%~2.png res/piece_qr.svg
exit /B 0