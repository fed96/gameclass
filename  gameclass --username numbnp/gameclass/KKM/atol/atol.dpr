//////////////////////////////////////////////////////////////////////////////
//
// mercury - DLL, ����������� ���������� GC � ��� ����� M
//
//
// ���������� ���������� MercFPrtVCL
//
//////////////////////////////////////////////////////////////////////////////

library atol;

uses
  Windows,
  Messages,
  FprnM1C_TLB,
  Forms,
  Math,
  Types,
  Classes,
  SysUtils,
  uY2KString in '..\..\Parts\Y2KCommon\uY2KString.pas',
  uY2KCommon in '..\..\Parts\Y2KCommon\uY2KCommon.pas';

const
  PLUGIN_NAME = '������ ���� ��� ���';
  PLUGIN_VERSION = '1.1.6';
  PLUGIN_NOTES = '������ ���� ���������� ������� ����!';
  DEF_CONFIG_TYPES = 'INTERNAL';
  DEF_CONFIG = '';


var
  FbConnected: Boolean;
  FstrConfig: String;
//  FECR: OleVariant;
  FFprnM45: TFprnM45;
  FFrm: TForm;
  FnRowCount: Integer;
  FlstErrors: TStringList;
  FstrLastError: String;
  FbRefund: Boolean;
//  FbPropertiesShowed: Boolean;
  FbCheckIsOpen: Boolean;

{$R *.res}

//��������� ������ � ������
procedure _AddError(AstrError: String);
begin
  FlstErrors.Add(AstrError);
end; // _AddError


// ������� ���.������ ��������� GameClass ��� ������ � ���
function IsKKMPlugin: Boolean; stdcall; // export
begin
  Result := True;
end; // IsKKMPlugin

// ���������� �������� ��������������� ���
function GetName: PChar; stdcall; // export
begin
  Result := PLUGIN_NAME;
end; // GetName

// ���������� ������ ������
function GetVersion: PChar; stdcall; // export
begin
  Result := PLUGIN_VERSION;
end; // GetVersion

// ���������� �������� ������������
function GetNotes: PChar; stdcall; // export
begin
  Result := PLUGIN_NOTES;
end; // GetNotes

// ���������� ������������ ����������
function GetConfigTypes: PChar; stdcall; // export
begin
  Result := DEF_CONFIG_TYPES;
end; // GetConfig

// ���������� ������������ ����������
function GetConfig: PChar; stdcall; // export
begin
  Result := PChar(FstrConfig);
end; // GetConfig

// ������������� ����� ������������ ����������
procedure SetConfig(const AstrConfig: PChar); stdcall; // export
begin
  FstrConfig := AstrConfig;
end; // SetConfig

// �������� ���������� ������ ��������� ����������
// ����� ������ ����� ���� ��������� ��� �������� ����������
procedure InternalConfig(const AnApplicationHandle: Integer;
    const AstrExt: PChar); stdcall; // export
begin
  if Assigned(FFprnM45) then
    FFprnM45.ShowProperties
  else
    MessageBox(0, '������� ���� ��� ��� �� ����������!', '������', MB_OK or
    MB_ICONERROR);
end; // InternalConfig

// ������������� ����� ������������ ����������
function Connect: Boolean; stdcall; // export
begin
  Result := False;
  if not Assigned(FFprnM45) then
    exit;
  FFprnM45.DeviceEnabled := True;
  // �������� ����
  if FFprnM45.ResultCode = 0 then
    // �������� ��������� ���
    if FFprnM45.GetStatus = 0 then
      // ���� ���� �������� ���, �� �������� ���
      if (FFprnM45.CheckState = 0) or (FFprnM45.CancelCheck = 0) then begin
        // ������ � ����� �����������
        // ������������� ������ �������
        FFprnM45.Password := '1';
        // ������ � ����� �����������
        FFprnM45.Mode := 1;
        if FFprnM45.SetMode = 0 then
          Result := True;
      end;
  if not Result then
    _AddError(String(FFprnM45.ResultDescription));
end; // SetConfig

// ������������� ����� ������������ ����������
procedure Disconnect; stdcall; // export
begin
  if Assigned(FFprnM45) then
    FFprnM45.DeviceEnabled := False;
end; // SetConfig

// ������������� ����� ������������ ����������
function IsConnected: Boolean; stdcall; // export
begin
  Result := False;
  if not Assigned(FFprnM45) then
    exit;
  if FbCheckIsOpen then
    Result := True
  else if FFprnM45.ResetMode = 0 then begin
    FFprnM45.Password := '1';
    FFprnM45.Mode := 1;
    if FFprnM45.SetMode = 0 then
      Result := True
  end;
  if not Result then
    _AddError(String(FFprnM45.ResultDescription));
end; // IsCconnected

// ������������� ����� ������������ ����������
function OpenShift(const AnOperatorNumber: Integer;
    const AstrOperatorName: PChar;
    const AstrExt: PChar): Boolean; stdcall; // export
var
  strOperatorName: String;
