Global $X[7][5]
Global $Y[7][5]
Global $S[7]
Global $halt[7][2] = [[TimerInit(),0],[TimerInit(),0],[TimerInit(),0],[TimerInit(),0],[TimerInit(),0],[TimerInit(),0],[TimerInit(),0]]
Enum $Summon=0, $PS, $PP, $SE, $BD, $SVS

Func A_Summon()
	;X[0] - masters window
	;X[1] - hp
	;X[2] - command
	;X[3] - summon born lifestamp
	;X[4] - mob hp
	;Y[0] - hp
	;Y[1] - life time

	If TimerDiff($halt[$Summon][0]) < $halt[$Summon][1] Then
		Return
	EndIf
	WinActivate($X[$Summon][0])
	WinWaitActive($X[$Summon][0])

	$X[$Summon][1] = get_summon_hp()
	$Y[$Summon][0] = $X[$Summon][1]
	$Y[$Summon][1] = TimerDiff($X[$Summon][3])/60000
	$S[$Summon] = ($X[$Summon][1] = 0)? 0 : $S[$Summon]
	Switch $S[$Summon]
		;������� ���
		Case 0
			If $X[$Summon][1] > 0 Then	;���� �� ���������, ����� ������ ��������
				$S[$Summon] = 1
				$X[$Summon][3] = TimerInit()
			Else
				$S[$PS] = 0				;��������� ��� - ��� ������.
				halt($Summon, 5000)		;����� �������� ������� �� 5 ���.
			EndIf

		;��������
		Case 1
			Switch $X[$Summon][2]
				Case 'attack'
					$S[$Summon] = 2
					Send("{F1}")
				Case 'stop'
					$X[$Summon][2] = 0			;���������� �������, ����� �� ��������� �� � ����. ��������
					Send("{F2}")
				Case 'unsummon'
					Send("{F12}")
					$S[$Summon] = 0
					$X[$Summon][2] = 0			;���������� �������, ����� �� ��������� �� � ����. ��������
			EndSwitch


			Switch $X[$Summon][1]
				Case 0
					$S[$Summon] = 0				;����� ����
				Case 1 To 80
					Send("2")					;���
			EndSwitch

		;� ���
		Case 2
			$X[$Summon][4] = get_mob_hp()	;������� �� ����
			If $X[$Summon][4] = 0 Then		;���� ��� ��� ��� �� ���� - � ��������
				$S[$Summon] = 1
				$X[$Summon][2] = 'stop'		;������ ������� ����, ����� �� �������� "�����" �� �����
			EndIf

			Switch $X[$Summon][2]
				Case 'attack'
					$S[$Summon] = 2
					Send("{F1}")
				Case 'stop'
					$X[$Summon][2] = 0			;���������� �������, ����� �� ��������� �� � ����. ��������
					Send("{F2}")
				Case 'unsummon'
					Send("{F12}")
					$S[$Summon] = 0
					$X[$Summon][2] = 0			;���������� �������, ����� �� ��������� �� � ����. ��������
			EndSwitch

			Switch $X[$Summon][1]
				Case 0
					$S[$Summon] = 0				;����� ����
				Case 1 To 30
					Send(Random(0,2)>1?"2":"3")	;��� ��� ����
				Case 30 To 80
					Send("2")					;���
			EndSwitch

	EndSwitch



EndFunc

