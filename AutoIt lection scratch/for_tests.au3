$time_stamp = 0
If (TimerDiff($time_stamp)/60000)>18 Then
	MsgBox(0,'','')
	$time_stamp = TimerInit()
EndIf

If (TimerDiff($time_stamp)/60000)>18 Then
	MsgBox(0,'','')
	$time_stamp = TimerInit()
EndIf