unit uLinuxProxy;

interface
uses Proxy, ExtCtrls, MappedPorts, IPInfo;

type


   TLinuxProxy = class(TProxy)
   protected
   //��������� ���������
      FTimer: TTimer;

   public
   //�����������/���������� - ��� �������� ����� ������ ����������� :))
      constructor Create;
      destructor Destroy; override;

      procedure Start; override;  //�������� ������ (������������ ������� �������� ������)
      procedure Stop; override;   //��������� ������ (������������ ������� �������������
                        // ������, ��������� �����������)
      procedure Reset; override;  //����� �������� (� ������� � ��������� � ������ IP)
//      procedure IPAdd(Addr : String);  //�������� IP (disabled)
      procedure IPEnable(AstrAddr: String; AstrTarifName: String); override;  //�������� IP
      procedure IPDisable(Addr : String); override; //��������� IP
//      function IPEnabled(Addr : String):Boolean;  //��������� IP
//      function IPAdded(Addr : String):Boolean;  //���������� �� � ������?
      procedure MappingAdd(ServerPort : Word; MappedAddr : String;
         MappedPort : Word);  override; //����� ������������ ��� �������� ������ ������-��������
{      procedure IPTrafficReset(Addr : String); // �������� ���� ������ � ����
      function IPTrafficGetIn(Addr : String) : Cardinal; // �������� ��������
                                                //��������� ������� � ������
      function IPTrafficGetOut(Addr : String) : Cardinal;// �������� ��������
                                                //���������� ������� � ������
 }
      procedure OnChangeTimer(Sender: TObject);
      procedure IPSetSpeedLimit(AstrAddr: String;
          AnSpeedLimit: Integer); override;
      procedure IPSetGroup(AstrAddr: String; AstrGroup: String); override;
      procedure IPSetTrafficLimit(AstrAddr: String;
          AnTrafficLimit: Integer); override;

   end;

implementation

uses
  frmMain,
  gccomputers,
  uProtocol,
  SysUtils,
  gcconst,
  uRegistry,
  uY2KString;
////////////////////////////////////////////////////////////////////////////////
//                                   TLinuxProxy
////////////////////////////////////////////////////////////////////////////////
constructor TLinuxProxy.Create;
begin
   inherited Create;
   FTimer := TTimer.Create(Nil);
   FTimer.Interval := GRegistry.Options.UnixServerQueryTime*1000;//5000; //������ ���� ������
   FTimer.OnTimer := OnChangeTimer;
end;

destructor TLinuxProxy.Destroy;
begin
   FTimer.Free;
   inherited Destroy;
end;

procedure TLinuxProxy.Start;
begin
   FTimer.Enabled := True;
end;

procedure TLinuxProxy.Stop;
begin
   FTimer.Enabled := False;
end;

procedure TLinuxProxy.Reset;
begin
   FIPList.Clear;
end;

procedure TLinuxProxy.IPEnable(AstrAddr: String; AstrTarifName: String);  //�������� IP
begin
  UDPSend(GRegistry.Options.UnixServerIP,
      STR_CMD_INETUNBLOCK
      + AstrAddr + '/'+AstrTarifName);
  FIPList.Enable(AstrAddr);
end;

procedure TLinuxProxy.IPDisable(Addr : String);
begin
  FIPList.Disable(Addr);
  UDPSend(GRegistry.Options.UnixServerIP,
      STR_CMD_INETBLOCK + Addr);
end;

procedure TLinuxProxy.MappingAdd(ServerPort : Word; MappedAddr : String; MappedPort : Word);
var
  i,nCount: Integer;
  strIPAddr, strTrafficIn, strTrafficOut: String;
begin
  nCount := GetParamCountFromString(MappedAddr) div 3;
  for i:=0 to nCount-1 do begin
    strIPAddr := GetParamFromString(MappedAddr,i*3);
    strTrafficIn := GetParamFromString(MappedAddr,i*3+1);
    strTrafficOut := GetParamFromString(MappedAddr,i*3+2);
    if (strIPAddr<>PARAM_NOT_EXISTS) and
      (strTrafficIn<>PARAM_NOT_EXISTS) and
      (strTrafficOut<>PARAM_NOT_EXISTS) then
      try
        FIPList.IncReceived(strIPAddr,StrToInt(strTrafficIn));
        FIPList.IncSent(strIPAddr,StrToInt(strTrafficOut));
      except
      end;
  end;
end;
procedure TLinuxProxy.OnChangeTimer(Sender: TObject);
begin
  if (GRegistry.Modules.Internet.LinuxPro
      or GRegistry.Modules.Internet.OuterPlugin) then
    UDPSend(GRegistry.Options.UnixServerIP,
        STR_CMD_GETTRAFFICVALUE);
end;

procedure TLinuxProxy.IPSetSpeedLimit(AstrAddr: String; AnSpeedLimit: Integer);
begin
  FIPList.SetSpeedLimit(AstrAddr,AnSpeedLimit);
  if GRegistry.Modules.Internet.OuterPluginSetSpeed then
    UDPSend(GRegistry.Options.UnixServerIP,
        STR_CMD_INETSETSPEEDFORIP
        + AstrAddr + '/' + IntToStr(AnSpeedLimit));
end;

procedure TLinuxProxy.IPSetGroup(AstrAddr: String; AstrGroup: String);
begin
  FIPList.SetGroup(AstrAddr, AstrGroup);
  if GRegistry.Modules.Internet.OuterPluginSetGroup then
    UDPSend(GRegistry.Options.UnixServerIP,
        STR_CMD_INETSETGROUP
        + AstrAddr + '/' + AstrGroup);
end;

procedure TLinuxProxy.IPSetTrafficLimit(AstrAddr: String;
    AnTrafficLimit: Integer);
begin
  if GRegistry.Modules.Internet.OuterPluginSetLimit then
    UDPSend(GRegistry.Options.UnixServerIP,
//        STR_CMD_INETSETGROUP]
        'inet_set_limit='
        + AstrAddr + '/' + IntToStr(AnTrafficLimit));
end;
end.
