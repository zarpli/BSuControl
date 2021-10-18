# BSuControl
BrightSign Media Players Tools for Arduino

# Serial Port 

This is a script for controlling BS unit through Microcontrollers using a serial port. 

This allows you to send a series of commands including play, stop, pause, and resume to control video playback.

The unit automatically responds when a command is received. 

The unit sends a response when a file has finished playing.

# Install

Simply add this script and your content to the flash card and you can send the list of commands below to control playback.

# Commands Supported

This control script supports the following commands. The commands are case sensitive.

Command Syntax: <command><space><argument><CR>
  
CR: Carriage Return

e.g.	PLAY VIDEO.MP4 		

# BS Response

<STX><STATUS><ETX>

# Supported devices

|Model  |Physical Serial Port | Firmware|
|---|---|---|
|LS423  |USB C to 3.5mm Serial| 8.3.46 |
|HD223  |GPIO                 | 8.3.46 |
|HD1023 |3.5mm Serial         | 8.3.46 |

BrightSign LS424 with USB C to 3.5mm Serial Cable

BrightSign HD1023
