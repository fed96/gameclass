//////////////////////////////////////////////////////////////////////////////
//
// mercury - DLL, ����������� ���������� GC � ��� �������� MS-K
//
//
// ���������� ���������� MercFPrtVCL
//
//////////////////////////////////////////////////////////////////////////////

library mercury;

uses
  Windows,
  Messages,
  MercuryFPrt,
  Forms,
  Math,
  Types,
  Classes,
  SysUtils,
  uY2KString in '..\..\Parts\Y2KCommon\uY2KString.pas',
  uY2KCommon in '..\..\Parts\Y2KCommon\uY2KCommon.pas';

const
  PLUGIN_NAME = '�������� MS-K';
  PLUGIN_VERSION = '1.0.1';
  PLUGIN_NOTES = '�������� ������ ��������� � ������������� � ���!';
  DEF_CONFIG_TYPES = 'COMPort/����/�������� COM-�����,'
      + ' � �������� ��������� ���.=lst/COM1/COM2/COM3/COM4'
      + '&Speed/��������/�������� ������ �������=lst/9600/19200/57600/115200'
      +  '&Password/������/������ ��� ����������� � ���=str';
  DEF_CONFIG = 'COMPort=0'
      + '&Speed=2'
      +  '&Password=0000';


var
  FbConnected: Boolean;
  FstrConfig: String;
  FMercuryFPrt: TMercuryFPrtCtrl;
  FFrm: TForm;
  FnRowCount: Integer;
  FlstErrors: TStringList;
  FstrLastError: String;

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
procedure InternalConfig(const AnApplicationHandle: Integer;
    const AstrExt: PChar); stdcall; // export
begin
end; // InternalConfig

// ������������� ����� ������������ ����������
function Connect: Boolean; stdcall; // export
var
  nCOMIndex, nSpeedIndex: Integer;
  strPassword: String;
begin
  Result := False;
  nCOMIndex := 0;
  TryStrToInt(GetValueFromConfig(FstrConfig, 'COMPort'), nCOMIndex);
  nSpeedIndex := 0;
  TryStrToInt(GetValueFromConfig(FstrConfig, 'Speed'), nSpeedIndex);
  strPassword := GetValueFromConfig(FstrConfig, 'Password');
{  nCOMIndex := 0;
  nSpeedIndex := 2;
  strPassword := '0000';}
  // ����������� ��������� ����������
  FMercuryFPrt.PortNum := nCOMIndex + 1;
  case nSpeedIndex of
    0:  FMercuryFPrt.BaudRate := CBR_9600;
    1:  FMercuryFPrt.BaudRate := CBR_19200;
    2:  FMercuryFPrt.BaudRate := CBR_57600;
    3:  FMercuryFPrt.BaudRate := CBR_115200;
  end;
  FMercuryFPrt.Password := strPassword;
  // ��������� ���������� � ���
  try
    FMercuryFPrt.Open;
    FbConnected := True;
    Result := True;
  except
    on E: Exception do
      _AddError(E.Message);
  end;
end; // SetConfig

// ������������� ����� ������������ ����������
procedure Disconnect; stdcall; // export
begin
  try
    FMercuryFPrt.Close(False);
  except
    on E: Exception do
      _AddError(E.Message);
  end;
end; // SetConfig

// ������������� ����� ������������ ����������
function IsConnected: Boolean; stdcall; // export
begin
  Result := False;
  try
//    FMercuryFPrt.TestConnection; �� �����������
    FMercuryFPrt.QueryEcrDateTime;
    Result := True;
  except
    on E: Exception do
      _AddError(E.Message);
  end;
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
  try
    FMercuryFPrt.OpenDay(AnOperatorNumber, strOperatorName, False,
        FMercuryFPrt.Protocol);
    Result := True;
  except
    on E: Exception do
      _AddError(E.Message);
  end;
end; // OpenShift

