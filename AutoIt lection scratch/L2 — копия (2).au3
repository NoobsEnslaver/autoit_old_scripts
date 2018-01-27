#RequireAdmin
Opt('PixelCoordMode',2)
Opt('MouseCoordMode',2)

#Region Объявление переменных
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
	MsgBox(0,'Выбор окна','После нажатия ОК у вас будет 3 секунды, чтобы выбрать окно PP')
	Sleep(3000)
	$PP = WinGetHandle("[ACTIVE]");
	MsgBox(0,'Выбор окна','После нажатия ОК у вас будет 3 секунды, чтобы выбрать окно SE')
	Sleep(3000)
	$SE = WinGetHandle("[ACTIVE]");
	MsgBox(0,'Выбор окна','После нажатия ОК у вас будет 3 секунды, чтобы выбрать окно SVS')
	Sleep(3000)
	$SVS = WinGetHandle("[ACTIVE]");
	MsgBox(0,'Выбор окна','После нажатия ОК у вас будет 3 секунды, чтобы выбрать окно BD')
	Sleep(3000)
	$BD = WinGetHandle("[ACTIVE]");
	MsgBox(0,'Выбор окна','После нажатия ОК у вас будет 3 секунды, чтобы выбрать окно NE')
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
	MsgBox(0,"Ждем","Объединитесь в группу, раставьте всех по местам и нажмите ОК")

	initialize($BD)	;инициализация по окну BD
	WinSetState($PP,'',@SW_MINIMIZE)
	WinSetState($SE,'',@SW_MINIMIZE)
	WinSetState($NE,'',@SW_MINIMIZE)
	WinActivate($BD)
	Sleep(1000)


	;Основной цикл
	While True
		;Контроль времени ребафа/реденса
		If (TimerDiff($time_stamp)/60000) >= 2 Then
			$need_redance = True
			$time_stamp = TimerInit()
			$redance_counter = (($redance_counter = 10 )? 0 : $redance_counter + 1)
			$need_rebuf = $redance_counter = 9 ? True : $need_rebuf
		EndIf

		;Контролим СВСа
		If attack_nearest($SVS) = False Then	;Если не в бою
		Switch $tmp[0][1]				;Бежим к следующему якорю
				Case 'PP'
					Send("{F10}")
					$tmp[0][1] = 'NE'

				Case 'NE'
					Send("{F12}")
					$tmp[0][1] = 'PP'

		EndSwitch
		EndIf

		;Контролим БД
		If attack_nearest($BD) = False Then	;Если не в бою
			Switch $tmp[1][1]				;Бежим к следующему якорю
				Case 'PP'
					Send("{F10}")
					$tmp[1][1] = 'NE'

				Case 'NE'
					Send("{F12}")
					$tmp[1][1] = 'PP'

			EndSwitch
		EndIf


		;Организуем ребаф
		If $need_rebuf = True  Then ;следующая точка БД - NE, значит чейчас - PP
			;Дождемся пока подойдет
			Sleep(2000)
			;Если мы тут - значит БД около ПП
			While attack_nearest($SVS) AND attack_nearest($BD);ждем пока мобы кончатся
				Sleep(3000)
			WEnd
		WinActivate($SVS)	;собираем всех у ПП
		Sleep(2000)
		Send("{F10}")
		WinActivate($BD)
		Sleep(2000)
		Send("{F10}")

		WinActivate($PP)
		Sleep(2000)
		Send("{F10}")				;Селф баф
		Sleep(10000)
		Send("{F1}")				;Баф для СВСа

		WinActivate($SE)
		Sleep(2000)
		Send("{F1}")				;Баф для СВСа

		WinActivate($BD)
		Sleep(1000)
		Send("{F5}")				;Бутылка скорости атаки
		Sleep(500)
		For $i=0 To 10				;Пока СВС на ребафе
			attack_nearest($BD)		;БД защищает их
		Next


		WinActivate($PP)
		Sleep(2000)
		Send("{F2}")				;Баф для БД

		WinActivate($SE)
		Sleep(2000)
		Send("{F2}")				;Баф для БД

		WinActivate($SVS)
		Sleep(1000)
		Send("{F5}")				;Бутылка скорости атаки
		Sleep(500)
		For $i=0 To 10				;Пока БД на ребафе
			attack_nearest($SVS)		;СВС защищает их
		Next

		WinActivate($PP)
		Sleep(2000)
		Send("{F3}")				;Несколько груп-хилов

		$need_rebuf = False
		EndIf
	WEnd




WEnd

Func attack_nearest($window)
	WinActivate($window)
	Sleep(2000)

	Switch get_stat('HP', $window)
		Case 0
			;Мёртв. Нужен рес
			;For $win In $all_windows
			;	WinClose($win)
			;Next
			MsgBox(0,""," т.к. кто-то сдох")
			;Exit

		Case 1 To 30
			Send("{F7}")					;втыкаем ульт
			Sleep(500)
			Send("{F6}")					;едим супер хилку
		Case 30 To 70
			Send("{F4}")					;едим хилку
	EndSwitch

	If get_stat('MOB_HP', $window) > 0 Then	;если есть живой моб на прицеле
		Send("{F1}")						;attack
		Return True							;возвращаем "я в бою"
	Else									;иначе
		Send("{F3}")						;target_next
		Sleep(1500)
		Send("{F1}")						;attack
		Return get_stat('MOB_HP', $BD) > 0 ? True : False	;"я в бою?"
	EndIf
EndFunc


