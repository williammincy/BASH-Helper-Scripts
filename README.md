BASH-Helper-Scripts
===================

BASH Helper Scripts written to perform a few macro actions that make my life easier. Work in progress.

#### gif.sh

Takes a single video file as input and outputs multiple GIF formatted images in various dimensions. All resized GIF images maintain the same aspect ratio of the source video.

Exported width sizes are: 
- 240
- 320
- 480
- 640

Usage: 
	./gif.sh inputfile.mp4

#### html5.sh 

Takes a single video file as input and outputs multiple video files for use in online HTML5 video players

Exported file formats are:
- 3GP
- MP4
- OGV
- WEBM
- WMV

Usage:
	./html5 infile.mp4
	./html5 INFILE.OGV   