begin
  Result := False;
  strOperatorName := AstrOperatorName;
  if not FFprnM45.SessionOpened then begin
    if FFprnM45.OpenSession = 0 then
      Result := True
    else
      _AddError(String(FFprnM45.ResultDescription));
//    FMercuryFPrt.OpenDay(AnOperatorNumber, strOperatorName, False,
//        FMercuryFPrt.Protocol);
  end;
end; // OpenShift

// ������������� ����� ������������ ����������
function IsShiftOpened(const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := FFprnM45.SessionOpened;
end; // OpenShift

// ������������� ����� ������������ ����������
function XReport(const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := False;
  // X - �����
  // ������������� ������ �������������� ���
  FFprnM45.Password := '29';
  // ������ � ����� ������� ��� �������
  FFprnM45.Mode := 2;
  if FFprnM45.SetMode = 0 then begin
    // ������� �����
    FFprnM45.ReportType := 2;
    if FFprnM45.Report = 0 then
      Result := True;
    FFprnM45.ResetMode;
  end;
  if not Result then
    _AddError(String(FFprnM45.ResultDescription));
end; // XReport

// ������������� ����� ������������ ����������
function ZReport(const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := False;
  // X - �����
  // ������������� ������ �������������� ���
  FFprnM45.Password := '30';
  // ������ � ����� ������� ��� �������
  FFprnM45.Mode := 3;
  if FFprnM45.SetMode = 0 then begin
    // ������� �����
    FFprnM45.ReportType := 1;
    if FFprnM45.Report = 0 then
      Result := True;
    FFprnM45.ResetMode;
  end;
  if not Result then
    _AddError(String(FFprnM45.ResultDescription));
end; // ZReport

function CashIn(const AfSum: Currency;
    const AstrAccount: PChar;
    const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := False;
  FFprnM45.Summ := AfSum;
  if FFprnM45.CashIncome = 0 then
      Result := True
  else
    _AddError(String(FFprnM45.ResultDescription));
end;

function CashOut(const AfSum: Currency;
    const AstrAccount: PChar;
    const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := False;
  FFprnM45.Summ := AfSum;
  if FFprnM45.CashOutcome = 0 then
      Result := True
  else
    _AddError(String(FFprnM45.ResultDescription));
end;

function StartSale(const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := True;
  FbRefund := False;
  if FFprnM45.NewDocument <> 0 then begin
    Result := False;
    _AddError(String(FFprnM45.ResultDescription));
  end;
  FFprnM45.CheckType := 1; //�������
  if FFprnM45.OpenCheck <> 0 then begin
    Result := False;
    _AddError(String(FFprnM45.ResultDescription));
  end;
  if Result then
    FbCheckIsOpen := True;
end;

function StartRefund(const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := True;
  FbRefund := True;;
  if FFprnM45.NewDocument <> 0 then begin
    Result := False;
    _AddError(String(FFprnM45.ResultDescription));
  end;
  FFprnM45.CheckType := 2; //�������
  if FFprnM45.OpenCheck <> 0 then begin
    Result := False;
    _AddError(String(FFprnM45.ResultDescription));
  end;
  if Result then
    FbCheckIsOpen := True;
end;

function AddItem(
    const AstrName: PChar;
    const AfPrice: Currency;
    const AbIsTare: Boolean;
    const AnDepartment: Integer;
    const AnCode: Integer;
    const AnQuantity: Integer;
    const AnQuantityPerc: Integer;
    const AnTaxIndex: Integer;
    const AstrUnitName: PChar;
    const AfPercent: Double;
    const AfAmount: Currency;
    const AstrExt: PChar): Boolean; stdcall; // export
var
  nPercents: Integer;
begin
  Result := True;
  with FFprnM45 do begin
    Name := AstrName;
    Price := AfPrice;
    AdvancedRegistration := True; //������ ����� � ���� ������ � ������.
    if AnQuantityPerc <= 0 then
      Quantity := AnQuantity
    else
      Quantity := AnQuantity * Power(10, - AnQuantityPerc);
    Department := AnDepartment;
    if FbRefund then begin
      if Return <> 0 then begin
        Result := False;
        _AddError(String(ResultDescription));
      end;
    end else begin
      if Registration <> 0 then begin
        Result := False;
        _AddError(String(ResultDescription));
      end;
    end;
    nPercents := Round(AfPercent * 100);
    if nPercents > 0 then begin
      // ��������� ���������� ������ �� �������
      Percents := nPercents;
      Destination := 1;
      if PercentsDiscount <> 0 then begin
        Result := False;
        _AddError(String(ResultDescription));
      end;
    end else if nPercents < 0 then begin
      // ��������� ���������� �������� �� �������
      Percents := - nPercents;
      Destination := 1;
      if PercentsCharge <> 0 then begin
        Result := False;
        _AddError(String(ResultDescription));
      end;
    end;
    if CompareValue(AfAmount, 0.00001) = GreaterThanValue then begin
      // ��������� �������� �������� �� �������
      Summ := AfAmount;
      Destination := 1;
      if SummCharge <> 0 then begin
        Result := False;
        _AddError(String(ResultDescription));
      end;
    end else if CompareValue(AfAmount, -0.00001) = LessThanValue then begin
      // ��������� �������� ������ �� �������
      Summ := - AfAmount;
      Destination := 1;
      if SummDiscount <> 0 then begin
        Result := False;
        _AddError(String(ResultDescription));
      end;
    end;
  end;
  if not Result then
    FbCheckIsOpen := False;
end;

function EndSale(
    const AnType: Integer;
//      0: Cash;
//      1: Credit;
//      2: Card;
//      3: CashCredit;
//      4: CashCard;
    const AfCash: Currency;
    const AfCashless: Currency;
    const AnTaxIndex: Integer;
    const AfPercent: Double;
    const AfAmount: Currency;
    const AstrExt: PChar): Boolean; stdcall; // export
var
  nPercents: Integer;
begin
  Result := True;
  with FFprnM45 do begin
    nPercents := Round(AfPercent * 100);
    if nPercents > 0 then begin
      // ��������� ���������� ������ �� �������
      Percents := nPercents;
      Destination := 0;
      if PercentsDiscount <> 0 then begin
        Result := False;
        _AddError(String(ResultDescription));
      end;
    end else if nPercents < 0 then begin
      // ��������� ���������� �������� �� �������
      Percents := - nPercents;
      Destination := 0;
      if PercentsCharge <> 0 then begin
        Result := False;
        _AddError(String(ResultDescription));
      end;
    end;
    if CompareValue(AfAmount, 0.00001) = GreaterThanValue then begin
      // ��������� �������� �������� �� �������
      Summ := AfAmount;
      Destination := 0;
      if SummCharge <> 0 then begin
        Result := False;
        _AddError(String(ResultDescription));
      end;
    end else if CompareValue(AfAmount, -0.00001) = LessThanValue then begin
      // ��������� �������� ������ �� �������
      Summ := - AfAmount;
      Destination := 0;
      if SummDiscount <> 0 then begin
        Result := False;
        _AddError(String(ResultDescription));
      end;
    end;
//    Summ := AfCash;
    TypeClose := 0;
//    if Delivery <> 0 then begin
    if CloseCheck <> 0 then begin
      Result := False;
      _AddError(String(ResultDescription));
    end;
  end;
  FbCheckIsOpen := False;
end;


function EndRefund(const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := True;
  with FFprnM45 do begin
    TypeClose := 0;
    if CloseCheck <> 0 then begin
      Result := False;
      _AddError(String(ResultDescription));
    end;
  end;
  FbCheckIsOpen := False;
end;

function PrintNonFiscal(const AstrText: PChar;
    const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := False;
  with FFprnM45 do begin
    Caption := AstrText;
    if PrintString = 0 then
      Result := True;
    if not Result then
      _AddError(String(ResultDescription));
  end;
end;

function GetLastError: PChar; stdcall; // export
var
  nPos: Integer;
begin
  nPos := FlstErrors.Count - 1;
  FstrLastError := '';
  if nPos >= 0 then begin
    FstrLastError := FlstErrors[0];
    FlstErrors.Delete(nPos);
  end;
  Result := PChar(FstrLastError);
end; // GetNotes

function GetErrorCount: Integer; stdcall; // export
begin
  Result := FlstErrors.Count;
end;


procedure DLLEntryPoint(dwReason: DWORD);
begin
  case dwReason Of
    DLL_PROCESS_ATTACH: begin
      FbConnected := False;
      FbCheckIsOpen := False;
//      FbPropertiesShowed := False;
      FstrConfig := DEF_CONFIG;
      FlstErrors := TStringList.Create;
      FFrm := TForm.Create(Nil);
      //�� ����� �������� ��� Parent Window
      FFprnM45 := Nil;
      try
        FFprnM45 := TFprnM45.Create(FFrm);
        FFprnM45.Parent := FFrm;
        FFprnM45.ApplicationHandle := FFrm.Handle;
      except
      end;
    end;
    DLL_PROCESS_DETACH: begin
      if Assigned(FFprnM45) then begin
        FFprnM45.DeviceEnabled := False;
        FreeAndNil(FFprnM45);
      end;
      FreeAndNil(FFrm);
      FreeAndNil(FlstErrors);
    end;
//		DLL_THREAD_ATTACH: ;
//    DLL_THREAD_DETACH:;
  end; // case
end; // DLLEntryPoint

exports
  IsKKMPlugin,
  GetName,
  GetVersion,
  GetNotes,
  GetConfigTypes,
  GetConfig,
  SetConfig,
  InternalConfig,
  Connect,
  Disconnect,
  IsConnected,
  OpenShift,
  IsShiftOpened,
  XReport,
  ZReport,
  CashIn,
  CashOut,
  StartSale,
  StartRefund,
  AddItem,
  EndSale,
  EndRefund,
  PrintNonFiscal,
  GetLastError,
  GetErrorCount;

begin

  DLLProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);

end. ////////////////////////// end of file //////////////////////////////////

