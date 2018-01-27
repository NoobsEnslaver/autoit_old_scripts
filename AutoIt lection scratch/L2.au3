#RequireAdmin
Opt('PixelCoordMode',2)
Opt('MouseCoordMode',2)

#Region Объявление переменных
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
	MsgBox(0,'Выбор окна','После нажатия ОК у вас будет 3 секунды, чтобы выбрать окно PP')
	Sleep(3000)
	$X[$PP][0] = WinGetHandle("[ACTIVE]");
;~ 	MsgBox(0,'Выбор окна','После нажатия ОК у вас будет 3 секунды, чтобы выбрать окно SE')
;~ 	Sleep(3000)
;~ 	$X[$SE][0] = WinGetHandle("[ACTIVE]");
	MsgBox(0,'Выбор окна','После нажатия ОК у вас будет 3 секунды, чтобы выбрать окно Warc')
	Sleep(3000)
	$X[$Warc][0] = WinGetHandle("[ACTIVE]");
	MsgBox(0,'Выбор окна','После нажатия ОК у вас будет 3 секунды, чтобы выбрать окно SVS')
	Sleep(3000)
	$X[$SVS][0] = WinGetHandle("[ACTIVE]");
	MsgBox(0,'Выбор окна','После нажатия ОК у вас будет 3 секунды, чтобы выбрать окно BD')
	Sleep(3000)
	$X[$BD][0] = WinGetHandle("[ACTIVE]");
	MsgBox(0,'Выбор окна','После нажатия ОК у вас будет 3 секунды, чтобы выбрать окно NE')
	Sleep(3000)
	$X[$PS][0] = WinGetHandle("[ACTIVE]");
EndIf



While True
	MsgBox(0,"Ждем","Объединитесь в группу, раставьте всех по местам и нажмите ОК")

	initialize($X[$PS][0])	;инициализация по окну PS
	WinSetState($X[$PP][0],'',@SW_MINIMIZE)
	WinSetState($X[$Warc][0],'',@SW_MINIMIZE)
	Sleep(1000)
	$X[$Summon][0] = $X[$PS][0]
	$X[$PS][3] = True
	$X[$PS][5] = True
	$X[$Summon][3] = TimerInit()
	;Основной цикл
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
		Return get_stat('MOB_HP', $window) > 0 ? True : False	;"я в бою?"
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


		;ищем позицию полоски SUMMON_HP
		$coord = PixelSearch ( 0, $exp_y+5, 25, $exp_y+50, 0xD61841, 5, 1, $window )
		If @error = 1 Then
			MsgBox(0,"Ошибка", "Не удалось определить координаты полоски SUMMON_HP")
			Exit
		EndIf
		$summon_hp_min = $coord[0]
		$summon_hp_y = $coord[1]
		$true_summon_hp_color = PixelGetColor($summon_hp_min, $summon_hp_y, $window)
		$summon_hp_max= $summon_hp_min
		While PixelGetColor($summon_hp_max, $summon_hp_y, $window) = $true_summon_hp_color
			$summon_hp_max += 2
			If $summon_hp_max > $summon_hp_min + 500 Then
				MsgBox(0,"Ошибка","Ошибка поиска SUMMON_hp_max")
				Exit
			EndIf
		WEnd

		;ищем позицию полоски MOB_HP
		$coord = PixelSearch ( 0, $summon_hp_y+30, 25, $summon_hp_y+70, 0xD61841, 5, 1, $window )
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

		MsgBox(0,'','Инициализаци прошла успешно'& @LF & 'x_min = '& $hp_min & @LF &'x_max = ' & $hp_max & @LF & '$mob_hp_min = '& $mob_hp_min & @LF &'$mob_hp_max = ' & $mob_hp_max & @LF & '$summon_hp_min = '& $summon_hp_min & @LF &'$summon_hp_max = ' & $summon_hp_max & @LF & 'cp_y = ' & $cp_y & @LF &'hp_y = ' & $hp_y & @LF &'mp_y = ' & $mp_y & @LF &'exp_y = ' & $exp_y & @LF & 'mob_hp_y = ' & $mob_hp_y & @LF)
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
			MsgBox(0,"Ошибка","Попадание в ветку Else, функция get_stat")
	EndSwitch

	$tmp = PixelSearch( $max, $y, $min, $y+1, $true_color, 5, 1, $window )	;ищем с правого края первое совпадение

	$current = (@error = 1) ? $min : $tmp[0]

