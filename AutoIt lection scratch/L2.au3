#RequireAdmin
Opt('PixelCoordMode',2)
Opt('MouseCoordMode',2)

#Region ���������� ����������
Global $cp_min, $cp_max, $cp_y, $hp_min, $hp_max, $hp_y, $mp_min, $mp_max, $mp_y, $exp_min, $exp_max,$exp_y, $mob_hp_min, $mob_hp_max, $mob_hp_y, $true_hp_color,$true_mp_color,$true_cp_color,$true_exp_color,$true_mob_hp_color, $summon_hp_min, $summon_hp_max, $summon_hp_y, $true_summon_hp_color
Dim $tmp[2][2]=[[0,0], ['NE','NE']]
Const $new_session = False

Global $X[8][10]
Global $Y[8][5]
Global $S[8] = [1,0,0,0,0,0,0]
Global $halt[8][2] = [[TimerInit(),0],[TimerInit(),0],[TimerInit(),0],[TimerInit(),0],[TimerInit(),0],[TimerInit(),0],[TimerInit(),0],[TimerInit(),0]]
Enum $Summon=0, $PS, $PP, $SE, $BD, $SVS, $Warc

#EndRegion


If $new_session = True Then
	$X[$PP][0] = login('my_slave1','Nfhrjcfkt121', 'PP')
	;$X[$SE][0] = login('my_slave2','Nfhrjcfkt121', 'SE')
	$X[$SVS][0] = login('my_slave3','Nfhrjcfkt121', 'SVS')
	$X[$BD][0] = login('my_slave4','Nfhrjcfkt121', 'BD')
	$X[$PS][0] = login('NoobsEnslaver','Nfhrjcfkt121', 'NE')
	$X[$Warc][0] = login('my_slave5','Nfhrjcfkt121', 'Warc')
	Sleep(5000)
Else
	MsgBox(0,'����� ����','����� ������� �� � ��� ����� 3 �������, ����� ������� ���� PP')
	Sleep(3000)
	$X[$PP][0] = WinGetHandle("[ACTIVE]");
;~ 	MsgBox(0,'����� ����','����� ������� �� � ��� ����� 3 �������, ����� ������� ���� SE')
;~ 	Sleep(3000)
;~ 	$X[$SE][0] = WinGetHandle("[ACTIVE]");
	MsgBox(0,'����� ����','����� ������� �� � ��� ����� 3 �������, ����� ������� ���� Warc')
	Sleep(3000)
	$X[$Warc][0] = WinGetHandle("[ACTIVE]");
	MsgBox(0,'����� ����','����� ������� �� � ��� ����� 3 �������, ����� ������� ���� SVS')
	Sleep(3000)
	$X[$SVS][0] = WinGetHandle("[ACTIVE]");
	MsgBox(0,'����� ����','����� ������� �� � ��� ����� 3 �������, ����� ������� ���� BD')
	Sleep(3000)
	$X[$BD][0] = WinGetHandle("[ACTIVE]");
	MsgBox(0,'����� ����','����� ������� �� � ��� ����� 3 �������, ����� ������� ���� NE')
	Sleep(3000)
	$X[$PS][0] = WinGetHandle("[ACTIVE]");
EndIf



While True
	MsgBox(0,"����","������������ � ������, ��������� ���� �� ������ � ������� ��")

	initialize($X[$PS][0])	;������������� �� ���� PS
	WinSetState($X[$PP][0],'',@SW_MINIMIZE)
	WinSetState($X[$Warc][0],'',@SW_MINIMIZE)
	Sleep(1000)
	$X[$Summon][0] = $X[$PS][0]
	$X[$PS][3] = True
	$X[$PS][5] = True
	$X[$Summon][3] = TimerInit()
	;�������� ����
	While True
		A_Summon()
		Sleep(200)
		A_PS()
		Sleep(200)
		A_PP()
		Sleep(200)
		A_Warc()
		Sleep(200)
		;A_SE()
		A_BD()
		Sleep(200)
		A_SVS()
		Sleep(200)
	WEnd
WEnd

