#RequireAdmin
Opt('PixelCoordMode',2)
Opt('MouseCoordMode',2)

#Region ���������� ����������
Global $cp_min, $cp_max, $cp_y, $hp_min, $hp_max, $hp_y, $mp_min, $mp_max, $mp_y, $exp_min, $exp_max,$exp_y, $mob_hp_min, $mob_hp_max, $mob_hp_y, $true_hp_color,$true_mp_color,$true_cp_color,$true_exp_color,$true_mob_hp_color
Dim $tmp[2][2]=[[0,0], ['NE','NE']]
Dim $PP, $SE, $NE, $BD, $SVS
Dim $all_windows[5]
$time_stamp = 0
Const $new_session = False
$need_rebuf = True
$need_redance = False
$redance_counter = 0
#EndRegion


If $new_session = True Then
	$PP = login('my_slave1','Nfhrjcfkt121', 'PP')
	$SE = login('my_slave2','Nfhrjcfkt121', 'SE')
	$SVS = login('my_slave3','Nfhrjcfkt121', 'SVS')
	$BD = login('my_slave4','Nfhrjcfkt121', 'BD')
	$NE = login('NoobsEnslaver','Nfhrjcfkt121', 'NE')
	Sleep(5000)
Else
	MsgBox(0,'����� ����','����� ������� �� � ��� ����� 3 �������, ����� ������� ���� PP')
	Sleep(3000)
	$PP = WinGetHandle("[ACTIVE]");
	MsgBox(0,'����� ����','����� ������� �� � ��� ����� 3 �������, ����� ������� ���� SE')
	Sleep(3000)
	$SE = WinGetHandle("[ACTIVE]");
	MsgBox(0,'����� ����','����� ������� �� � ��� ����� 3 �������, ����� ������� ���� SVS')
	Sleep(3000)
	$SVS = WinGetHandle("[ACTIVE]");
	MsgBox(0,'����� ����','����� ������� �� � ��� ����� 3 �������, ����� ������� ���� BD')
	Sleep(3000)
	$BD = WinGetHandle("[ACTIVE]");
	MsgBox(0,'����� ����','����� ������� �� � ��� ����� 3 �������, ����� ������� ���� NE')
	Sleep(3000)
	$NE = WinGetHandle("[ACTIVE]");
EndIf
$all_windows[0] = $PP
$all_windows[1] = $SE
$all_windows[2] = $SVS
$all_windows[3] = $BD
$all_windows[4] = $NE

$time_stamp = TimerInit()
While True
	MsgBox(0,"����","������������ � ������, ��������� ���� �� ������ � ������� ��")

	initialize($BD)	;������������� �� ���� BD
	WinSetState($PP,'',@SW_MINIMIZE)
	WinSetState($SE,'',@SW_MINIMIZE)
	WinSetState($NE,'',@SW_MINIMIZE)
	WinActivate($BD)
	Sleep(1000)


	;�������� ����
	While True
		;�������� ������� ������/�������
		If (TimerDiff($time_stamp)/60000) >= 2 Then
			$need_redance = True
			$time_stamp = TimerInit()
			$redance_counter = (($redance_counter = 10 )? 0 : $redance_counter + 1)
			$need_rebuf = $redance_counter = 9 ? True : $need_rebuf
		EndIf

		;��������� ����
		If attack_nearest($SVS) = False Then	;���� �� � ���
		Switch $tmp[0][1]				;����� � ���������� �����
				Case 'PP'
					Send("{F10}")
					$tmp[0][1] = 'NE'

				Case 'NE'
					Send("{F12}")
					$tmp[0][1] = 'PP'

		EndSwitch
		EndIf

		;��������� ��
		If attack_nearest($BD) = False Then	;���� �� � ���
			Switch $tmp[1][1]				;����� � ���������� �����
				Case 'PP'
					Send("{F10}")
					$tmp[1][1] = 'NE'

				Case 'NE'
					Send("{F12}")
					$tmp[1][1] = 'PP'

			EndSwitch
		EndIf


		;���������� �����
		If $need_rebuf = True  Then ;��������� ����� �� - NE, ������ ������ - PP
			;�������� ���� ��������
			Sleep(2000)
			;���� �� ��� - ������ �� ����� ��
			While attack_nearest($SVS) AND attack_nearest($BD);���� ���� ���� ��������
				Sleep(3000)
			WEnd
		WinActivate($SVS)	;�������� ���� � ��
		Sleep(2000)
		Send("{F10}")
		WinActivate($BD)
		Sleep(2000)
		Send("{F10}")

		WinActivate($PP)
		Sleep(2000)
		Send("{F10}")				;���� ���
		Sleep(10000)
		Send("{F1}")				;��� ��� ����

		WinActivate($SE)
		Sleep(2000)
		Send("{F1}")				;��� ��� ����

		WinActivate($BD)
		Sleep(1000)
		Send("{F5}")				;������� �������� �����
		Sleep(500)
		For $i=0 To 10				;���� ��� �� ������
			attack_nearest($BD)		;�� �������� ��
		Next


		WinActivate($PP)
		Sleep(2000)
		Send("{F2}")				;��� ��� ��

		WinActivate($SE)
		Sleep(2000)
		Send("{F2}")				;��� ��� ��

		WinActivate($SVS)
		Sleep(1000)
		Send("{F5}")				;������� �������� �����
		Sleep(500)
		For $i=0 To 10				;���� �� �� ������
			attack_nearest($SVS)		;��� �������� ��
		Next

		WinActivate($PP)
		Sleep(2000)
		Send("{F3}")				;��������� ����-�����

		$need_rebuf = False
		EndIf
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
		Return get_stat('MOB_HP', $BD) > 0 ? True : False	;"� � ���?"
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


		;���� ������� ������� MOB_HP
		$coord = PixelSearch ( 0, $exp_y+5, 25, $exp_y+50, 0xD61841, 5, 1, $window )
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

		MsgBox(0,'','������������ ������ �������'& @LF & 'x_min = '& $hp_min & @LF &'x_max = ' & $hp_max & @LF & '$mob_hp_min = '& $mob_hp_min & @LF &'$mob_hp_max = ' & $mob_hp_max & @LF & 'cp_y = ' & $cp_y & @LF &'hp_y = ' & $hp_y & @LF &'mp_y = ' & $mp_y & @LF &'exp_y = ' & $exp_y & @LF & 'mob_hp_y = ' & $mob_hp_y & @LF)
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
		Case Else
			MsgBox(0,"������","��������� � ����� Else, ������� get_stat")
	EndSwitch

	$current = $min
	While PixelGetColor ( $current , $y , $window ) = $true_color
		$current += 5
		If $current > $max Then
			MsgBox(0,"������", "��������"&$stat& "����� ������ ������������� (������� get_stat)")
			Exit
		EndIf
	WEnd

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



#Region �� ��� �������

#EndRegion