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
del /s /q Install\Src\Packages\gccllin\*.* >nul 2>nul
echo  OK
ech "  �������� �������� ��⠫���� ..."
if not exist Install\Src\Packages\gccllin md Install\Src\Packages\gccllin| ech .
if not exist Install\Src\Packages\gccllin\gccllin md Install\Src\Packages\gccllin\gccllin| ech .
if not exist Install\Src\Packages\gccllin\gccllin\Skins md Install\Src\Packages\gccllin\gccllin\Skins| ech .
if not exist Install\Src\Packages\gccllin\gccllin\Sounds md Install\Src\Packages\gccllin\gccllin\Sounds| ech .
echo  OK

rem ���樠������ ��ࠡ�⪨ ���-䠩��
del Install\Src\Logs\CopyPackagesFiles.log >nul 2>nul
Set error_check=

ech "  ����஢���� 䠩��� ��� ���⠫��樨 "
rem ������� ��������� � for �⮡� �� ����஢��� 䠩�� vssver.scc
copy Output\Debug\gccllin Install\Src\Packages\gccllin\gccllin >>Install\Src\Logs\CopyPackagesFiles.log| ech .
copy Docs\ClientLinux\readme.txt Install\Src\Packages\gccllin >>Install\Src\Logs\CopyPackagesFiles.log| ech .
copy Install\Src\Files\ClientLinux\*.* Install\Src\Packages\gccllin\gccllin\ >>Install\Src\Logs\CopyPackagesFiles.log| ech .
copy Install\Src\Files\SkinsLinux\*.* Install\Src\Packages\gccllin\gccllin\Skins >>Install\Src\Logs\CopyPackagesFiles.log| ech .
copy Install\Src\Files\Sounds\*.* Install\Src\Packages\gccllin\gccllin\Sounds >>Install\Src\Logs\CopyPackagesFiles.log| ech .

find "���⥬� �� 㤠���� ���� 㪠����� ����" <Install\Src\Logs\CopyPackagesFiles.log >Install\Src\Logs\CopyPackagesFiles.txt
find "System cannot find the path specified" <Install\Src\Logs\CopyPackagesFiles.log >>Install\Src\Logs\CopyPackagesFiles.txt
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
