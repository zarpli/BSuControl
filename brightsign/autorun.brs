'   BSuControl 1.0 - Brightsign Serial Port Control
'   Zarpli - Tecnología Interactiva
'   12112021 Alejandro Zárate
'   https://github.com/zarpli/BSuControl/

Sub Main()
    settings = createobject ("roAssociativeArray")
    settings.serialPortSpeed=115200
    settings.serialPortMode$="8N1"
    settings.videoMode$ = ""        ' ex. "1920x1080x60p", set empty to use automode
    settings.AudioOutput = 4        ' 4 : hdmi & analog
    avc = NewControl(settings)
    avc.SendStatus(2)               ' send Online status
    avc.listen()
End Sub

Sub Listen()
While True
    msg = wait(0,m.msgport)
    if type(msg) = "roVideoEvent" if msg.GetInt() = m.MEDEND m.SendStatus(m.MEDEND)
    if type(msg) = "roStreamLineEvent" m.ProcessCommand(msg.GetString())
End While
End Sub

Sub ProcessCommand(command As String)
m.ParseCommand(command)
ok = 0
if m.command = "LOOP"       ok = m.video.SetLoopMode(m.command_value)
if m.command = "PLAY" 	    ok = m.video.PlayFile(m.command_value)
if m.command = "DISPLAY"    ok = m.video.DisplayFile(m.command_value)
if m.command = "VOLUME"	    ok = m.video.SetVolume(m.command_value)
if m.command = "STOP" 	    ok = m.video.StopClear()
if m.command = "PAUSE" 	    ok = m.video.Pause()
if m.command = "RESUME"     ok = m.video.Resume()
if m.command = "REBOOT"     RebootSystem()
if ok m.SendStatus(1) else m.SendStatus(0) 
End Sub

Sub ParseCommand(command As String)
    bl_position=instr(1, command, chr(32))
    if bl_position > 0 then 
        m.command_value = mid(command,bl_position+1)
        m.command = left(command, bl_position-1)
    else 
        m.command=command
        m.command_value = ""
    endif
command=""
End Sub

Sub SendStatus(cmd As Integer)
    m.serial.SendByte(2)        'STX
    m.serial.SendByte(cmd)
    m.serial.SendByte(3)        'ETX
End Sub

Function NewControl(settings As Object) As Object
control = CreateObject("roAssociativeArray")
control.mode=CreateObject("roVideoMode")
control.msgport=CreateObject("roMessagePort")
control.video=CreateObject("roVideoPlayer")

control.registrySection = CreateObject("roRegistrySection", "usb")
if control.registrySection.Exists("type_c_serial") = false control.registrySection.Write("type_c_serial","1")

control.serial = CreateObject("roSerialPort", 0, settings.serialPortSpeed)
if control.serial = Invalid control.serial = CreateObject("roSerialPort", 2, settings.serialPortSpeed)

if control.serial = Invalid then
    control.controlPort = CreateObject("roControlPort", "BrightSign")
    control.controlPort.EnableAlternateFunction(0, "serial1")
    control.controlPort.EnableAlternateFunction(6, "serial1")
    control.serial = CreateObject("roSerialPort", 1, settings.serialPortSpeed)
endif

control.serial.SetMode(settings.serialPortMode$)
control.serial.SetLineEventPort(control.msgport)
control.serial.SetInverted(1)

control.settings=settings
control.video.SetPort(control.msgport)
control.video.SetAudioOutput(control.settings.audiooutput)
control.ProcessCommand=ProcessCommand
control.ParseCommand=ParseCommand
control.Listen = Listen
control.SendStatus=SendStatus
control.command=""
control.command_value=""
control.MEDEND=8
control.mode.SetMode(settings.videoMode$)
return control
End Function
