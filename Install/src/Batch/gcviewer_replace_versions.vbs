Set objArgs = WScript.Arguments  ' ������� ������ WshArguments

if objArgs.Count() <> 1 then
  WScript.Echo "������� APP_VERSION � �������� ����������"
Else
  strAppVersion = objArgs.Unnamed.Item(0)
  Set objFSO=CreateObject("Scripting.FileSystemObject")
  set objWSH=Wscript.CreateObject("Wscript.Shell")
  
  while not objFSO.FileExists("rootdir")
    objWSH.CurrentDirectory = ".."
  wend

  strCmd = "wscript Install\src\Batch\ReplaceStringInFile.vbs "  
  Set objExec = objWSH.Exec(strCmd + "Viewer\GCViewer.dof" + " ProductVersion " + """ProductVersion=" + strAppVersion + """" )
  While objExec.Status = 0
  WEnd

  '��� ���������������� ����� ����� ����� ������ ��������
  strAppVersion = Replace(strAppVersion, " ", ".")
'  <var name="AppVersion" value="3.85"/>
  Set objExec = objWSH.Exec(strCmd + "Install\src\GI\gcviewer.gi2" + " 'AppVersion'  ""  <var name='AppVersion' value='" + strAppVersion + "'/>""")
  While objExec.Status = 0
  WEnd

' ������������ res-�����
  strCmd = "Tools\ReplaceVerInfo\ReplaceVerInfo.exe " 
  strParameters = " ProductVersion """ + strAppVersion + """"
  Set objExec = objWSH.Exec(strCmd + "Viewer\GCViewer.res" + strParameters)
  While objExec.Status = 0
  WEnd
'  Set objExec = objWSH.Exec(strCmd + "ClientLinux\gccllin.res" + strParameters)
'  While objExec.Status = 0
'  WEnd
End If
