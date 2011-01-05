unit ufrmAccounts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls,
  GCLangUtils, Grids, DBGridEh, DB, Mask, DBCtrlsEh, DBCtrls,
  ADODB, EDBImage, RxGIF, ToolEdit, RXDBCtrl;

type
  TfrmAccounts = class(TForm)
    gbAccountInfo: TGroupBox;
    lblAccountName: TLabel;
    lblAccountNumber: TLabel;
    lblAccountPassword: TLabel;
    lblAccountAddress: TLabel;
    lblAccountPhone: TLabel;
    lblAccountPhoto: TLabel;
    imgAccountPhotoBG: TImage;
    editAccountName: TDBEditEh;
    editAccountNumber: TDBEditEh;
    editAccountPass: TDBEditEh;
    editAccountAddress: TDBEditEh;
    editAccountPhone: TDBEditEh;
    butPhoto: TButton;
    cbAccountDisabled: TDBCheckBoxEh;
    cbAccountPrivileged: TDBCheckBoxEh;
    editPrivelegedDiscount: TDBEditEh;
    gbBalanceInfo: TGroupBox;
    lblOnBalance: TLabel;
    editOnBalance: TDBEditEh;
    lblSummary: TLabel;
    editSummary: TDBEditEh;
    butBalanceAdd: TButton;
    cbAccountBlocked: TDBCheckBoxEh;
    butBalanceRemove: TButton;
    lblZeroAccountBalance: TLabel;
    editAccountZeroBalance: TDBEditEh;
    butAccountAdd: TButton;
    butAccountSave: TButton;
    butAccountDelete: TButton;
    butViewSecCodes: TButton;
    Label6: TLabel;
    butClose: TButton;
    butHelp: TButton;
    butGenerateSecCodes: TButton;
    lblSummaryDiscount: TLabel;
    gbFilter: TGroupBox;
    lblFilterNumber: TLabel;
    editFilterNumber: TEdit;
    lblFilterName: TLabel;
    editFilterName: TEdit;
    lblAccountEmail: TLabel;
    editAccountEmail: TDBEditEh;
    lblAccountMemo: TLabel;
    memoAccountMemo: TDBMemo;
    butClearPass: TButton;
    dsrcAccounts: TDataSource;
    grdAccounts: TDBGridEh;
    OpenDialog1: TOpenDialog;
    imgAccountPhoto: TEDBImage;
    cbxPeriodOfValidity: TDBCheckBox;
    dtpExpirationDate: TDBDateEdit;
    gbTarifsInfo: TGroupBox;
    cbTarifsLimit: TDBCheckBoxEh;
    lblUserLevel: TLabel;
    cbUserLevel: TComboBox;
    editUserLevel: TDBEditEh;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure butCloseClick(Sender: TObject);
    procedure butAccountAddClick(Sender: TObject);
    procedure butAccountDeleteClick(Sender: TObject);
    procedure butViewSecCodesClick(Sender: TObject);
    procedure butGenerateSecCodesClick(Sender: TObject);
    procedure cbAccountBlockedClick(Sender: TObject);
    procedure editFilterNumberChange(Sender: TObject);
    procedure editFilterNameChange(Sender: TObject);
    procedure butAccountSaveClick(Sender: TObject);
    procedure butBalanceAddClick(Sender: TObject);
    procedure butBalanceRemoveClick(Sender: TObject);
    procedure butClearPassClick(Sender: TObject);
    procedure butHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure butPhotoClick(Sender: TObject);
    procedure imgAccountPhotoLoadCustomImage(var B: TGraphic;
      Stream: TStream);
    procedure editAccountNameChange(Sender: TObject);
    procedure editSummaryChange(Sender: TObject);
    procedure dtpExpirationDateChange(Sender: TObject);
    procedure cbxPeriodOfValidityClick(Sender: TObject);
    procedure cbTarifsLimitClick(Sender: TObject);
    procedure dsrcAccountsStateChange(Sender: TObject);
    procedure cbUserLevelChange(Sender: TObject);
    procedure editUserLevelChange(Sender: TObject);
  private
    { Private declarations }
    FbDirty: Boolean;
    FbControlsEnabled: Boolean;
    FbUpdateDuringEditing: Boolean;
    procedure SetDirty(AbValue: Boolean);
    procedure UpdateDiscount;
    procedure UpdateFilter;
    procedure _UpdateQuery(const Sender: TObject; const AnId: Integer; var CanUpdate: Boolean);
    procedure _AfterScroll(DataSet: TDataSet);
    procedure _BeforeScroll(DataSet: TDataSet);
    procedure _OnChange(Sender: TObject);
    property Dirty: Boolean
      read FbDirty write SetDirty;
  public
    procedure DoDesign;
    procedure DoDesignExpirationDate;
    procedure EnableControls;
    procedure DisableControls;
    property ControlsEnabled: Boolean
        read FbControlsEnabled write FbControlsEnabled;
  public
    { Public declarations }
