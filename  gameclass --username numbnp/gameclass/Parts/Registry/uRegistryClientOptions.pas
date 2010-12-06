unit uRegistryClientOptions;

interface

uses
  uRegistryRecord,
  uRegistryDataSet;

type

  TRegistryClientOptions = class(TObject)
  private
    FRegistryDataSet: TRegistryDataSet;
    FRegistryRecord: TRegistryRecord;
    function LocateCompNumber: Boolean;
    function GetCompNumber: String;
    procedure SetCompNumber(AValue: String);
    function LocateBlockKeyboard: Boolean;
    function GetBlockKeyboard: Boolean;
    procedure SetBlockKeyboard(AValue: Boolean);
    function LocateBlockMouse: Boolean;
    function GetBlockMouse: Boolean;
    procedure SetBlockMouse(AValue: Boolean);
    function LocateBlockTasks: Boolean;
    function GetBlockTasks: Boolean;
    procedure SetBlockTasks(AValue: Boolean);
    function LocateBlockDisplay: Boolean;
    function GetBlockDisplay: Boolean;
    procedure SetBlockDisplay(AValue: Boolean);
    function LocateStartBlock: Boolean;
    function GetStartBlock: Boolean;
    procedure SetStartBlock(AValue: Boolean);
    function LocateStartBlockSec: Boolean;
    function GetStartBlockSec: Boolean;
    procedure SetStartBlockSec(AValue: Boolean);
    function LocateOfflineBlock: Boolean;
    function GetOfflineBlock: Boolean;
    procedure SetOfflineBlock(AValue: Boolean);
    function LocateOfflineBlockType: Boolean;
    function GetOfflineBlockType: Boolean;
    procedure SetOfflineBlockType(AValue: Boolean);
    function LocateOfflineBlockTypeImmediatelyMin: Boolean;
    function GetOfflineBlockTypeImmediatelyMin: Boolean;
    procedure SetOfflineBlockTypeImmediatelyMin(AValue: Boolean);
    function LocateUnblockPassword: Boolean;
    function GetUnblockPassword: Boolean;
    procedure SetUnblockPassword(AValue: Boolean);
    function LocateUnblockPasswordHash: Boolean;
    function GetUnblockPasswordHash: Boolean;
    procedure SetUnblockPasswordHash(AValue: Boolean);
    function LocateAutoLogoff: Boolean;
    function GetAutoLogoff: Boolean;
    procedure SetAutoLogoff(AValue: Boolean);
    function LocateAutoLogoffSec: Boolean;
    function GetAutoLogoffSec: Boolean;
    procedure SetAutoLogoffSec(AValue: Boolean);
    function LocateAfterStopType: Boolean;
    function GetAfterStopType: Boolean;
    procedure SetAfterStopType(AValue: Boolean);
    function LocateSyncTime: Boolean;
    function GetSyncTime: Boolean;
    procedure SetSyncTime(AValue: Boolean);
    function LocateShellMode: Boolean;
    function GetShellMode: Boolean;
    procedure SetShellMode(AValue: Boolean);
    function LocateUseSounds: Boolean;
    function GetUseSounds: Boolean;
    procedure SetUseSounds(AValue: Boolean);
    function LocateUseBaloons: Boolean;
    function GetUseBaloons: Boolean;
    procedure SetUseBaloons(AValue: Boolean);
    function LocateUseTextMessage: Boolean;
    function GetUseTextMessage: Boolean;
    procedure SetUseTextMessage(AValue: Boolean);
    function LocateUseTextMessageBlinking: Boolean;
    function GetUseTextMessageBlinking: Boolean;
    procedure SetUseTextMessageBlinking(AValue: Boolean);
    function LocateUseTextMessageMin: Boolean;
    function GetUseTextMessageMin: Boolean;
    procedure SetUseTextMessageMin(AValue: Boolean);
    function LocateURLCompFree: Boolean;
    function GetURLCompFree: Boolean;
    procedure SetURLCompFree(AValue: Boolean);
    function LocateURLTop: Boolean;
    function GetURLTop: Boolean;
    procedure SetURLTop(AValue: Boolean);
    function LocateURLAccount: Boolean;
    function GetURLAccount: Boolean;
    procedure SetURLAccount(AValue: Boolean);
    function LocateURLAgreement: Boolean;
    function GetURLAgreement: Boolean;
    procedure SetURLAgreement(AValue: Boolean);
    function LocateAgreement: Boolean;
    function GetAgreement: Boolean;
    procedure SetAgreement(AValue: Boolean);
    function LocateAllowCardsSupport: Boolean;
    function GetAllowCardsSupport: Boolean;
    procedure SetAllowCardsSupport(AValue: Boolean);
    function LocateLanguage: Boolean;
    function GetLanguage: Boolean;
    procedure SetLanguage(AValue: Boolean);
    function LocateTarifNames: Boolean;
    function GetTarifNames: Boolean;
    procedure SetTarifNames(AValue: Boolean);
    function Locate: Boolean;
    function Get: Boolean;
    procedure Set(AValue: Boolean);
    function Locate: Boolean;
    function Get: Boolean;
    procedure Set(AValue: Boolean);
    function Locate: Boolean;
    function Get: Boolean;
    procedure Set(AValue: Boolean);
  public
    constructor Create(ARegistryDataSet: TRegistryDataSet;
        ARegistryRecord: TRegistryRecord);
    destructor Destroy; override;

    // properties
    // ����� ����������
    property CompNumber: String
        read GetCompNumber write SetCompNumber;
    // ����������� ����������
    property BlockKeyboard: Boolean
        read GetBlockKeyboard write SetBlockKeyboard;
    // ����������� ����
    property BlockMouse: Boolean
        read GetBlockMouse write SetBlockMouse;
    // ������� ������ ��� ������������
    property BlockTasks: Boolean
        read GetBlockTasks write SetBlockTasks;
    // ����������� �������
    property BlockDisplay: Boolean
        read GetBlockDisplay write SetBlockDisplay;
   // ���������� ����� ����� ������ ����������
    property StartBlock: Boolean
        read GetStartBlock write SetStartBlock;
    // ���-�� ������ �� ������� ���������� ����� ����� ������ ����������
    // (0 - ����������)
    property StartBlockSec: Integer
        read GetStartBlockSec write SetStartBlockSec;
    // ���������� ��� ������ �����
    property OfflineBlock: Boolean
        read GetOfflineBlock write SetOfflineBlock;
    // ��� ���������� ��� ������ �����
    // (�����, ����� ��������� ������)
    property OfflineBlockType: TOfflineBlockType
        read GetOfflineBlockType write SetOfflineBlockType;
    // (�����)  = ����� ������� ����� ��� ������ �����
    property OfflineBlockTypeImmediatelyMin: Integer
        read GetOfflineBlockTypeImmediatelyMin
        write SetOfflineBlockTypeImmediatelyMin;
    // ������������ ������ ��� ������������� ������� �� CTRL+ALT+U
    property UnblockPassword: Boolean
        read GetUnblockPassword write SetUnblockPassword;
    // ������ � ����� ������ ��� ������������� ������� �� CTRL+ALT+U
    property UnblockPasswordHash: String
        read GetUnblockPasswordHash write SetUnblockPasswordHash;
     // ���������� �� ���������
    property AutoLogoff: Boolean
        read GetAutoLogoff write SetAutoLogoff;
    // ���-�� �����, ����� ������������ ������� ���������� ����������������
    property AutoLogoffSec: Integer
        read GetAutoLogoffSec write SetAutoLogoffSec;
    // �������� ����� ��������� ����� (����/���)
    property AfterStop: Boolean
        read GetAfterStop write SetAfterStop;
    // ���-�� ������, ����� ������� �����������
    // �������� ����� ��������� �����
    property AfterStopSec: Integer
        read GetAfterStopSec write SetAfterStopSec;
    // ��� �������� ����� ��������� �����
    // (0 - ������� ������)
    // (1 - Logoff)
    // (2 - Restart)
    // (3 - Shutdown)
    property AfterStopType: TAfterStopType
        read GetAfterStopType write SetAfterStopType;
  // ������������� ������� �� �������
    property SyncTime: Boolean
        read GetSyncTime write SetSyncTime;
    // ����-�����
    property ShellMode: TShellMode
        read GetShellMode write SetShellMode;
    // ������������ �����
    property UseSounds: Boolean
        read GetUseSounds write SetUseSounds;
    // ������������ Baloons
    property UseBaloons: Boolean
        read GetUseBaloons write SetUseBaloons;
    // ������������ ��������� ����
    property UseTextMessage: Boolean
        read GetUseTextMessage write SetUseTextMessage;
    // ������������ ����� � ���������
    property UseTextMessageBlinking: Boolean
        read GetUseTextMessageBlinking write SetUseTextMessageBlinking;
    // ���-�� ����� �� ��������� ��� ��������������
    property UseTextMessageMin: Integer
        read GetUseTextMessageMin write SetUseTextMessageMin;
    // URL ������ "��������� ���������"
    property URLCompFree: String
        read GetURLCompFree write SetURLCompFree;
    // URL ������ "��������� ���������"
    property URLTop: String
        read GetURLTop write SetURLTop;
    // URL ������ "��������� ���������"
    property URLAccount: String
        read GetURLCompFreeAccount write SetURLCompFreeAccount;
    // URL ������ "��������� ���������"
    property URLAgreement: String
        read GetURLAgreement write SetURLAgreement;
    // �������� ����� ����������
    property Agreement: Boolean
        read GetAgreement write SetAgreement;
    // ��������� ��������� ������� ����
    property AllowCardsSupport: Boolean
        read GetAllowCardsSupport write SetAllowCardsSupport;
    // ���� ����������
    property Language: Integer
        read GetLanguage write SetLanguage;
    // ������ ������� ��� RunPad Shell
    property TarifNames: TStringList
        read GetTarifNames write SetTarifNames;
    // ���������� ���������� ������
    property ShowSmallInfo: Boolean
        read GetShowSmallInfo write SetShowSmallInfo;
    // ������ ������� RunPad Shell
    property RunPadHideTabs: Boolean
        read GetRunPadHideTabs write SetRunPadHideTabs;
    // ������ ���� �������� RunPad Shell
    property RunPadTabs: TStringList
        read GetRunPadTabs write SetRunPadTabs;
    // �������������� Internet �  RunPad Shell
    property RunPadIntenetControl: Boolean
        read GetRunPadIntenetControl write SetRunPadIntenetControl;
  end;

