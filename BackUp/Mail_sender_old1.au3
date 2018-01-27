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
$Input4 = GUICtrlCreateInput("e-mail", 264, 88, 193, 21)
$Input5 = GUICtrlCreateInput("пароль", 264, 112, 193, 21)
$Input6 = GUICtrlCreateInput("SMTP сервер", 264, 136, 193, 21)
$Input7 = GUICtrlCreateInput("0", 200, 160, 57, 21)
$Progress1 = GUICtrlCreateProgress(264, 160, 358, 17)
$Button4 = GUICtrlCreateButton("Начать", 472, 88, 147, 49)
GUICtrlSetOnEvent(-1, "Button4Click")
$Label1 = GUICtrlCreateLabel("Адресов:", 520, 16, 120, 17)
$Label2 = GUICtrlCreateLabel("Заголовков:", 520, 40, 120, 17)
$Label3 = GUICtrlCreateLabel("Сообщений:", 520, 64, 120, 17)
$Label4 = GUICtrlCreateLabel("Отправлено:", 472, 136, 68, 17)
$Label5 = GUICtrlCreateLabel("Перерыв между сообщениями (сек)", 16, 88, 187, 17)
$Label6 = GUICtrlCreateLabel("Сообщений в цикле:", 88, 112, 107, 17)
$Label7 = GUICtrlCreateLabel("Перерыв между циклами (сек)", 32, 136, 160, 17)
$Input8 = GUICtrlCreateInput("5", 200, 88, 57, 21)
$Input9 = GUICtrlCreateInput("10", 200, 112, 57, 21)
$Input10 = GUICtrlCreateInput("60", 200, 136, 57, 21)
$Label8 = GUICtrlCreateLabel("Стартовый индекс:", 96, 160, 101, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#Region Переменные
Local $file_mail
Local $file_msg
Local $file_themes
Local $array_mail
Local $array_msg
Local $array_themes
Local $isOk_mail=False
Local $isOk_msg=False
Local $isOk_themes=False
#EndRegion

While 1
	Sleep(100)
WEnd

;Themes
Func Button1Click()
	$file_themes = FileOpenDialog("Файл-список тем сообщений",@AppDataDir,"Текстовые файлы (*.txt)",$FD_FILEMUSTEXIST)
	If Not @error Then
		$array_themes = FileReadToArray($file_themes)
		If @error Then
			MsgBox($MB_SYSTEMMODAL, "", "Ошибка чтения. @error: " & @error) ; An error occurred reading the current script file.
			Return
		Else
			GUICtrlSetData($Label2,GUICtrlRead($Label2) & " " & UBound($array_themes))
			MsgBox(64,"","Themes is OK");
			$isOk_themes = True
		EndIf
		GUICtrlSetData($Input2,$file_themes)
	EndIf
EndFunc

;Mail
Func Button2Click()
	$file_mail = FileOpenDialog("Файл-список адресов",@AppDataDir,"Текстовые файлы (*.txt)",$FD_FILEMUSTEXIST)
	If Not @error Then
		$array_mail = FileReadToArray($file_mail)
		If @error Then
			MsgBox($MB_SYSTEMMODAL, "", "Ошибка чтения. @error: " & @error) ; An error occurred reading the current script file.
			Return
		Else
			GUICtrlSetData($Label1,GUICtrlRead($Label1) & " " & UBound($array_mail))
			MsgBox(64,"","mail is OK");
			$isOk_mail = True
		EndIf
		GUICtrlSetData($Input1,$file_mail)	;Вывод пути в Input

	EndIf
EndFunc

;Message
Func Button3Click()
$file_msg = FileOpenDialog("Файл-список тел сообщений",@AppDataDir,"Текстовые файлы (*.txt)",$FD_FILEMUSTEXIST)
If Not @error Then
	$array_msg = FileReadToArray($file_msg)
	If @error Then
		MsgBox($MB_SYSTEMMODAL, "", "Ошибка чтения. @error: " & @error) ; An error occurred reading the current script file.
		Return
	Else
		GUICtrlSetData($Label3,GUICtrlRead($Label3) & " " & UBound($array_msg))
		MsgBox(64,"","Msg is OK");
		$isOk_msg = True
	EndIf
	GUICtrlSetData($Input3,$file_msg)
EndIf
EndFunc

Func Button4Click()
	Local $tmp_for_msg=0
	Local $tmp_for_themes=0
	For $i = 0 To UBound($array_mail) - 1
		MsgBox($MB_SYSTEMMODAL, "", $array_mail[$i]) ; Display the contents of the array.

		If $tmp_for_msg = (UBound($array_msg) - 1) Then
				$tmp_for_msg = 0
		EndIf
		If $tmp_for_themes = (UBound($array_themes) - 1) Then
				$tmp_for_themes = 0
		EndIf

		_INetSmtpMail("smtp.mail.ru","lol","noobsenslaver@mail.ru","khomich-a.g@yandex.ru","ura","Eto telo soobshenia",
	Next
EndFunc

Func Form1_1Close()
	Exit
EndFunc