//    ManagerMode: boolean; // ���� false - �� ����� ���������, ���� true - �� ��������� (��� �������)
  end;

var
  frmAccounts: TfrmAccounts;

implementation

uses
  gcconst,
  gccommon,
  gccomputers,
  frmGCMessageBox,
  frmInputSumm,
  frmMain,
  gcfunctions,
  uAccounts,
  uAccountsRecord,
  uY2KString,
  uKKMTools,
  uRegistry;

{$R *.dfm}

procedure TfrmAccounts.EnableControls;
begin
  FbControlsEnabled := True;
end;

procedure TfrmAccounts.DisableControls;
begin
  FbControlsEnabled := False;
end;

procedure TfrmAccounts.DoDesign;
var
  bCreateRigth: Boolean;
  bRecordSelected: Boolean;
  bEditPermission: Boolean;
  bManagerPermission: Boolean;
begin
  bCreateRigth := isManager or FunctionAmIRight(FN_ACCOUNTS_CREATE);
  bRecordSelected := not GAccountsCopy.IsEmpty;
  bEditPermission := bCreateRigth and bRecordSelected;
  bManagerPermission := isManager and bRecordSelected;
  butPhoto.Enabled :=  bEditPermission;
  editAccountNumber.Enabled :=  bEditPermission;
  editAccountName.Enabled := bEditPermission;
  editAccountPass.Enabled := bEditPermission;
  editAccountEmail.Enabled := bEditPermission;
  editAccountPhone.Enabled := bEditPermission;
  //butPhoto.Enabled := ManagerMode;
  cbAccountDisabled.Enabled := bEditPermission;
  cbAccountPrivileged.Enabled := bManagerPermission;
  // �������� ������ ����� �������������� ������������
  cbAccountBlocked.Enabled := (bCreateRigth
      or (cbAccountBlocked.Checked and (Not cbAccountDisabled.Checked)))
      and bRecordSelected;
  editPrivelegedDiscount.Enabled := bManagerPermission
      and cbAccountPrivileged.Checked;
  cbTarifsLimit.Enabled := bManagerPermission;
  lblUserLevel.Enabled := bManagerPermission;
  editAccountZeroBalance.Enabled := bManagerPermission;
  butAccountAdd.Visible := bCreateRigth;
  butAccountSave.Visible := bCreateRigth;
  butAccountDelete.Visible := isManager;
  butViewSecCodes.Visible := bCreateRigth;
  butGenerateSecCodes.Visible := bCreateRigth;
  butBalanceRemove.Visible := isManager;
  editOnBalance.Enabled := bManagerPermission;
  editSummary.Enabled := bManagerPermission;
  editSummary.ReadOnly := not bManagerPermission;
  butBalanceAdd.Enabled := (isManager
      or FunctionAmIRight(FN_ACCOUNTS_CHANGE_MONEY)) and bRecordSelected;
  butAccountSave.Enabled := bEditPermission and Dirty;
  butAccountDelete.Enabled := bManagerPermission;
  butViewSecCodes.Enabled := bEditPermission;
  butGenerateSecCodes.Enabled := bEditPermission;
  butBalanceRemove.Enabled := bManagerPermission;
  editAccountAddress.Enabled := bEditPermission;
  memoAccountMemo.Enabled := bEditPermission;
  cbxPeriodOfValidity.Enabled := bEditPermission;
  butClearPass.Visible := (isManager
      or FunctionAmIRight(FN_ACCOUNTS_CLEAR_PASSWORD)) and bRecordSelected;
  cbUserLevel.Enabled:=cbTarifsLimit.Checked and bManagerPermission;
  UpdateDiscount;
  DoDesignExpirationDate;