;~ 	While PixelGetColor ( $current , $y , $window ) = $true_color
;~ 		$current += 5
;~ 		If $current > $max Then
;~ 			MsgBox(0,"Ошибка", "Значение"&$stat& "стало больше максимального (функция get_stat)")
;~ 			Exit
;~ 		EndIf
;~ 	WEnd

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



#Region Автоматы

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
		;Саммона нет
		Case 0
			MsgBox(0,"","Попали в обработчик 'нет самона' у Shadow")
			If $X[$Summon][1] > 0 Then	;если хп появилось, знаит саммон появился
				$S[$Summon] = 1
				$X[$Summon][3] = TimerInit()
			Else
				halt($Summon, 5000)		;иначе усыпляем автомат на 5 сек.
			EndIf

		;ожидание
		Case 1
			Switch $X[$Summon][2]
				Case 'attack'
					$S[$Summon] = 2
					Send("{F1}")
					Sleep(300)
				Case 'stop'
					$X[$Summon][2] = 0			;сбрасываем команду, чтобы не выполнять ее в след. итерации
					Send("{F2}")
				Case 'unsummon'
					Send("{F12}")
					$S[$Summon] = 0
					$X[$Summon][2] = 0			;сбрасываем команду, чтобы не выполнять ее в след. итерации
			EndSwitch


			Switch $X[$Summon][1]
				Case 0
					$S[$Summon] = 0				;самон мёртв
				Case 1 To 80
					Send("{F3}")					;хил
					MsgBox(0,'','хилю самона в не бою т.к. его хп = ' & $X[$Summon][1])
			EndSwitch

		;в бою
			If $X[$Summon][4] = 0 Then		;если его нет или он мёртв - в ожидание
				$S[$Summon] = 1
				$X[$Summon][2] = 'stop'		;пошлем команду стоп, чтобы не тыкалась "атака" по трупу
			EndIf

			Switch $X[$Summon][2]
				Case 'attack'
					$S[$Summon] = 2
					Send("{F1}")
					;$X[$Summon][2] = 0
				Case 'stop'
					$S[$Summon] = 1
					$X[$Summon][2] = 0			;сбрасываем команду, чтобы не выполнять ее в след. итерации
					Send("{F2}")
				Case 'unsummon'
					Send("{F12}")
					$S[$Summon] = 0
					$X[$Summon][2] = 0			;сбрасываем команду, чтобы не выполнять ее в след. итерации
			EndSwitch

			Switch $X[$Summon][1]
				Case 0
					$S[$Summon] = 0				;самон мёртв
				Case 1 To 30
					Send(Random(0,2)>1?"{F3}":"{F4}")	;хил или ульт
					MsgBox(0,'','Экстренно хилю самона в не бою т.к. его хп = ' & $X[$Summon][1])
				Case 30 To 80
					Send("{F3}")					;хил
					MsgBox(0,'','хилю самона в бою т.к. его хп = ' & $X[$Summon][1])
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
	If $S[$Summon] = 0 Then								;если нет самона - призываем его.
		MsgBox(0,"","Попали в обработчик 'нет самона' у ФС")
		Send("{F10}")
		$X[$PS][3] = True
		$X[$PS][5] = True
		halt($PS,5000)
	Else												;если он есть  - работаем с ним
		If $Y[$Summon][1] > 45 And $S[$Summon] = 1 Then	;если самону уже 40 мин и он не в бою
			$X[$Summon][2] = 'unsummon'					;отправляем ему сообщение "отозваться"
		Else
			If $X[$PS][2] = 0 Then							;если хп моба = 0
				Send("{F6}")									;target next
				Sleep(200)
			Else
				$X[$Summon][2] = 'attack'					;команда самону - атака.
			EndIf

			If ($S[$Summon] > 0) AND ($X[$PS][3] = True) Then	;если самон жив и нужен ребаф - разошлем команды сапорту
				$X[$PS][3] = False
				$X[$PP][2] = 'buf'
				$X[$Warc][2] = 'buf'
				Send("{F9}")									;вызываем новый кубик
				halt($PS,3000)
				$X[$PS][4] = TimerInit()
			EndIf

			If TimerDiff($X[$PS][4]) > 18*60*1000 Then					;если с прошлого ребафа прошло 18 минут - нужен ребаф
				$X[$PS][3] = True
				MsgBox(0,'','пришло время ребафа т.к. TimerDiff($X[$PS][4])=' & TimerDiff($X[$PS][4]))

			EndIf

			If ($S[$Summon] > 0) AND ($X[$PS][5] = True) Then	;тоже, но для сонга и денса
				$X[$PS][5] = False
				$X[$BD][2] = 'buf'
				$X[$SVS][2] = 'buf'
				$X[$PS][6] = TimerInit()
			EndIf

			If TimerDiff($X[$PS][6]) > 2*60*1000 Then					;тоже
				$X[$PS][5] = True
				MsgBox(0,'','пришло время реденса т.к. TimerDiff($X[$PS][6])=' & TimerDiff($X[$PS][6]))
			EndIf
		EndIf
	EndIf

	Switch $X[$PS][1]		;Реакия на ХП чара
		Case 0
			If $S[$PP] = 0 Then			;если ПП в состоянии ожидания
				$X[$PP][1] = 'res_PS'	;пп - ресни плз
			EndIf
			MsgBox(0,'','В обработчике серти ФСа')
		Case 1 To 50
			If $S[$PP] = 0 Then			;если ПП в состоянии ожидания
				$X[$PP][1] = 'heal_PS'	;пп - хил плз
			ElseIf $S[$Warc] = 0 Then
				$X[$Warc][1] = 'heal'	;варк - хил плз
			EndIf
			Send("{F5}")					;съесть хилку
			MsgBox(0,'','В обработчике экстренного выхиливания ФСа саппортами')
		Case 50 To 80
			Send("{F5}")					;съесть хилку
			MsgBox(0,'','В обработчике хаванья хилки ФСом')
	EndSwitch

