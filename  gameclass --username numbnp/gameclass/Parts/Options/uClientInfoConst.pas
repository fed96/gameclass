//////////////////////////////////////////////////////////////////////////////
//
// ������ �������� ��������� ��� ������ TClientInfo.
//
//////////////////////////////////////////////////////////////////////////////

unit uClientInfoConst;

interface

const
  // �������� �� ��������� ��� �����
  DEF_BLOCKED = TRUE;
//  DEF_CLIENT_STATE = ClientState_Blocked;
  DEF_LOGIN = '�����';
  DEF_BALANCE = 0;
  DEF_BALANCE_LIMIT = 0;
  DEF_BALANCE_HISTORY = '';
  DEF_INFO = '����������� ����������� � ������� GameClass 3';
  DEF_INFO_FULL = '����������� ����������� � ������� GameClass 3';
  DEF_SUM = 0;
  DEF_START = 0;
  DEF_STOP = 0;
  DEF_TARIF_NAME = '';
  DEF_PACKET_TARIF = FALSE;
  DEF_TRAFIIC_SEPARATE_PAYMENT = FALSE;
  DEF_SEC_CODE = 0;
  DEF_UNBLOCKED_BY_PASSWORD = FALSE;
  DEF_INTERNET = FALSE;
  DEF_INTERNET_AVAILABLE = 0;
  DEF_INTERNET_USED = 0;
  DEF_RUNPAD_HIDED_TABS = '';
  DEF_DISCONNECTED = False;
  DEF_AFTER_STOP_ACTION_NEEDED = FALSE;

  INFO_GENERAL_FOLDER = 'ClientInfo';

type

  // ������������ ��������� �����������
  TClientState = (
      ClientState_Blocked,          // �������������
      ClientState_Authentication,   // ����� ����������
      ClientState_Order,            // ���������, ����� ������
      ClientState_Session,          // ���������, ������
      ClientState_Agreement,        // ���������, ����� ������, ����������
      ClientState_OperatorSession,   // ������, ������������ ����������
      ClientState_OperatorAgreement, // ���������� ������ ���������
      ClientState_OperatorAgreementAccepted, // ���������� �������
                                            // (���� ������ ������ �������)
      ClientState_AgreementAccepted,// ���������� �������� �������
                                    // (���� ������ ������ �������)
      ClientState_NotInitialized          // ��� �� ���������������

  );


implementation
end.


