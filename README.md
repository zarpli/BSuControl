# BSuControl

This script allows you to control the unit efficiently using any controller with a serial interface.

Usually in the design of interactive exhibits for museums, only the command is needed to play video and interrupt it with another video, without the need to use the network interface, GPIO, Timers, or other types of events. That is why this lightweight script was designed.

# Loop
If you need to loop, you can wait for the unit to notify you that the video playback is finished (MEDIA_ENDED) and instruct you to play again. Although for this you don't need a microcontroller and it is preferable to do the script with BrightAuthor. 

# Install

Simply add this script and your content to the flash card and you can send the list of commands below to control playback.

# Commands Supported

The commands are case sensitive. 
The unit automatically responds when a command is received.
The unit sends a response when a file has finished playing.

|command|argument|response STATUS (hex)|
|---|---|---|
|PLAY|FILE|0 : ERROR <br>1 : OK<BR>8 : MEDIA_ENDED|
|STOP|None|0 : ERROR <br>1 : OK|
|PAUSE|None|0 : ERROR <br>1 : OK|
|RESUME|None|0 : ERROR <br>1 : OK|
|REEBOT|None|None|

Command Syntax: \<command>\<space>\<argument>\<cr>

The argument is used in uppercase as this is how brightsign handles files internally.


e.g. PLAY VIDEO.MP4		

cr: carriage return

# BS Response

The response start with STX (02h) followed by the status byte and lastly an ETX (03h). 
  
\<STX>\<STATUS>\<ETX>

# Supported devices

|Model  |Physical Serial Port | Firmware|
|---|---|---|
|LS423  |USB C to 3.5mm Serial| 8.3.46 |
|HD223  |GPIO connector AF| 8.3.46 |
|HD1023 |3.5mm Serial         | 8.3.46 |
|XD233  |GPIO connector AF| 8.3.46 |
|XT243  |GPIO connector AF| 8.3.46 |
  
AF: alternate function
