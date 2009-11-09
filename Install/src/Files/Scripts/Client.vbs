'%1 - �������� (ServiceStart, ServiceStop, ClientStart, ClientStop, Blocking, Unblocking, 
'     EnableIntenet, DisableIntenet, AfterStopAction, Disconnect, NMinutLeft, StateChanged, 
'     ��� TarifChanged)
'%2 - ������ ������� � ������� dd.mm.yy-hh:mm:ss
'%3 - ��������������� �������� (KillTask, Logoff, Restart ��� Shutdown ��� AfterStopAction; 
'     ���������� ����� ��� NMinutLeft; �������� ������ ��� TarifChanged)

Dim oArgs
Set oArgs = Wscript.Arguments

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


If strActon="ServiceStart" Then
  WScript.Echo strMoment & "  ������� ������ ������� GameClass"
End If
If strActon="ServiceStop" Then
  WScript.Echo strMoment & "  ���������� ������ ������� GameClass"
End If
If strActon="ClientStart" Then
  WScript.Echo strMoment & "  �������� ���������� ����� ������� GameClass"
End If
If strActon="ClientStop" Then
  WScript.Echo strMoment & "  ����������� ���������� ����� ������� GameClass"
End If
If strActon="Blocking" Then
  WScript.Echo strMoment & "  ��������� ������������"
End If
If strActon="Unblocking" Then
  WScript.Echo strMoment & "  ��������� �������������"
End If
If strActon="EnableIntenet" Then
  WScript.Echo strMoment & "  ������ � �������� �������������"
End If
If strActon="DisableIntenet" Then
  WScript.Echo strMoment & "  ������ � �������� ������������"
End If
If strActon="AfterStopAction" Then
  If strExtraParameter="KillTask" Then
    strInfo = "������ �����"
  End If
  If strExtraParameter="Logoff" Then
    strInfo = "���������� ������"
  End If
  If strExtraParameter="Restart" Then
    strInfo = "������������"
  End If
  If strExtraParameter="Shutdown" Then
    strInfo = "���������� ����������"
  End If
  WScript.Echo strMoment & "  �������� ����� ���������� ������: " & strInfo
End If
If strActon="Disconnect" Then
  WScript.Echo strMoment & "  ������ ����� ����� �������� � �������� GameClass"
End If
If strActon="NMinutLeft" Then
  WScript.Echo strMoment & "  �� ���������� ������ �������� " & strExtraParameter & " �����" 
End If
If strActon="StateChanged" Then
  WScript.Echo strMoment & "  ���������� ��������� ������� GameClass"
End If
If strActon="TarifChanged" Then
  WScript.Echo strMoment & "  ������� ����� ������� �� " & strExtraParameter
End If

'Set wshshell = WScript.CreateObject("WScript.Shell")

'wshshell.Popup "Error with creating ActiveX object!",0,"",0


