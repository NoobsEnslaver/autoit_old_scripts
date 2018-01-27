#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=C:\Users\ne\Desktop\123.Exe
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

Opt("GUIOnEventMode", 1)

#Region ### START Koda GUI section ### Form=d:\imp\autoit\mail sender\form1.kxf
$Form1_1 = GUICreate("AutoSender", 643, 188, 204, 134)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1_1Close")
$Input1 = GUICtrlCreateInput("Файл адресов", 88, 16, 425, 21)
$Button2 = GUICtrlCreateButton("Указать", 8, 16, 75, 25)
GUICtrlSetOnEvent(-1, "Button2Click")
$Input2 = GUICtrlCreateInput("Файл тем сообщени", 88, 40, 425, 21)
$Button1 = GUICtrlCreateButton("Указать", 8, 40, 75, 25)
GUICtrlSetOnEvent(-1, "Button1Click")
$Input3 = GUICtrlCreateInput("Файл тел сообщений", 88, 64, 425, 21)
$Button3 = GUICtrlCreateButton("Указать", 8, 64, 75, 25)
GUICtrlSetOnEvent(-1, "Button3Click")
$Input4 = GUICtrlCreateInput("noobsenslaver@mail.ru", 264, 88, 193, 21)
$Input5 = GUICtrlCreateInput("пароль", 264, 112, 193, 21)
$Input6 = GUICtrlCreateInput("smtp.mail.ru", 264, 136, 193, 21)
$Input7 = GUICtrlCreateInput("0", 200, 160, 57, 21)
$Progress1 = GUICtrlCreateProgress(264, 160, 358, 17)
$Button4 = GUICtrlCreateButton("Начать", 472, 88, 147, 49)
GUICtrlSetOnEvent(-1, "Button4Click")
$Label1 = GUICtrlCreateLabel("Адресов:", 520, 16, 120, 17)
$Label2 = GUICtrlCreateLabel("Заголовков:", 520, 40, 120, 17)
$Label3 = GUICtrlCreateLabel("Сообщений:", 520, 64, 120, 17)
;$Label4 = GUICtrlCreateLabel("Отправлено:", 472, 136, 68, 17)
$Label5 = GUICtrlCreateLabel("Перерыв между сообщениями (сек)", 16, 88, 187, 17)
$Label6 = GUICtrlCreateLabel("Сообщений в цикле:", 88, 112, 107, 17)
$Label7 = GUICtrlCreateLabel("Перерыв между циклами (сек)", 32, 136, 160, 17)
$Input8 = GUICtrlCreateInput("5", 200, 88, 57, 21)
$Input9 = GUICtrlCreateInput("10", 200, 112, 57, 21)
$Input10 = GUICtrlCreateInput("60", 200, 136, 57, 21)
$Label8 = GUICtrlCreateLabel("Текущий e-mail:", 96, 160, 101, 17)
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
Local $file_msg
Local $file_themes
Local $array_mail
Local $array_msg
Local $array_themes
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

				$rc = _INetSmtpMailCom($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)

				If @error Then
					MsgBox(0, "Error sending message", "Error code:" & @error & "  Description:" & $rc)
					$Working = False
					GUICtrlSetData($Button4, "Старт")
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

;Themes
Func Button1Click()
	$file_themes = FileOpenDialog("Файл-список тем сообщений", @AppDataDir, "Текстовые файлы (*.txt)", $FD_FILEMUSTEXIST)
	If Not @error Then
		$array_themes = FileReadToArray($file_themes)
		If @error Then
			MsgBox($MB_SYSTEMMODAL, "", "Ошибка чтения. @error: " & @error) ; An error occurred reading the current script file.
			Return
		Else
			GUICtrlSetData($Label2, GUICtrlRead($Label2) & " " & UBound($array_themes))
			MsgBox(64, "", "Themes is OK");
			$isOk_themes = True
		EndIf
		GUICtrlSetData($Input2, $file_themes)
	EndIf
EndFunc   ;==>Button1Click

;Mail
Func Button2Click()
	$file_mail = FileOpenDialog("Файл-список адресов", @AppDataDir, "Текстовые файлы (*.txt)", $FD_FILEMUSTEXIST)
	If Not @error Then
		$array_mail = FileReadToArray($file_mail)
		If @error Then
			MsgBox($MB_SYSTEMMODAL, "", "Ошибка чтения. @error: " & @error) ; An error occurred reading the current script file.
			Return
		Else
			GUICtrlSetData($Label1, GUICtrlRead($Label1) & " " & UBound($array_mail))
			MsgBox(64, "", "mail is OK");
			$isOk_mail = True
		EndIf
		GUICtrlSetData($Input1, $file_mail) ;Вывод пути в Input

	EndIf
EndFunc   ;==>Button2Click

;Message
Func Button3Click()
	$file_msg = FileOpenDialog("Файл-список тел сообщений", @AppDataDir, "Текстовые файлы (*.txt)", $FD_FILEMUSTEXIST)
	If Not @error Then
		$array_msg = FileReadToArray($file_msg)
		If @error Then
			MsgBox($MB_SYSTEMMODAL, "", "Ошибка чтения. @error: " & @error) ; An error occurred reading the current script file.
			Return
		Else
			GUICtrlSetData($Label3, GUICtrlRead($Label3) & " " & UBound($array_msg))
			MsgBox(64, "", "Msg is OK");
			$isOk_msg = True
		EndIf
		GUICtrlSetData($Input3, $file_msg)
	EndIf
EndFunc   ;==>Button3Click

Func Button4Click()
	If $isOk_mail * $isOk_msg * $isOk_themes = 0 Then
			MsgBox(64,"Не окончена настройка","Mail: " & $isOk_mail & "  Body: " & $isOk_msg & "  Themes: " & $isOk_themes)
			Return
	EndIf

	#Region Переменные
		$SmtpServer = GUICtrlRead($Input6)          ; address for the smtp-server to use - REQUIRED
		$FromName = GUICtrlRead($Input4)            ; name from who the email was sent
		$FromAddress = GUICtrlRead($Input4)			; address from where the mail should come
		$Username = GUICtrlRead($Input4)            ; username for the account used from where the mail gets sent - REQUIRED
		$Password = GUICtrlRead($Input5)            ; password for the account used from where the mail gets sent - REQUIRED
	#EndRegion

	$Working = True
	GUICtrlSetData($Button4, "Стоп")
	$tmp_for_msg = 0
	$tmp_for_themes = 0
	$sleep_enumerator = 0
	$sl_time = 0

EndFunc   ;==>Button4Click

Func Form1_1Close()
	Exit
EndFunc   ;==>Form1_1Close


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


