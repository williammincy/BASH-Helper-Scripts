#!/bin/sh

## Adapted from the wonderful example script here: http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html

# get just the file's name without file extension
file=$1
filename=${file%.*}

# work out the duration of the clip from the file
# note: I was seeing a 1 second offset so am just adding one second to the duration, should come back a fix later
start_time=00:00
duration=$(ffmpeg -i $1 2>&1 | grep "Duration"| cut -d ' ' -f 4 | sed s/,// | sed 's@\..*@@g' | awk '{ split($1, A, ":"); split(A[3], B, "."); print 3600*A[1] + 60*A[2] + B[1] + 1 }')

# location for the pallette file
palette="/tmp/palette.png"

# create the file if it doesn't already exist
touch $palette

# set up filters and sizes
filterso="fps=15,scale=240:-1:flags=lanczos"
filtersoo="fps=15,scale=320:-1:flags=lanczos"
filtersooo="fps=15,scale=480:-1:flags=lanczos"
filtersoooo="fps=15,scale=640:-1:flags=lanczos"

# establish file suffixes
suffix240="_240.gif"
suffix320="_320.gif"
suffix480="_480.gif"
suffix640="_640.gif"

# process GIF and palette for 240 width
ffmpeg -v warning -ss 0:00 -t $duration -i $1 -vf "$filterso,palettegen" -y $palette
ffmpeg -v warning -ss 0:00 -t $duration -i $1 -i $palette -lavfi "$filterso [x]; [x][1:v] paletteuse" -y $filename$suffix240

# process GIF and palette for 320 width
ffmpeg -v warning -ss 0:00 -t $duration -i $1 -vf "$filtersoo,palettegen" -y $palette
ffmpeg -v warning -ss 0:00 -t $duration -i $1 -i $palette -lavfi "$filtersoo [x]; [x][1:v] paletteuse" -y $filename$suffix320

# process GIF and palette for 480 width
ffmpeg -v warning -ss 0:00 -t $duration -i $1 -vf "$filtersooo,palettegen" -y $palette
ffmpeg -v warning -ss 0:00 -t $duration -i $1 -i $palette -lavfi "$filtersooo [x]; [x][1:v] paletteuse" -y $filename$suffix480

# process GIF and palette for 640 width
ffmpeg -v warning -ss 0:00 -t $duration -i $1 -vf "$filtersoooo,palettegen" -y $palette
ffmpeg -v warning -ss 0:00 -t $duration -i $1 -i $palette -lavfi "$filtersoooo [x]; [x][1:v] paletteuse" -y $filename$suffix640

