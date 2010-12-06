unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  uWinhkg;

type
  TfrmMain = class(TForm)
    btnMouseHook: TButton;
    btnMouseUnhook: TButton;
    btnLoadHookDll: TButton;
    btnUnloadHookDll: TButton;
    btnKeyboardHook: TButton;
    btnKeyboardUnhook: TButton;
    btnTestKeyboard: TButton;
    btnTestMouse: TButton;
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    procedure btnLoadHookDllClick(Sender: TObject);
    procedure btnMouseHookClick(Sender: TObject);
    procedure btnMouseUnhookClick(Sender: TObject);
    procedure btnUnloadHookDllClick(Sender: TObject);
    procedure btnKeyboardHookClick(Sender: TObject);
    procedure btnKeyboardUnhookClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnTestMouseClick(Sender: TObject);
    procedure btnTestKeyboardClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FWinhkg: TWinhkg;

  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  DirectInput8;


{$R *.dfm}


//------------------------------------------------------------------------------
// ��������� � ���������� ����������
//------------------------------------------------------------------------------
var
  lpDI8:        IDirectInput8       = nil;
  lpDIKeyboard: IDirectInputDevice8 = nil;

  nXPos, 
  nYPos:         Integer; 




//------------------------------------------------------------------------------ 
// ���:      InitDirectInput() 
// ��������: ���������� ������������� �������� DirectInput � ��������� 
//------------------------------------------------------------------------------ 
function InitDirectInput( hWnd: HWND ): Boolean;
var
  lpdf: TDIDataFormat;
begin 
  Result := FALSE; 

  // ������ ������� ������ DirectInput 
  if FAILED( DirectInput8Create( GetModuleHandle( nil ), DIRECTINPUT_VERSION,
                                 IID_IDirectInput8, lpDI8, nil ) ) then
     Exit;
  lpDI8._AddRef();

  // ������ ������ ��� ������ � �����������
  if FAILED( lpDI8.CreateDevice( GUID_SysKeyboard, lpDIKeyboard, nil ) ) then
     Exit;
  lpDIKeyboard._AddRef();

  // ������������� ��������������� ������ ��� "�������� ����������". � ����-
  // ������� ������� ����� ��������������� � �����������, ��������� � ���������
  // c_dfDIKeyboard �� ���������, �� � ������ ������� ����� ��������� � ������
  lpdf := c_dfDIKeyboard;
  if FAILED( lpDIKeyboard.SetDataFormat( lpdf ) ) then
     Exit;

  // ������������� ������� ����������. ����������� � ������ ������ � DirectX SDK
//  DISCL_FOREGROUND 
  if FAILED( lpDIKeyboard.SetCooperativeLevel( hWnd, DISCL_BACKGROUND or
                                                     DISCL_NONEXCLUSIVE ) ) then
     Exit; 

  // ����������� ���������� 
  lpDIKeyboard.Acquire(); 

  Result := TRUE; 
end; 

     


//------------------------------------------------------------------------------ 
// ���:      ReleaseDirectInput() 
// ��������: ���������� �������� �������� DirectInput 
//------------------------------------------------------------------------------ 
procedure ReleaseDirectInput(); 
begin 
  // ������� ������ ��� ������ � ����������� 
  if lpDIKeyboard <> nil then // ����� ��������� if Assigned( DIKeyboard ) 
  begin 
    lpDIKeyboard.Unacquire(); // ����������� ���������� 
    lpDIKeyboard._Release(); 
    lpDIKeyboard := nil; 
  end; 

  // ��������� ������� ������� ������ DirectInput 
  if lpDI8 <> nil then 
  begin 
    lpDI8._Release(); 
    lpDI8 := nil; 
  end; 
end;


procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FWinhkg := TWinhkg.Create('..\..\output\winhkg.dll');
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FWinhkg);
end;

procedure TfrmMain.btnLoadHookDllClick(Sender: TObject);
begin
  FWinhkg.Init();
end;

procedure TfrmMain.btnMouseHookClick(Sender: TObject);
begin
  FWinhkg.SetClientHandle(frmMain.Handle);
  FWinhkg.LockMouse();
end;

procedure TfrmMain.btnMouseUnhookClick(Sender: TObject);
begin
  FWinhkg.UnlockMouse();
end;

procedure TfrmMain.btnUnloadHookDllClick(Sender: TObject);
begin
  FWinhkg.Final();
end;

procedure TfrmMain.btnKeyboardHookClick(Sender: TObject);
begin
  FWinhkg.SetClientHandle(frmMain.Handle);
  FWinhkg.LockKeyboard();
end;

procedure TfrmMain.btnKeyboardUnhookClick(Sender: TObject);
begin
  FWinhkg.UnlockKeyboard();
end;


procedure TfrmMain.btnTestMouseClick(Sender: TObject);
begin
  if FWinhkg.IsLockMouse() then
    MessageDlg('Mouse locked', mtInformation, [mbOK], 0)
  else
    MessageDlg('Mouse unlocked', mtInformation, [mbOK], 0);
end;

procedure TfrmMain.btnTestKeyboardClick(Sender: TObject);
begin
  if FWinhkg.IsLockKeyboard() then
    MessageDlg('Keyboard locked', mtInformation, [mbOK], 0)
  else
    MessageDlg('Keyboard unlocked', mtInformation, [mbOK], 0);
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  Sleep(40000);
  if not InitDirectInput( frmMain.Handle ) then
  begin 
    MessageBox( frmMain.Handle, '������ ��� ������������� DirectInput!',
                '������!', MB_ICONHAND );
    ReleaseDirectInput(); 
    Halt;
  end;
  FWinhkg.LockKeyboard();
  Sleep(40000);
  FWinhkg.UnlockKeyboard();
  ReleaseDirectInput();
end;

procedure TfrmMain.FormClick(Sender: TObject);
begin
frmMain.SetFocus;
end;
procedure TfrmMain.Button2Click(Sender: TObject);
begin
  FWinhkg.SetClientHandle(frmMain.Handle);
end;

end.
