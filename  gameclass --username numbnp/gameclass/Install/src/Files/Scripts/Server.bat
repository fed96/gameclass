@echo off
if "%1"=="Logon" goto Logon
if "%1"=="Logoff" goto Logoff
if "%1"=="Service" goto Service
if "%1"=="CloseShift" goto CloseShift
if "%1"=="MoneyRemoved" goto MoneyRemoved
echo �ਬ�� ����⭮�� 䠩�� ��� ��ࠡ�⪨ ᮡ�⨩ �� ࠡ�� �ࢥ� GameClass 3
echo ��ࠬ���� ��������� ��ப�:
echo %%1 - ����⢨� (Logon, Logoff, Service, CloseShift ��� MoneyRemoved)
echo %%2 - �६� � �ଠ� dd.mm.yy-hh:mm:ss
echo %%3 - ��� ���짮��⥫�
echo %%4 � ����� - �������⥫쭠� ���ଠ��
echo �� Service:
echo %%4 - �����䨪��� ��㣨
echo %%5 - ������⢮
echo %%6 - IP-���� �������� (none - �᫨ �������⭮)
echo %%7 - ��� ������ (none - �᫨ �������⭮)
echo %%8 - ��ਠ�� ������ (Separate, Prepay, Postpay)
echo �� CloseShift:
echo %%4 - �ᥣ� ��ࠡ�⠭�
echo %%5 - � ������
echo %%6 - � ��������
echo �� MoneyRemoved:
echo %%4 - ��묠���� �㬬�
exit

:Logon
echo %2 ���짮��⥫� %3 ������稫�� � ���� ������
pause
exit
:Logoff
echo %2 ���짮��⥫� %3 �⪫�稫�� �� ���� ������
pause
exit
:Service
echo %2 �� ������ %3 ������� ��㣠 � �����䨪��஬ %4 � ������⢥ %5
echo   IP-���� ��������: %6 
echo   ��� ������: %7
if "%8"=="Separate" echo   ��ਠ�� ������: �⤥�쭠� �����  
if "%8"=="Prepay" echo   ��ਠ�� ������: ������ �� �।������ �� ᥠ��  
if "%8"=="Postpay" echo   ��ਠ�� ������: ������� � ���⮯����� �� ᥠ��
pause
exit
:CloseShift
echo %2 ������ %3 �����訫 ᬥ��
echo   �ᥣ� ��ࠡ�⠭�: %4
echo   � ������: %5
echo   � ��������: %6
pause
exit
:MoneyRemoved
echo %2 �������� %3 ���ࠫ ���죨 �� �����: %4
pause
exit
