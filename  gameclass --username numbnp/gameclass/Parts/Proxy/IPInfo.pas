unit IPInfo;

interface

uses Classes;

type
   TIPInfo = class(TCollectionItem)  //���������� �� ip-������
   public
      Addr     : String;   //ip-�����
      Enabled  : Boolean;  //���� ���������� � ���������
      BytesReceived  : Cardinal; //���-�� �������� ����
      BytesSent      : Cardinal; //���-�� ���������� ����
      SpeedLimit      : Cardinal; //����������� ��������
      TrafficLimit    : Cardinal; //������ �������
      Group      : String; //������ (���� ������ ��� TI � UG)
   end;
   TIPInfoPtr = ^TIPInfo;//��� ��������� �� ���������� �� ip-������

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
   TIPInfoList = class(TCollection) //�����, ������ ���������� �� ip-�������
   public
   //������ ���������
   //�����������/����������
      constructor Create;
      destructor Destroy; override;
  //��������� ������
      function Index(Addr:string):integer; //������� ������ �� ������
      procedure Add(Addr:string);  //�������� ����� ������ ��� �� �������� ���� ����
//      function Get(Addr:string):TIPInfoPtr; //������� ptr ������ �� ������
      function Enabled(Addr:string):Boolean; //�������� �������� ?
      procedure Enable(Addr:string); //��������� �������� ��� ip
      procedure Disable(Addr:string); //��������� �������� ��� ip
      procedure SetSpeedLimit(AstrAddr: String; AnSpeedLimit: Integer);
      procedure SetGroup(AstrAddr: String; AstrGroup: String);
      procedure SetTrafficLimit(AstrAddr: String; AnTrafficLimit: Integer);
      function MappingEnabled :Boolean; //�������� ������� ����
      procedure EnableMapping; //��������� ������� ����
      procedure DisableMapping; //��������� ������� ����
      procedure IncReceived(Addr:string;Count:Cardinal); //��������� ��.������
      procedure IncSent(Addr:string;Count:Cardinal); //��������� ���.������
      procedure IPTrafficReset(Addr:string); //�������� ������ � 0
      function IPTrafficGetIn(Addr: String) : Cardinal; // �������� �������� ��������� �������� � ������
      function IPTrafficGetOut(Addr: String) : Cardinal;

      function GetItem(Index: Integer): TIPInfo ;
      procedure SetItem(Index: Integer; Value: TIPInfo);

   private
      FEnabled : Boolean;   //���� ������������
      property Items[Index: Integer]:TIPInfo read GetItem write SetItem; default;
   end;
   TIPInfoListPtr = ^TIPInfoList;//��� ��������� �� ������ ip-�������

implementation
///////////////////////////////////////////////////////////////////////////////
//                              TIPInfoList
////////////////////////////////////////////////////////////////////////////////

constructor TIPInfoList.Create;
begin
   inherited Create(TIPInfo);
   FEnabled := False;
end;

destructor TIPInfoList.Destroy;
begin
   Clear;
   inherited Destroy;
end;

function TIPInfoList.Index(Addr:string):integer;
var
   i : Integer;
begin
   Result := -1;
   for i := 0 to Count-1 do
      if Items[i].Addr = Addr then
         Result := i;
end;

procedure TIPInfoList.Add(Addr:string);
var
   i : Integer;
   IPInfo : TIPInfo;
begin
   i := Index(Addr);
   if i=-1 then begin
      IPInfo := TIPInfo(inherited Add);
      IPInfo.Addr := Addr;
      IPInfo.Enabled := False;
      IPInfo.BytesReceived := 0;
      IPInfo.BytesSent := 0;
      IPInfo.SpeedLimit := 0;
      IPInfo.Group := '';
   end;
end;

function TIPInfoList.GetItem(Index: Integer): TIPInfo;
begin
  Result := TIPInfo(inherited Items[Index]);
end;

procedure TIPInfoList.SetItem(Index: Integer; Value: TIPInfo);
begin
  Items[Index].Assign(Value);
end;

function TIPInfoList.Enabled(Addr:string):Boolean;
var
   n:integer;
begin
   Result := False;
   n:=Index(Addr);
   if n <> -1 then
      if Items[n].Enabled then
         Result := True;
end;

procedure TIPInfoList.Enable(Addr:string);
var
   n:integer;
begin
   n:=Index(Addr);
   if n <> -1 then
      Items[n].Enabled := True;
end;

procedure TIPInfoList.Disable(Addr:string);
var
   n:integer;
begin
   n:=Index(Addr);
   if n <> -1 then
      Items[n].Enabled := False;
end;

function TIPInfoList.MappingEnabled:Boolean;
begin
   Result := FEnabled;
end;

procedure TIPInfoList.EnableMapping;
begin
   FEnabled := True;
end;

procedure TIPInfoList.DisableMapping;
begin
   FEnabled := False;
end;

procedure TIPInfoList.IncReceived(Addr:string;Count:Cardinal);
var
   n:integer;
begin
   n:=Index(Addr);
   if n <> -1 then
      Items[n].BytesReceived := Items[n].BytesReceived + Count;
end;

procedure TIPInfoList.IncSent(Addr:string;Count:Cardinal);
var
   n:integer;
begin
   n:=Index(Addr);
   if n <> -1 then
      Items[n].BytesSent := Items[n].BytesSent + Count;
end;

procedure TIPInfoList.IPtrafficReset(Addr:string);
var
   n:integer;
begin
   n:=Index(Addr);
   if n <> -1 then begin
      Items[n].BytesSent := 0;
      Items[n].BytesReceived := 0;
   end;
end;

function TIPInfoList.IPTrafficGetIn(Addr : String) : Cardinal;
var
   n:integer;
begin
   n:=Index(Addr);
   if n <> -1 then begin
      Result := Items[n].BytesReceived;
      Items[n].BytesReceived := 0;
   end
   else
      Result := 0;
end;

function TIPInfoList.IPTrafficGetOut(Addr : String) : Cardinal;
var
   n:integer;
begin
   n:=Index(Addr);
   if n <> -1 then begin
      Result := Items[n].BytesSent;
      Items[n].BytesSent := 0;
   end
   else
      Result := 0;
end;

procedure TIPInfoList.SetSpeedLimit(AstrAddr: String; AnSpeedLimit: Integer);
var
   n:integer;
begin
   n:=Index(AstrAddr);
   if n <> -1 then
      Items[n].SpeedLimit := AnSpeedLimit;
end;

procedure TIPInfoList.SetGroup(AstrAddr: String; AstrGroup: String);
var
   n:integer;
begin
   n:=Index(AstrAddr);
   if n <> -1 then
      Items[n].Group := AstrGroup;
end;

procedure TIPInfoList.SetTrafficLimit(AstrAddr: String; AnTrafficLimit: Integer);
var
   n:integer;
begin
   n:=Index(AstrAddr);
   if n <> -1 then
      Items[n].TrafficLimit := AnTrafficLimit;
end;


end.
