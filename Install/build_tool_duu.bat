@echo off
rem -------------------- ��砫� 蠯�� ------------------------------------
rem ��室 � ��୥��� ��४��� �஥�
for /l %%i in (1,1,8) do if not exist rootdir cd ..
rem ��砫�� ࠡ�稩 ��⠫�� ��� ��� ������� 䠩��� - ��୥��� 
rem ��४��� �஥�� (Current\ ��� 3.XX\)
rem ����������� � ���� ���᪠ Install\Src\Batch
if not -%GCMakePath%==- goto PathAlreadySet
for /d %%i in (Install\Src\Batch\) do set GCMakePath=%%~dpi
set Path=%GCMakePath%;%Path%
:PathAlreadySet
rem -------------------- ����� 蠯�� ------------------------------------
call Install\src\Batch\compile_osql.bat

set APP_NAME=DeleteUnregisteredUsers
set APP_FULLNAME%=�⨫�� 㤠����� ����ॣ����஢����� � GameClass 3 ���짮��⥫��
set APP_VERSION%=2.2
set APP_MESSAGE%=�������� ����ॣ����஢����� � GameClass 3 ���짮��⥫��

call Install\build_tools.bat