Func attack_nearest($window)
	WinActivate($window)
	Sleep(2000)

	Switch get_stat('HP', $window)
		Case 0
			;̸���. ����� ���
			;For $win In $all_windows
			;	WinClose($win)
			;Next
			MsgBox(0,""," �.�. ���-�� ����")
			;Exit

		Case 1 To 30
			Send("{F7}")					;������� ����
			Sleep(500)
			Send("{F6}")					;���� ����� �����
		Case 30 To 70
			Send("{F4}")					;���� �����
	EndSwitch

	If get_stat('MOB_HP', $window) > 0 Then	;���� ���� ����� ��� �� �������
		Send("{F1}")						;attack
		Return True							;���������� "� � ���"
	Else									;�����
		Send("{F3}")						;target_next
		Sleep(1500)
		Send("{F1}")						;attack
		Return get_stat('MOB_HP', $window) > 0 ? True : False	;"� � ���?"
	EndIf
EndFunc


Func initialize($window)
	;���������� ����� ����� CP, HP, MP, EXP, MOB_HP � ������� �� ���������� � ��������������� ����������.
	;����� �������� ����� ������� get_stat. � �������� $window ���������� hwnd ������ ���� (��������������, ��� ���� ����� ����� ���������� ������������ ����������)
	;������� �������� ����������:
		;���� CP - 0x9F682C, pos: 16, 29
		;���� HP - 0xD60831, pos: 16, 41
		;���� MP - 0x0071CE, pos: 16, 55
		;���� EXP -0xA596BD, pos: 16, 69
		;���� MOB_HP - 0xD61841 , pos: 16, 112

		$coord = PixelSearch ( 0, 0, 50, 50, 0x9F682C, 5, 1, $window ) 			;���� ������� ������� CP (CP ������ ���� ������)
		If @error = 1 Then
			MsgBox(0,"������", "�� ������� ���������� ���������� ������� CP")
			Exit
		EndIf
		$hp_min = $coord[0]						;����� ������� � ���� ����������
		$mp_min = $coord[0]
		$exp_min = $coord[0]
		$cp_min = $coord[0]
		$cp_y = $coord[1]


		$true_cp_color = PixelGetColor($cp_min, $cp_y, $window)
		$cp_max = $cp_min
		While PixelGetColor ( $cp_max , $cp_y , $window ) = $true_cp_color
			$cp_max += 2
			If $cp_max > $cp_min + 500 Then
				MsgBox(0,"������","������ ������ cp_max")
				Exit
			EndIf
		WEnd
		$hp_max = $cp_max								;������ ������� � ���� ����������
		$mp_max = $cp_max
		$exp_max = $cp_max


		;���� ������� ������� HP
		$coord = PixelSearch ( $hp_min-1,  $cp_y+5, $hp_min+1, $cp_y+100, 0xD60831, 5, 1, $window )
		If @error = 1 Then
			MsgBox(0,"������", "�� ������� ���������� ���������� ������� HP")
			Exit
		EndIf
		$hp_y = $coord[1]
		$true_hp_color = PixelGetColor($hp_min, $hp_y, $window)


		;���� ������� ������� MP
		$coord = PixelSearch ( $mp_min,  $hp_y+5, $mp_min, $hp_y+100,0x0071CE, 5, 1, $window )
		If @error = 1 Then
			MsgBox(0,"������", "�� ������� ���������� ���������� ������� MP")
			Exit
		EndIf
		$mp_y = $coord[1]
		$true_mp_color = PixelGetColor($mp_min, $mp_y, $window)


		;���� ������� ������� EXP
		$coord = PixelSearch ( $exp_min,  $mp_y+5, $exp_min, $mp_y+100, 0xA596BD, 5, 1, $window )
		If @error = 1 Then
			MsgBox(0,"������", "�� ������� ���������� ���������� ������� EXP")
			Exit
		EndIf
		$exp_y = $coord[1]
		$true_exp_color = PixelGetColor($exp_min, $exp_y, $window)


		;���� ������� ������� SUMMON_HP
		$coord = PixelSearch ( 0, $exp_y+5, 25, $exp_y+50, 0xD61841, 5, 1, $window )
		If @error = 1 Then
			MsgBox(0,"������", "�� ������� ���������� ���������� ������� SUMMON_HP")
			Exit
		EndIf
		$summon_hp_min = $coord[0]
		$summon_hp_y = $coord[1]
		$true_summon_hp_color = PixelGetColor($summon_hp_min, $summon_hp_y, $window)
		$summon_hp_max= $summon_hp_min
		While PixelGetColor($summon_hp_max, $summon_hp_y, $window) = $true_summon_hp_color
			$summon_hp_max += 2
			If $summon_hp_max > $summon_hp_min + 500 Then
				MsgBox(0,"������","������ ������ SUMMON_hp_max")
				Exit
			EndIf
		WEnd

		;���� ������� ������� MOB_HP
		$coord = PixelSearch ( 0, $summon_hp_y+30, 25, $summon_hp_y+70, 0xD61841, 5, 1, $window )
		If @error = 1 Then
			MsgBox(0,"������", "�� ������� ���������� ���������� ������� MOB_HP")
			Exit
		EndIf
		$mob_hp_min = $coord[0]
		$mob_hp_y = $coord[1]
		$true_mob_hp_color = PixelGetColor($mob_hp_min, $mob_hp_y, $window)
		$mob_hp_max= $mob_hp_min
		While PixelGetColor($mob_hp_max, $mob_hp_y, $window) = $true_mob_hp_color
			$mob_hp_max += 2
			If $mob_hp_max > $mob_hp_min + 500 Then
				MsgBox(0,"������","������ ������ mob_hp_max")
				Exit
			EndIf
		WEnd

		;�����
		;ConsoleWrite('x_min = '& $hp_min & @LF &'x_max = ' & $hp_max & @LF)
		;ConsoleWrite('$mob_hp_min = '& $mob_hp_min & @LF &'$mob_hp_max = ' & $mob_hp_max & @LF)
		;ConsoleWrite('cp_y = ' & $cp_y & @LF &'hp_y = ' & $hp_y & @LF &'mp_y = ' & $mp_y & @LF &'exp_y = ' & $exp_y & @LF & 'mob_hp_y = ' & $mob_hp_y & @LF)

		MsgBox(0,'','������������ ������ �������'& @LF & 'x_min = '& $hp_min & @LF &'x_max = ' & $hp_max & @LF & '$mob_hp_min = '& $mob_hp_min & @LF &'$mob_hp_max = ' & $mob_hp_max & @LF & '$summon_hp_min = '& $summon_hp_min & @LF &'$summon_hp_max = ' & $summon_hp_max & @LF & 'cp_y = ' & $cp_y & @LF &'hp_y = ' & $hp_y & @LF &'mp_y = ' & $mp_y & @LF &'exp_y = ' & $exp_y & @LF & 'mob_hp_y = ' & $mob_hp_y & @LF)
