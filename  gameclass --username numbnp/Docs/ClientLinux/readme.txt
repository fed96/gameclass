    ����������� �� ��������� Linux ������� GameClass -- gccllin

1. � ������� ������ ���� ����������� ������� ������ CP1251 �������� cronyx ��� 
   ���������� 96 DPI. ��� Debian ����� ������������ ����� 
   xfonts-cronyx-cp1251-100dpi_2.3.8-6_all.deb, ��������� �� ������:
   http://www.gameclass.ru/download/xfonts-cronyx-cp1251-100dpi_2.3.8-6_all.deb

2. ���������� ���������� ������ 96 DPI (��. ���������� 1)

3. �������� ��� ���������� � ���������� ��-��������� ������ ru_RU.CP1251. 
   � Debian ��� �������� ��������:
           dpkg-reconfigure locales

3. �������� ������������, ��� �������� ����� ����������� ������.

4. ���������� ����� � ������� ������� "tar xzf gccllin.tar.gz".

5. ��������� install.sh. ������� ���������� ��� ��������� ������� � ��� 
   ������������, ��� �������� ����� ����������� ������. 

6. ����� ������������ ������ GameClass ����� ������������� ����������� ���
   ������ ������ X-Window

������ �������� /etc/rc.local ��� ��������������� ������� ������� ��� ������ 
�������. ��������� ������������ ��������� ���������.






-----------------------------------------------------------------
���������� 1. ��������� ���������� ������ 96 DPI.

   �� ������ ������ ���������� ������ ��������: 
           xdpyinfo | grep resol

   �� ������ ������ ������� ������ ��������: 
           xdpyinfo | grep dimen

   Window ���������� �� ��������� 96 DPI, Linux - 75 ��� 81. ���� ����� ������
   � Linux �������� ������ �� ��������� � ���� �� ������ �������� � Windows ���
   ���������� ������� ������ � �������. 

   � ����������� �� �������� ���������� ������� ��������� ����, �����
   ��������� Linux �������� ��� 96 DPI.

   �) ���� X-Window ������������� �������� ����� KDM ��� GDM, ���������� 
   ��������������� xorg.conf ��� XF86Config. ���������� ���������������
   ���������� DisplaySize � ������������� � ������������ ����������� ������.
   
   ��� ���������� 1280x1024:

           #   **********************************************************************
           # Monitor section
           #   **********************************************************************
           # Any number of monitor sections may be present
           Section "Monitor"
           Identifier "My Monitor"
           # HorizSync is in kHz unless units are specified.
           # HorizSync may be a comma separated list of discrete values, or a
           # comma separated list of ranges of values.
           # NOTE: THE VALUES HERE ARE EXAMPLES ONLY. REFER TO YOUR MONITOR'S
           # USER MANUAL FOR THE CORRECT NUMBERS.
           HorizSync 31 - 86
           # HorizSync 30-64 # multisync
           # HorizSync 31.5, 35.2 # multiple fixed sync frequencies
           # HorizSync 15-25, 30-50 # multiple ranges of sync frequencies
           # VertRefresh is in Hz unless units are specified.
           # VertRefresh may be a comma separated list of discrete values, or a
           # comma separated list of ranges of values.
           # NOTE: THE VALUES HERE ARE EXAMPLES ONLY. REFER TO YOUR MONITOR'S
           # USER MANUAL FOR THE CORRECT NUMBERS.
           VertRefresh 50-180
           Option "dpms"
           DisplaySize 337.5 270.0  #<--- ������� ��� �������� ��� ������
           EndSection
 
 
   ����� DisplaySize 337.5 270.0 ���������� X-Window ����������� �
   ����������� 96x96 dpi ��� ������� ������ 1280x1024. �������� ����������
   ��������������� ���:

           DisplaySize X Y

   ���

           X = ������_������_�_�������� * 25.4 / ��������_dpi
           Y = ������_������_�_�������� * 25.4 / ��������_dpi


   �) ���� Linux ������� ����������� � ������� (runlevel 3), � ��� ������ 
   X-Window � ������������ startx, ����� ���������������� ������ 
   /usr/X11/bin/startx. � ����������� �� ������������, ��� ����� ���� 
   ���������� ������.

           userclientrc=$HOME/.xinitrc
           userserverrc=$HOME/.xserverrc
           sysclientrc=/usr/X11R6/lib/X11/xinit/xinitrc
           sysserverrc=/usr/X11R6/lib/X11/xinit/xserverrc
           defaultclient=/usr/X11R6/bin/xterm
           defaultserver=/usr/X11R6/bin/X
           defaultclientargs=""
           defaultserverargs="-dpi 96" #<--- �������� ��� �������� ��� ������
           clientargs=""
           serverargs=""


   ���������� �������� "-dpi 96" � ������ defaultserverargs=

   c) ���� ������������ Gnome, �� ���������� ������ �� ����������� ����� 
   ������������. � ���������� Gnome/Desktop Prefs/Fonts/Details �����
   �������� ����� DPI ������ �������� �� 96. ���� Gnome �� ������������, 
   �� ����������� ����� gnome-setting ��� �������� ���������� ��
   Gnome � KDE, ��� ������������ ���������� �� Gnome, �����, ���
   evolution, ���������� ��������� ��� ��������.


------------------------------------------------------------------------------
-
������: locale -a | grep ru

���� ��� ���� 'ru_RU.CP1251', �� ��� ������

������: localedef -c -i ru_RU -f CP1251 ru_RU.CP1251
���� ������� ����� ������ 
cannot read character map directory 
`/usr/share/i18n/charmaps': No such file or directory
�� ��������� ������ glibc-i18ndata-2.2.4-77 icu-i18ndata-1.7-92 
(��� ������ ������)

���� � /usr/lib/locale

���� ��� �������� ������� 'ru_RU.cp1251', �������� � 'ru_RU.CP1251' (���������������������)

������ 'locale -a | grep ru' � ����������, ��� 'ru_RU.CP1251' ������
