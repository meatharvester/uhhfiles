powershell -NoProfile -Command "Get-ChildItem -Filter *.wav | ForEach-Object { ffmpeg -i $_.FullName -c:a flac \"$($_.BaseName).flac\"; if ($?) { Remove-Item $_.FullName } }"
