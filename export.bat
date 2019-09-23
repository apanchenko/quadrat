cd ./res

set list=sphere cell parasite

for %%a in (%list%) do (
  inkscape --export-id=%%a --export-id-only -e %%a.png piece_qr.svg
)

cd ..