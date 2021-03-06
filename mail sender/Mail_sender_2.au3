#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=envelope_4749.ico
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Fileversion=2.0.7.2
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <Inet.au3>
#Include <file.au3>
#include <Encoding.au3>
#include <Array.au3>

Opt("GUIOnEventMode", 1)

#Region ### START Koda GUI section ### Form=d:\imp\autoit\mail sender\form1.kxf
$Form1_1 = GUICreate("AutoSender", 643, 527, 262, 130)

$Input1 = GUICtrlCreateInput("Файл адресов", 88, 10, 409, 21)
$Input2 = GUICtrlCreateInput("Файл тем сообщени", 88, 34, 409, 21)
$Input3 = GUICtrlCreateInput("Андрей Александров", 264, 156, 233, 21)
$Input4 = GUICtrlCreateInput("box_pro_aal@mail.ru", 264, 84, 233, 21)
$Input5 = GUICtrlCreateInput("811m405m", 264, 108, 233, 21)
$Input6 = GUICtrlCreateInput("smtp.mail.ru", 264, 132, 233, 21)
$Input7 = GUICtrlCreateInput("0", 200, 156, 57, 21)
$Input8 = GUICtrlCreateInput("5", 200, 84, 57, 21)
$Input9 = GUICtrlCreateInput("10", 200, 108, 57, 21)
$Input10 = GUICtrlCreateInput("60", 200, 132, 57, 21)
$Input11 = GUICtrlCreateInput("Прикрепление", 88, 58, 409, 21)


$Button1 = GUICtrlCreateButton("Файл", 8, 34, 75, 25)

$Button2 = GUICtrlCreateButton("Файл", 8, 10, 75, 25)
$Button3 = GUICtrlCreateButton("Добавить сообщение", 0, 180, 123, 33)
$Button4 = GUICtrlCreateButton("Начать рассылку", 128, 180, 115, 33)
$Button5 = GUICtrlCreateButton("Файл", 8, 58, 75, 25)

$Progress1 = GUICtrlCreateProgress(248, 188, 390, 17)

$Label1 = GUICtrlCreateLabel("Всего адресов: 0", 504, 10, 130, 17)
$Label2 = GUICtrlCreateLabel("Всего тем: 0", 504, 36, 130, 17)
$Label3 = GUICtrlCreateLabel("Всего сообщений: 0", 504, 58, 130, 17)
$Label5 = GUICtrlCreateLabel("Перерыв между сообщениями (сек)", 10, 84, 187, 17)
$Label6 = GUICtrlCreateLabel("Сообщений в цикле:", 88, 108, 107, 17)
$Label7 = GUICtrlCreateLabel("Перерыв между циклами (сек)", 32, 132, 160, 17)
$Label8 = GUICtrlCreateLabel("Стартовый индекс:", 96, 156, 101, 17)

$Edit1 = GUICtrlCreateEdit("", 0, 212, 641, 309)

GUISetOnEvent($GUI_EVENT_CLOSE, "Form1_1Close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1_1Minimize")
GUICtrlSetOnEvent($Input1, "Input1Change")
GUICtrlSetOnEvent($Input2, "Input2Change")
GUICtrlSetOnEvent($Button1, "Button1Click")
GUICtrlSetOnEvent($Button2, "Button2Click")
GUICtrlSetOnEvent($Button3, "Button3Click")
GUICtrlSetOnEvent($Button4, "Button4Click")
GUICtrlSetOnEvent($Button5, "Button5Click")
GUICtrlSetData($Edit1, "Текст сообщения")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#Region Переменные
$SmtpServer = ""          ; address for the smtp-server to use - REQUIRED
$FromName = ""            ; name from who the email was sent
$FromAddress = ""		; address from where the mail should come
$AttachFiles = ""                       	; the file(s) you want to attach seperated with a ; (Semicolon) - leave blank if not needed
$CcAddress = ""       						; address for cc - leave blank if not needed
$BccAddress = ""     						; address for bcc - leave blank if not needed
$Importance = "Normal"                  	; Send message priority: "High", "Normal", "Low"
$Username = ""           ; username for the account used from where the mail gets sent - REQUIRED
$Password = ""            ; password for the account used from where the mail gets sent - REQUIRED
$IPPort = 465                            	; port used for sending the mail
$ssl = 1