// ������������� ����� ������������ ����������
function IsShiftOpened(const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := False;
  try
    Result := FMercuryFPrt.CheckEcrStatus(MERC_SBIT_DAY_OPENED) > 0;
  except
    on E: Exception do
      _AddError(E.Message);
  end;
end; // OpenShift

// ������������� ����� ������������ ����������
function XReport(const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := False;
  try
    FMercuryFPrt.XReport(MERC_REPF_NO_ZEROES);
    Result := True;
  except
    on E: Exception do
      _AddError(E.Message);
  end;
end; // IsCconnected

// ������������� ����� ������������ ����������
function ZReport(const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := False;
  try
    FMercuryFPrt.ZReport(MERC_REPF_NO_ZEROES);
    Result := True;
  except
    on E: Exception do
      _AddError(E.Message);
  end;
end; // IsCconnected

// �������� ������ ��������� ���������� ����, ���� ��� ����������
procedure _FiscalPrintHeader(var AnRowCount: Integer);
var
  I: Integer;
  PrintNeeded: array [1..4] of Boolean;
begin
  // ��� ���, �� �������������� ����������� ������ ��������� ��������� ������
  // ����� � ��� ����� �������
  if (FMercuryFPrt.Generation <> 7)
      or (FMercuryFPrt.EcrSubVersion < $0300) then
  begin
    for I := 1 to 4 do
    begin
      FMercuryFPrt.AddHeaderLine(I, 0, 0, AnRowCount);
      Inc(AnRowCount);
    end;
  end
  else
  begin
    // ���� ��� ������������ ����������� ������ ���������, �� ���������, ������
    // ����� ����� ����� ��������
    PrintNeeded[1] := FMercuryFPrt.QueryParameterBool(
        MERC_PARAM_AUTOHEADER_LINE1);
    PrintNeeded[2] := FMercuryFPrt.QueryParameterBool(
        MERC_PARAM_AUTOHEADER_LINE2);
    PrintNeeded[3] := FMercuryFPrt.QueryParameterBool(
        MERC_PARAM_AUTOHEADER_LINE3);
    PrintNeeded[4] := FMercuryFPrt.QueryParameterBool(
        MERC_PARAM_AUTOHEADER_LINE4);
    // ���� ����������� ������ ��������� ��� ���� �����, �� ��������� ������
    // ����� � ��� ����� �������
    if not PrintNeeded[1] and not PrintNeeded[2] and not PrintNeeded[3] and
       not PrintNeeded[4] then
    begin
      for I := 1 to 4 do
      begin
        FMercuryFPrt.AddHeaderLine(I, 0, 0, AnRowCount);
        Inc(AnRowCount);
      end;
    end
    else
    begin
      // ���� �������� ����������� ������, �� ���������, ���� �� ��������������
      // ������ �����; ���� ���� - �������� ��������� ���� ������� ������
      // PrintHeader (����� ���������� ������ �� ������, ��� ������� ��������
      // ����������� ������); ������� ����� AnRowCount �����
      // � ����� ������ �����������
      // �� �����, �.�. ��������� �� ������ � ������ ����
      for I := 1 to 4 do
      begin
        if PrintNeeded[I] and
           not FMercuryFPrt.QueryParameterBool(MERC_PARAM_HEADER_PRINTED_LINE1
           + I - 1) then
        begin
          FMercuryFPrt.PrintHeader;
          Break;
        end;
      end;
    end;
  end;
end;

procedure _FiscalPrintFullHeader(var AnRowCount: Integer);
begin
  // ������� ������������ ����������
  AnRowCount := 0;
  // ��������� ������ ���������
  _FiscalPrintHeader(AnRowCount);
  // ��������� ����� ��� � ����� ��������� (�� ����� ������)
  FMercuryFPrt.AddSerialNumber(0, 0, AnRowCount);
  FMercuryFPrt.AddDocNumber(0, 31, AnRowCount);
  Inc(AnRowCount);
  // ��������� ���
  FMercuryFPrt.AddTaxPayerNumber(0, 0, AnRowCount);
  Inc(AnRowCount);
  // ��������� ���� / ����� � ����� ���� (�� ����� ������)
  FMercuryFPrt.AddDateTime(0, 0, AnRowCount);
  FMercuryFPrt.AddReceiptNumber(0, 31, AnRowCount);
  Inc(AnRowCount);
  // ��������� ���������� �� ���������
  FMercuryFPrt.AddOperInfo(moiNumberName, 0, 0, AnRowCount);
  Inc(AnRowCount);
end;

// ������������� ����� ������������ ����������
function _CashInOut(const AbIn: Boolean; const AfSum: Currency;
    const AstrAccount: PChar): Boolean;
var
  nRowCount: Integer;
  strAccount: String;
begin
  Result := False;
  try
    // ��������� ��� �� �������� ���������� (������� - ����������)
    if AbIn then
      FMercuryFPrt.OpenFiscalDoc(motCashIn)
    else
      FMercuryFPrt.OpenFiscalDoc(motCashOut);
    try
      // ��������� ������ ��������� � ������ ����������
      _FiscalPrintFullHeader(nRowCount);
      // ��������� �������
      strAccount := AstrAccount;
      if Length(strAccount) > 0 then begin
        FMercuryFPrt.AddCustom(strAccount, 0, 0, nRowCount);
        Inc(nRowCount);
      end;
      FMercuryFPrt.AddItem(
        mitItem,          // - ������ �������� ��� ������� ���� ��������� �����������
        AfSum,            // - ����� �������� / �������
        False, 0, 0, 0, 0,// - ��������� ������������ ��� ���� �������� / �������
        0, 0, '',
        0,                // - ������������ ��� ������� ���� ���������
        0,                // - �������� �� ���������
        nRowCount,               // - �������� �� �����������
        0                 // - ������������
      );
      Inc(nRowCount);
      // ��������� ����
      FMercuryFPrt.AddTotal(0, 0, nRowCount, 0); Inc(nRowCount);
      // ��� ���������� ������ ��������� ��������������� �����
      if FMercuryFPrt.EcrModel = mem114_1FMD then
        FMercuryFPrt.AddRegNumber(0, 0, nRowCount);
      // ��������� ��������
      FMercuryFPrt.CloseFiscalDoc;
    except
      // � ������ ������ �������� �������� ��������
      FMercuryFPrt.CancelFiscalDoc(False);
      raise;
    end;
    Result := True;
  except
    on E: Exception do
      _AddError(E.Message);
  end;
end;

function CashIn(const AfSum: Currency;
    const AstrAccount: PChar;
    const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := _CashInOut(True, AfSum, AstrAccount);
end;

function CashOut(const AfSum: Currency;
    const AstrAccount: PChar;
    const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := _CashInOut(False, AfSum, AstrAccount);
end;


function _StartSaleRefund(const AbSale: Boolean): Boolean;
begin
  Result := False;
  try
    // ��������� ��� �� �������
    if AbSale then
      FMercuryFPrt.OpenFiscalDoc(motSale)
    else
      FMercuryFPrt.OpenFiscalDoc(motRefund);
    try
      // ��������� ������ ��������� � ������ ����������
      _FiscalPrintFullHeader(FnRowCount);
    except
      // � ������ ������ �������� �������� ��������
      FMercuryFPrt.CancelFiscalDoc(False);
      raise;
    end;
      Result := True;
  except
    on E: Exception do
      _AddError(E.Message);
  end;
end;

function StartSale(const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := _StartSaleRefund(True);
end;

function StartRefund(const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := _StartSaleRefund(False);
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
  nAdjustment: Integer;
begin
  Result := False;
  try
    // ��������� ��� �� �������
    // ��������� �������
    // - ������������ ������, ��� �������������� ��������
    FMercuryFPrt.AddCustom(AstrName, 0, 0, FnRowCount);
    Inc(FnRowCount);
    FMercuryFPrt.AddItem(
      mitItem,          // - ������ ��� �����
      AfPrice,              // - ���� ������
      AbIsTare,            // - ����� �� �������� �����
      AnDepartment,                // - ����� ������
      AnCode,              // - ��� ������
      0,                // - ������������
      AnQuantity,         // - ����������
      AnQuantityPerc,    // - ���������� ������ ����� ���������� �����
      AnTaxIndex,                // - ������ ��������� ������
      AstrUnitName,            // - ������� ���������
      0,                // - �����
      0,                // - �������� �� ���������
      FnRowCount,               // - �������� �� �����������
      0                 // - ������������
    );
    Inc(FnRowCount);
    // ��������� ���������� ������ �� �������
    nAdjustment := Round(AfPercent * 100);
    if nAdjustment <> 0 then begin
      FMercuryFPrt.AddItem(
          mitPercentAdj,    // - ���������� ������ / ��������
          AfPrice,              // - ���� ������
          AbIsTare,            // - ����� �� �������� �����
          AnDepartment,                // - ����� ������
          AnCode,              // - ��� ������
          nAdjustment,                // - ������
          AnQuantity,         // - ����������
          AnQuantityPerc,    // - ���������� ������ ����� ���������� �����
          AnTaxIndex,                // - ������ ��������� ������
          '',            // - ������������ ��� ������ / ��������
          0,                // - �����
          0,                // - �������� �� ���������
          FnRowCount,               // - �������� �� �����������
          0                 // - ������������
      );
      Inc(FnRowCount);
    end;
    if not (CompareValue(AfAmount, 0) = EqualsValue) then begin
      // ��������� �������� �������� �� �������
      FMercuryFPrt.AddItem(
          mitAmountAdj,     // - �������� ������ / ��������
          AfAmount,               // - ����� ��������
          False,            // - �� ����� ��������
          AnDepartment,                // - ����� ������
          AnCode,              // - ��� ������
          0,                // - ������������
          0, 0,             // - �� ����� ��������
          AnTaxIndex,                // - ������ ��������� ������
          '',               // - ������������ ��� ������ / ��������
          0,                // - �����
          0,                // - �������� �� ���������
          FnRowCount,               // - �������� �� �����������
          0                 // - ������������
      );
      Inc(FnRowCount);
    end;
    Result := True;
  except
    on E: Exception do begin
      _AddError(E.Message);
      // � ������ ������ �������� �������� ��������
      try
        FMercuryFPrt.CancelFiscalDoc(False);
      except
      end;
    end;
  end;
end;

function EndSale(
    const AnType: Integer;
    // 0 -
    const AfCash: Currency;
    const AfCashless: Currency;
    const AnTaxIndex: Integer;
    const AfPercent: Double;
    const AfAmount: Currency;
    const AstrExt: PChar): Boolean; stdcall; // export
var
  mpt: TMercPayType;
  nAdjustment: Integer;
begin
  Result := False;
  try
    // ��������� ��� �� �������
    // ��������� ����
    FMercuryFPrt.AddTotal(0, 0, FnRowCount, 0);
    Inc(FnRowCount);
    // ��������� ���������� �������� �� ���
    nAdjustment := Round(AfPercent * 100);
    if nAdjustment <> 0 then begin
      FMercuryFPrt.AddDocPercentAdj(
          nAdjustment,              // - �������� 4.5%
          AnTaxIndex,                // - ������ ��������� ������
          0,                // - �����
          0,                // - �������� �� ���������
          FnRowCount,               // - �������� �� �����������
          0                 // - ������������
      );
      Inc(FnRowCount);
    end;
    if not (CompareValue(AfAmount, 0) = EqualsValue) then begin
      // ��������� �������� ������ �� ���
      FMercuryFPrt.AddDocAmountAdj(
          AfAmount,             // - ����� ������
          AnTaxIndex,                // - ������ ��������� ������
          0,                // - �����
          0,                // - �������� �� ���������
          FnRowCount,               // - �������� �� �����������
          0                 // - ������������
      );
      Inc(FnRowCount);
    end;
    case AnType of
      0: mpt := mptCash;
      1: mpt := mptCredit;
      2: mpt := mptCard;
      3: mpt := mptCashCredit;
      4: mpt := mptCashCard;
    else
      mpt := mptCash;
    end;
    // ��������� ���������� �� ������
    FMercuryFPrt.AddPay(
      mpt,      // - ������: �������� + ��������� �����
      AfCash,             // - ����� ������ ���������
      AfCashless,               // - ����� ������ �� �������
      '',               // - �������������� ���������� �� ������ - ������������
                        //   ��� ��������������� ������
      0, 0, FnRowCount, 0);
    Inc(FnRowCount);
    // ��������� ����� �����
    FMercuryFPrt.AddChange(0, 0, FnRowCount, 0);
    Inc(FnRowCount);
    // ��� ���������� ������ ��������� ��������������� �����
    if FMercuryFPrt.EcrModel = mem114_1FMD then
      FMercuryFPrt.AddRegNumber(0, 0, FnRowCount);
    // ��������� ��������
    FMercuryFPrt.CloseFiscalDoc;
    Result := True;
  except
    on E: Exception do begin
      _AddError(E.Message);
      // � ������ ������ �������� �������� ��������
      try
        FMercuryFPrt.CancelFiscalDoc(False);
      except
      end;
    end;
  end;
end;


function EndRefund(const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := False;
  try
  // ��������� ��� �� �������
    // ��������� ����
    FMercuryFPrt.AddTotal(0, 0, FnRowCount, 0);
    Inc(FnRowCount);
    // ��� ���������� ������ ��������� ��������������� �����
    if FMercuryFPrt.EcrModel = mem114_1FMD then
      FMercuryFPrt.AddRegNumber(0, 0, FnRowCount);
    // ��������� ��������
    FMercuryFPrt.CloseFiscalDoc;
    Result := True;
  except
    on E: Exception do begin
      _AddError(E.Message);
      // � ������ ������ �������� �������� ��������
      try
        FMercuryFPrt.CancelFiscalDoc(False);
      except
      end;
    end;
  end;
end;

function PrintNonFiscal(const AstrText: PChar;
    const AstrExt: PChar): Boolean; stdcall; // export
begin
  Result := False;
  try
    // �������� ������������ ��������
    FMercuryFPrt.PrintNonFiscal(AstrText, True, True);
    // ��������� ������ � ����� ������, ���� ��������������
    if FMercuryFPrt.Generation >= 2 then
      FMercuryFPrt.FeedAndCut(5, True);
    Result := True;
  except
    on E: Exception do begin
      _AddError(E.Message);
    end;
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
      FstrConfig := DEF_CONFIG;
      FlstErrors := TStringList.Create;
      FFrm := TForm.Create(Nil);
      //�� ����� �������� ��� Parent Window
      FMercuryFPrt := TMercuryFPrtCtrl.Create(FFrm);
      FMercuryFPrt.Parent := FFrm;
    end;
    DLL_PROCESS_DETACH: begin
      FreeAndNil(FMercuryFPrt);
      FreeAndNil(FFrm);
      FreeAndNil(FlstErrors);
    end;
//		DLL_THREAD_ATTACH: ;
//		DLL_THREAD_DETACH: ;
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

