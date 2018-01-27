Global $halt[8][2] = [[TimerInit(),0],[TimerInit(),0],[TimerInit(),0],[TimerInit(),0],[TimerInit(),0],[TimerInit(),0],[TimerInit(),0],[TimerInit(),0]]

halt(0,5000)
While True

If TimerDiff($halt[0][0]) < $halt[0][1] Then
		ConsoleWrite("Еще не пришло время!" & @LF)
Else
		ConsoleWrite("Время пришло, timedif=" & TimerDiff($halt[0][0]) & @LF)
		MsgBox(0,'','')
	EndIf


Sleep(500)
WEnd




Func halt($who, $time)
	$halt[$who][0] = TimerInit()
	$halt[$who][1] = $time
EndFunc