EndFunc

Func A_PP()
	;X[0] - window
	;X[1] - hp
	;X[2] - command
	If TimerDiff($halt[$PP][0]) < $halt[$PP][1] Then
		Return
	EndIf

	If Not $X[$PP][2] = 0 And $S[$PP] <> 2 Then	;активируем окно только если пришли команды
		WinActivate($X[$PP][0])
		WinWaitActive($X[$PP][0])
		Sleep(2000)
	Else
		halt($PP, 2000)
		Return
	EndIf
	MsgBox(0,"","В автомате ПП")
	;$X[$PP][1] = get_my_hp()
	Switch $S[$PP]
		Case 0	;ждет
;~ 			Switch $X[$PP][1]	;реакция на жизни
;~ 				Case 0
;~ 					$S[$PP] = 4	;состояние - мертв
;~ 				Case 1 To 70
;~ 					Send("9")	;self heal
;~ 					Sleep(500)
;~ 			EndSwitch
			Switch $X[$PP][2]
				Case 'buf'
					$S[$PP] = 1
					Send("{F1}")	;селф баф + баф самонера
					halt($PP, 20000)
				Case 'heal_PS'
					$S[$PP] = 2
					Send("{F3}")	;таргет самонера + батл хил + таргет селф
					halt($PP, 4000)
				Case 'res_PS'
					$S[$PP] = 3
					Send("{F10}")	;ресаем ФСа
					halt($PP, 10000)
				Case Else
					MsgBox(0,"Ошибка","Оказались в ветке Else у дешифратора команд ПП")
			EndSwitch
			;$X[$PP][2] = 0
		Case 1	;законил первую часть бафа
			$S[$PP] = 5
			Send("{F2}")	;вторая часть бафа (самон)
			halt($PP, 25000)
		Case 2	;занят
			$S[$PP] = 0		;теперь он ничем не занят
			$X[$PP][2] = 0	;сбраываем команду, чтоыб не повторять её снова
		Case 3	;реснули
			WinActivate($X[$PS][0])
			WinWaitActive($X[$PS][0])
			Sleep(500)
			MouseClick("left",400, 400)
			$S[$PP] = 0		;теперь он ничем не занят
			$X[$PP][2] = 0
		Case 4	;мёртв
			$X[$PP][2] = 0	;и теперь он точно ничем не занят:) А вообще - чтобы не переключалось окно.
		Case 5	;третья часть бафа, не ожидал что так выйдет
			$S[$PP] = 2
			Send("{F4}")	;третья часть бафа (самон)
			halt($PP, 25000)
		Case Else
			MsgBox(0,"Ошибка","Оказались в ветке Else у дешифратора состояний ПП")
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

	If $X[$SE][2] <> 0 Then	;активируем окно только если пришли команды
		WinActivate($X[$SE][0])
		WinWaitActive($X[$SE][0])
	EndIf
	;$X[$SE][1] = get_my_hp()

	Switch $S[$SE]
		Case 0	;ждет
