#/bin/sh
phantomjs ./phantom.js $1 | ffmpeg -y -c:v png -f image2pipe -i - -c:v libx264 -pix_fmt yuv420p -movflags +faststart $2
