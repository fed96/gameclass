unit uHardwareAnalizer;

interface

uses
  DB, ADODB,
  XMLDoc,
  XMLIntf;


procedure AnalyzeHardware(AstrHardwareReport: String; AnComputerIndex: Integer);
function ParseHardwareNode(const AXMLNode: IXMLNode;
    var AstrName: String;
    var AstrDescription: String;
    var AstrXML: String): Boolean;
procedure ProcesHardwareNode(const AXMLNode: IXMLNode;
    var AdtsOldHardware: TADODataSet;
    const AnComputerIndex: Integer);
procedure SaveHardwareChangesToDB(const AnComputerIndex: Integer;
    const AstrName: String;
    const AstrDescription: String;
    const AstrXML: String;
    const AbAdded: Boolean
    );


implementation

uses
  StrUtils,
  SysUtils,
  uHWConst,
  uY2KString,
  gccomputers,
  gccommon,
  gcconst,
  frmMain,
  gclangutils,
  uVirtualTime;


procedure ProcesHardwareNode(const AXMLNode: IXMLNode;
    var AdtsOldHardware: TADODataSet;
    const AnComputerIndex: Integer);
var
  strName: String;
  strDescription: String;
  strXML: String;
  strDBName: String;
  strDBXML: String;
  bNeedInsert: Boolean;
  t: Integer;
begin
  bNeedInsert := True;
  ParseHardwareNode(AXMLNode, strName, strDescription, strXML);
  if not AdtsOldHardware.IsEmpty then begin
    AdtsOldHardware.First;
    while (not AdtsOldHardware.Eof) do
    begin
      strDBName := AdtsOldHardware.FieldValues['name'];
      strDBXML := AdtsOldHardware.FieldValues['FullInfo'];
      if (strName = strDBName) then begin
        if (strXML = strDBXML) then
          bNeedInsert := False
        else
          SaveHardwareChangesToDB(AnComputerIndex, strName,
              AdtsOldHardware.FieldValues['hw_value'],
              AdtsOldHardware.FieldValues['FullInfo'], False);
        // ��� ������� ��� ����������� ��� ��� ����
        AdtsOldHardware.Edit;
        AdtsOldHardware.FieldValues['histored'] := 1;
        AdtsOldHardware.Post;
      end;
      AdtsOldHardware.Next;
    end;
  end;
  if bNeedInsert then
    SaveHardwareChangesToDB(AnComputerIndex, strName, strDescription,
        strXML, True);
end;
function ParseHardwareNode(const AXMLNode: IXMLNode;
    var AstrName: String;
    var AstrDescription: String;
    var AstrXML: String): Boolean;
begin
  Result := False;
  AstrName := AXMLNode.NodeName;
  AstrXML := AXMLNode.XML;
  if (AstrName = SYSTEM_TAG) then
      AstrDescription := AXMLNode.Attributes['ComputerName'] + ' MB:'
          + RemoveBlanks(AXMLNode.Attributes['MBSerialNumber']) + ' BIOS:'
          + RemoveBlanks(AXMLNode.Attributes['BIOSVersion'])
  else if (AstrName = CPU_TAG) then
      AstrDescription := RemoveBlanks(AXMLNode.Attributes['Name']) + ' '
          + RemoveBlanks(AXMLNode.Attributes['ProcessorId'])
  else if (AstrName = MEMORY_TAG) then
      AstrDescription := AXMLNode.Attributes['BankLabel'] + ' '
          + AXMLNode.Attributes['Name'] + ' '
          + GetShortSizeString(AXMLNode.Attributes['Capacity']) + ' '
          + AXMLNode.Attributes['Speed']
          + IfThen(Length(AXMLNode.Attributes['Speed'])>0,' MHz','')
  else if (AstrName = VIDEO_TAG) then
      AstrDescription := AXMLNode.Attributes['Name'] + ' '
          + GetShortSizeString(AXMLNode.Attributes['RAMCapacity'])
  else if (AstrName = HDD_TAG) then
      AstrDescription := AXMLNode.Attributes['Name'] + ' '
          + AXMLNode.Attributes['Caption'] + ' '
          + GetShortSizeString(AXMLNode.Attributes['Size'])
  else if (AstrName = CDROM_TAG) then
      AstrDescription := AXMLNode.Attributes['MediaType'] + ' '
          + AXMLNode.Attributes['Name']
  else if (AstrName = FLOPPY_TAG) then
      AstrDescription := AXMLNode.Attributes['Name'] + ' '
          + AXMLNode.Attributes['DeviceId']
  else if (AstrName = NETWORK_TAG) then
      AstrDescription := AXMLNode.Attributes['Caption'] + ' '
          + AXMLNode.Attributes['MACAddress']
  else if (AstrName = SOUND_TAG) then
      AstrDescription := AXMLNode.Attributes['Name'];
  if (AstrName <> SYSTEM_TAG) and (AstrName <> VIDEO_TAG) then
    AstrName := AstrName + AXMLNode.Attributes['Id'];
  Result := True;
end;

procedure AnalyzeHardware(AstrHardwareReport: String; AnComputerIndex: Integer);
var
  i,j: integer;
  dtsOldHardware: TADODataSet;
  dtsOldHardwareLocal: TADODataSet;

  XMLDoc: TXMLDocument;
  NodeList, ChildNodeList: IXMLNodeList;
  Node: IXMLNode;
  n:Integer;
  strXML, strNodeName: String;