Local $file_mail
;Local $file_msg
Local $file_themes
Local $array_mail[1] = [0]
_ArrayDelete($array_mail,0)
Local $array_msg[1] = [0]
_ArrayDelete($array_msg,0)
Local $array_themes[1] = [0]
_ArrayDelete($array_themes,0)
Local $isOk_mail = False
Local $isOk_msg = False
Local $isOk_themes = False
Local $Working = False
;Local $tmp_for_mails = 0
Local $tmp_for_msg = 0
Local $tmp_for_themes = 0
Local $sleep_enumerator = 0
Local $sl_time = 0

#EndRegion Переменные


$tray2 = TrayCreateItem("Восстановить из трея")
TrayItemSetOnEvent($tray2,"_Restore")

AutoItSetOption("TrayOnEventMode",1)
AutoItSetOption("TrayAutoPause",0)

While 1
	If $sl_time > 0 Then
		$sl_time = $sl_time - GUICtrlRead($Input8)*1000
	Else
			If $Working = True Then

				GUICtrlSetData($Progress1, ((GUICtrlRead($Input7)+1)/UBound($array_mail))*100)

				If $tmp_for_themes = (UBound($array_themes)) Then	;Если кончились темы - инкремент тела сообщения
					$tmp_for_themes = 0
					$tmp_for_msg = $tmp_for_themes + 1
					If $tmp_for_msg = (UBound($array_msg)) Then
						$tmp_for_msg = 0
					EndIf
				EndIf

				$ToAddress = $array_mail[GUICtrlRead($Input7)] 	 			;destination address of the email - REQUIRED
				$Subject = $array_themes[$tmp_for_themes]                   ; subject from the email - can be anything you want it to be

				$Body = $array_msg[$tmp_for_msg]
				;$Body = GUICtrlRead($Input1)
				$rc = _INetSmtpMailCom($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)

				If @error Then
					MsgBox(0, "Error sending message", "Error code:" & @error & "  Description:" & $rc)
					$Working = False
					GUICtrlSetData($Button4, "Начать рассылку")
				EndIf

				If $sleep_enumerator =  GUICtrlRead($Input9) Then	;отсчет количества итераций для слипа между циклами
					$sleep_enumerator = 0
					$sl_time = GUICtrlRead($Input10)*1000
				EndIf
				$sleep_enumerator = $sleep_enumerator + 1
				$tmp_for_themes = $tmp_for_themes + 1
				GUICtrlSetData($Input7, GUICtrlRead($Input7) + 1)

					If GUICtrlRead($Input7) = UBound($array_mail) Then	;Если смещение равно размеру массива с адресами
					MsgBox(64,"","Рассылка закончена")
					$Working = False
					GUICtrlSetData($Button4, "Старт")
				EndIf
			EndIf
	EndIf

	Sleep(GUICtrlRead($Input8)*1000)
WEnd

;Добавить темы из файла
Func Button1Click()
	$file_themes = FileOpenDialog("Файл-список тем сообщений", @AppDataDir, "Текстовые файлы (*.txt)", $FD_FILEMUSTEXIST)
	If Not @error Then
		$array_themes = FileReadToArray($file_themes)
		If @error Then
			MsgBox($MB_SYSTEMMODAL, "", "Ошибка чтения. @error: " & @error) ; An error occurred reading the current script file.
			Return
		Else
			GUICtrlSetData($Label2, "Всего тем: " & UBound($array_themes))
			MsgBox(64, "", "Themes is OK");
			$isOk_themes = True
		EndIf
		GUICtrlSetData($Input2, $file_themes)
	EndIf
EndFunc

