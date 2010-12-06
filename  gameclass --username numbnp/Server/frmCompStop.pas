unit frmCompStop;

interface

uses
  GCLangutils, GCComputers, GCCommon,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, gcsessions,
  ufrmComputers, Grids, Mask, ToolEdit, CurrEdit, uAlignEdit;

type
  TCompStopAction = (
    csaDefault = 1,
    csaNothing = 2,
    csaMoneyBack = 3,
    csaMoneyGet = 4
  );


  TformCompStop = class(TForm)
    lblClient: TLabel;
    lblStart: TLabel;
    dtpStart: TDateTimePicker;
    lblStop: TLabel;
    dtpStop: TDateTimePicker;
    editClient: TEdit;
    editTarif: TEdit;
    lblTarif: TLabel;
    timerStop: TTimer;
    lblCompStopAction: TLabel;
    pnlComputers: TPanel;
    butOk: TButton;
    butCancel: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    lblSummaryBill: TLabel;
    memoBill: TMemo;
    grdDetailInfo: TStringGrid;
    Panel3: TPanel;
    editResult: TAlignEdit;
    procedure butCancelClick(Sender: TObject);
    procedure butOkClick(Sender: TObject);
    procedure timerStopTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdDetailInfoClick(Sender: TObject);
  private
    FnSessionId: Integer;
    FComputerAction: TComputerAction;
    FfrmComputers: TfrmComputers;
    procedure UpdateInformation;
    procedure UpdateGridInformation;
    procedure UpdateDetailInformation(const ASession: TGCSession;
        const ACompStopAction: TCompStopAction = csaDefault;
        const AfSumm: Double = 0);
    procedure DoDesign;
    procedure _OnComputersChange(ASender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init;
    function ShowModal(const AAction: TComputerAction;
      const AnSessionId: Integer = -1): Integer;
  end;

var
  formCompStop: TformCompStop;

implementation
uses
  Types,
  StrUtils,
  Math,
  uVirtualTime,
  uRegistry,
  uVCLTools,
  uY2KString;
{$R *.dfm}
constructor TformCompStop.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FfrmComputers := TfrmComputers.Create(pnlComputers);
  FfrmComputers.Parent := pnlComputers;
  FfrmComputers.Align := alClient;
  FfrmComputers.Show;
  FfrmComputers.ComputerAction := caStop;
  FfrmComputers.OnChange := _OnComputersChange;
end;

destructor TformCompStop.Destroy;
begin
  FfrmComputers.OnChange := Nil;
  FreeAndNil(FfrmComputers);
  inherited Destroy;
end;

procedure TformCompStop.DoDesign;
var
  nHeight: Integer;
begin
  if (FComputerAction = caReserveCancel) or (CompsSelCount = 1) then begin
    Height := 328;
  end else begin
    nHeight := 328 + 48 + CompsSelCount * 17;
    if nHeight > 548 then
      nHeight := 548;
    Height := nHeight;
  end;
end;


procedure TformCompStop.Init;
begin
  Caption := translate('formCompStopCaption');
  butCancel.Caption := translate('butCancel');
  lblStart.Caption := translate('lblStartDate');
  lblStop.Caption := translate('lblEndDate');
  lblClient.Caption := translate('Client');
  lblTarif.Caption := translate('Tarif');
  lblSummaryBill.Caption := translate('lblSummaryBill');
  with grdDetailInfo do begin
    Cells[0,0] := '� ';
    Cells[1,0] := '������ ';
    Cells[2,0] := '����� ';
    Cells[3,0] := '������ ';
    Cells[4,0] := '����� ';
    Cells[5,0] := '�������.';
    Cells[6,0] := '����� ';
    Cells[7,0] := '����� ';
    Cells[8,0] := '����� ';
    Cells[9,0] := '������ ';
    Cells[10,0] := '������ ';
    Cells[11,0] := '������ ';
  end;
  timerStop.Enabled := true;
  if (FComputerAction = caStop) then begin
    CompsSelDeselect(caStop);
    FfrmComputers.Init(caStop);
  end else begin
    if (GSessions.GetItemByIdSessionsAdd(FnSessionId) <> Nil) then
      FfrmComputers.Init(caReserveCancel,
          Comps[ComputersGetIndex(
          GSessions.GetItemByIdSessionsAdd(FnSessionId).IdComp)].GetStrNumber);
  end;
  DoDesign;
  UpdateInformation;
end;

procedure TformCompStop.butCancelClick(Sender: TObject);
begin
  timerStop.Enabled := false;
  ModalResult := mrCancel;
end;

procedure TformCompStop.butOkClick(Sender: TObject);
begin
  UpdateInformation;
  timerStop.Enabled := false;
  ModalResult := mrOk;
end;

procedure TformCompStop.timerStopTimer(Sender: TObject);
begin
  UpdateInformation;
end;

procedure TformCompStop.UpdateInformation;
var
  session: TGCSession;
begin
  session := Nil;
  if (FComputerAction = caReserveCancel) and (FnSessionId <> -1) then
    session := GSessions.GetItemByIdSessionsAdd(FnSessionId)
  else
    session := Comps[ComputersGetIndex(CompsSel[0])].session;
  if (session = nil) or (session.Status = ssFinished) then begin
    butCancelClick(nil);
  end else begin
    if (FComputerAction = caReserveCancel) or (CompsSelCount = 1) then
      UpdateDetailInformation(session)
    else
      UpdateGridInformation;
  end;
end;

procedure TformCompStop.UpdateGridInformation;
var
  tempMoney, fSumm: double;
  session: TGCSession;
  i, j: Integer;
  dtStop: TDateTime;
  bGuestPresent: Boolean;
//  CompStopAction: CompStopAction
begin
  grdDetailInfo.RowCount := CompsSelCount + 1;
  dtStop := GetVirtualTime;
  fSumm := 0;
  bGuestPresent := False;
  for i := 1 to CompsSelCount do begin
    session := Comps[ComputersGetIndex(CompsSel[i - 1])].session;
    if (session = nil) or (session.Status = ssFinished) then
      butCancelClick(nil);
{    if (grdDetailInfo.Selection.Top = i) then
      UpdateDetailInformation(session);
}    if session.IsGuest then
      bGuestPresent := True;
    with grdDetailInfo do begin
      Cells[0,i] := Comps[ComputersGetIndex(
          session.IdComp)].GetStrNumber;
      Cells[1,i] := session.GetStrClient;
      Cells[2,i] := session.GetStrTarif;
      Cells[3,i] := TimeToStr(session.TimeStart);
      Cells[4,i] := TimeToStr(dtStop);
      // �������.
      if session.PostPay then
        Cells[5,i] := ''
      else
        Cells[5,i] := FormatFloat('0.00', session.CommonPay)
            + IfThen((CompareValue(session.SeparateTrafficPay, 0)
            = EqualsValue), '', '(+'
            + FormatFloat('0.00', session.SeparateTrafficPay) + ')')
            + ' ' + GRegistry.Options.Currency;
      // �����
      Cells[6,i] := FormatFloat('0.00', session.GetCostTotal) + ' '
          + GRegistry.Options.Currency;
      // �����
      if session.IsGuest then begin
{        if session.PostPay then
          tempMoney := session.GetCostTotal
        else
          tempMoney := session.GetCostTotal - session.CommonPay;
        if (tempMoney < 0)
            and (session.IdClient = 0) //��� �������� ������ ������ ������
            and GRegistry.Options.DisableChange then
          tempMoney := 0;                }
        tempMoney := - session.Change;
        Cells[7,i] := FormatFloat('0.00', tempMoney) + ' '
            + GRegistry.Options.Currency;
      end else begin
        Cells[7,i] := '';
        tempMoney := 0;
      end;
      fSumm := fSumm + tempMoney;
      // �����
      Cells[8,i] := TimeToStr(dtStop - session.Started) + ' = '
          + FormatFloat('0.00', session.GetCostTime) + ' '
          + GRegistry.Options.Currency;
      // ������
      if session.SummaryTraffic > 0 then
        Cells[9,i] := Format('%s = %m',
            [GetShortSizeString(session.SummaryTraffic),
            session.GetCostTraffic])
      else
        Cells[9,i] := '';
      // ������
      if roundto(session.ServiceCost, -2) > 0 then
        Cells[10,i] := FloatToStr(session.ServiceCost) + ' '
            + GRegistry.Options.Currency
      else
        Cells[10,i] := '';
      // ������
      if roundto(session.PrintCost, -2) > 0 then
        Cells[11,i] := FloatToStr(session.PrintCost) + ' '
            + GRegistry.Options.Currency
      else
        Cells[11,i] := '';
    end;
  end;
  StringGridAutoResizeColums(grdDetailInfo);
  if (grdDetailInfo.Selection.Top >= 1)
      and (grdDetailInfo.Selection.Top <= CompsSelCount) then begin
    session := Comps[ComputersGetIndex(CompsSel[grdDetailInfo.Selection.Top
        - 1])].session;
    if (session = nil) or (session.Status = ssFinished) then
      butCancelClick(nil);
      if bGuestPresent then begin
        if fSumm > 0 then
          UpdateDetailInformation(session, csaMoneyGet, fSumm)
        else
          UpdateDetailInformation(session, csaMoneyBack, -fSumm);
      end else
        UpdateDetailInformation(session, csaNothing);
  end;


end;

procedure TformCompStop.UpdateDetailInformation(const ASession: TGCSession;
    const ACompStopAction: TCompStopAction = csaDefault;
    const AfSumm: Double = 0);
var
  tempMoney: Double;
  strAction, strMoney: String;
begin
  editClient.Text := ASession.GetStrClient;
  editTarif.Text := ASession.GetStrTarif;
  dtpStart.DateTime := ASession.TimeStart;
  if (ASession.Status = ssReserve) then begin
    dtpStop.DateTime := ASession.TimeStop;
    lblCompStopAction.Caption := translate('CompStopActionMoneyBack');
    editResult.Text := FormatFloat('0.00', ASession.Change) + ' '
        + GRegistry.Options.Currency;
  end
  else begin
    dtpStop.DateTime := GetVirtualTime;//ASession.GetStop;
    if Comps[ComputersGetIndex(ASession.IdComp)].IsGuestSession then begin
       if (Asession.Change >=0) then begin
         strAction := translate('CompStopActionMoneyBack');
         strMoney := FormatFloat('0.00', Asession.Change) + ' '
            + GRegistry.Options.Currency;
       end
       else begin
         strAction := translate('CompStopActionMoneyGet');
         strMoney := FormatFloat('0.00', - Asession.Change) + ' '
            + GRegistry.Options.Currency;
       end;
    end else begin
      strAction := '';
      strMoney := '';
    end;
    memoBill.Text := ASession.MoneyInfo;
    if ACompStopAction = csaDefault then begin
      lblCompStopAction.Caption := strAction;
      editResult.Text := strMoney;
    end else begin
      memoBill.Lines.Add(strAction + ': ' + strMoney);
      case ACompStopAction of
        csaNothing:
          lblCompStopAction.Caption := '';
        csaMoneyBack:
          lblCompStopAction.Caption := translate('CompStopActionMoneyBack');
        csaMoneyGet:
          lblCompStopAction.Caption := translate('CompStopActionMoneyGet');
      end;
      if (ACompStopAction = csaNothing) then
        editResult.Text := ''
      else
        editResult.Text := FormatFloat('0.00', AfSumm) + ' '
            + GRegistry.Options.Currency;
    end;
  end;
end;


procedure TformCompStop.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=27) then
    butCancelClick(Nil);
end;

function TformCompStop.ShowModal(const AAction: TComputerAction;
    const AnSessionId: Integer = -1): Integer;
begin
  FComputerAction := AAction;
  if (AAction = caStop) or (AAction = caReserveCancel)
      and (GSessions.Index(AnSessionId) <> -1) then begin
    FnSessionId := AnSessionId;
    Init;
    Result := inherited ShowModal;
  end else
    Result := Integer(mbCancel);
end;

procedure TformCompStop._OnComputersChange(ASender: TObject);
begin
  DoDesign;
  UpdateInformation;
end;

procedure TformCompStop.grdDetailInfoClick(Sender: TObject);
begin
  UpdateGridInformation;
end;

end.
