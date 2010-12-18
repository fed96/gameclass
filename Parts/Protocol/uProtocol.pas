//////////////////////////////////////////////////////////////////////////////
//
// �������� ���������
//
//////////////////////////////////////////////////////////////////////////////

unit uProtocol;

interface

const
  // ������ ���������
  PROTOCOL_V01 = 'v01';
  // ������� ���������� �� ������� � �������
  STR_CMD_INFO            = 'info';
  // ������ ������� �� �������� ����� ���������� ������
  STR_CMD_INFO_FULL       = 'infofull';
  // �������������
  STR_CMD_BLOCKED         = 'blocked';
  // ���� �������
  STR_CMD_PING            = 'ping';
  // ����� ������
  STR_CMD_KILLTASK        = 'killtask';
  // ��������� �������
  STR_CMD_SETTIME         = 'settime';
  // ������������� !!!������: �������� True-restart, False-logoff
  STR_CMD_RESTART         = 'restart';
  // ��������� ����
  STR_CMD_SHUTDOWN        = 'shutdown';
  // �������� ������ ������������
  STR_CMD_GETHARDWARE     = 'gethardware';
  // �������� ������ ���������� �����
  STR_CMD_GETTASKSLIST    = 'gettaskslist';
  // ���������������� �������
  STR_CMD_UNINSTALL       = 'uninstall';
  // ��������/��������� ����� �����
  STR_CMD_SHELLMODE       = 'shellmode';
  // ��������� ������ �������
  STR_CMD_CLOSECLIENT     = 'closeclient';
  // �������� ��������� ����
  STR_CMD_GETEXTENDEDINFO = 'getextendedinfo';
  // ������� ��������� �� �������
  // ���/����/���������
