unit frmInputSumm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  GCLangUtils, gccommon;

type
  TformInputSumm = class(TForm)
    lblAccount: TLabel;
    lblAccountInfo: TLabel;
    lblInputSumm: TLabel;
    editSumma: TEdit;
    butOK: TButton;
    butCancel: TButton;
    procedure editSummaChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure butOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    typefrm:integer;    // 0 - ���������� �������, 1 - ������ �� �����
  end;

var
  formInputSumm: TformInputSumm;

implementation

uses
  uAccountSystem,
  uAccounts;
{$R *.dfm}

procedure TformInputSumm.editSummaChange(Sender: TObject);
var
  res: double;
begin
  res := StrToFloatGC(editSumma.Text);
  butOK.Enabled := (res > 0);
end;

procedure TformInputSumm.FormActivate(Sender: TObject);
begin
  if (typefrm = 1) then
    editSumma.Text := FloatToStr(GAccountsCopy.Current.Balance);
  editSummaChange(Sender);
end;

procedure TformInputSumm.butOKClick(Sender: TObject);
var
  res: double;
begin
  res := StrToFloatGC(editSumma.Text);
  if ((typefrm = 0) and (res<GAccountSystem.MinAddedSumma)) then begin
    MessageBox(HWND_TOP,PChar('����������� ����� ���������� ����� = '
        + FloatToStr(GAccountSystem.MinAddedSumma)),
        PChar(translate('Warning')), MB_OK);
    exit;
  end;
  if ((typefrm = 0) and (res>=GAccountSystem.WarningAddedSumma)) then
    if (MessageBox(HWND_TOP,PChar('�� ���������� ���� �� ����� '
        + FloatToStr(res) + ' ?'), PChar(translate('Warning')),
        MB_YESNO or MB_ICONQUESTION)<>IDYES) then
      exit;
  if ((typefrm = 1) and (res>GAccountsCopy.Current.Balance))
      then begin
    MessageBox(HWND_TOP, PChar('������ ����� ������, ��� ���� �� �����'),
        PChar(translate('Warning')), MB_OK);
    exit;
  end;
  ModalResult := mrOK;
end;

end.
