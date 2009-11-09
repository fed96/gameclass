//////////////////////////////////////////////////////////////////////////////
//
// ������ ������������������ ������� ����������
//
//////////////////////////////////////////////////////////////////////////////
unit uCrossPlatformBlocking;

interface

procedure Block(const AbLock: Boolean = True);

implementation

uses
{$IFDEF MSWINDOWS}
  uWinhkg,
  Windows,
  Forms,
  Messages,
{$ENDIF}
{$IFDEF LINUX}
  Xlib,
  QForms,
  Qt,
{$ENDIF}
  uSafeStorage,
  uClientOptions,
  uCrossPlatformWindow,
  Types;

var
  GbMinimized: Boolean;
  GbMonitorDisabled: Boolean;

{$IFDEF MSWINDOWS}
procedure BlockKeyboard(const AbLock: Boolean = True);
begin
  if AbLock then
    GWinhkg.LockKeyboard
  else
    GWinhkg.UnlockKeyboard
end;
{$ENDIF}

{$IFDEF LINUX}
procedure BlockKeyboard(const AbLock: Boolean = True);
begin
  if AbLock then
    TSafeStorage.Instance().Push(ThreadSafeOperation_Blocking,
        Integer(BlockingAction_BlockKeyboard))
  else
    TSafeStorage.Instance().Push(ThreadSafeOperation_Blocking,
        Integer(BlockingAction_UnblockKeyboard));

end;
{$ENDIF}

{$IFDEF MSWINDOWS}
procedure BlockMouse(const AbLock: Boolean = True);
begin
  if AbLock then
    GWinhkg.LockMouse
  else
    GWinhkg.UnlockMouse
end;
{$ENDIF}
{$IFDEF LINUX}
procedure BlockMouse(const AbLock: Boolean = True);
begin
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
procedure DisableMonitor(const AbLock: Boolean = True);
begin
  if AbLock then begin
     SendMessage(Application.Handle, wm_SysCommand, SC_MonitorPower, 1);
     GbMonitorDisabled := True;
  end else begin
     SendMessage(Application.Handle, wm_SysCommand, SC_MonitorPower,-1);
     GbMonitorDisabled := False;
  end;
end;
{$ENDIF}
{$IFDEF LINUX}
procedure DisableMonitor(const AbLock: Boolean = True);
begin
end;
{$ENDIF}

procedure Block(const AbLock: Boolean = True);
begin
{$IFOPT D+}
  TSafeStorage.Instance().Push(ThreadSafeOperation_TestBlockingInvalidate, 0);
{$ELSE}
  if AbLock then begin
    if GClientOptions.BlockKeyboard then
      BlockKeyboard(True);
    if GClientOptions.BlockMouse then
      BlockMouse(True);
    if GClientOptions.BlockTasks then begin
      ModifyAllWindows(True);
      if not GbMinimized then begin
        //������������ ����������
        TSafeStorage.Instance().Push(ThreadSafeOperation_RunPadAction,
            Integer(RunPadAction_RestoreVideoMode));
      end;
      GbMinimized := True;
    end;
    if GClientOptions.BlockDisplay then
      DisableMonitor(True)
    else if GbMonitorDisabled then
      //����� �������� �������!!!
      DisableMonitor(False);

  end else begin
    //����������� ������, ���� ���� �� ��������
    BlockKeyboard(False);
    BlockMouse(False);
    if GClientOptions.BlockTasks and GbMinimized then begin
      ModifyAllWindows(False);
      GbMinimized := False;
    end;
    if GbMonitorDisabled then
      DisableMonitor(False);
  end;

{$ENDIF}
end;

initialization
  GbMinimized := False;
  GbMonitorDisabled := False;

end.

