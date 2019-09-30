@echo off

:: clean target folder
if exist images (
  del /S /Q images\*
) else (
  mkdir images
)

:: export image size
set cell=-128:-128:128:128

:: export all images
::   method     svg       folder  object          size
call :raster    piece_qr  spot    cell            %cell%
call :raster    piece_qr  power   jumpproof       %cell%
call :raster    piece_qr  power   movediagonal    %cell%
call :raster    piece_qr  power   parasite        %cell%
call :raster    piece_qr  power   parasite_host   %cell%
call :raster    piece_qr  power   scavenger       %cell%
call :raster    piece_qr  power   sphere          %cell%
call :raster    piece_qr  piece   body            %cell%
call :raster_bw piece_qr  piece   active          %cell%
call :raster_bw piece_qr  piece   ability         %cell%
call :raster_bw piece_qr  piece   pimp            %cell%
call :raster    arrow     board   arrow           0:0:128:64
call :raster    jade      board   jade            0:0:256:256
call :raster_bw piece_qr  board   project         %cell%
exit /B %ERRORLEVEL%

:: export image from vector (svg, folder, object, size)
:raster
  set target=images\%~2
  if not exist %target% md %target%
  inkscape --export-id=%~3 --export-id-only -a %~4 -e %target%\%~3.png res\%~1.svg
exit /B 0

:: export black and white images (svg, folder, object, size)
:raster_bw
  call :raster %~1 %~2 %~3_white %~4
  call :raster %~1 %~2 %~3_black %~4
exit /B 0