implementation

uses
  SysUtils,
  DB, uGCDataSet;

{*******************************************************************************
                      class  TRegistryClientOptions
*******************************************************************************}
constructor TRegistryClientOptions.Create(ARegistryDataSet: TRegistryDataSet;
        ARegistryRecord: TRegistryRecord);
begin
  FRegistryDataSet := ARegistryDataSet;
  FRegistryRecord := ARegistryRecord;
end;

destructor TRegistryClientOptions.Destroy;
begin
  inherited Destroy;
end;

function TRegistryClientOptions.LocateEnable: Boolean;
begin
  Result := FRegistryDataSet.LocateByKey('AccountSystem\bEnabled', '0');
end;

function TRegistryClientOptions.GetEnable: Boolean;
begin
  LocateEnable;
  Result := FRegistryRecord.ValueAsBoolean;
end;

procedure TRegistryClientOptions.SetEnable(AValue: Boolean);
begin
  LocateEnable;
  FRegistryRecord.ValueAsBoolean := AValue;
end;

function TRegistryClientOptions.LocateUseSecurityCodes: Boolean;
begin
  Result := FRegistryDataSet.LocateByKey('AccountSystem\bUseSecurityCodes',
      '0');
end;

function TRegistryClientOptions.GetUseSecurityCodes: Boolean;
begin
  LocateUseSecurityCodes;
  Result := FRegistryRecord.ValueAsBoolean;
