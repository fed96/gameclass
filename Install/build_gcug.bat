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

set Version=2.0.1
echo ����ࠥ��� ����� %VERSION%
rem ToDo need compile GameClass.chm

rem ��������� exe-䠩���
call compile_release_gcug.bat

rem ��������� exe-䠩���
call asprotect_gcug.bat

rem �����⮢�� 䠩��� ��� ᮧ����� ����ਡ�⨢�:
call copy_packages_files_gcug.bat

cd Install\Src\GI
"c:\Program Files\gInstall\Ghost Installer\Bin\GIBuild.exe" gcug.gpr
cd ..\..\..
