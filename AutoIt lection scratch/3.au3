#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <IE.au3>
;#include <GDIP.au3>
#include <GDIPlus.au3>

$oIE = _IECreateEmbedded()
GUICreate(("Windows Internet Explorer"), 1000, 800, 0, 0)
GUISetState(@SW_SHOW)
$GUIActiveX = GUICtrlCreateObj($oIE, 0, 0, 1000, 800)

_IENavigate($oIE, 'http://bilet.pp.ru/calculator_rus/moy_brouser.php')
Sleep(10000)