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
echo �����⮢�� 䠩��� ��� ᮧ����� ����ਡ�⨢�:
ech "  �������� ����� 䠩��� ..."
del /s /q Install\Src\Packages\Tools\*.* >nul 2>nul
echo  OK
ech "  �������� �������� ��⠫���� ..."
if not exist Install\Src\Packages\Tools md Install\Src\Packages\Tools| ech .
if not exist Install\Src\Packages\Presetup md Install\Src\Packages\Presetup| ech .
echo  OK

rem ���樠������ ��ࠡ�⪨ ���-䠩��
del Install\Src\Logs\CopyPackagesFiles.log >nul 2>nul
Set error_check=

ech "  ����஢���� 䠩��� ��� ���⠫��樨 "
rem �������� ��������� � for �⮡� �� ����஢��� 䠩�� vssver.scc
rem Presetup
for /r Install\Src\Files\Presetup %%i in (*.*) do if not -%%~xi==-.scc copy "%%~fi" Install\Src\Packages\Presetup >>Install\Src\Logs\CopyPackagesFiles.log| ech .
copy Docs\License.txt Install\Src\Packages\Presetup >>Install\Src\Logs\CopyPackagesFiles.log| ech .
rem Database
copy Output\Release\GCosql.exe Install\Src\Packages\Tools >>Install\Src\Logs\CopyPackagesFiles.log| ech .

:lab
find /v "�����஢��� 䠩���" <Install\Src\Logs\CopyPackagesFiles.log >Install\Src\Logs\CopyPackagesFiles.txt
for /f %%i in (Install\Src\Logs\CopyPackagesFiles.txt) DO @SET error_check=%%i 
if "%error_check%"=="" goto no_error
echo  �訡��
pause
more Install\Src\Logs\CopyPackagesFiles.txt
pause
exit
:no_error
echo  OK
del Install\Src\Logs\CopyPackagesFiles.txt >nul 2>nul
del Install\Src\Logs\CopyPackagesFiles.log >nul 2>nul
