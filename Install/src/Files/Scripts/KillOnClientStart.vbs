'%1 - �������� (ServiceStart, ServiceStop, ClientStart, ClientStop, Blocking, Unblocking, 
'     EnableIntenet, DisableIntenet, AfterStopAction, Disconnect, NMinutLeft, StateChanged, 
'     ��� TarifChanged)
'%2 - ������ ������� � ������� dd.mm.yy-hh:mm:ss
'%3 - ��������������� �������� (KillTask, Logoff, Restart ��� Shutdown ��� AfterStopAction; 
'     ���������� ����� ��� NMinutLeft; �������� ������ ��� TarifChanged)

Dim oArgs
Set oArgs = Wscript.Arguments
Set objWSH=Wscript.CreateObject("Wscript.Shell")

If oArgs.Count < 2 Then
  WScript.Quit 
End If

Dim strAction, strMoment, strExtraParameter, strInfo
strActon =  oArgs(0)
strMoment = oArgs(1)
strExtraParameter = ""
If oArgs.Count = 3 Then
  strExtraParameter = oArgs(2)
End If


If strActon="ClientStart" Then
  WScript.Sleep 2000
  Set objExec = objWSH.Exec("C:\Program Files\GameClass3\Client\kill.exe" )
  While objExec.Status = 0
  WEnd
End If


