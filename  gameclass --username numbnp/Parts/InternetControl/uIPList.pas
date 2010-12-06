unit uIPList;

interface

uses Classes;

type
  TIPInformation = class(TCollectionItem)  //���������� �� ip-������
  private
    FstrIP            : String;   //ip-�����
    FstrName          : String;   //���������� ���
    FstrExtraInfo   : String;   //���������� GUID � TI, INI-������ � UG 2.8
    FstrGroup         : String;   //������ (���� ������ ��� TI � UG)
    FstrTarif         : String;   //�������� ������
    FstrServerIP      : String;   //����� ������� (����� ��� ���� � ����� ��������)
    FbEnabled       : Boolean;  //���� ���������� � ������
    FnTotalBytesReceived  : Cardinal; //���-�� �������� ����
    FnTotalBytesSent      : Cardinal; //���-�� ���������� ����
    FnCurrentBytesReceived  : Cardinal; //���-�� �������� ����
    FnCurrentBytesSent      : Cardinal; //���-�� ���������� ����
    FnSpeedLimit    : Cardinal; //�������� � ������ � �������, 0 - unlimited
    FnTrafficLimit  : Cardinal; //����������� �������, 0 - unlimited
  public
    constructor Create(Collection: TCollection); override;

    procedure Enable; //��������� �������� ��� ip
    procedure Disable; //��������� �������� ��� ip
    procedure SetReceived(AnCount: Cardinal); //��������� ��.������
    procedure SetSent(AnCount: Cardinal); //��������� ���.������
    function UnloadReceived: Cardinal; //������� ���. ��.������ � �������� ���
    function UnloadSent: Cardinal; //������� ���.������ � �������� ��� � ����

    property IP: String
        read FstrIP write FstrIP;
    property Name: String
        read FstrName write FstrName;
    property ExtraInfo: String
        read FstrExtraInfo write FstrExtraInfo;
    property Group: String
        read FstrGroup write FstrGroup;
    property Tarif: String
        read FstrTarif write FstrTarif;
    property ServerIP: String
        read FstrServerIP write FstrServerIP;
    property Enabled: Boolean
        read FbEnabled write FbEnabled;
    property TotalBytesReceived: Cardinal
        read FnTotalBytesReceived write FnTotalBytesReceived;
    property TotalBytesSent: Cardinal
        read FnTotalBytesSent write FnTotalBytesSent;
    property CurrentBytesReceived: Cardinal
        read FnCurrentBytesReceived write FnCurrentBytesSent;
    property CurrentBytesSent: Cardinal
        read FnCurrentBytesSent write FnCurrentBytesSent;
    property SpeedLimit: Cardinal
        read FnSpeedLimit write FnSpeedLimit;
    property TrafficLimit: Cardinal
        read FnTrafficLimit write FnTrafficLimit;
  end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
  TIPInformations = class(TCollection) //�����, ������ ���������� �� ip-�������
  public
  //�����������/����������
    constructor Create;
    destructor Destroy; override;
  //��������� ������
    //������� ������ �� ������
    function Index(const AstrIP: String):integer;
    //�������� ����� ������ ��� �� �������� ���� ����
    function Add(const AstrIP: String): TIPInformation;
    function GetItem(const AnIndex: Integer): TIPInformation;
    function GetItemByIP(const AstrIP: String): TIPInformation;
    function GetSerializedList: String;
    procedure SetSerializedList(AstrList: String);

  //��������
    property Items[const AnIndex: Integer]: TIPInformation
        read GetItem; default;
    property ItemsByIP[const AstrIP: String]: TIPInformation
        read GetItemByIP;
    property SerializedList: String
        read GetSerializedList write SetSerializedList ;
  end;

implementation
uses
  uY2KString,
  StrUtils;

const
  PARAMETER_DIVIDER_SYMBOL = '|';
  ITEM_DIVIDER_SYMBOL = '&';
