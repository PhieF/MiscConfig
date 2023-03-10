ffmpeg -i input.mp4 -c:a copy -c:v libsvtav1 -crf 35 -filter:v fps=25 -s hd720 -movflags +faststart out.mp4