end;

procedure TfrmAccounts.DoDesignExpirationDate;
begin
  dtpExpirationDate.Enabled := cbxPeriodOfValidity.Checked
      and (isManager or FunctionAmIRight(FN_ACCOUNTS_CREATE))
      and not GAccountsCopy.IsEmpty;
end;

procedure TfrmAccounts.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=27) then ModalResult := mrCancel;
end;

procedure TfrmAccounts.butCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;


procedure TfrmAccounts.butAccountAddClick(Sender: TObject);
begin
  DisableControls;
  GAccountsCopy.AfterScroll := nil;
  GAccountsCopy.Append;
  GAccountsCopy.Current.GenerateSecCodes;
  GAccountsCopy.AfterScroll := _AfterScroll;
  DoDesign;
  EnableControls;
end;

procedure TfrmAccounts.butAccountDeleteClick(Sender: TObject);
begin
  if GAccountsCopy.IsEmpty then
    exit;
  //������ ������� �������, ���� �� ��� ��� ���� ������.
  if GAccountsCopy.Current.Balance > 0 then begin
    formMain.timerCompsList.Enabled := false;
    formGCMessageBox.memoInfo.Text := translate('DeletingAccountWithMoney');
    formGCMessageBox.SetDontShowAgain(False);
    formGCMessageBox.ShowModal;
    formMain.timerCompsList.Enabled := true;
  end
  else begin
     GAccountsCopy.Delete(GAccountsCopy.Current.Id);
  end;
end;

function IntToStr2(i: integer):string;
begin
  Result := IntToStr(i);
  if (Strlen(PChar(Result))<2) then
    Result := '0'+Result;
end;

procedure TfrmAccounts.butViewSecCodesClick(Sender: TObject);
var
  SecCodes: TSecCodes;
  i, index: integer;
begin
  if GAccountsCopy.IsEmpty then exit;
  formGCMessageBox.memoInfo.Text := '';
  SecCodes := GAccountsCopy.Current.SecCodes;
  for i:=0 to 4 do
    formGCMessageBox.memoInfo.Lines.Add(
     IntToStr2(i+1)+'='+SecCodes[i] +
     '  ' + IntToStr2(i+6)+'='+SecCodes[i+5] +
     '  ' + IntToStr2(i+11)+'='+SecCodes[i+10] +
     '  ' + IntToStr2(i+16)+'='+SecCodes[i+15]
     );
  formGCMessageBox.SetDontShowAgain(false);
  formGCMessageBox.ShowModal;
end;

procedure TfrmAccounts.butGenerateSecCodesClick(Sender: TObject);
begin
  if GAccountsCopy.IsEmpty then exit;

  if (MessageBox(HWND_TOP,'������ ���� ����� ������� ������. �� �������?',       //���������
      PChar(translate('Warning')),MB_YESNO or MB_ICONQUESTION)<>IDYES) then
    exit;
  GAccountsCopy.Current.GenerateSecCodes;
  _OnChange(Sender);
  butViewSecCodesClick(Sender);
end;