EndFunc

Func get_stat ($stat, $window)
	;WinActive($window)
	;Sleep(300)
	;WinWaitActive($window)

	Local $y, $min, $max, $current
	$max = $cp_max
	$min = $cp_min
	Switch $stat

		Case 'CP'
			$y = $cp_y
			$true_color = $true_cp_color
		Case 'HP'
			$y = $hp_y
			$true_color = $true_hp_color
		Case 'MP'
			$y = $mp_y
			$true_color = $true_mp_color
		Case 'EXP'
			$y = $exp_y
			$true_color = $true_exp_color
		Case 'MOB_HP'
			$y = $mob_hp_y
			$max = $mob_hp_max
			$min = $mob_hp_min
			$true_color = $true_mob_hp_color
		Case 'SUMMON_HP'
			$y = $summon_hp_y
			$max = $summon_hp_max
			$min = $summon_hp_min
			$true_color = $true_summon_hp_color
		Case Else
			MsgBox(0,"������","��������� � ����� Else, ������� get_stat")
	EndSwitch

	$tmp = PixelSearch( $max, $y, $min, $y+1, $true_color, 5, 1, $window )	;���� � ������� ���� ������ ����������

	$current = (@error = 1) ? $min : $tmp[0]

;~ 	While PixelGetColor ( $current , $y , $window ) = $true_color
;~ 		$current += 5
;~ 		If $current > $max Then
;~ 			MsgBox(0,"������", "��������"&$stat& "����� ������ ������������� (������� get_stat)")
;~ 			Exit
;~ 		EndIf
;~ 	WEnd

	;ConsoleWrite('��: ' & $current & @LF)
	$current = ($current - $min)*100.0/($max - $min)	;��������� � ��������
	;ConsoleWrite('�����: ' & $current & @LF)
	Return $current

