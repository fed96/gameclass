unit Proxy;

interface
uses Dialogs, MappedPorts, IPInfo;

type


   TProxy = class
   protected
   //��������� ���������
      FIPList : TIPInfoList;  //������ ip-�������
      FMappedPorts: TMappedPorts;      //��������� "��������", ��������� �����
//                                     //(listen) � ��������� ��������

   public
   //�����������/���������� - ��� �������� ����� ������ ����������� :))
      constructor Create;
      destructor Destroy; override;

      procedure Start; virtual;  //�������� ������ (������������ ������� �������� ������)
      procedure Stop; virtual;  //��������� ������ (������������ ������� �������������
                        // ������, ��������� �����������)
      procedure Reset; virtual; //����� �������� (� ������� � ��������� � ������ IP)
      procedure IPAdd(Addr : String);  //�������� IP (disabled)
      procedure IPEnable(AstrAddr: String; AstrTarifName: String); virtual; //�������� IP
      procedure IPDisable(Addr : String); virtual;//��������� IP
      function IPEnabled(Addr : String):Boolean;  //��������� IP
      function IPAdded(Addr : String):Boolean;  //���������� �� � ������?
      procedure MappingAdd(ServerPort : Word; MappedAddr : String;
         MappedPort : Word); virtual; //�������� �������
      procedure IPTrafficReset(Addr : String); // �������� ���� ������ � ����
      function IPTrafficGetIn(Addr : String) : Cardinal; // �������� ��������
                                                //��������� ������� � ������
      function IPTrafficGetOut(Addr : String) : Cardinal;// �������� ��������
                                                //���������� ������� � ������
      // �������� �������������� ��������
      function IPTrafficGetTraffic(Addr : String) : Cardinal;
      procedure IPSetSpeedLimit(AstrAddr: String;
          AnSpeedLimit: Integer); virtual;
      procedure IPSetGroup(AstrAddr: String; AstrGroup: String); virtual;
      procedure IPSetTrafficLimit(AstrAddr: String;
          AnTrafficLimit: Integer); virtual;

   end;

implementation

uses
  uRegistry,
  uRegistryInternet;
////////////////////////////////////////////////////////////////////////////////
//                                   TProxy
////////////////////////////////////////////////////////////////////////////////
constructor TProxy.Create;
begin
   inherited Create;
   FIPList := TIPInfoList.Create;
   FMappedPorts := TMappedPorts.Create(FIPList);
end;

destructor TProxy.Destroy;
begin
   FMappedPorts.Free;
   FIPList.Free;
   inherited Destroy;
end;

procedure TProxy.Start;
begin
   FIPList.EnableMapping;
end;

procedure TProxy.Stop;
begin
   FIPList.DisableMapping;
   FMappedPorts.DisconnectAll;
end;

procedure TProxy.Reset;
begin
   FIPList.DisableMapping;
   FMappedPorts.DisconnectAll;
   FMappedPorts.Clear;
   FIPList.Clear;
end;

procedure TProxy.IPAdd(Addr : String);
begin
   FIPList.Add(Addr);
end;

procedure TProxy.IPEnable(AstrAddr: String; AstrTarifName: String);  //�������� IP
begin
   FIPList.Enable(AstrAddr);
end;

procedure TProxy.IPDisable(Addr : String);
begin
   FIPList.Disable(Addr);
   FMappedPorts.DisconnectByIP(Addr);
end;

procedure TProxy.MappingAdd(ServerPort : Word; MappedAddr : String; MappedPort : Word);
begin
   FMappedPorts.Add(ServerPort,MappedAddr,MappedPort);
end;

procedure TProxy.IPTrafficReset(Addr : String); // �������� ���� (���/����) ������� � ����
begin
   FIPList.IPTrafficReset(Addr);
end;

function TProxy.IPTrafficGetIn(Addr : String) : Cardinal; // �������� �������� ��������� �������� � ������
begin
  Result := FIPList.IPTrafficGetIn(Addr);
end;

function TProxy.IPTrafficGetOut(Addr : String) : Cardinal;
begin
  Result := FIPList.IPTrafficGetOut(Addr);
end;

function TProxy.IPTrafficGetTraffic(Addr : String) : Cardinal;
var
  nInbound, nOutbound: Cardinal;
begin
  Result := 0;
  nInbound := FIPList.IPTrafficGetIn(Addr);
  nOutbound := FIPList.IPTrafficGetOut(Addr);
  case GRegistry.Modules.Internet.TariffingMode of
    tmOnlyInbound: Result := nInbound;
    tmSummary: Result := nInbound + nOutbound;
    tmMaximum:
      if (nInbound > nOutbound) then
        Result := nInbound
      else
        Result := nOutbound;
  end;
end;

function TProxy.IPAdded(Addr : String):Boolean;
begin
   if FIPList.Index(Addr)= -1 then
      Result := False
   else
      Result := True;
end;

function TProxy.IPEnabled(Addr : String):Boolean;
begin
   Result := FIPList.Enabled(Addr);
end;

procedure TProxy.IPSetSpeedLimit(AstrAddr: String; AnSpeedLimit: Integer);
begin
   FIPList.SetSpeedLimit(AstrAddr,AnSpeedLimit);
end;

procedure TProxy.IPSetGroup(AstrAddr: String; AstrGroup: String);
begin
   FIPList.SetGroup(AstrAddr, AstrGroup);
end;

procedure TProxy.IPSetTrafficLimit(AstrAddr: String; AnTrafficLimit: Integer);
begin
   FIPList.SetTrafficLimit(AstrAddr, AnTrafficLimit);
end;
end.