procedure TfrmAccounts.cbAccountBlockedClick(Sender: TObject);
begin
//  if (Dirty) then exit;
  if not ControlsEnabled or GAccountsCopy.IsEmpty then
    exit;
  // �������� ������ ����� �������������� ������������
  if not(isManager or FunctionAmIRight(FN_ACCOUNTS_CREATE)) then begin
    if (MessageBox(HWND_TOP,'�������������� ������� ������? �� �������?',        //���������
        PChar(translate('Warning')),
        MB_YESNO or MB_ICONQUESTION)<>IDYES) then begin
      DisableControls;
      cbAccountBlocked.Checked := True;
      EnableControls;
      exit;
    end;
//    GAccountsCopy.Current.SecurityBlocked := True;
      DisableControls;
      cbAccountBlocked.Checked := False;
      EnableControls;

    Dirty := False;
    DoDesign;
  end else
    _OnChange(Sender);
end;

procedure TfrmAccounts.editFilterNumberChange(Sender: TObject);
begin
  if Dirty then exit;
  UpdateFilter;
end;

procedure TfrmAccounts.editFilterNameChange(Sender: TObject);
begin
  if Dirty then exit;
  UpdateFilter;
end;

procedure TfrmAccounts.butAccountSaveClick(Sender: TObject);
begin
  if not GAccountsCopy.CheckFreeName(editAccountName.Text) then begin
       MessageBox(HWND_TOP,'������� ������ � ����� ������ ��� ����������',        // ���������
          PChar(translate('Warning')),MB_OK);
       exit;
  end;
  if FbUpdateDuringEditing
      and (MessageBox(HWND_TOP, PChar(translate('AccountSaveQuestion')),
      FORM_MAIN_CAPTION, MB_YESNO or MB_ICONQUESTION) = IDNO) then begin
    Dirty := False;
    GAccountsCopy.Select(GAccountsCopy.Current.Id);
    exit;
  end;
  FbDirty := False;
  GAccountsCopy.Edit;
  GAccountsCopy.Post;
  //butAccountSave.Enabled := false;
  DoDesign;
end;

procedure TfrmAccounts.butBalanceAddClick(Sender: TObject);
var
  index: integer;
  res: double;
  str: string;
  bActionCanceled: Boolean;
begin
  If not FunctionAmIRight(FN_ACCOUNTS_CHANGE_MONEY) then exit;
  if butAccountSave.Enabled then
    if (MessageBox(HWND_TOP,PChar(translate('AccountSaveQuestion')),
        FORM_MAIN_CAPTION,MB_YESNO or MB_ICONQUESTION) = IDYES) then
      butAccountSaveClick(Nil);
  if GAccountsCopy.IsEmpty then exit;
  Application.CreateForm(TformInputSumm, formInputSumm);
  // ToDo translate
  formInputSumm.Caption := '���������� �������';                                 //���������
  formInputSumm.lblAccountInfo.Caption :=
      IntToStr(GAccountsCopy.Current.Id) + ' ('
      + GAccountsCopy.Current.Name +')';
  formInputSumm.typefrm := 0; // ����������
  if (formInputSumm.ShowModal = mrOK) then begin
    res := StrToFloatGC(formInputSumm.editSumma.Text);
    bActionCanceled := False;
    if GRegistry.Modules.KKM.Active
        and (not isManager
        or not GRegistry.Modules.KKM.OnlyForOperator) then begin
      bActionCanceled := not CashIncome(res, '�������� ����� �� ���� '           //���������
          + GAccountsCopy.Current.Name)
          and GRegistry.Modules.KKM.DisconnectBlock;
    end;
    if bActionCanceled then
      Console.AddEvent(EVENT_ICON_INFORMATION, LEVEL_1,
          '�������� �������� ��-�� ������ ���: ' + GKKMPlugin.GetLastError)       //���������
    else begin
      GAccountsCopy.Current.MoneyPut(res);
      Console.AddEvent(EVENT_ICON_INFORMATION, LEVEL_0, '������� ������ '         //���������
          + GAccountsCopy.Current.Name + '. �������� ����� �� ���� :'            //���������
          + FloatToStrGC(res));
    end;
  end;
