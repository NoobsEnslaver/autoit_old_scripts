;Грабер данных из 2Гиса (программы). Как использовать:
;Открываем 2Гис -> Вводим нужный запрос -> Нажимаем "развернуть все карточки" ->
;-> Запускаем парсер -> Выбираем куда сохранить результат -> Ждем, не трогаем комп
;Если нужно изменить выпарсиваемые из записи данные, меняй паттерн в строке 18
;

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_x64=C:\Users\ne\Desktop\2Gis_parser.Exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Constants.au3>
Local $x_left=0, $y_top=0, $x_right=0, $y_bottom=0, $chk_sum=0
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

$file = FileOpen($path, 1)

;WinWaitActive("Новосибирск (декабрь 2015) - 2ГИС") ;Нужно будет обновить в след. месяце
Sleep(3000)

Do ;Основной цикл, листает страницы
	$pos = PixelSearch(0, 100, 2, 1024, 0xCBD2E3)	;отсюда начинается список предприятий (серая линия)
													;pos[0] - y, pos[1] - x
	If @error Then ;Основная проверка для окончания поиска
		$err = $err + 1

		MouseWheel("down", 3) ;следующая страница
		Sleep(100 + $num/10)

		If $err = 3 Then
			MouseClick("left",150,765)
			MouseMove(310, $last, 2) ;Отводим мышку чтобы изчезли лишний бардюры от выделения
			Sleep(1000)
			$chk_sum = PixelChecksum(120,750,180,780)
			Smart_wait(120,750,180,780,$chk_sum)
			MouseWheel("down", 3)
		EndIf
		ContinueLoop
	EndIf
	If $pos[1] = $last_last Then ;защита от зацикливаний
		ExitLoop
	Else
		$last_last = $last
		$last = $pos[1]
	EndIf
	Do ;Перебирает предприятия на этой странице
		 		;Счетчик записей
		$pos[0] = $pos[0] + 2 	;т.к. толщина бордюра 2px
		$pos[1] = $pos[1] + 2


		MouseClick("right", $pos[0], $pos[1], 1, 1)
		Sleep(50+$num/10)
		Send("{DOWN 2}{ENTER}") ;копирование
		Sleep(20+$num/20)
		MouseClick("right", $pos[0], $pos[1], 1, 1)
		Sleep(50+$num/10)
		Send("{DOWN}{ENTER}") ;сворачивание списка
		Sleep(400+$num/20)


		$raw_text = ClipGet() ;обработка буфера обмена
		If Not @error Then
			$text = StringRegExp($raw_text, $pattern, 1)
			If Not @error Then
				FileWriteLine($file, $text[0] & ",") 	;Формат записи в файл тут
				$num = $num + 1
				;MsgBox(64,"",$text[0])
			EndIf
		EndIf

		$pos = PixelSearch(0, $pos[1], 2, 1024, 0xCBD2E3)	;ищем опорный бордюр, начиная с последнего найденого + 2 px
	Until @error = 1
	MouseMove(310, $last, 1) ;Отводим мышку чтобы изчезли лишний бардюры от выделения
	Sleep(50)

	MouseWheel("down", 3) ;следующая страница
	Sleep(100+$num/10)
Until $err = 4

FileClose($file)
Beep(500, 500)
Beep(400, 500)
Beep(300, 500)
Beep(200, 500)
MsgBox(64, "2GIS_parser", "Всего скопированно адрессов " & $num)



;Функции
Func Smart_wait($x_left, $y_top, $x_right, $y_bottom, $loc_chk_sum)
	$antilag = 0
	While $loc_chk_sum = PixelChecksum($x_left, $y_top, $x_right, $y_bottom)
		$antilag = $antilag +1
		Sleep(50)
		;MsgBox(64,"",$loc_chk_sum = PixelChecksum($x_left, $y_top, $x_right, $y_bottom))
		If $antilag > 30 Then
			Return False
		EndIf
	WEnd
	Return True
EndFunc

