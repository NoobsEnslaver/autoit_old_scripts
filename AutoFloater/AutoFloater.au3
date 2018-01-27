#cs ��������
   ������ ��� ��������� ������ � ���������� floatconv - ���������������� �� ��������� ������������� ����� � float.
   �������� ������ ����������� � ���, ��� ������� � �������� ������ ��������� ����� �� ���������� � �������� �������
   � ���������� �� � ������ ��������� � �������� �������, � ����� ��, ��� ������ ����������� � �������� ������ ����
   ������ �� ������ �����, ��� ���������� ��� ������ ������. ������ �� ��������� ��������� �������:  ��������� ���������
   � �������� �. ����� � ������� ������ ��������� ����� ������, ��� ������ ��� ���������� ������ ���� ���� FF FF FF FF
   �� �������� � ���������, ����� ����� ������� � ������� ��������� � ����.
   ������ ������ ������ � ����� ����� � floatconv.exe
#ce
Dim $old_match = 'ZZZZZ'
Dim $bytes[5]
If Not WinExists("floatconv") Then
   Run("floatconv.exe")
   WinWait("floatconv", "", 10)
   Sleep(100)
   ControlCommand("floatconv","", "Button3","Check", "")	;����� ������ Microchip 32bit
EndIf

WinSetState("floatconv", "", @SW_HIDE)	;������

While True
   $raw_text = ClipGet()									;�������� ����� ������
   If StringLen($raw_text) < 20  Then						;�� ������������� ������� ������ - � ��� ����� 4 ����� (8 �������� + �������, ����� � �������)
	  $matches = StringRegExp($raw_text, '(?:[\s]*[0-9A-Fa-f]{2}\s*){4}',1) ;����� �� ���������� ���� � ���� ����������� ��������� ������ ������
	  If @error = 0 AND $old_match <> $matches[0]  Then
		 $old_match = $matches[0]

		 $no_WS_string = StringReplace($matches[0], " ", "")	;������� ��� �������
		 $bytes[4] = StringLeft($no_WS_string, 2)				;�������� ����
		 $no_WS_string = StringTrimLeft($no_WS_string, 2)		;������ ��� �� ���������� ������
		 $bytes[3] = StringLeft($no_WS_string, 2)				;� ��� ��� 4 �����
		 $no_WS_string = StringTrimLeft($no_WS_string, 2)
		 $bytes[2] = StringLeft($no_WS_string, 2)
		 $no_WS_string = StringTrimLeft($no_WS_string, 2)
		 $bytes[1] = StringLeft($no_WS_string, 2)
															;���� �������� ����� 4 ���� - �������������� ������ 4.
		 ControlSetText("floatconv","","Edit1", $bytes[4])	;������� ������ � ���������-��������
		 ControlSetText("floatconv","","Edit2", $bytes[3])
		 ControlSetText("floatconv","","Edit3", $bytes[2])
		 ControlSetText("floatconv","","Edit4", $bytes[1])
		 ControlClick("floatconv","","Button7", "left", 2)	;���� "���������"
		 Sleep(200)											;����� �� �����?
		 $result = ControlGetText("floatconv","","Edit5")	;����������� ���������

		 TrayTip("", $result, 4)							;������� � ���� �� 4 �������.
	  EndIf
   EndIf

   Sleep(700)
WEnd