begin
  // 1. ������ �� ���� ������ ������
  dtsOldHardware := TADODataSet.Create(nil);
  dsDoQuery(DS_HARDWARE_SELECT + ' @idComputers='
      + IntToStr(Comps[AnComputerIndex].number), @dtsOldHardware);
//  dtsOldHardware := dtsOldHardware2;
//  dtsOldHardware.StoreDefs := True;
  dtsOldHardwareLocal := TADODataSet.Create(nil);
  dtsOldHardwareLocal.FieldDefs :=   dtsOldHardware.FieldDefs;
  dtsOldHardwareLocal.CreateDataSet;
  if not dtsOldHardware.IsEmpty then
    while (not dtsOldHardware.Eof) do begin
      dtsOldHardwareLocal.Append;
      dtsOldHardwareLocal.FieldValues['id'] :=
          dtsOldHardware.FieldValues['id'];
      dtsOldHardwareLocal.FieldValues['number'] :=
          dtsOldHardware.FieldValues['number'];
      dtsOldHardwareLocal.FieldValues['name'] :=
          dtsOldHardware.FieldValues['name'];
      dtsOldHardwareLocal.FieldValues['hw_value'] :=
          dtsOldHardware.FieldValues['hw_value'];
      dtsOldHardwareLocal.FieldValues['moment'] :=
          dtsOldHardware.FieldValues['moment'];
      dtsOldHardwareLocal.FieldValues['comment'] :=
          dtsOldHardware.FieldValues['comment'];
      dtsOldHardwareLocal.FieldValues['operator'] :=
          dtsOldHardware.FieldValues['operator'];
      dtsOldHardwareLocal.FieldValues['FullInfo'] :=
          dtsOldHardware.FieldValues['FullInfo'];
      dtsOldHardwareLocal.FieldValues['histored'] :=
          dtsOldHardware.FieldValues['histored'];
      dtsOldHardwareLocal.Post;
      dtsOldHardware.Next;
    end;

//  dtsOldHardware.Clone(dtsOldHardware2);
  //
  XMLDoc := TXMLDocument.Create(formMain);
  strXML := '<?xml version="1.0" encoding="Windows-1251"?>' +
  '<Root>'
   + AstrHardwareReport
   + '</Root>';
  // ���� �� ������ ��� ������ XMLDoc �� ���������
  strXML := AnsiReplaceStr(strXML,'&','&amp;');
  XMLDoc.LoadFromXML(strXML);
  NodeList := XMLDoc.ChildNodes;
  NodeList := XMLDoc.DocumentElement.ChildNodes;
  try
    for i:=0 to NodeList.Count-1 do begin
      Node := NodeList.Nodes[i];
      if (Node.NodeName = SYSTEM_TAG) or (Node.NodeName = VIDEO_TAG) then
        ProcesHardwareNode(Node, dtsOldHardwareLocal, AnComputerIndex)
      else
        with NodeList.Nodes[i] do begin
          for j:=0 to ChildNodes.Count-1 do
            ProcesHardwareNode(ChildNodes[j], dtsOldHardwareLocal,
                AnComputerIndex)
        end;
    end;
  except
  end;
  XMLDoc.Active := False;
  FreeAndNil(XMLDoc);
  //������ ���������� ��� ���������� �������
  if not dtsOldHardwareLocal.IsEmpty then begin
    dtsOldHardwareLocal.First;
    while (not dtsOldHardwareLocal.Eof) do begin
      if (dtsOldHardwareLocal.FieldValues['histored'] = 0)
          and (dtsOldHardwareLocal.FieldValues['comment'] <> 'REMOVED') then
        SaveHardwareChangesToDB(AnComputerIndex,
            dtsOldHardwareLocal.FieldValues['name'],
            dtsOldHardwareLocal.FieldValues['hw_value'],
            dtsOldHardwareLocal.FieldValues['FullInfo'], False);
      dtsOldHardwareLocal.Next;
    end;
  end;
  dtsOldHardwareLocal.Close;
  dtsOldHardwareLocal.Free;
  exit;
end;

procedure SaveHardwareChangesToDB(const AnComputerIndex: Integer;
    const AstrName: String;
    const AstrDescription: String;
    const AstrXML: String;
    const AbAdded: Boolean
    );
var
  strData: String;
begin
  strData := translate('Computer') + Comps[AnComputerIndex].GetStrNumber + ' '
  + IfThen(AbAdded,'ADDED','REMOVED') + ' '
  + AstrName + ' (' +AstrDescription + ')';
  dsDoCommand(DS_LOGS_INSERT + ' @prioritet=0, @message=N''' + strData
      + ''', @moment=''' + DateTimeToSql(GetVirtualTime) + '''');
  dsDoCommand(DS_HARDWARE_INSERT + ' @idComputers='
      + IntToStr(Comps[AnComputerIndex].id)
      + ', @hardware=N''' + AstrName + ''', @value=N''' + AstrDescription
      + ''', @moment=''' + DateTimeToSql(GetVirtualTime)
      + ''', @comment='''
      + IfThen(AbAdded,'ADDED','REMOVED')
      + ''', @FullInfo=''' + AstrXML + '''');
end;

end.
 