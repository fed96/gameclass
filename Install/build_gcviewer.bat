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

set APP_VERSION=1.0.6
Install\src\Batch\gcviewer_replace_versions.vbs "%APP_VERSION%"
echo ����ࠥ��� ����� %APP_VERSION%


rem ��������� exe-䠩���
call compile_release_gcviewer.bat

rem �����⮢�� 䠩��� ��� ᮧ����� ����ਡ�⨢�:
call copy_packages_files_gcviewer.bat

cd Install\Src\GI
"C:\Program Files\Ethalone\Ghost Installer\Bin\GIBuild.exe" gcviewer.gpr
cd ..\..\..