Func A_PS()
	;X[0] - window
	;X[1] - hp
	;X[2] - mob hp
	;X[3] - need rebuf
	;X[4] - buff timestamp
	;X[5] - need song_dance
	;X[6] - song_dance timestamp

	If TimerDiff($halt[$PS][0]) < $halt[$PS][1] Then
		Return
	EndIf
	WinActivate($X[$PS][0])
	WinWaitActive($X[$PS][0])

	$X[$PS][1] = get_my_hp()

	If $S[$Summon] = 0 Then								;���� ��� ������ - ��������� ���.
		Send("0")
		$X[$PS][3] = True
		halt($PS,5000)
	Else												;���� �� ����  - �������� � ���
		If $Y[$Summon][1] > 40 And $S[$Summon] = 1 Then	;���� ������ ��� 40 ��� � �� �� � ���
			$X[$Summon][2] = 'unsummon'					;���������� ��� ��������� "����������"
		Else
			If $X[$PS][2] = 0 Then							;���� �� ���� = 0
				Send("4")									;target next
			Else
				$X[$Summon][2] = 'attack'					;������� ������ - �����.
			EndIf

			If $S[$Summon] > 0 AND $X[$PS][3] = True Then	;���� ����� ��� � ����� ����� - �������� ������� �������
				$X[$PS][3] = False
				$X[$PP][1] = 'buf'
				$X[$SE][1] = 'buf'
				$X[$PS][4] = TimerInit()
			EndIf

			If $X[$PS][4] > 18*60*1000 Then					;���� � �������� ������ ������ 18 ����� - ����� �����
				$X[$PS][3] = True
				Send("9")									;�������� ����� �����
				halt($PS,5000)
			EndIf

			If $S[$Summon] > 0 AND $X[$PS][5] = True Then	;����, �� ��� ����� � �����
				$X[$PS][3] = False
				$X[$BD][1] = 'buf'
				$X[$SVS][1] = 'buf'
				$X[$PS][6] = TimerInit()
			EndIf

			If $X[$PS][6] > 2*60*1000 Then					;����
				$X[$PS][5] = True
			EndIf
		EndIf
	EndIf

	Switch $X[$PS][1]		;������ �� �� ����
		Case 0
			If $S[$PP] = 0 Then			;���� �� � ��������� ��������
				$X[$PP][1] = 'res_PS'	;�� - ����� ���
			ElseIf $S[$SE] = 0 Then
				$X[$SE][1] = 'res_PS'	;�� - ����� ���
			EndIf
		Case 1 To 50
			If $S[$PP] = 0 Then			;���� �� � ��������� ��������
				$X[$PP][1] = 'heal_PS'	;�� - ��� ���
			ElseIf $S[$SE] = 0 Then
				$X[$SE][1] = 'heal_PS'	;�� - ��� ���
			EndIf
			Send("5")					;������ �����
		Case 50 To 80
			Send("5")					;������ �����
	EndSwitch

EndFunc

Func A_PP()
	;X[0] - window
	;X[1] - hp
	;X[2] - command
	If TimerDiff($halt[$PP][0]) < $halt[$PP][1] Then
		Return
	EndIf

	If $X[$PP][2] <> 0 Then	;���������� ���� ������ ���� ������ �������
		WinActivate($X[$PP][0])
		WinWaitActive($X[$PP][0])
	EndIf
	$X[$PP][1] = get_my_hp()

	Switch $S[$PP]
		Case 0	;����
;~ 			Switch $X[$PP][1]	;������� �� �����
;~ 				Case 0
;~ 					$S[$PP] = 4	;��������� - �����
;~ 				Case 1 To 70
;~ 					Send("9")	;self heal
;~ 					Sleep(500)
;~ 			EndSwitch
			Switch $X[$PP][2]
				Case 'buf'
					$S[$PP] = 1
					Send("3")	;���� ��� + ��� ��������
					halt($PP, 10000)
				Case 'heal_PS'
					$S[$PP] = 2
					Send("2")	;������ �������� + ���� ��� + ������ ����
					halt($PP, 4000)
				Case 'res_PS'
					$S[$PP] = 3
					Send("0")	;������ ���
					halt($PP, 10000)
			EndSwitch
		Case 1	;������� ������ ����� ����
			$S[$PP] = 2
			Send("4")	;������ ��� ������
			halt($PP, 25000)
		Case 2	;�����
			$S[$PP] = 0		;������ �� ����� �� �����
			$X[$PP][2] = 0	;��������� �������, ����� �� ��������� � �����
		Case 3	;�������
			WinActivate($X[$PS][0])
			WinWaitActive($X[$PS][0])
			Sleep(500)
			MouseClick("left",400, 400)
			$S[$PP] = 0		;������ �� ����� �� �����
		Case 4	;����



	EndSwitch
