#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Fileversion=0.0.0.5
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Sleep(5000)

Const $vsego_poziciy = 21
const $pervaya_poziciya = 0
Local $dy = 20
Local $table1_x = 80
Local $table1_y = 142
Local $table2_x = 470
Local $table2_y = 245
Local $table3_x = 470
Local $table3_y = 585
Local $expand_btn_x = 1250
Local $expand_btn_y = 340
Local $change_btn_OK_x = 1320
Local $change_btn_OK_y = 540
Const $my_buy_order = 5
Const $my_sell_order = 6
Const $concurent_buy_order = 3
Const $concurent_sell_order = 4

While 1
;$time = TimerInit()
For $i = $pervaya_poziciya To $vsego_poziciy - 1 Step +1
	MouseMove($table1_x,$table1_y + $i*$dy)
	MouseClick("left",$table1_x+5,$table1_y + $i*$dy)
	Sleep(1000+Random()*1000)

	$pos = PixelSearch($table2_x,$table2_y,$table3_x+2,$table3_y-20,1776984,20) ;Pos of my sell position
	If Not @error Then
		$pos[0] = $pos[0] + 5
		$pos[1] = $pos[1] + 5
		If $pos[1]-10 > $table2_y Then
			$concurent_order_data = CopyPrice($table2_x,$table2_y,$concurent_sell_order)
			$my_order_data = CopyPrice($pos[0], $pos[1],$my_sell_order)

			$my_goods_quantity = $my_order_data[0]
			$my_price = $my_order_data[1]
			;$my_order_time = $my_order_data[2]
			$concurent_price = $concurent_order_data[1]
			$concurent_goods_quantity = $concurent_order_data[0]
			;$concurent_order_time = $concurent_order_data[2]
			#Region debuging
				ConsoleWrite("my_goods=" & $my_goods_quantity& " |my_price=" & $my_price & " |C_goods=" & $concurent_goods_quantity & " |C_price=" & $concurent_price & " |")
				If Abs(($concurent_price - $my_price)/$my_price) < 0.02 Then
					ConsoleWrite("Price_prot_OK.|")
				Else
					ConsoleWrite("Price_prot_FAIL.|")
				EndIf
				If $my_goods_quantity < 33*$concurent_goods_quantity Then
					ConsoleWrite("Quant_prot_OK.|")
				Else
					ConsoleWrite("Quant_prot_FAIL.|")
				EndIf
				#EndRegion

			If (Abs(($concurent_price - $my_price)/$my_price) < 0.02) And $my_goods_quantity < 33*$concurent_goods_quantity Then	;Difference of prices not more that 2% and quantity of concurent goods not less 3% of total
				MouseMove($pos[0],$pos[1])
				Sleep(50)
				MouseClick("right",$pos[0]+3,$pos[1])
				Sleep(500+Random()*1000)
				MouseMove($pos[0]+20,$pos[1]+20)
				Sleep(50)
				MouseClick("left",$pos[0]+30,$pos[1]+20)
				Sleep(500+Random()*1000)
				$tmp = $concurent_price-0.01
				$tmp=StringReplace($tmp, '.', ',')
				If @extended > 0 Then
					ConsoleWrite("It FLOAT.|")
					Send(StringLeft($tmp,( StringInStr($tmp,",")-1)))
					Sleep(500)
					Send("{, down}")
					Sleep(500)
					Send("{, up}")
					Sleep(500)
					Send(StringRight($tmp,(StringLen($tmp) - StringInStr($tmp,","))))
					Sleep(100)
				Else
					ConsoleWrite("It INT.|")
					Send($tmp)
				EndIf
				ConsoleWrite("$tmp =" & $tmp & " | ")
				Send("{CTRLDOWN}")
				Send("{c down}") ; Holds the ctrl+c key down
				Sleep(500)
				Send("{c up}")
				Send("{CTRLUP}")
				Sleep(200)
				ConsoleWrite("Ctr+c = " & ClipGet() & "|")
				If $tmp <> ClipGet() Then
					ConsoleWrite("Compare ERROR.|" & @CR)
					ContinueLoop
				EndIf
				ConsoleWrite("Compare OK.|" & @CR)
				Send("{ENTER}")
				Sleep(500)
				MouseClick("left",780,530)
				Sleep(500)
			Else
				Beep(500, 500)
				Beep(400, 500)
			EndIf
		EndIf
	EndIf

	;ContinueLoop

	$pos = PixelSearch($table3_x,$table3_y,$table3_x+2,$table3_y+250,1776984,20) ;Pos of my buy position
	If Not @error Then
		$pos[0] = $pos[0] + 5
		$pos[1] = $pos[1] + 5
		If $pos[1]-10 > $table3_y  Then
		 	$concurent_order_data = CopyPrice($table3_x,$table3_y,$concurent_buy_order)
			$my_order_data = CopyPrice($pos[0], $pos[1],$my_buy_order)

			$my_goods_quantity = $my_order_data[0]
			$my_price = $my_order_data[1]
			;$my_order_time = $my_order_data[2]
			$concurent_price = $concurent_order_data[1]
			$concurent_goods_quantity = $concurent_order_data[0]
			;$concurent_order_time = $concurent_order_data[2]

			#Region debuging
				ConsoleWrite("my_goods=" & $my_goods_quantity& " |my_price=" & $my_price & " |C_goods=" & $concurent_goods_quantity & " |C_price=" & $concurent_price & " |")
				If Abs(($concurent_price - $my_price)/$my_price) < 0.02 Then
					ConsoleWrite("Price_prot_OK.|")
				Else
					ConsoleWrite("Price_prot_FAIL.|")
				EndIf
				If $my_goods_quantity < 33*$concurent_goods_quantity Then
					ConsoleWrite("Quant_prot_OK.|")
				Else
					ConsoleWrite("Quant_prot_FAIL.|")
				EndIf
				#EndRegion

			If (Abs(($concurent_price - $my_price)/$my_price) < 0.02) And $my_goods_quantity < 33*$concurent_goods_quantity Then	;Difference of prices not more that 1%
				MouseMove($pos[0],$pos[1])
				Sleep(50)
				MouseClick("right",$pos[0]+3,$pos[1])
				Sleep(1000)
				MouseMove($pos[0]+20,$pos[1]+10)
				Sleep(50)
				MouseClick("left",$pos[0]+30,$pos[1]+10)	;click "change order"
				Sleep(1500)
				$tmp = $concurent_price+0.01
				$tmp=StringReplace($tmp, '.', ',')
				If @extended > 0 Then
					ConsoleWrite("It FLOAT.|")
					Send(StringLeft($tmp,( StringInStr($tmp,",")-1)))
					Sleep(500)
					Send("{, down}")
					Sleep(500)
					Send("{, up}")
					Sleep(500)
					Send(StringRight($tmp,(StringLen($tmp) - StringInStr($tmp,","))))
					Sleep(100)
				Else
					ConsoleWrite("It INT.|")
					Send($tmp)
				EndIf
				ConsoleWrite("$tmp =" & $tmp & " | ")
				Send("{CTRLDOWN}")
				Send("{c down}") ; Holds the ctrl+c key down
				Sleep(500)
				Send("{c up}")
				Send("{CTRLUP}")
				Sleep(200)
				ConsoleWrite("Ctr+c = " & ClipGet() & "|")
				If $tmp <> ClipGet() Then
					ConsoleWrite("Compare ERROR.|" & @CR)
					ContinueLoop
				EndIf
				ConsoleWrite("Compare OK.|" & @CR)
				Send("{ENTER}")
				;Sleep(1000)
				;MouseClick("left",$change_btn_OK_x,$change_btn_OK_y)
				Sleep(500)
				MouseClick("left",780,530)
				Sleep(500)
				MouseClick("left",470,180) ;refresh btn
			Else
				Beep(500, 500)
				Beep(400, 500)
			EndIf
		EndIf
	EndIf

