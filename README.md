# BSuControl

This script is designed to control brightsign units efficiently using any controller with a serial interface. Usually in the design of interactive exhibits for museums the most used command is play video and interrupt it with another video, and of course you need to know when the current video ends playing. 

# Install

Simply add this script and your content to the flash card and you can send the list of commands below to control playback.

# Commands Supported

The commands are case sensitive. 
The unit automatically responds when a command is received.

|command (chars)|argument|response STATUS (hex)|
|---|---|---|
|PLAY|FILE|0 : Error <br>1 : Ok|
|STOP|None|0 : Error <br>1 : Ok|
|PAUSE|None|0 : Error <br>1 : Ok|
|RESUME|None|0 : Error <br>1 : Ok|
|REBOOT|None|None|

Command Syntax: ```<command><space><argument><cr>```

The argument is used in uppercase as this is how brightsign handles files internally.

e.g. ```PLAY VIDEO.MP4```

cr: carriage return

# BS Response

The response start with STX (02h) followed by the status byte and lastly an ETX (03h). 
  
```<STX><STATUS><ETX>```
  
When the unit starts up and has the script installed, the status online (02h) is sent.

```02h 02h 03h```
  
Unit responds automatically with MEDIA_ENDED (08h) when a file has finished playing:
  
```02h 08h 03h```
  
# USB 2.0 Type-C Serial Port
  
The LS423 and LS424 units has a USB 2.0 Type-C port, this includes a TTL serial port.

The following table illustrates the pinout of the USB 2.0 Type-C host port:

|pin|Signal Name|Description|pin|Signal Name|Description|
|---|---|---|---|---|---|
|A1|GND|Ground return|B12|GND|Ground return|
|A2|TX1+|**Serial Transmit**|B11|||
|A3|TX1-|**Serial Receive**|B10|||
|A4|VBUS|Bus Power|B9|VBUS|Bus Power|
|A5|CC1|Configuration Channel|B8|||
|A6|DP1|Positive Half USB 2.0 Position 1|B7|DN2|Negative Half of USB 2.0 Position 2|
|A7|DN1|Negative Half USB 2.0 Position 1|B6|DP2|Positive Half of USB 2.0 Position 2|
|A8|||B5|CC2|Configuration channel|
|A9|VBUS|Bus Power|B4|VBUS|Bus Power|
|A10|||B3|TX2-|**Serial Receive**|
|A11|||B2|TX2+|**Serial Transmit**|
|A12|GND|Ground return|B1|GND|Ground return|

The serial port supports TTL signaling and is located on the the A2/A3 and B2/B3 pins. It enumerates as port 0.
  
# Serial Port in GPIO 

On some BrightSign models that have onboard GPIO connector it is possible to use them with an **alternate function**, including a TTL serial port. This method is currently supported on the XTx44, XTx43, XDx34, XDx33, HDx24, HDx23, and HO523 models.

The following table outlines the possible alternate setting for each pin:

|GPIO Pin|Button Number|Alternate Function|
|---|---|---|
|3|0|**serial1 (Rx)**|
|4|1|irin1|
|5|2|irout (HDx23, HO523 only)|
|6|3|N/A|
|9|4|serial0 (Rx - console port)*|
|10|5|serial0 (Tx)*|
|11|6|**serial1 (Tx)**|
|12|7|N/A|

*Models that do not have a 3.5mm serial port (e.g. HD223, XD233) do not support serial port 0.

# Loop
If you need to loop, you can wait for the unit to notify you that the video playback is finished (MEDIA_ENDED) and instruct you to play again. Although for this you don't need a microcontroller and it is preferable to do the script with BrightAuthor. 

# Supported devices

The following list shows the models that have been tested with this script, but it will surely work on another model in the same series as well. 
  
|Model  |Physical Serial Port | Firmware|
|---|---|---|
|LS423  |USB C to 3.5mm Serial| 8.3.46 |
|LS424* |USB C to 3.5mm Serial| 8.3.46 |
|HD223  |GPIO connector AF| 8.3.46 |
|HD1023 |Onboard 3.5mm Serial| 8.3.46 |
|XD233  |GPIO connector AF| 8.3.46 |
|XT243  |GPIO connector AF| 8.3.46 |
  
**AF:** Alternate Function
  
\* LS424 need a power cycle
