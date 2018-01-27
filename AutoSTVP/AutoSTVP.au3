#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=d:\imp\autoit\autostvp\form1.kxf
$Form1_1 = GUICreate("Auto STVP", 357, 62, 192, 124)
$Button1 = GUICtrlCreateButton("Открыть", 0, 0, 91, 41)
$Button2 = GUICtrlCreateButton("Записать", 88, 0, 91, 41)
$Button3 = GUICtrlCreateButton("Проверить", 176, 0, 91, 41)
$Button4 = GUICtrlCreateButton("Стереть", 264, 0, 91, 41)
$StatusBar1 = _GUICtrlStatusBar_Create($Form1_1)
_GUICtrlStatusBar_SetParts($StatusBar1,5,72)

If Not WinExists("no project - STVP") Then
	Run("stvp.exe")
	WinWait("no project - STVP", "")
EndIf
WinActivate("no project - STVP")
Sleep(100)
$hwnd = WinGetHandle("[ACTIVE]")
WinSetState($hwnd, "", @SW_HIDE)	;прячем


GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###




While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			WinClose($hwnd)
			Exit
		Case $Button1
			ControlSend($hwnd,"",60160,"^o")
		Case $Button2
			ControlSend($hwnd,"",60160,"^p")
		Case $Button3
			ControlSend($hwnd,"",60160,"^v")
		Case $Button4
			ControlSend($hwnd,"",60160,"^e")
	EndSwitch

;~ GUICtrlSetData($Progress1, )
If StringCompare(StatusbarGetText($StatusBar1,"",1), StatusbarGetText($hwnd,"",1))<>0 Then
	_GUICtrlStatusBar_SetText($StatusBar1,StatusbarGetText($hwnd,"",1), 1)
EndIf
If StringCompare(StatusbarGetText($StatusBar1,"",2), StatusbarGetText($hwnd,"",2)) <> 0 Then
	_GUICtrlStatusBar_SetText($StatusBar1,StatusbarGetText($hwnd,"",2), 2)
EndIf
If StringCompare( StatusbarGetText($StatusBar1,"",3) , StatusbarGetText($hwnd,"",3)) <> 0 Then
	_GUICtrlStatusBar_SetText($StatusBar1,StatusbarGetText($hwnd,"",3), 3)
EndIf
If StringCompare( StatusbarGetText($StatusBar1,"",3) , StatusbarGetText($hwnd,"",3)) <> 0 Then
	_GUICtrlStatusBar_SetText($StatusBar1,StatusbarGetText($hwnd,"",3), 3)
EndIf
If StringCompare( StatusbarGetText($StatusBar1,"",4) , StatusbarGetText($hwnd,"",4)) <> 0 Then
	_GUICtrlStatusBar_SetText($StatusBar1,StatusbarGetText($hwnd,"",4), 4)
EndIf
If StringCompare( StatusbarGetText($StatusBar1,"",5) , StatusbarGetText($hwnd,"",5)) <> 0 Then
	_GUICtrlStatusBar_SetText($StatusBar1,StatusbarGetText($hwnd,"",5), 5)
EndIf

WEnd
