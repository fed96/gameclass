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

rem ����塞 ���� 䠩��
del Install\src\Packages\DataBase\*.sqp 2>nul

rem ����஢���� sql-䠩��� � sqp
ech "����஢���� sql-䠩��� � sqp "
for /r DataBase\SQLCode %%i in (GCSync*.sql) do Output\Release\GCOsql.exe encode "%%~fi" "Install\src\Packages\GCSync\%%~ni.sqp" | ech .
echo  OK
