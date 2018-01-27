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
		;Саммона нет
		Case 0
			If $X[$Summon][1] > 0 Then	;если хп появилось, знаит саммон появился
				$S[$Summon] = 1
				$X[$Summon][3] = TimerInit()
			Else
				$S[$PS] = 0				;Состояние ФСа - нет самона.
				halt($Summon, 5000)		;иначе усыпляем автомат на 5 сек.
			EndIf

		;ожидание
		Case 1
			Switch $X[$Summon][2]
				Case 'attack'
					$S[$Summon] = 2
					Send("{F1}")
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
					Send("2")					;хил
			EndSwitch

		;в бою
		Case 2
			$X[$Summon][4] = get_mob_hp()	;считаем хп моба
			If $X[$Summon][4] = 0 Then		;если его нет или он мёртв - в ожидание
				$S[$Summon] = 1
				$X[$Summon][2] = 'stop'		;пошлем команду стоп, чтобы не тыкалась "атака" по трупу
			EndIf

			Switch $X[$Summon][2]
				Case 'attack'
					$S[$Summon] = 2
					Send("{F1}")
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
				Case 1 To 30
					Send(Random(0,2)>1?"2":"3")	;хил или ульт
				Case 30 To 80
					Send("2")					;хил
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

	If $S[$Summon] = 0 Then								;если нет самона - призываем его.
		Send("0")
		$X[$PS][3] = True
		halt($PS,5000)
	Else												;если он есть  - работаем с ним
		If $Y[$Summon][1] > 40 And $S[$Summon] = 1 Then	;если самону уже 40 мин и он не в бою
			$X[$Summon][2] = 'unsummon'					;отправляем ему сообщение "отозваться"
		Else
			If $X[$PS][2] = 0 Then							;если хп моба = 0
				Send("4")									;target next
			Else
				$X[$Summon][2] = 'attack'					;команда самону - атака.
			EndIf

			If $S[$Summon] > 0 AND $X[$PS][3] = True Then	;если самон жив и нужен ребаф - разошлем команды сапорту
				$X[$PS][3] = False
				$X[$PP][1] = 'buf'
				$X[$SE][1] = 'buf'
				$X[$PS][4] = TimerInit()
			EndIf

			If $X[$PS][4] > 18*60*1000 Then					;если с прошлого ребафа прошло 18 минут - нужен ребаф
				$X[$PS][3] = True
				Send("9")									;вызываем новый кубик
				halt($PS,5000)
			EndIf

			If $S[$Summon] > 0 AND $X[$PS][5] = True Then	;тоже, но для сонга и денса
				$X[$PS][3] = False
				$X[$BD][1] = 'buf'
				$X[$SVS][1] = 'buf'
				$X[$PS][6] = TimerInit()
			EndIf

			If $X[$PS][6] > 2*60*1000 Then					;тоже
				$X[$PS][5] = True
			EndIf
		EndIf
	EndIf

	Switch $X[$PS][1]		;Реакия на ХП чара
		Case 0
			If $S[$PP] = 0 Then			;если ПП в состоянии ожидания
				$X[$PP][1] = 'res_PS'	;пп - ресни плз
			ElseIf $S[$SE] = 0 Then
				$X[$SE][1] = 'res_PS'	;се - ресни плз
			EndIf
		Case 1 To 50
			If $S[$PP] = 0 Then			;если ПП в состоянии ожидания
				$X[$PP][1] = 'heal_PS'	;пп - хил плз
			ElseIf $S[$SE] = 0 Then
				$X[$SE][1] = 'heal_PS'	;се - хил плз
			EndIf
			Send("5")					;съесть хилку
		Case 50 To 80
			Send("5")					;съесть хилку
	EndSwitch

EndFunc

Func A_PP()
	;X[0] - window
	;X[1] - hp
	;X[2] - command
	If TimerDiff($halt[$PP][0]) < $halt[$PP][1] Then
		Return
	EndIf

	If $X[$PP][2] <> 0 Then	;активируем окно только если пришли команды
		WinActivate($X[$PP][0])
		WinWaitActive($X[$PP][0])
	EndIf
	$X[$PP][1] = get_my_hp()

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
					Send("3")	;селф баф + баф самонера
					halt($PP, 10000)
				Case 'heal_PS'
					$S[$PP] = 2
					Send("2")	;таргет самонера + батл хил + таргет селф
					halt($PP, 4000)
				Case 'res_PS'
					$S[$PP] = 3
					Send("0")	;ресаем ФСа
					halt($PP, 10000)
			EndSwitch
		Case 1	;законил первую часть бафа
			$S[$PP] = 2
			Send("4")	;полный баф самона
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
		Case 4	;мёртв



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
	$X[$SE][1] = get_my_hp()

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
					$S[$PP] = 2
					Send("3")	;баф самона
					halt($SE, 10000)
				Case 'heal_PS'
					$S[$SE] = 2
					Send("2")	;таргет самонера + хил + таргет селф
					halt($SE, 10000)
				Case 'res_PS'
					$S[$SE] = 3
					Send("0")	;ресаем ФСа
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

	If $X[$BD][2] <> 0 Then	;активируем окно только если пришли команды
		WinActivate($X[$BD][0])
		WinWaitActive($X[$BD][0])
	EndIf
	$X[$BD][1] = get_my_hp()

	Switch $X[$BD][1]	;реакция на жизни
		Case 0
			$S[$BD] = 1	;состояние - мертв
		Case 1 To 70
			$S[$BD] = 0 ;состояние - жив
			Send("4")	;съесть хилку
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

	If $X[$SVS][2] <> 0 Then	;активируем окно только если пришли команды
		WinActivate($X[$SVS][0])
		WinWaitActive($X[$SVS][0])
	EndIf
	$X[$SVS][1] = get_my_hp()

	Switch $X[$SVS][1]	;реакция на жизни
		Case 0
			$S[$SVS] = 1	;состояние - мертв
		Case 1 To 70
			$S[$SVS] = 0 ;состояние - жив
			Send("4")	;съесть хилку
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

