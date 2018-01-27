#cs Описание
   Скрипт для упрощения работы с программой floatconv - преобразователем из байтового представления числа в float.
   Проблема работы заключается в том, что работая с консолью обычно получаешь байты от устройства в обратном порядке
   и приходится их в ручную вставлять в обратном порядке, а также то, что нельзя скопировать и вставить строку байт
   только по одному байту, что раздражает при долгой работе. Скрипт же действует следующим образом:  запускает программу
   и скрывает её. Далее в фоновом режиме сканирует буфер обмена, как только там появляется строка байт вида FF FF FF FF
   он передает её программе, меняя байты местами и выводит результат в трее.
   Скрипт должен лежать в одной папке с floatconv.exe
#ce
Dim $old_match = 'ZZZZZ'
Dim $bytes[5]
If Not WinExists("floatconv") Then
   Run("floatconv.exe")
   WinWait("floatconv", "", 10)
   Sleep(100)
   ControlCommand("floatconv","", "Button3","Check", "")	;Выбор режима Microchip 32bit
EndIf

WinSetState("floatconv", "", @SW_HIDE)	;прячем

While True
   $raw_text = ClipGet()									;копируем буфер обмена
   If StringLen($raw_text) < 20  Then						;не рассматриваем длинные тексты - у нас всего 4 байта (8 символов + пробелы, берем с запасом)
	  $matches = StringRegExp($raw_text, '(?:[\s]*[0-9A-Fa-f]{2}\s*){4}',1) ;чтобы не выводилось одно и тоже отслеживаем изменение буфера обмена
	  If @error = 0 AND $old_match <> $matches[0]  Then
		 $old_match = $matches[0]

		 $no_WS_string = StringReplace($matches[0], " ", "")	;удаляем все пробелы
		 $bytes[4] = StringLeft($no_WS_string, 2)				;выделяем байт
		 $no_WS_string = StringTrimLeft($no_WS_string, 2)		;бераем его из остального текста
		 $bytes[3] = StringLeft($no_WS_string, 2)				;и так все 4 байта
		 $no_WS_string = StringTrimLeft($no_WS_string, 2)
		 $bytes[2] = StringLeft($no_WS_string, 2)
		 $no_WS_string = StringTrimLeft($no_WS_string, 2)
		 $bytes[1] = StringLeft($no_WS_string, 2)
															;если передано более 4 байт - обрабатываются первые 4.
		 ControlSetText("floatconv","","Edit1", $bytes[4])	;заносим данные в программу-носитель
		 ControlSetText("floatconv","","Edit2", $bytes[3])
		 ControlSetText("floatconv","","Edit3", $bytes[2])
		 ControlSetText("floatconv","","Edit4", $bytes[1])
		 ControlClick("floatconv","","Button7", "left", 2)	;жмем "посчитать"
		 Sleep(200)											;вдруг не сразу?
		 $result = ControlGetText("floatconv","","Edit5")	;вытаскиваем результат

		 TrayTip("", $result, 4)							;выводим в трее на 4 секунды.
	  EndIf
   EndIf

   Sleep(700)
WEnd