Func initialize($window)
	;Производит поиск строк CP, HP, MP, EXP, MOB_HP и заносит их координаты в соответствующие переменные.
	;Нужно вызывать перед вызовом get_stat. В параметр $window сообщается hwnd любого окна (предпологается, что окна будут иметь одинаковое расположение интерфейса)
	;Обычные значения параметров:
		;Цвет CP - 0x9F682C, pos: 16, 29
		;Цвет HP - 0xD60831, pos: 16, 41
		;Цвет MP - 0x0071CE, pos: 16, 55
		;Цвет EXP -0xA596BD, pos: 16, 69
		;Цвет MOB_HP - 0xD61841 , pos: 16, 112

		$coord = PixelSearch ( 0, 0, 50, 50, 0x9F682C, 5, 1, $window ) 			;ищем позицию полоски CP (CP должно быть полным)
		If @error = 1 Then
			MsgBox(0,"Ошибка", "Не удалось определить координаты полоски CP")
			Exit
		EndIf
		$hp_min = $coord[0]						;левая граница у всех одинаковая
		$mp_min = $coord[0]
		$exp_min = $coord[0]
		$cp_min = $coord[0]
		$cp_y = $coord[1]


		$true_cp_color = PixelGetColor($cp_min, $cp_y, $window)
		$cp_max = $cp_min
		While PixelGetColor ( $cp_max , $cp_y , $window ) = $true_cp_color
			$cp_max += 2
			If $cp_max > $cp_min + 500 Then
				MsgBox(0,"Ошибка","Ошибка поиска cp_max")
				Exit
			EndIf
		WEnd
		$hp_max = $cp_max								;правая граница у всех одинаковая
		$mp_max = $cp_max
		$exp_max = $cp_max


		;ищем позицию полоски HP
		$coord = PixelSearch ( $hp_min-1,  $cp_y+5, $hp_min+1, $cp_y+100, 0xD60831, 5, 1, $window )
		If @error = 1 Then
			MsgBox(0,"Ошибка", "Не удалось определить координаты полоски HP")
			Exit
		EndIf
		$hp_y = $coord[1]
		$true_hp_color = PixelGetColor($hp_min, $hp_y, $window)


		;ищем позицию полоски MP
		$coord = PixelSearch ( $mp_min,  $hp_y+5, $mp_min, $hp_y+100,0x0071CE, 5, 1, $window )
		If @error = 1 Then
			MsgBox(0,"Ошибка", "Не удалось определить координаты полоски MP")
			Exit
		EndIf
		$mp_y = $coord[1]
		$true_mp_color = PixelGetColor($mp_min, $mp_y, $window)


		;ищем позицию полоски EXP
		$coord = PixelSearch ( $exp_min,  $mp_y+5, $exp_min, $mp_y+100, 0xA596BD, 5, 1, $window )
		If @error = 1 Then
			MsgBox(0,"Ошибка", "Не удалось определить координаты полоски EXP")
			Exit
		EndIf
		$exp_y = $coord[1]
		$true_exp_color = PixelGetColor($exp_min, $exp_y, $window)


		;ищем позицию полоски MOB_HP
		$coord = PixelSearch ( 0, $exp_y+5, 25, $exp_y+50, 0xD61841, 5, 1, $window )
		If @error = 1 Then
			MsgBox(0,"Ошибка", "Не удалось определить координаты полоски MOB_HP")
			Exit
		EndIf
		$mob_hp_min = $coord[0]
		$mob_hp_y = $coord[1]
		$true_mob_hp_color = PixelGetColor($mob_hp_min, $mob_hp_y, $window)
		$mob_hp_max= $mob_hp_min
		While PixelGetColor($mob_hp_max, $mob_hp_y, $window) = $true_mob_hp_color
			$mob_hp_max += 2
			If $mob_hp_max > $mob_hp_min + 500 Then
				MsgBox(0,"Ошибка","Ошибка поиска mob_hp_max")
				Exit
			EndIf
		WEnd

		;Дебаг
		;ConsoleWrite('x_min = '& $hp_min & @LF &'x_max = ' & $hp_max & @LF)
		;ConsoleWrite('$mob_hp_min = '& $mob_hp_min & @LF &'$mob_hp_max = ' & $mob_hp_max & @LF)
		;ConsoleWrite('cp_y = ' & $cp_y & @LF &'hp_y = ' & $hp_y & @LF &'mp_y = ' & $mp_y & @LF &'exp_y = ' & $exp_y & @LF & 'mob_hp_y = ' & $mob_hp_y & @LF)

		MsgBox(0,'','Инициализаци прошла успешно'& @LF & 'x_min = '& $hp_min & @LF &'x_max = ' & $hp_max & @LF & '$mob_hp_min = '& $mob_hp_min & @LF &'$mob_hp_max = ' & $mob_hp_max & @LF & 'cp_y = ' & $cp_y & @LF &'hp_y = ' & $hp_y & @LF &'mp_y = ' & $mp_y & @LF &'exp_y = ' & $exp_y & @LF & 'mob_hp_y = ' & $mob_hp_y & @LF)
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
			MsgBox(0,"Ошибка","Попадание в ветку Else, функция get_stat")
	EndSwitch

	$current = $min
	While PixelGetColor ( $current , $y , $window ) = $true_color
		$current += 5
		If $current > $max Then
			MsgBox(0,"Ошибка", "Значение"&$stat& "стало больше максимального (функция get_stat)")
			Exit
		EndIf
	WEnd

	;ConsoleWrite('До: ' & $current & @LF)
	$current = ($current - $min)*100.0/($max - $min)	;переводим в проценты
	;ConsoleWrite('После: ' & $current & @LF)
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



#Region Не мои функции

#EndRegion