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

if -%APP_NAME%==- goto parameter_needed

rem ����塞 ���� 䠩��
del Install\src\Packages\Tools\*.sqp 2>nul

rem ����஢���� sql-䠩��� � sqp
ech "����஢���� sql-䠩��� � sqp ..."
Output\Release\GCOsql.exe encode "DataBase\SQLCode\Tools\%APP_NAME%.sql" "Install\src\Packages\Tools\%APP_NAME%.sqp" | ech .
echo  OK
goto no_error

:parameter_needed
echo ������ �����\�������� �⨫��� � ����⢥ ��ࠬ���

:no_error