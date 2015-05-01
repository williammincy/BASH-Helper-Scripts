#!/bin/bash

####################################
##                                ##
## Converts a video file into the ##
## appropriate HTML5 formats:     ##
##  - 3GP                         ##
##  - MP4                         ##
##  - OGV                         ##
##  - WEBM                        ##
##  - WMV                         ##
##                                ##
## usage:                         ##
##   ./html5 infile.mp4           ##
##   ./html5 INFILE.OGV           ##
##                                ##
##                                ##
##                                ##
##                                ##
####################################


function instructions {
	echo ""
	echo "html5 video conversion script"
	echo "  by William Mincy [ [ http://github.com/williammincy ] ]"
	echo ""
}

## ffmpeg is required to run this script
ffmpegExists=(`command -v ffmpeg`)
if [ -z "$ffmpegExists" ]
then
	echo "Error: ffmpeg must be installed to use this script"
	echo "Please install via Homebrew or download from http://ffmpeg.org/"
	echo ""
	exit
fi

## ffmpeg2theora is used to make OGV files, though not required to run the script
ffmpegtheoraExists=(`command -v ffmpeg2theora`)
if [ -z "$ffmpeg2theora" ]
then
	echo "ffmpeg2theora is used to create OGV files, but is not installed"
	echo " Script will run but no OGV file types will be created"
	echo " To create OGV files, please install via Homebrew or download from http://v2v.cc/~j/ffmpeg2theora/ and rerun the script"
fi




## test that least one file is required
if [ $# -lt 1 ]
then
	echo "Error: at least one file is required"
	exit
fi

## test that this is not a directory
if [[ -d $1 ]]
then
	echo "Error: input file cannot be a directory"
	exit
fi

## test to see if the file exists
if ! test -f "$1"
then
	echo "Error: file not found"
	exit
fi

## user flags
TEST=false
QUALITY=-false
VERBOSE=false
SIZE=

while test $# -gt 0; do
	case "$1" in
		-h|--help|-?
			instructions
			exit 0;
			;;
		-q|--quality
			QUALITY=$1
			;;
		-t|--test
			TEST=true
			;;
		-s|--size
			SIZE=$1
	esac
done

## get the file's name minus the extension
basefile=`basename $1`
directory=`dirname $1`
filename=(`echo $basefile | tr "." "\n"`)
fileext="${basefile##*.}"

## make a directory and move the video into it
if ! test -d "$filename"
then
	mkdir $filename
fi
cp $1 $filename/$basefile
cd $filename


## create the MP4 version of the video
if [ $fileext != "mp4" ]
then
	echo "Creating MP4 version of the file"
	ffmpeg -i "$basefile" -vcodec libx264 -acodec libfaac $SIZE "$filename".mp4
fi

## create the WEBM version of the video
if [ $fileext != "webm" ]
then
	echo "Creating WEBM version of the file"
	ffmeg -i "$basefile" -vcodec libvpx -acodec libvorbis $SIZE "$filename".webm
fi

## create the WMV version of the video
if [ $fileext != "wmv" ]
then
	echo "Creating WMV version of the file"
	ffmpeg -i "$basefile" $SIZE "$filename".wmv
fi

## create the 3GP version of the video
if [ $fileext != "3gp" ]
then
	echo "Creating 3GP version of the file"
	ffmpeg -i "$basefile" $SIZE "$filename".3gp
fi

## create the OGV version of the video
if [ $fileext != "ogv" ]
	if [ -z "$ffmpeg2theora" ]
	then
		echo "Creating OGV version of the file"
		ffmpeg2theora "$basefile" $SIZE -o "$filename".ogv
	else
		ffmpeg -i "$basefile" -vcodec libtheora -acodec libvorbis -g 30 $SIZE "$filename".ogv
	fi
fi

## create screenshots of the video every 10 seconds
echo "Creating screenshots at 10 second intervals from video"
ffmpeg -i "$basefile" -ss 00:10 -vframes 1 -r 1 $SIZE -f image2 "$filename".jpg



## mp4  (H.264 / ACC)
## ffmpeg -i %1 -b 1500k -vcodec libx264 -vpre slow -vpre baseline -g 30 -s 640x360 %1.mp4
## webm (VP8 / Vorbis)
## ffmpeg -i %1 -b 1500k -vcodec libvpx -acodec libvorbis -ab 160000 -f webm -g 30 -s 640x360 %1.webm
## ogv  (Theora / Vorbis)
## ffmpeg -i %1 -b 1500k -vcodec libtheora -acodec libvorbis -ab 160000 -g 30 -s 640x360 %1.ogv
## REM jpeg (screenshot at 10 seconds)
## ffmpeg -i %1 -ss 00:10 -vframes 1 -r 1 -s 640x360 -f image2 %1.jpg

echo "~fin~"
echo ""
exit