EndFunc

Func login($name, $pass, $new_title)
	$varPID = Run("D:\Games\L2C6\system\l2.exe","D:\Games\L2C6")
	Sleep(13000)
	$hwnd = WinGetHandle("[ACTIVE]")
	Send($name)
	Send("{TAB}")
	Sleep(200)
	Send($pass)
	Send("{ENTER}")
	Sleep(2000)
	Send("{ENTER}")
	Sleep(2000)
	Send("{ENTER}")
	Sleep(5000)
	Send("{ENTER}")
	Sleep(2000)
	;WinSetTitle ( $BD, "", $new_title)
	Return $hwnd
EndFunc



#Region ��������

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
	If Not WinActive($X[$Summon][0]) Then
		WinActivate($X[$Summon][0])
		WinWaitActive($X[$Summon][0])
		Sleep(2000)
	EndIf

	$X[$Summon][1] = get_stat ('SUMMON_HP', $X[$Summon][0])
	$Y[$Summon][0] = $X[$Summon][1]
	$Y[$Summon][1] = TimerDiff($X[$Summon][3])/60000
	$S[$Summon] = ($X[$Summon][1] = 0)? 0 : $S[$Summon]
	$X[$Summon][4] = get_stat ('MOB_HP', $X[$Summon][0])

	Switch $S[$Summon]
		;������� ���
		Case 0
			MsgBox(0,"","������ � ���������� '��� ������' � Shadow")
			If $X[$Summon][1] > 0 Then	;���� �� ���������, ����� ������ ��������
				$S[$Summon] = 1
				$X[$Summon][3] = TimerInit()
			Else
				halt($Summon, 5000)		;����� �������� ������� �� 5 ���.
			EndIf

		;��������
		Case 1
			Switch $X[$Summon][2]
				Case 'attack'
					$S[$Summon] = 2
					Send("{F1}")
					Sleep(300)
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
					Send("{F3}")					;���
					MsgBox(0,'','���� ������ � �� ��� �.�. ��� �� = ' & $X[$Summon][1])
			EndSwitch

		;� ���
			If $X[$Summon][4] = 0 Then		;���� ��� ��� ��� �� ���� - � ��������
				$S[$Summon] = 1
				$X[$Summon][2] = 'stop'		;������ ������� ����, ����� �� �������� "�����" �� �����
			EndIf

			Switch $X[$Summon][2]
				Case 'attack'
					$S[$Summon] = 2
					Send("{F1}")
					;$X[$Summon][2] = 0
				Case 'stop'
					$S[$Summon] = 1
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
					Send(Random(0,2)>1?"{F3}":"{F4}")	;��� ��� ����
					MsgBox(0,'','��������� ���� ������ � �� ��� �.�. ��� �� = ' & $X[$Summon][1])
				Case 30 To 80
					Send("{F3}")					;���
					MsgBox(0,'','���� ������ � ��� �.�. ��� �� = ' & $X[$Summon][1])
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
	If Not WinActive($X[$PS][0]) Then
		WinActivate($X[$PS][0])
		WinWaitActive($X[$PS][0])
		Sleep(2000)
	EndIf


	Sleep(500)
	$X[$PS][1] = get_stat ('HP', $X[$PS][0])
	$X[$PS][2] = $X[$Summon][4]
	If $S[$Summon] = 0 Then								;���� ��� ������ - ��������� ���.
		MsgBox(0,"","������ � ���������� '��� ������' � ��")
		Send("{F10}")
		$X[$PS][3] = True
		$X[$PS][5] = True
		halt($PS,5000)
	Else												;���� �� ����  - �������� � ���
		If $Y[$Summon][1] > 45 And $S[$Summon] = 1 Then	;���� ������ ��� 40 ��� � �� �� � ���
			$X[$Summon][2] = 'unsummon'					;���������� ��� ��������� "����������"
		Else
			If $X[$PS][2] = 0 Then							;���� �� ���� = 0
				Send("{F6}")									;target next
				Sleep(200)
			Else
				$X[$Summon][2] = 'attack'					;������� ������ - �����.
			EndIf

			If ($S[$Summon] > 0) AND ($X[$PS][3] = True) Then	;���� ����� ��� � ����� ����� - �������� ������� �������
				$X[$PS][3] = False
				$X[$PP][2] = 'buf'
				$X[$Warc][2] = 'buf'
				Send("{F9}")									;�������� ����� �����
				halt($PS,3000)
				$X[$PS][4] = TimerInit()
			EndIf

			If TimerDiff($X[$PS][4]) > 18*60*1000 Then					;���� � �������� ������ ������ 18 ����� - ����� �����
				$X[$PS][3] = True
				MsgBox(0,'','������ ����� ������ �.�. TimerDiff($X[$PS][4])=' & TimerDiff($X[$PS][4]))

			EndIf

			If ($S[$Summon] > 0) AND ($X[$PS][5] = True) Then	;����, �� ��� ����� � �����
				$X[$PS][5] = False
				$X[$BD][2] = 'buf'
				$X[$SVS][2] = 'buf'
				$X[$PS][6] = TimerInit()
			EndIf

			If TimerDiff($X[$PS][6]) > 2*60*1000 Then					;����
				$X[$PS][5] = True
				MsgBox(0,'','������ ����� ������� �.�. TimerDiff($X[$PS][6])=' & TimerDiff($X[$PS][6]))
			EndIf
		EndIf
	EndIf

	Switch $X[$PS][1]		;������ �� �� ����
		Case 0
			If $S[$PP] = 0 Then			;���� �� � ��������� ��������
				$X[$PP][1] = 'res_PS'	;�� - ����� ���
			EndIf
			MsgBox(0,'','� ����������� ����� ���')
		Case 1 To 50
			If $S[$PP] = 0 Then			;���� �� � ��������� ��������
				$X[$PP][1] = 'heal_PS'	;�� - ��� ���
			ElseIf $S[$Warc] = 0 Then
				$X[$Warc][1] = 'heal'	;���� - ��� ���
			EndIf
			Send("{F5}")					;������ �����
			MsgBox(0,'','� ����������� ����������� ����������� ��� ����������')
		Case 50 To 80
			Send("{F5}")					;������ �����
			MsgBox(0,'','� ����������� ������� ����� ����')
	EndSwitch

