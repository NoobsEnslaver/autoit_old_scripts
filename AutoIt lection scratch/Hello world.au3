$choice = MsgBox(4,"Мой первый скрипт","Hello World?");
#cs

#ce
if $choice = 6 Then
	ConsoleWrite("Спасибо!")
Else
	ConsoleWrite("Зря ты так..")
EndIf

Run("cmd.exe")
WinWaitActive("C:\Windows\SYSTEM32\cmd.exe")
Send('echo "Привет мир!"{ENTER}')