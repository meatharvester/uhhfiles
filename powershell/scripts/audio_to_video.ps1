$ErrorActionPreference = "Stop"

# Check for the file format.
if ($args[0] -eq  "-w") {
    Write-Host("Inputting .wav files.")
    $audio_format = ".wav"
}
elseif ($args[0] -eq "-f") {
    Write-Host("Inputting .flac files.")
    $audio_format = ".flac"
}
elseif ($args[0] -eq "-3") {
    Write-Host("Inputting .mp3 files.")
    $audio_format = ".mp3"
}
elseif ($args[0] -eq "-o") {
    Write-Host("Inputting .ogg files.")
    $audio_format = ".ogg"
}
else {
    Write-Host("No audo file format specified, exiting.")
    exit 1
}
if ($args[1] -eq 0) {
    Write-Host("Please provide a image")
}

$gpu = (Get-WmiObject Win32_VideoController).Name
if ($gpu -like "*NVIDIA*") {
    Write-Host("NVIDA GPU detected, using NVENC encoder")
    $encoder = "h264_nvenc"
}
elseif ($gpu -like "*AMD") {
    Write-Host("AMD GPU detected, using AMF encoder")
    $encoder = "h264_amf"
}
else {
    Write-Host("No GPU detected, using CPU Encoder")
    $encoder = "libx264"
}

Write-Host("Executing FFmpeg")
foreach ($file in Get-ChildItem -Path . -Filter *$audio_format) {
    $input = $file.FullName
    $output = [System.IO.Path]::ChangeExtension($input, ".mp4")
    Write-Host "Processing $input..."

    & ffmpeg -loop 1 -framerate 2 -i $args[1] -i "$input" `
        -map 0:v -map 1:a -c:v $encoder -pix_fmt yuv420p -preset p3 -qp 23 `
        -vf "scale=-1:1080,pad=1920:ih:(ow-iw)/2" -c:a aac -b:a 256k `
        -shortest -movflags +faststart "$output"

    Write-Host "Converted $input to $output"
}

Write-Host "All files processed!"
pause