end;

procedure TRegistryClientOptions.SetUseSecurityCodes(AValue: Boolean);
begin
  LocateUseSecurityCodes;
  FRegistryRecord.ValueAsBoolean := AValue;
end;

function TRegistryClientOptions.LocateBlockIfLogonFailed3Times: Boolean;
begin
  Result := FRegistryDataSet.LocateByKey(
      'AccountSystem\bBlockIfLogonFailed3times', '1');
end;

function TRegistryClientOptions.GetBlockIfLogonFailed3Times: Boolean;
begin
  LocateBlockIfLogonFailed3Times;
  Result := FRegistryRecord.ValueAsBoolean;
end;

procedure TRegistryClientOptions.SetBlockIfLogonFailed3Times(AValue: Boolean);
begin
  LocateBlockIfLogonFailed3Times;
  FRegistryRecord.ValueAsBoolean := AValue;
end;

function TRegistryClientOptions.LocateAlwaysAllowAuthentication: Boolean;
begin
  Result := FRegistryDataSet.LocateByKey(
      'AccountSystem\bAlwaysAllowAuthentication', '1');
end;

function TRegistryClientOptions.GetAlwaysAllowAuthentication: Boolean;
begin
  LocateAlwaysAllowAuthentication;
  Result := FRegistryRecord.ValueAsBoolean;
end;

procedure TRegistryClientOptions.SetAlwaysAllowAuthentication(AValue: Boolean);
begin
  LocateAlwaysAllowAuthentication;
  FRegistryRecord.ValueAsBoolean := AValue;
end;

function TRegistryClientOptions.LocateMinAddedSumma: Boolean;
begin
  Result := FRegistryDataSet.LocateByKey('AccountSystem\minAddedSumma','10');
end;

function TRegistryClientOptions.GetMinAddedSumma: Double;
begin
  LocateMinAddedSumma;
  Result := FRegistryRecord.ValueAsDouble;
end;

procedure TRegistryClientOptions.SetMinAddedSumma(AValue: Double);
begin
  LocateMinAddedSumma;
  FRegistryRecord.ValueAsDouble := AValue;
end;

function TRegistryClientOptions.LocateWarningAddedSumma: Boolean;
begin
  Result := FRegistryDataSet.LocateByKey('AccountSystem\warningAddedSumma',
      '100');
end;

function TRegistryClientOptions.GetWarningAddedSumma: Double;
begin
  LocateWarningAddedSumma;
  Result := FRegistryRecord.ValueAsDouble;
end;

procedure TRegistryClientOptions.SetWarningAddedSumma(AValue: Double);
begin
  LocateWarningAddedSumma;
  FRegistryRecord.ValueAsDouble := AValue;
end;
end.