//  STR_CMD_RECEIVEMESSAGE     = 'receivemessage';

  STR_CMD_SETVOLUME = 'setvolume';

  // ������� �����������
  // ������ �������������������
  // ���������� True - �������������, False - ������ ���������
  STR_CMD_AUTH_GOSTATE_0          = 'auth_gostate0';
  // ������ �� ��������� ��������������
  STR_CMD_AUTH_QUERYSTATE_1       = 'auth_querystate1';
  // ������� � ��������� �����������,
  // ���������� ����� ���������� ����� ���. ����
  STR_CMD_AUTH_GOSTATE_1          = 'auth_gostate1';
  // ������ ����������� (���������� ������, ���, ���.���)
  STR_CMD_AUTH_QUERYSTATE_2       = 'auth_querystate2';
  // �������� ������/���/��� � �.�. ���������� ���� �������� ������
  STR_CMD_AUTH_FAILEDLOGGING_2    = 'auth_failedpass2';
  // ����������� �������, ������� � ��������� ������
  // (� ��� ����� ���������� 60 ���),
  // ���������� ���������� �����/������/������_�������
  STR_CMD_AUTH_GOSTATE_2          = 'auth_gostate2';
  // ������ �������
  STR_CMD_AUTH_QUERYTARIFS_2      = 'auth_querytarifs2';
  // ������� ���������� ������
  STR_CMD_AUTH_RETTARIFS_2        = 'auth_rettarifs2';
  // ������ � ���������
  // ���������: ��������-������/������/�����
  // ������ ��� ����� ������ ���� ������ - ����� ��������
  STR_CMD_AUTH_QUERYCOSTTIME_2    = 'auth_querycosttime2';
  // ������� ��������� ��� ���������� ������
  // ���������: ��������-������/������
  STR_CMD_AUTH_RETCOSTTIME_2      = 'auth_retcosttime2';
  // ������ �� ������ ������
  // ���������: ���������/������/�����/�������� �����
  STR_CMD_AUTH_QUERYSTATE_3       = 'auth_querystate3';
  // ����������� �������� � ������ �����
  // ���������:  ���_������/�����/����/������/�������_������_�������/�����������
  STR_CMD_AUTH_GOSTATE_3          = 'auth_gostate3';
  // ������ � ��������� ������� ��� ������� ������
  // ���������: ������/������ � ��
  // ������ ��� ����� ������ ���� ������ - ����� ��������
  STR_CMD_AUTH_QUERYCOSTTRAFFIC_3    = 'auth_querycosttraffic3';
  // ������� ��������� ������� ��� ������� ������
  // ���������: ���������/������ � ��
  STR_CMD_AUTH_RETCOSTTRAFFIC_3      = 'auth_retcosttraffic3';
  // ��������� �� ������
  // ���������: ������
  STR_CMD_AUTH_ADDTRAFFIC_3    = 'auth_addtraffic3';
  // ������ �� ��������� �������� ������, ������� � ����� 2
  STR_CMD_AUTH_QUERYSTOP_3        = 'auth_querystop3';
  // ������������� ��������� ������
  STR_CMD_AUTH_STOPSTATE_3        = 'auth_stopstate3';
  // ������ �� ��������� ��������������
  STR_CMD_AUTH_QUERYLOGOFF        = 'auth_querylogoff';
  // �������� ������� ��������
  STR_CMD_AUTH_SENDBALANCEHISTORY = 'auth_sendbalancehistory';
  // ������ �� ����� ������
  STR_CMD_AUTH_QUERYCHANGEPASS    = 'auth_querychangepass';
  // ������ �������
  STR_CMD_AUTH_PASSCHANGED        = 'auth_passchanged';

  STR_CMD_SESSIONINFO = 'sessioninfo';   // ������� �� ������������

  // �������� �������
  STR_CMD_PLAY_SOUND = 'play_sound';
  STR_CMD_RET_PROCESSLIST = 'inet_ret_process_list';

  WAVFILE_5MINSLEFT_RU        = 'gccl_5minsleft_ru.wav';
  WAVFILE_MAXPOSTPAY_RU       = 'gccl_maxpostpay_ru.wav';
  WAVFILE_STOP_PREPAY_RU      = 'gccl_stopprepay_ru.wav';
  WAVFILE_MOVETOOTHERCOMP_RU  = 'gccl_movetoothercomp_ru.wav';
  WAVFILE_YOUAREPENALIZED_RU  = 'gccl_youarepenalized_ru.wav';
  WAVFILE_FORMINUTE_BEGIN     = 'gccl_for';
  WAVFILE_FORMINUTE_END_RU    = 'minuts_ru.wav';

  WAVFILE_5MINSLEFT_ENG       = 'gccl_5minsleft_eng.wav';
  WAVFILE_MAXPOSTPAY_ENG      = 'gccl_maxpostpay_eng.wav';
  WAVFILE_STOP_PREPAY_ENG     = 'gccl_stopprepay_eng.wav';
  WAVFILE_MOVETOOTHERCOMP_ENG = 'gccl_movetoothercomp_eng.wav';
  WAVFILE_YOUAREPENALIZED_ENG = 'gccl_youarepenalized_eng.wav';
  WAVFILE_FORMINUTE_END_ENG   = 'minuts_eng.wav';
  STR_CMD_GUESTSESSION = 'guestsession';   // ������ �������� ������
  // ��������� �� �����
  // ���������: ������
  STR_CMD_AUTH_ADDTIME_3    = 'auth_addtime3';
  // ������ � ���������
  // ���������: ������/�����
  // ������ ��� ����� ������ ���� ������ - ����� ��������
  STR_CMD_AUTH_QUERYCOSTTIME_3    = 'auth_querycosttime3';
  // ������� ��������� ��� ���������� ������
  // ���������: ������/�����
  STR_CMD_AUTH_RETCOSTTIME_3      = 'auth_retcosttime3';

  // ������� �������� ���� � �������
  // �������� ��������/��������
  STR_CMD_CLIENT_INFO_SET                 = 'client_info_set';
  // ��������� �������� ��� 'all' - ��� ���������
  STR_CMD_CLIENT_INFO_GET                 = 'client_info_get';

  // ������� ��� ��������� �������� �������
  // �������� ��������/��������
  STR_CMD_OPTION_SET                = 'option_set';
  // ��������� �������� ��� 'all' - ��� ���������
  STR_CMD_OPTION_GET                = 'option_get';

  // �������, ������� ������ GameClass �������� �������
  STR_CMD_RET_GETEXTENDEDINFO   = 'RetGetextendedinfo';
  STR_CMD_RET_PINGANSWER        = 'pinganswer';
  STR_CMD_RET_RESTARTING        = 'restarting';
  STR_CMD_RET_TASKSLIST         = 'RetTasksList';
  STR_CMD_RET_GETHARDWARE       = 'RetGetHardware';
  STR_CMD_RET_INFO              = 'RetInfo';
  // ������� ��������� � ������� �� ������
  // ���/����/���������
  STR_CMD_SENDMESSAGE     = 'sendmessage';


  // �������� ��� Linux-�������
  STR_CMD_INETBLOCK   = 'inet_block=';
  STR_CMD_INETUNBLOCK = 'inet_unblock=';
  // ��� ����� �������� ��� Linux-�������
  //inet_set_speed_for_ip=ip/speed (���������� �������� ������� ��� IP (�� �������))
  STR_CMD_INETSETSPEEDFORIP = 'inet_set_speed_for_ip=';
  //inet_get_traffic_value (������ ���������� �� ������� ��� ���� IP)
  STR_CMD_GETTRAFFICVALUE = 'inet_get_traffic_value';
  //inet_get_traffic_value_answer (����� �� ������� ��� ���� IP)
  STR_CMD_GETTRAFFICVALUEANSWER = 'inet_get_traffic_value_answer';
  STR_CMD_INETSETGROUP = 'inet_set_group=';
  STR_CMD_INETSETLIMIT = 'inet_set_limit';

  // = - ��� ����
  // �������� ��� Linux-�������
  STR_CMD_INET_BLOCK   = 'inet_block';
  STR_CMD_INET_UNBLOCK = 'inet_unblock';
  // ��� ����� �������� ��� Linux-�������
  //inet_set_speed_for_ip=ip/speed (���������� �������� ������� ��� IP (�� �������))
  STR_CMD_INET_SETSPEEDFORIP = 'inet_set_speed_for_ip';
  //inet_get_traffic_value (������ ���������� �� ������� ��� ���� IP)
  STR_CMD_INET_GETTRAFFICVALUE = 'inet_get_traffic_value';
  //inet_get_traffic_value_answer (����� �� ������� ��� ���� IP)
  STR_CMD_INET_GETTRAFFICVALUEANSWER = 'inet_get_traffic_value_answer';
  STR_CMD_INET_SETGROUP = 'inet_set_group';
  STR_CMD_INET_SETLIMIT = 'inet_set_limit';

implementation

end.
