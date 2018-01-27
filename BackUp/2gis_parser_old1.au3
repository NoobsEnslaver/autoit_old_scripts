$err = 0
$last = 0
$last_last = 0
$num = 0
$raw_text = ""
$text = ""
$pattern = "(?:mailto:)([^\s]+@[\w]+\.[\w]{2,4}?)"

$path = FileSaveDialog("Сохранение списка", @WorkingDir, "Текстовые файлы (*.txt)")
If StringInStr($path, ".txt") = 0 Then
	$path = $path & ".txt"
EndIf

$file = FileOpen($path,1)

WinWaitActive("Новосибирск (октябрь 2014) - 2ГИС")	;Нужно будет обновить в след. месяце
Sleep(500)

Do	;Основной цикл, листает страницы
	$pos = PixelSearch(0,100,2,1024,0xCBD2E3)

	If @error Then		;Основная проверка для окончания поиска
		$err = $err + 1
		MouseWheel("down",3)
		ContinueLoop
	EndIf
	If $pos[1] = $last_last Then	;защита от зацикливаний
		ExitLoop
	Else
		$last_last = $last
		$last = $pos[1]
	EndIf
	Do		;Перебирает предприятия на этой странице
		$num = $num + 1	;Счетчик записей
		$pos[0] = $pos[0] + 2	;т.к. толщина бордюра 2px
		$pos[1] = $pos[1] + 2
		MouseClick("right",$pos[0], $pos[1],1,1)
		Sleep(50)
		Send("{DOWN 2}{ENTER}")		;копирование
		MouseClick("right",$pos[0], $pos[1],1,1)
		Sleep(50)
		Send("{DOWN}{ENTER}")		;сворачивание списка
		Sleep(200)
		$raw_text = ClipGet()		;обработка буфера обмена
		If Not @error Then
			$text = StringRegExp($raw_text, $pattern,1)
			If Not @error Then
				FileWriteLine($file,$text[0] & ",")	;Формат записи в файл тут
				;MsgBox(64,"",$text[0])
			Else
				$num = $num - 1
			EndIf
		Else
			$num = $num - 1
		EndIf



		$pos = PixelSearch(0,$pos[1],2,1024,0xCBD2E3)
	Until @error = 1
	MouseMove(310,$last,1)	;Отводим мышку чтобы изчезли лишний бардюры от выделения
	MouseWheel("down",3)	;следующая страница
	Sleep(200)
Until $err = 3
FileClose($file)
$num = $num - 2
Beep(500,500)
Beep(400,500)
Beep(300,500)
Beep(200,500)
MsgBox(64, "2GIS_fucker", "Всего скопированно адрессов " & $num)