#include <InetConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <Array.au3>
#include <File.au3>

Local $objectId
Local $bookFolder = ""
Local $linkroot = ""
Local $minsize = 83
Local $page = 0
Local $firstpage = 0

$fSet = "settings"
FileOpen($fSet, 0)
For $i = 1 to _FileCountLines($fSet)
    $line = FileReadLine($fSet, $i)
	$array = stringsplit($line," ")
	Switch $array[1]
		Case "objectId"
			$objectId = $array[2]
		Case "folder"
			$bookFolder = $array[2]
		Case "root"
			$linkroot = $array[2]
		Case "minsize"
			$minsize = $array[2]
		Case "firstpage"
			$firstpage = $array[2]
		Case Else
	EndSwitch
Next
FileClose($fSet)

If DirGetSize($bookFolder) = -1 Then DirCreate($bookFolder)
If StringRight($bookFolder, 1) <> "\" Then $bookFolder = $bookFolder & "\"

Do
	Sleep(250)
	$pagePath = $bookFolder & $objectId & "_" & StringFormat("%05i", $page + $firstpage) & ".png"
	$link = $linkroot & "?objectId=" & $objectId & "&page=" & $page + $firstpage & "&cache=cache.png"
	$dStatus = InetGet($link, $pagePath, $INET_FORCERELOAD)
	$PageSize = FileGetSize($pagePath)
	$page = $page + 1
	InetClose($dStatus)
	If Int($PageSize) < Int($minsize) Then 
		FileDelete($pagePath)
		ExitLoop
	EndIf
Until InetGetInfo($dStatus, $INET_DOWNLOADCOMPLETE)
