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

if "-%APP_NAME%"=="-" goto parameter_needed
if "-%APP_FULLNAME%"=="-" goto parameter_needed
if "-%APP_VERSION%"=="-" goto parameter_needed
if "-%APP_MESSAGE%"=="-" goto parameter_needed

echo ����ࠥ��� �⨫�� %APP_NAME% (%APP_FULLNAME%) ����� %APP_VERSION%

rem �����⮢�� 䠩��� ��� ᮧ����� ����ਡ�⨢�:
call copy_packages_files_tools.bat

rem ����஢���� sql-䠩��� � sqp
call encode_sql_tools.bat

ech "�������� �஥�� gpr �� �᭮�� tools.gpr ... "
Create_gpr_for_Tools.vbs  %APP_NAME% "%APP_FULLNAME%" %APP_VERSION% "%APP_MESSAGE%"
echo Ok


cd Install\Src\GI
"C:\Program Files\Ethalone\Ghost Installer\Bin\GIBuild.exe" %APP_NAME%.gpr
cd ..\..\..

pause

:parameter_needed
echo ����室��� �ࠢ��쭮 ��⠭����� ��६���� APP_NAME, APP_FULLNAME, APP_VERSION, APP_MESSAGE