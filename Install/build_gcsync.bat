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

set Version=1.0.2
echo ����ࠥ��� ����� %VERSION%
rem ToDo need compile GameClass.chm

rem ��������� exe-䠩���
call compile_release_gcsync.bat

rem ��������� exe-䠩���
call asprotect_gcsync.bat

rem �����⮢�� 䠩��� ��� ᮧ����� ����ਡ�⨢�:
call copy_packages_files_gcsync.bat

rem ����஢���� sql-䠩��� � sqp
call encode_sql_gcsync.bat

cd Install\Src\GI
"c:\Program Files\gInstall\Ghost Installer\Bin\GIBuild.exe" gcsync.gi2
cd ..\..\..