;~ 			Switch $X[$PP][1]	;реакция на жизни
;~ 				Case 0
;~ 					$S[$PP] = 4	;состояние - мертв
;~ 				Case 1 To 70
;~ 					Send("9")	;self heal
;~ 					Sleep(500)
;~ 			EndSwitch
			Switch $X[$SE][2]
				Case 'buf'
					$S[$SE] = 2
					Send("{F3}")	;баф самона
					halt($SE, 10000)
				Case 'heal_PS'
					$S[$SE] = 2
					Send("{F2}")	;таргет самонера + хил + таргет селф
					halt($SE, 10000)
				Case 'res_PS'
					$S[$SE] = 3
					Send("{F10}")	;ресаем ФСа
					halt($SE, 10000)
			EndSwitch
		Case 2	;занят
			$S[$SE] = 0		;теперь он ничем не занят
			$X[$SE][2] = 0	;сбраываем команду, чтоыб не повторять её снова
		Case 3	;реснули
			WinActivate($X[$PS][0])
			WinWaitActive($X[$PS][0])
			Sleep(500)
			MouseClick("left",400, 400)
			$S[$SE] = 0		;теперь он ничем не занят
		Case 4	;мёртв
	EndSwitch
EndFunc

Func A_BD()
	;X[0] - window
	;X[1] - hp
	;X[2] - command
	If TimerDiff($halt[$BD][0]) < $halt[$BD][1] Then
		Return
	EndIf

	If Not $X[$BD][2] = 0 Then	;активируем окно только если пришли команды
		WinActivate($X[$BD][0])
		WinWaitActive($X[$BD][0])
		Sleep(2000)
	Else
		halt($BD, 2000)
		Return
	EndIf
	MsgBox(0,"","В автомате БД т.к. $X[$BD][2] = " & $X[$BD][2])
;~ 	$X[$BD][1] = get_stat ('HP', $X[$BD][0])

;~ 	Switch $X[$BD][1]	;реакция на жизни (пока не руализую т.к. для этого нужно каждый раз активировать окно)
;~ 		Case 0
;~ 			$S[$BD] = 1	;состояние - мертв
;~ 		Case 1 To 70
;~ 			$S[$BD] = 0 ;состояние - жив
;~ 			Send("4")	;съесть хилку
;~ 			Sleep(200)
;~ 	EndSwitch

	Switch $X[$BD][2]
		Case 'buf'
			Send("2")
			halt($BD,10000)
			$X[$BD][2] = 0
			MsgBox(0,"","Делаем реденс")
	EndSwitch
EndFunc

Func A_SVS()
	;X[0] - window
	;X[1] - hp
	;X[2] - command
	If TimerDiff($halt[$SVS][0]) < $halt[$SVS][1] Then
		Return
	EndIf

	If Not $X[$SVS][2] = 0 Then	;активируем окно только если пришли команды
		WinActivate($X[$SVS][0])
		WinWaitActive($X[$SVS][0])
		Sleep(2000)
	Else
		halt($SVS, 2000)
		Return
	EndIf
	MsgBox(0,"","В автомате СВСа т.к. $X[$SVS][2] = " & $X[$SVS][2])
;~ 	$X[$SVS][1] = get_stat ('HP', $X[$SVS][0])
;~ 	Switch $X[$SVS][1]	;реакция на жизни
;~ 		Case 0
;~ 			$S[$SVS] = 1	;состояние - мертв
;~ 		Case 1 To 70
;~ 			$S[$SVS] = 0 ;состояние - жив
;~ 			Send("{F4}")	;съесть хилку
;~ 			Sleep(200)
;~ 	EndSwitch

	Switch $X[$SVS][2]
		Case 'buf'
			Send("{F2}")
			halt($SVS,10000)
			$X[$SVS][2] = 0
			MsgBox(0,"","Делаем ресонг")
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

	If Not $X[$Warc][2] = 0 Then	;активируем окно только если пришли команды
		WinActivate($X[$Warc][0])
		WinWaitActive($X[$Warc][0])
		Sleep(2000)
	Else
		halt($Warc, 2000)
		Return
	EndIf
	MsgBox(0,"","В автомате Варка")
	;$X[$Warc][1] = get_my_hp()

	Switch $S[$Warc]
		Case 0	;ждет
			Switch $X[$Warc][2]
				Case 'buf'
					$S[$Warc] = 1
					Send("{F3}")	;баф
					halt($Warc, 20000)
					$X[$Warc][2] = 0	;сбраываем команду, чтоыб не повторять её снова
				Case 'heal'
					$S[$Warc] = 1
					Send("{F2}")	;хил
					halt($Warc, 10000)
					$X[$Warc][2] = 0	;сбраываем команду, чтоыб не повторять её снова
				Case Else

			EndSwitch
		Case 1	;занят
			$S[$Warc] = 0		;теперь он ничем не занят

		Case 3	;мёртв
	EndSwitch
EndFunc

#EndRegion