Sleep(1000)
Next

Sleep( Abs(5*60*1000 + Random()*30000 )) ;- TimerDiff($time))
WEnd

;Open first trade order and copy price, return at numeric and it steel in clip buffer.
Func CopyPrice($x, $y, $mode)
MouseMove($x,$y)
Sleep(50)
MouseClick("right",$x+5,$y)
Sleep(1000)
MouseMove($x+40,$y+15*$mode)
Sleep(50)
MouseClick("left",$x+50,$y+15*$mode)

Sleep(1000)
Local $OrderData[3]
$test_string = ClipGet()
$test_string = StringReplace($test_string,chr(160),'')

$temp = StringLeft($test_string,StringInStr($test_string,"<t>",0,2) - 1)
$temp = StringTrimLeft($temp,StringInStr($temp,"<right>")+6)
$OrderData[0] = Number($temp)

$temp = StringLeft($test_string,StringInStr($test_string,"ISK") - 1)
$temp = StringTrimLeft($temp,StringInStr($temp,"<right>",0,2)+6)
$temp = StringStripWS(StringReplace($temp, ',', '.'), 8)
$OrderData[1] = Number($temp)

;$temp = StringStripWS(StringTrimLeft($test_string,StringInStr($test_string,"<t>",0,-1) +2),8)
;$temp = StringSplit($temp,"д")
;$OrderData[2] = $temp[1] * 24
;$temp = StringSplit($temp[2],"ч")
;$OrderData[2] = ($OrderData[2] + $temp[1]) * 60
;$temp = StringSplit($temp[2],"мин")

;$OrderData[2] = $OrderData[2] + $temp[1]

;_ArrayDisplay($temp)
;MsgBox(64,"",$temp)

ClipPut("")
Return $OrderData
EndFunc
