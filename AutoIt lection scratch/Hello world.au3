$choice = MsgBox(4,"��� ������ ������","Hello World?");
#cs

#ce
if $choice = 6 Then
	ConsoleWrite("�������!")
Else
	ConsoleWrite("��� �� ���..")
EndIf

Run("cmd.exe")
WinWaitActive("C:\Windows\SYSTEM32\cmd.exe")
Send('echo "������ ���!"{ENTER}')