EndFunc

Func A_PP()
	;X[0] - window
	;X[1] - hp
	;X[2] - command
	If TimerDiff($halt[$PP][0]) < $halt[$PP][1] Then
		Return
	EndIf

	If Not $X[$PP][2] = 0 And $S[$PP] <> 2 Then	;���������� ���� ������ ���� ������ �������
		WinActivate($X[$PP][0])
		WinWaitActive($X[$PP][0])
		Sleep(2000)
	Else
		halt($PP, 2000)
		Return
	EndIf
	MsgBox(0,"","� �������� ��")
	;$X[$PP][1] = get_my_hp()
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
					Send("{F1}")	;���� ��� + ��� ��������
					halt($PP, 20000)
				Case 'heal_PS'
					$S[$PP] = 2
					Send("{F3}")	;������ �������� + ���� ��� + ������ ����
					halt($PP, 4000)
				Case 'res_PS'
					$S[$PP] = 3
					Send("{F10}")	;������ ���
					halt($PP, 10000)
				Case Else
					MsgBox(0,"������","��������� � ����� Else � ����������� ������ ��")
			EndSwitch
			;$X[$PP][2] = 0
		Case 1	;������� ������ ����� ����
			$S[$PP] = 5
			Send("{F2}")	;������ ����� ���� (�����)
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
			$X[$PP][2] = 0
		Case 4	;����
			$X[$PP][2] = 0	;� ������ �� ����� ����� �� �����:) � ������ - ����� �� ������������� ����.
		Case 5	;������ ����� ����, �� ������ ��� ��� ������
			$S[$PP] = 2
			Send("{F4}")	;������ ����� ���� (�����)
			halt($PP, 25000)
		Case Else
			MsgBox(0,"������","��������� � ����� Else � ����������� ��������� ��")
			$X[$PP][2] = 0
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
	;$X[$SE][1] = get_my_hp()

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
					$S[$SE] = 2
					Send("{F3}")	;��� ������
					halt($SE, 10000)
				Case 'heal_PS'
					$S[$SE] = 2
					Send("{F2}")	;������ �������� + ��� + ������ ����
					halt($SE, 10000)
				Case 'res_PS'
					$S[$SE] = 3
					Send("{F10}")	;������ ���
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

	If Not $X[$BD][2] = 0 Then	;���������� ���� ������ ���� ������ �������
		WinActivate($X[$BD][0])
		WinWaitActive($X[$BD][0])
		Sleep(2000)
	Else
		halt($BD, 2000)
		Return
	EndIf
	MsgBox(0,"","� �������� �� �.�. $X[$BD][2] = " & $X[$BD][2])
