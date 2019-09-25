cd ./res

set list=sphere cell parasite scavenger

for %%a in (%list%) do (
  inkscape --export-id=%%a --export-id-only -a -128:-128:128:128 -e %%a.png piece_qr.svg
)

cd ..