EndFunc

Func A_SE()
	;X[0] - window
	;X[1] - hp
	;X[2] - command
	If TimerDiff($halt[$SE][0]) < $halt[$SE][1] Then
		Return
	EndIf

	If $X[$SE][2] <> 0 Then	;���������� ���� ������ ���� ������ �������
		WinActivate($X[$SE][0])
		WinWaitActive($X[$SE][0])
	EndIf
	$X[$SE][1] = get_my_hp()

	Switch $S[$SE]
		Case 0	;����
;~ 			Switch $X[$PP][1]	;������� �� �����
;~ 				Case 0
;~ 					$S[$PP] = 4	;��������� - �����
;~ 				Case 1 To 70
;~ 					Send("9")	;self heal
;~ 					Sleep(500)
;~ 			EndSwitch
			Switch $X[$SE][2]
				Case 'buf'
					$S[$PP] = 2
					Send("3")	;��� ������
					halt($SE, 10000)
				Case 'heal_PS'
					$S[$SE] = 2
					Send("2")	;������ �������� + ��� + ������ ����
					halt($SE, 10000)
				Case 'res_PS'
					$S[$SE] = 3
					Send("0")	;������ ���
					halt($SE, 10000)
			EndSwitch
		Case 2	;�����
			$S[$SE] = 0		;������ �� ����� �� �����
			$X[$SE][2] = 0	;��������� �������, ����� �� ��������� � �����
		Case 3	;�������
			WinActivate($X[$PS][0])
			WinWaitActive($X[$PS][0])
			Sleep(500)
			MouseClick("left",400, 400)
			$S[$SE] = 0		;������ �� ����� �� �����
		Case 4	;����
	EndSwitch
EndFunc

Func A_BD()
	;X[0] - window
	;X[1] - hp
	;X[2] - command
	If TimerDiff($halt[$BD][0]) < $halt[$BD][1] Then
		Return
	EndIf

	If $X[$BD][2] <> 0 Then	;���������� ���� ������ ���� ������ �������
		WinActivate($X[$BD][0])
		WinWaitActive($X[$BD][0])
	EndIf
	$X[$BD][1] = get_my_hp()

	Switch $X[$BD][1]	;������� �� �����
		Case 0
			$S[$BD] = 1	;��������� - �����
		Case 1 To 70
			$S[$BD] = 0 ;��������� - ���
			Send("4")	;������ �����
			Sleep(200)
	EndSwitch

	Switch $X[$BD][2]
		Case 'buf'
			Send("2")
			halt($BD,10000)
			$X[$BD][2] = 0
	EndSwitch
EndFunc

Func A_SVS()
	;X[0] - window
	;X[1] - hp
	;X[2] - command
	If TimerDiff($halt[$SVS][0]) < $halt[$SVS][1] Then
		Return
	EndIf

	If $X[$SVS][2] <> 0 Then	;���������� ���� ������ ���� ������ �������
		WinActivate($X[$SVS][0])
		WinWaitActive($X[$SVS][0])
	EndIf
	$X[$SVS][1] = get_my_hp()

	Switch $X[$SVS][1]	;������� �� �����
		Case 0
			$S[$SVS] = 1	;��������� - �����
		Case 1 To 70
			$S[$SVS] = 0 ;��������� - ���
			Send("4")	;������ �����
			Sleep(200)
	EndSwitch

	Switch $X[$SVS][2]
		Case 'buf'
			Send("2")
			halt($SVS,10000)
			$X[$SVS][2] = 0
	EndSwitch
EndFunc

Func halt($who, $time)
	$halt[$who][0] = TimerInit()
	$halt[$who][1] = $time
EndFunc

Func get_summon_hp()

EndFunc

Func get_mob_hp()

EndFunc

Func get_my_hp()

EndFunc