///////////////////////////////////////////////////////////////////////////////
//                              TIPInformation
////////////////////////////////////////////////////////////////////////////////
constructor TIPInformation.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FstrIP := '';
  FstrName := '';
  FstrExtraInfo := '';
  FstrGroup := '';
  FstrTarif := '';
  FstrServerIP := '';
  FbEnabled := False;
  FnTotalBytesReceived := 0;
  FnTotalBytesSent := 0;
  FnCurrentBytesReceived := 0;
  FnCurrentBytesSent := 0;
  FnSpeedLimit := 0;
  FnTrafficLimit := 0;
end;

procedure TIPInformation.Enable;
begin
  Enabled := True;
end;

procedure TIPInformation.Disable;
begin
  Enabled := False;
end;

procedure TIPInformation.SetReceived(AnCount: Cardinal);
begin
  if (FnTotalBytesReceived <= AnCount) then begin
    FnCurrentBytesReceived := FnCurrentBytesReceived + AnCount - FnTotalBytesReceived;
    FnTotalBytesReceived := AnCount;
  end
  else begin
    FnCurrentBytesReceived := AnCount;
    FnTotalBytesReceived := AnCount;
  end;
end;

procedure TIPInformation.SetSent(AnCount: Cardinal);
begin
  if (FnTotalBytesSent <= AnCount) then begin//���������� ��� ��� ����� TI ����� ���������� �������
    FnCurrentBytesSent := FnCurrentBytesSent + AnCount - FnTotalBytesSent;
    FnTotalBytesSent := AnCount;
  end
  else begin
    FnCurrentBytesSent := AnCount;
    FnTotalBytesSent := AnCount;
  end;
end;

function TIPInformation.UnloadReceived: Cardinal;
begin
  Result := FnCurrentBytesReceived;
  FnTotalBytesReceived := 0;
end;

function TIPInformation.UnloadSent: Cardinal;
begin
  Result := FnCurrentBytesSent;
  FnTotalBytesSent := 0;
end;

///////////////////////////////////////////////////////////////////////////////
//                              TIPInformations
////////////////////////////////////////////////////////////////////////////////

constructor TIPInformations.Create;
begin
   inherited Create(TIPInformation);
end;

destructor TIPInformations.Destroy;
begin
   Clear;
   inherited Destroy;
end;

function TIPInformations.Index(const AstrIP: String):integer;
var
   i : Integer;
begin
   Result := -1;
   for i := 0 to Count-1 do
      if Items[i].IP = AstrIP then
         Result := i;
end;

function TIPInformations.Add(const AstrIP: String): TIPInformation;
var
  i : Integer;
  IPInformation : TIPInformation;
begin
  i := Index(AstrIP);
  if i=-1 then begin
    IPInformation := TIPInformation(inherited Add);
    with IPInformation do begin
      IP := AstrIP;
      Name := AstrIP;
    end;
    Result := IPInformation;
  end else
    Result := TIPInformation(inherited Items[i]);
end;

function TIPInformations.GetItem(const AnIndex: Integer): TIPInformation;
begin
  Result := TIPInformation(inherited Items[AnIndex]);
end;

function TIPInformations.GetItemByIP(const AstrIP: String): TIPInformation;
begin
  Result := Add(AstrIP);
end;

function TIPInformations.GetSerializedList: String;
var
  strList: String;
  i: Integer;
begin
  for i:=0 to Count do
    with GetItem(i) do
      strList := strList + IP + PARAMETER_DIVIDER_SYMBOL + Name
         + PARAMETER_DIVIDER_SYMBOL + ExtraInfo + ITEM_DIVIDER_SYMBOL;
  System.Delete(strList, Length(strList)-1, 1);
  Result := strList;
end;

procedure TIPInformations.SetSerializedList(AstrList: String);
var
  str: String;
  i, nCount: Integer;
begin
  Clear;
  nCount := GetParamCountFromString(AstrList, ITEM_DIVIDER_SYMBOL);
  for i := 0 to nCount - 1 do begin
    str := GetParamFromString(AstrList, i, ITEM_DIVIDER_SYMBOL);
    with Add(GetParamFromString(str, 0, PARAMETER_DIVIDER_SYMBOL)) do begin
      Name := GetParamFromString(str, 1, PARAMETER_DIVIDER_SYMBOL);
      ExtraInfo := GetParamFromString(str, 2, PARAMETER_DIVIDER_SYMBOL);
    end;
  end;
end;

end.
