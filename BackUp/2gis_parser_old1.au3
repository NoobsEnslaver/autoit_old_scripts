$err = 0
$last = 0
$last_last = 0
$num = 0
$raw_text = ""
$text = ""
$pattern = "(?:mailto:)([^\s]+@[\w]+\.[\w]{2,4}?)"

$path = FileSaveDialog("���������� ������", @WorkingDir, "��������� ����� (*.txt)")
If StringInStr($path, ".txt") = 0 Then
	$path = $path & ".txt"
EndIf

$file = FileOpen($path,1)

WinWaitActive("����������� (������� 2014) - 2���")	;����� ����� �������� � ����. ������
Sleep(500)

Do	;�������� ����, ������� ��������
	$pos = PixelSearch(0,100,2,1024,0xCBD2E3)

	If @error Then		;�������� �������� ��� ��������� ������
		$err = $err + 1
		MouseWheel("down",3)
		ContinueLoop
	EndIf
	If $pos[1] = $last_last Then	;������ �� ������������
		ExitLoop
	Else
		$last_last = $last
		$last = $pos[1]
	EndIf
	Do		;���������� ����������� �� ���� ��������
		$num = $num + 1	;������� �������
		$pos[0] = $pos[0] + 2	;�.�. ������� ������� 2px
		$pos[1] = $pos[1] + 2
		MouseClick("right",$pos[0], $pos[1],1,1)
		Sleep(50)
		Send("{DOWN 2}{ENTER}")		;�����������
		MouseClick("right",$pos[0], $pos[1],1,1)
		Sleep(50)
		Send("{DOWN}{ENTER}")		;������������ ������
		Sleep(200)
		$raw_text = ClipGet()		;��������� ������ ������
		If Not @error Then
			$text = StringRegExp($raw_text, $pattern,1)
			If Not @error Then
				FileWriteLine($file,$text[0] & ",")	;������ ������ � ���� ���
				;MsgBox(64,"",$text[0])
			Else
				$num = $num - 1
			EndIf
		Else
			$num = $num - 1
		EndIf



		$pos = PixelSearch(0,$pos[1],2,1024,0xCBD2E3)
	Until @error = 1
	MouseMove(310,$last,1)	;������� ����� ����� ������� ������ ������� �� ���������
	MouseWheel("down",3)	;��������� ��������
	Sleep(200)
Until $err = 3
FileClose($file)
$num = $num - 2
Beep(500,500)
Beep(400,500)
Beep(300,500)
Beep(200,500)
MsgBox(64, "2GIS_fucker", "����� ������������ �������� " & $num)