;Добавить адресса из файла
Func Button2Click()
	$file_mail = FileOpenDialog("Файл-список адресов", @AppDataDir, "Текстовые файлы (*.txt)", $FD_FILEMUSTEXIST)
	If Not @error Then
		$array_mail = FileReadToArray($file_mail)
		If @error Then
			MsgBox($MB_SYSTEMMODAL, "", "Ошибка чтения. @error: " & @error) ; An error occurred reading the current script file.
			Return
		Else
			GUICtrlSetData($Label1, "Всего адрессов: " & UBound($array_mail))
			MsgBox(64, "", "mail is OK");
			$isOk_mail = True
		EndIf
		GUICtrlSetData($Input1, $file_mail) ;Вывод пути в Input

	EndIf
EndFunc

;Добавить тело сообщения
Func Button3Click()
	_ArrayAdd($array_msg,GUICtrlRead($Edit1))
	GUICtrlSetData($Label3,"Всего сообщений: " & UBound($array_msg))
	GUICtrlSetData($Edit1,"")
EndFunc

;Начать
Func Button4Click()
	If $isOk_mail * UBound($array_msg) * $isOk_themes = 0 Then
		MsgBox(64,"Не окончена настройка","Mail: " & $isOk_mail & "  Body: " & UBound($array_msg) & "  Themes: " & $isOk_themes)
		Return
	EndIf

	#Region Переменные
		$SmtpServer = GUICtrlRead($Input6)          ; address for the smtp-server to use - REQUIRED
		$FromName = GUICtrlRead($Input3)            ; name from who the email was sent
		$FromAddress = GUICtrlRead($Input4)			; address from where the mail should come
		$Username = GUICtrlRead($Input4)            ; username for the account used from where the mail gets sent - REQUIRED
		$Password = GUICtrlRead($Input5)            ; password for the account used from where the mail gets sent - REQUIRED
		$AttachFiles = GUICtrlRead($Input11)
	#EndRegion

	$Working = True
	GUICtrlSetData($Button4, "Стоп")
	$tmp_for_msg = 0
	$tmp_for_themes = 0
	$sleep_enumerator = 0
	$sl_time = 0
EndFunc


Func Form1_1Close()
	Exit
EndFunc

Func Form1_1Minimize()
	WinSetState("AutoSender", '', @SW_HIDE)
EndFunc

Func _Restore()
    WinSetState("AutoSender", '', @SW_SHOW)
	WinSetState("AutoSender", '', @SW_RESTORE)
EndFunc

;Вручную ввели адресс
Func Input1Change()
	If GUICtrlRead($Input1) = "" Then
			$isOk_mail = False
			Return
	Else
			_ArrayAdd($array_mail,GUICtrlRead($Input1))
			GUICtrlSetData($Label1,"Всего адрессов: " & UBound($array_mail))
			$isOk_mail = True
	EndIf
EndFunc

;Вручную ввели тему
Func Input2Change()
	If GUICtrlRead($Input2) = "" Then
		$isOk_themes = False
		Return
	Else
		_ArrayAdd($array_themes,GUICtrlRead($Input2))
		GUICtrlSetData($Label2,"Всего тем: " & UBound($array_themes))
		$isOk_themes = True
	EndIf
EndFunc

;Добавить прекрепление
Func Button5Click()
	$AttachFiles = FileOpenDialog("Файл-список тем сообщений", @AppDataDir, "Файлы (*.*)", $FD_FILEMUSTEXIST)
	GUICtrlSetData($Input11, $AttachFiles)
	GUICtrlSetData($Edit1, "")
EndFunc

; Script
Global $oMyRet[2]
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")

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

; Com Error Handler
Func MyErrFunc()
    $HexNumber = Hex($oMyError.number, 8)
    $oMyRet[0] = $HexNumber
    $oMyRet[1] = StringStripWS($oMyError.description, 3)
    ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $oMyError.scriptline & "   Description:" & $oMyRet[1] & @LF)
    SetError(1); something to check for when this function returns
    Return
EndFunc   ;==>MyErrFunc


