@echo off
if "%1"=="Start" goto Start
if "%1"=="Stop" goto Stop
if "%1"=="ChangeTarif" goto ChangeTarif
echo �ਬ�� ����⭮�� 䠩�� ��� ��ࠡ�⪨ ᮡ�⨩ ���짮��⥫�᪨� ��ᨩ GameClass 3
echo ��ࠬ���� ��������� ��ப�:
echo %%1 - ����⢨� (Start, Stop ��� ChangeTarif)
echo %%2 - IP-���� ��������
echo %%3 - ���⪮� �������� ��� (��� ����� �����)
echo %%4 - ������ �������� ��� 
echo %%5 - ��� ������
echo %%6 - ����㯭���� ���୥� (Enabled, Disabled)
exit

:Start
if "%6"=="Enabled" echo �� �������� %2 ����饭 ᥠ�� ��� ���짮��⥫� %5 �� ���� %4 � ����㯮� � ���୥�
if "%6"=="Disabled" echo �� �������� %2 ����饭 ᥠ�� ��� ���짮��⥫� %5 �� ���� %4 ��� ����㯠 � ���୥�
pause
exit
:Stop
echo �� �������� %2 ����襭 ᥠ�� ��� ���짮��⥫� %5
pause
exit
:ChangeTarif
if "%6"=="Enabled" echo �� �������� %2 ��� ���짮��⥫� %5 ᬥ�� ��� �� %4 � ����㯮� � ���୥�
if "%6"=="Disabled" echo �� �������� %2 ��� ���짮��⥫� %5 ᬥ�� ��� �� %4 ��� ����㯠 � ���୥�
pause