end;

procedure TfrmAccounts.butBalanceRemoveClick(Sender: TObject);
var
  res: double;
  str: string;
  bActionCanceled: Boolean;
begin
  if butAccountSave.Enabled then
    if (MessageBox(HWND_TOP,PChar(translate('AccountSaveQuestion')),
        FORM_MAIN_CAPTION,MB_YESNO or MB_ICONQUESTION) = IDYES) then
      butAccountSaveClick(Nil);
  if GAccountsCopy.IsEmpty then exit;
  if (GAccountsCopy.Current.Balance <= 0) then begin
    MessageBox(HWND_TOP,PChar('�� ����� ��� �������.'),                          //���������
        PChar(translate('Warning')),MB_OK);
    exit;
  end;
  Application.CreateForm(TformInputSumm, formInputSumm);
  // ToDo translate
  formInputSumm.Caption := '������ �� �����';                                    //���������
  formInputSumm.lblAccountInfo.Caption :=
      IntToStr(GAccountsCopy.Current.Id)
      + ' ('+ GAccountsCopy.Current.Name +')';
  formInputSumm.typefrm := 1; // ����������
  if (formInputSumm.ShowModal = mrOK) then begin
    res := StrToFloatDefWithReplace(formInputSumm.editSumma.Text,0);
    bActionCanceled := False;
    if GRegistry.Modules.KKM.Active
        and (not isManager
        or not GRegistry.Modules.KKM.OnlyForOperator) then begin
      bActionCanceled := not CashOutcome(res, '������ ����� �� ����� '
          + GAccountsCopy.Current.Name)
          and GRegistry.Modules.KKM.DisconnectBlock;
    end;
    if bActionCanceled then
      Console.AddEvent(EVENT_ICON_INFORMATION, LEVEL_1,
          '�������� �������� ��-�� ������ ���: ' + GKKMPlugin.GetLastError)      //���������
    else begin
      GAccountsCopy.Current.MoneyRemove(res);
      Console.AddEvent(EVENT_ICON_INFORMATION, LEVEL_0,
          '������� ������ ' + GAccountsCopy.Current.Name
          + '. ������ ����� �� �����: '                                          //���������
          + FloatToStrGC(res));
    end;
  end;
end;
procedure TfrmAccounts.SetDirty(AbValue: Boolean);
begin
  if AbValue <> FbDirty then begin
    FbDirty := AbValue;
    if (AbValue = False) then
      FbUpdateDuringEditing := False;
    DoDesign;
  end;
end;

procedure TfrmAccounts.UpdateDiscount;
begin
  if (GAccountsCopy.RecordCount > 0) then
    lblSummaryDiscount.Caption := '������ = '                                    //���������
        + IntToStr(GAccountsCopy.Current.Discount) + ' %';
end;

procedure TfrmAccounts.butClearPassClick(Sender: TObject);
begin
  if butAccountSave.Enabled then begin
    if (MessageBox(HWND_TOP,PChar(translate('AccountSaveQuestion')),
        FORM_MAIN_CAPTION,MB_YESNO or MB_ICONQUESTION) = IDYES) then
      butAccountSaveClick(Nil)
    else
      GAccountsCopy.Cancel;
  end;
  if GAccountsCopy.IsEmpty then exit;
  GAccountsCopy.Current.Password := '';
  butAccountSaveClick(Nil);
//  _OnChange(Sender);
end;

procedure TfrmAccounts.butHelpClick(Sender: TObject);
begin
  GCHelp(HELP_ACCOUNTS);
end;


procedure TfrmAccounts._UpdateQuery(const Sender: TObject; const AnId: Integer;
    var CanUpdate: Boolean);
begin
  if Dirty and (AnId = StrToIntDef(editAccountNumber.Text,-1)) then begin
    if not GAccountsCopy.InAutoUpdate then
      GAccountsCopy.PostLocal;
    CanUpdate := False
  end else
    CanUpdate := True;

