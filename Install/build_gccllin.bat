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

set Version=3.85.Beta.8

echo ����ࠥ��� ����� %VERSION%
rem ToDo need compile GameClass.chm

rem ��������� exe-䠩���
rem call compile_release_gcti.bat


rem �����⮢�� 䠩��� ��� ᮧ����� ����ਡ�⨢�:
call copy_packages_files_gccllin.bat

ech "  �������� ��娢� tar.gz ..."
set Path="C:\Program Files\UnxUtils\";%GCMakePath%;%Path%
cd Install/src/Packages/gccllin
tar -cvf ..\..\..\..\Output\Setup\gccllin.tar gccllin/libborqt-6.9-qt2.3.so gccllin/Skins gccllin/Sounds readme.txt| ech .
tar --mode=777 -rf ..\..\..\..\Output\Setup\gccllin.tar gccllin/install.sh gccllin/gccllin gccllin/bg_exec | ech .
cd ..\..\..\..\Output\Setup\
gzip -f gccllin.tar| ech .
rename gccllin.tar.gz gccllin.%VERSION%.tar.gz
echo  OK