;~ 	$X[$BD][1] = get_stat ('HP', $X[$BD][0])

;~ 	Switch $X[$BD][1]	;������� �� ����� (���� �� �������� �.�. ��� ����� ����� ������ ��� ������������ ����)
;~ 		Case 0
;~ 			$S[$BD] = 1	;��������� - �����
;~ 		Case 1 To 70
;~ 			$S[$BD] = 0 ;��������� - ���
;~ 			Send("4")	;������ �����
;~ 			Sleep(200)
;~ 	EndSwitch

	Switch $X[$BD][2]
		Case 'buf'
			Send("2")
			halt($BD,10000)
			$X[$BD][2] = 0
			MsgBox(0,"","������ ������")
	EndSwitch
EndFunc

Func A_SVS()
	;X[0] - window
	;X[1] - hp
	;X[2] - command
	If TimerDiff($halt[$SVS][0]) < $halt[$SVS][1] Then
		Return
	EndIf

	If Not $X[$SVS][2] = 0 Then	;���������� ���� ������ ���� ������ �������
		WinActivate($X[$SVS][0])
		WinWaitActive($X[$SVS][0])
		Sleep(2000)
	Else
		halt($SVS, 2000)
		Return
	EndIf
	MsgBox(0,"","� �������� ���� �.�. $X[$SVS][2] = " & $X[$SVS][2])
;~ 	$X[$SVS][1] = get_stat ('HP', $X[$SVS][0])
;~ 	Switch $X[$SVS][1]	;������� �� �����
;~ 		Case 0
;~ 			$S[$SVS] = 1	;��������� - �����
;~ 		Case 1 To 70
;~ 			$S[$SVS] = 0 ;��������� - ���
;~ 			Send("{F4}")	;������ �����
;~ 			Sleep(200)
;~ 	EndSwitch

	Switch $X[$SVS][2]
		Case 'buf'
			Send("{F2}")
			halt($SVS,10000)
			$X[$SVS][2] = 0
			MsgBox(0,"","������ ������")
		Case Else

	EndSwitch
EndFunc

Func halt($who, $time)
	$halt[$who][0] = TimerInit()
	$halt[$who][1] = $time
EndFunc

Func A_Warc()
	;X[0] - window
	;X[1] - hp
	;X[2] - command
	If TimerDiff($halt[$Warc][0]) < $halt[$Warc][1] Then
		Return
	EndIf

	If Not $X[$Warc][2] = 0 Then	;���������� ���� ������ ���� ������ �������
		WinActivate($X[$Warc][0])
		WinWaitActive($X[$Warc][0])
		Sleep(2000)
	Else
		halt($Warc, 2000)
		Return
	EndIf
	MsgBox(0,"","� �������� �����")
	;$X[$Warc][1] = get_my_hp()

	Switch $S[$Warc]
		Case 0	;����
			Switch $X[$Warc][2]
				Case 'buf'
					$S[$Warc] = 1
					Send("{F3}")	;���
					halt($Warc, 20000)
					$X[$Warc][2] = 0	;��������� �������, ����� �� ��������� � �����
				Case 'heal'
					$S[$Warc] = 1
					Send("{F2}")	;���
					halt($Warc, 10000)
					$X[$Warc][2] = 0	;��������� �������, ����� �� ��������� � �����
				Case Else

			EndSwitch
		Case 1	;�����
			$S[$Warc] = 0		;������ �� ����� �� �����

		Case 3	;����
	EndSwitch
EndFunc

#EndRegion