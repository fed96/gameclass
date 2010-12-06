unit uErrors;

interface

uses
  Classes;
  
resourcestring
  //����� ������ 0-100
  ERR_CAPTION = '������';
  ERR_UNKNOWN = '����������� ������';
  ERR_CRITICAL = '����������� ������';
  //SQL ������ 100-200
  ERR_SQLSERVER_NOT_EXIST = '������ ����������� � SQL-�������.' + #13#10
      + 'C����� �� ����������/�� ��� ����������/����������� GameClass3 '
      + '���� ��������� �������.';
  ERR_SQLSERVER_PASSWORD_INCORRECT = '������ �������� ������.';
  //���������� ������ 200-300
  ERR_EXEFILE_CORRUPT = '�������� ����������� ����� GCServer.exe';
  ERR_SOCKET = '���������� ������� ������ ��� UDP-����� 3775! '
      + '��������, Gameclass ��� ������� ��� ����������,'#13#10
      + '�����-���� ������ ���������� ������ ���� ���� '
      + '��� ��������� ��������� ��������� ��� �������.';
const
  //����� ������ 0-100
  ERRNUM_DEFAULT = 0;
  //SQL ������ 100-200
  ERRNUM_SQLSERVER_NOT_EXIST = 100;
  ERRNUM_SQLSERVER_PASSWORD_INCORRECT = 101;

type
  TErrorEvent = procedure(const Sender: TObject;
      const AnErrorNumber: Integer; const AlstError: TStringList) of object;

implementation

end.
