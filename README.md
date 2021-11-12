# BSuControl

This script is designed to control BrightSign units efficiently using any controller with a serial interface.

# Supported devices

The following list shows the models that have been tested with this script, but it will surely work on another model in the same series as well. 
  
|Model|Physical Serial Port|Firmware|
|---|---|---|
|AU320 |Onboard DE9 RS-232|6.1.76|
|LS422 |USB to Serial Adapter|6.2.147.9|
|LS423 |USB C Serial Built-in|8.3.46|
|LS424 |USB C Serial Built-in|8.3.46|
|HD223 |GPIO connector AF|8.3.46|
|HD1023|Onboard 3.5mm Serial|8.3.46|
|XD233 |GPIO connector AF|8.3.46|
|XT243 |GPIO connector AF|8.3.46|
  
**AF:** Alternate Function

Please check the technical specifications of the serial port, in particular the tolerated voltages.

# Install

Simply add this script and your content to the flash card and you can send the list of commands below to control playback.

# Commands Supported

The commands are case sensitive. 
The unit automatically responds when a command is received.

|command (chars)|argument|response STATUS (hex)|
|---|---|---|
|PLAY|FILE|0 : error <br>1 : ok|
|STOP|none|0 : error <br>1 : ok|
|VOLUME|% (INT)|0 : error <br>1 : ok|
|PAUSE|none|0 : error <br>1 : ok|
|RESUME|none|0 : error <br>1 : ok|
|REBOOT|none|none|

Command Syntax: ```<command><space><argument><cr>```

The argument is used in **uppercase** as this is how brightsign handles files internally.

|command example|description|
|---|---|
|```PLAY VIDEO.MOV```|try to play video file called "video.mov"|
|```PLAY AUDIO.M4A```|try to play audio file called "audio.m4a"|
|```VOLUME 50```|set the volume to 50 percent|

cr: carriage return

# BS Response

The response start with STX (02h) followed by the status byte and lastly an ETX (03h). 
  
```<STX><STATUS><ETX>```
  
When the unit starts up and has the script installed, the status **online** (02h) is sent.

```02h 02h 03h```
  
Unit responds automatically with **media_ended** (08h) when a file has finished playing:
  
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
  
# GPIO - Serial Port

On some BrightSign models that have onboard GPIO connector it is possible to use them with an **alternate function**, including a TTL serial port. This method is currently supported on the XTx44, XTx43, XDx34, XDx33, HDx24, HDx23, and HO523 models.

The following table outlines the possible alternate setting for each pin:

|GPIO Pin|Native Function|Alternate Function|
|---|---|---|
|1|GND|N/A|
|2|VDD|N/A|
|3|Button 0|**serial1 (Rx)**|
|4|Button 1|irin1|
|5|Button 2|irout (HDx23, HO523 only)|
|6|Button 3|N/A|
|9|Button 4|serial0 (Rx - console port)*|
|10|Button 5|serial0 (Tx)*|
|11|Button 6|**serial1 (Tx)**|
|12|Button 7|N/A|

GPIO alternate function serial is **always TTL.**

*Models that do not have a 3.5mm serial port (e.g. HD223, XD233) do not support serial port 0.

# DE9 RS-232
The RS-232 interface is a male DE9 connector. The following table illustrates the pinout.

|Pin|Description|Pin|Description|
|---|---|---|---|
|1|NC|2|Receive data into the device|
|3|Transmit data out of the device|4|Available 5V @ 500mA|
|5|Ground|6|NC|
|7|RTS|8|CTS|
|9|NC|||

# 3.5mm Serial Port

The UART (asynchronous serial) interface is a 3.5mm (1/8") jack that uses **TTL levels** for communication. There are some models that are compatible with RS-232 voltages, see the following table: 

|Series with 3.5mm serial|RS-232 Compatible|
|---|---|
|XT4|YES|
|XD4|YES|
|HD4|YES|
|XD3 (Revision H and newer)|YES|
|XT3 (Revision H and newer)|YES|
|XD3 (Revision G and older)|NO|
|XT3 (Revision G and older)|NO|
|HD3|NO|
|LS424|NO|
|LS423|NO|

The 3.5mm serial port has the following configuration (from the perspective of the player):

|Pin|Function|
|---|---|
|Tip|Receive|
|Ring|Transmit|
|Sleeve|Ground|

This serial interface supports TX, RX, and ground only.


# USB to Serial Port Adapter

At the moment on **LS422** units, it is only possible to use serial communication using a USB adapter.
This script has been tested in conjunction with the following adapters, but it may well work with any other.
|Brand|
|---|
|ATEN International CO., LTD|
|Future Technology Devices International - FTDI|
|Prolific Technology Inc|

# Signaling Settings

The following are the default serial settings for a BrightSign player. They can be changed in the script.
|Default serial settings|
|---|
|Baud rate: 115200|
|Data: 8 bit|
|Parity: None|
|Stop: 1 bit|

# Use with Docklight

[Docklight](https://docklight.de/) is a testing, analysis and simulation tool for serial communication protocols.

Use the following project to use BrightSign unit connected to a PC running Windows OS.

[bs_commands.ptp](docklight/bs_commands.ptp)
    
# Loop
If you need to loop, you can wait for the unit to notify you that the video playback is finished (MEDIA_ENDED) and instruct you to play again. Although for this you don't need a microcontroller and it is preferable to do the script with BrightAuthor. 

# Power Cycle
\* LS424 need a power cycle
