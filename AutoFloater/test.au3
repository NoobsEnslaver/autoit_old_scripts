Dim $texts[8] = ["AF FF 0F 11", "AF FF 0F 11 ", " AF FF 0F 11", " AF FF 0F 11 ", "Smthing text AF FF", "Smthing text AF FF AA BB", "AF FF 0F Z1", "AFFF0F11"]
 #include <Array.au3>

;If MsgBox(0,"",StringLen($texts[3])) <= 13 Then


;~ $text = StringStripWS("   this    is   a   line    of   text   ", 7)
;~ ConsoleWrite($text)

;~ $result = StringRegExp($texts[4], '(?:[\s]*[0-9A-Fa-f]{2}\s*){4}',1)
;~ If @error = 0 Then
;~    ConsoleWrite("Есть совпадение" & @LF)
;~ Else
;~    ConsoleWrite("нет совпадения"& @LF)
;~ EndIf

;~ ConsoleWrite($result[0])
;~ $tmp = StringSplit($result[0],' ')
;~  _ArrayDisplay($tmp, "1D display")
;~ For $val in $result
;~    ConsoleWrite($val & @LF)
;~ Next

;~ For $i=0 To 7
;~    $result = StringRegExp($texts[$i], '(?:\s+[0-9A-Fa-f]{2}\s+)',0)
;~    If $result = True Then
;~ 	  ConsoleWrite("Тест № " & $i &" пройден" & @LF)
;~    EndIf
;~ Next

;~ $str = StringReplace(" AF FF 0F 11"," ", "")
;~ ConsoleWrite($str)

#include <MsgBoxConstants.au3>
$str = "This is a sentence with whitespace."
Local $sString = StringLeft($str, 5) ; Retrieve 5 characters from the left of the string.
$str = StringTrimLeft($str,5)
MsgBox($MB_SYSTEMMODAL, "", $sString)
MsgBox($MB_SYSTEMMODAL, "", $str)