{    if (MessageBox(HWND_TOP,
        PChar(translate('AccountSaveQuestion')),
        FORM_MAIN_CAPTION, MB_YESNO or MB_ICONQUESTION) = IDYES) then
      CanUpdate := True
    else
      CanUpdate := False;
      }
end;

procedure TfrmAccounts._BeforeScroll(DataSet: TDataSet);
begin
  DisableControls;
  if Dirty and not GAccountsCopy.InAutoUpdate then begin
    FbUpdateDuringEditing := True;
    butAccountSaveClick(Self);
  end;
end;

procedure TfrmAccounts._AfterScroll(DataSet: TDataSet);
begin
  EnableControls;
  if not GAccountsCopy.InAutoUpdate then begin
    Dirty := False;
    DoDesign;
  end;
end;

procedure TfrmAccounts._OnChange(Sender: TObject);
begin
  if ControlsEnabled then
    Dirty := True;
end;

procedure TfrmAccounts.FormCreate(Sender: TObject);
begin
  FbUpdateDuringEditing := False;
  FbControlsEnabled := False;
  dsrcAccounts.DataSet := GAccountsCopy;
  GAccountsCopy.First;
  GAccountsCopy.OnUpdateQuery := _UpdateQuery;
  GAccountsCopy.AfterScroll := _AfterScroll;
  GAccountsCopy.BeforeScroll := _BeforeScroll;
  FbDirty := False;
  FbControlsEnabled := True;
  DoDesign;
end;

procedure TfrmAccounts.FormDestroy(Sender: TObject);
begin
  GAccountsCopy.OnUpdateQuery := Nil;
  GAccountsCopy.AfterScroll := Nil;
  GAccountsCopy.BeforeScroll := Nil;
  GAccountsCopy.Filter := '';
  GAccountsCopy.Filtered := False;
end;

procedure TfrmAccounts.butPhotoClick(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    imgAccountPhoto.LoadFromFile(OpenDialog1.FileName);
    _OnChange(Sender);
  end;
end;

procedure TfrmAccounts.imgAccountPhotoLoadCustomImage(var B: TGraphic;
  Stream: TStream);
begin
  B := TGifImage.Create;
  B.LoadFromStream( Stream );
end;

procedure TfrmAccounts.UpdateFilter;
var
  str: String;
begin
  str := '';
  if Length(editFilterNumber.Text) > 0 then
    str := 'id=' + editFilterNumber.Text;
  if Length(editFilterName.Text) > 0 then begin
    if Length(str) > 0 then
      str := str + ' and ';
    str := str + 'name LIKE ''*' + editFilterName.Text + '*''';
  end;
  GAccountsCopy.Filter := str;
  GAccountsCopy.Filtered := (Length(str) > 0);
end;

procedure TfrmAccounts.editAccountNameChange(Sender: TObject);
begin
  _OnChange(Sender);
end;


procedure TfrmAccounts.editSummaryChange(Sender: TObject);
begin
  _OnChange(Sender);
end;

procedure TfrmAccounts.dtpExpirationDateChange(Sender: TObject);
begin
  _OnChange(Sender);
end;

procedure TfrmAccounts.cbxPeriodOfValidityClick(Sender: TObject);
begin
  DoDesignExpirationDate;
  _OnChange(Sender);
end;

procedure TfrmAccounts.cbTarifsLimitClick(Sender: TObject);
begin
  _OnChange(Sender);
end;

procedure TfrmAccounts.dsrcAccountsStateChange(Sender: TObject);
begin
//  cbUserLevel.Text := editUserLevel.Text;
end;

procedure TfrmAccounts.cbUserLevelChange(Sender: TObject);
begin
  editUserLevel.Text := cbUserLevel.Text;
  _OnChange(Sender);
end;

procedure TfrmAccounts.editUserLevelChange(Sender: TObject);
begin
  cbUserLevel.Text := editUserLevel.Text;
end;

end.


