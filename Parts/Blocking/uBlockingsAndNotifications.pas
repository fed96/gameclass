//////////////////////////////////////////////////////////////////////////////
//
// ����� �������� �� ����������.
//
// ���� �������� ������� ���������� � ������ ���������,
// �� ���� ������� ����������� ������.
//
//////////////////////////////////////////////////////////////////////////////

unit uBlockingsAndNotifications;
{$IFDEF LINUX}
  {$DEFINE GCCL}
  {$DEFINE GCCLSRV}
{$ENDIF}

interface

uses
  // system units
  Types;
  // project units

const
{$IFDEF MSWINDOWS}
  TIMEOUT_DEF = 30; // ����� � ������ ����������
{$ENDIF}
{$IFDEF LINUX}
  TIMEOUT_DEF = 1000; // ����� � ������ ����������
{$ENDIF}

type

  //
  // TBlockingsAndNotifications
  //

  TBlockingsAndNotifications = class(TObject)
  private
    // fields
    FhCheckingThread: THandle;
    FbIsSoundUsed: Boolean;
    FbIsBaloonsUsed: Boolean;
    FbIsTextMessageUsed: Boolean;
    FbWindowsMinimized: Boolean;
    FbDisplayBlocked: Boolean;
    FbIsNMinutesLeftRunScriptUsed: Boolean;

    // threads methods
    procedure _DoChecking();
    // ������� �������� ���� ���� � �������

    // private helper methods

  public
    // constructor / destructor
    constructor Create();
    destructor Destroy(); override;

    // public methods
    procedure StartChecking();
    procedure StopChecking();

  end; // TBlockingsAndNotifications
var
   BlockingsAndNotifications: TBlockingsAndNotifications;

implementation

uses
  // system units
  SysUtils,
{$IFDEF MSWINDOWS}
  ShellApi,
  Dialogs,
  Activex,
  uShowTextInAllVideoModes,
  Windows,
{$ENDIF}
{$IFDEF LINUX}
  QDialogs,
  XLib,
{$ENDIF}
  // project units
{$IFDEF GCCL}
  ufrmMain,
  uCrossPlatformBlocking,
  {$IFDEF MSWINDOWS}
    Forms,
    Messages,
    uWinhkg,
    RS_APILib_TLB,
  {$ENDIF}
  {$IFDEF LINUX}
    QForms,
  {$ENDIF}
  uClientConst,
  uSafeStorage,
{$ENDIF}
{$IFDEF GCCLSRV}
  uKillTaskRemoteCommand,
  uLogoffRemoteCommand,
  uRestartRemoteCommand,
  uShutdownRemoteCommand,
  uExecuteCommandRemoteCommand,
  uClientInfoGetRemoteCommand,
  uRemoteCommand,
  uClientScripting,
{$ENDIF}
  uDebugLog,
  uClientOptions,
  uClientOptionsConst,
  uClientInfo,
  uClientInfoConst,
  DateUtils,
  uCompositeRemoteCommand;



// ����� ������������ ��� ���������� ����� �������� �������
// ��. �������� API-������� QueueUserAPC
procedure ExitThreadAPC(AdwParam: DWORD); stdcall;
begin
//
end; // ExitThreadAPC


// �� ���� ��� ������ ���� ����� ������, �� ��� ������� ���������
// ����� ������ � ��������� ������ ���������� ���������
// � �������� � ���������� �������� ��� �������� ���������
function DoChecking(Ap: TBlockingsAndNotifications): DWORD;
begin
  Ap._DoChecking();
  Result := 0;
end; // DoPrintersNotifies


//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// TBlockingsAndNotifications

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// constructor / destructor

constructor TBlockingsAndNotifications.Create();
begin
  inherited Create();

  FhCheckingThread := 0;
  FbWindowsMinimized := False;
  FbDisplayBlocked := False;
  FbIsSoundUsed := False;
  FbIsBaloonsUsed := False;
  FbIsTextMessageUsed := False;
  FbIsNMinutesLeftRunScriptUsed := False;
end; // TBlockingsAndNotifications.Create


destructor TBlockingsAndNotifications.Destroy();
begin
  inherited Destroy();
end; // TBlockingsAndNotifications.Destroy


//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// public methods

procedure TBlockingsAndNotifications.StartChecking();
var
  nThreadId: cardinal;
begin
{$IFDEF MSWINDOWS}
  FhCheckingThread := BeginThread(
      nil, 0, @DoChecking, Pointer(Self), 0, nThreadId);
  ASSERT(FhCheckingThread <> INVALID_HANDLE_VALUE);
{$ENDIF}
{$IFDEF LINUX}
  FhCheckingThread := BeginThread(
      nil, @DoChecking, Pointer(Self), nThreadId);
{$ENDIF}


end; // TBlockingsAndNotifications.StartThreads


procedure TBlockingsAndNotifications.StopChecking();
begin
{$IFDEF MSWINDOWS}
  if (FhCheckingThread <> INVALID_HANDLE_VALUE)
      and (FhCheckingThread <> 0) then begin
    QueueUserAPC(@ExitThreadAPC, FhCheckingThread, 0);
    Debug.Trace5('wait...');
    WaitForSingleObject(FhCheckingThread, INFINITE);
    Debug.Trace5('wait complete!');
    CloseHandle(FhCheckingThread);
  end;
{$ENDIF}
{$IFDEF LINUX}
{$ENDIF}
end; // TBlockingsAndNotifications.StopThreads

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// threads methods

procedure TBlockingsAndNotifications._DoChecking();
var
  dwWaitStatus: DWORD;
  bBlocked: Boolean;
{$IFDEF GCCLSRV}
  cmd: TRemoteCommand;
  dt: TDateTime;
  bAfterStopActionneededSave: Boolean;
  i: Integer;
{$ENDIF}
begin
  while(TRUE) do begin
  try
//if(False) then begin
{$IFDEF GCCLSRV}
    GClientInfo.Disconnected := GClientInfo.IsDisconnected;
//      GClientInfo.SaveIfNeeded;
    if GClientOptions.OfflineBlock
        and GClientInfo.IsDisconnected
        and not GClientInfo.IsFirstRun then begin
      case GClientOptions.OfflineBlockType of
        OfflineBlockType_Immediately :begin
          GClientInfo.Blocked := (Now >= IncMinute(GClientInfo.LastPingTime,
              GClientOptions.OfflineBlockTypeImmediatelyMin));
        end;

        OfflineBlockType_AfterSessionStop :begin
          GClientInfo.Blocked := (not GClientInfo.IsSession)
              or (Now >= GClientInfo.Stop);
        end;
      end;

      if (not GClientInfo.IsSession) or (Now >= GClientInfo.Stop) then begin
        if (GClientInfo.ClientState <> ClientState_Blocked) then begin
          dt := GClientInfo.Stop;
          bAfterStopActionneededSave := GClientInfo.AfterStopActionNeeded;
          GClientInfo.Clear(True);
          GClientInfo.Stop := dt;
          GClientInfo.AfterStopActionNeeded := bAfterStopActionneededSave;
          cmd := TClientInfoGetRemoteCommand.Create('Blocked');
          cmd.Execute;
          cmd.Free;
          cmd := TClientInfoGetRemoteCommand.Create('ClientState');
          cmd.Execute;
          cmd.Free;
        end;
      end;
    end;

    if GClientOptions.AfterStop
        and GClientInfo.AfterStopActionNeeded then begin
      if (Now >= IncSecond(GClientInfo.Stop, GClientOptions.AfterStopSec))
          then begin
        GClientInfo.Stop := DEF_STOP;
        case GClientOptions.AfterStopType of
          AfterStopType_KillTask :
            cmd := TKillTaskRemoteCommand.Create;
          AfterStopType_Logoff :
            cmd := TLogoffRemoteCommand.Create;
          AfterStopType_Restart :
            cmd := TRestartRemoteCommand.Create;
          AfterStopType_Shutdown :
            cmd := TShutdownRemoteCommand.Create;
        end;
        GClientInfo.AfterStopActionNeeded := False;
        GClientInfo.SaveIfNeeded;
        RunClientScript(caAfterStopAction);
        cmd.Execute;
        cmd.Free;
      end;
    end;

    if GClientOptions.StartBlock
        and GClientInfo.IsNotConnected
        and not GClientInfo.IsFirstRun then begin
      if (GClientOptions.StartBlockSec = 0) then
//        GClientInfo.Blocked := True
        GClientInfo.Blocked := not GClientOptions.RestoreClientInfo
            or (GClientInfo.Stop < Now)
      else
        GClientInfo.Blocked := (Now <= IncSecond(GClientInfo.LastPingTime,
              GClientOptions.StartBlockSec));
    end;
{$ENDIF}
    bBlocked := GClientInfo.ResultBlocking;
{$IFDEF LINUX}
    // ����� ��������� ������
    bBlocked := bBlocked and frmMain.AfterFirstFormShow;
{$ENDIF}
{$IFDEF GCCL}
    Block(bBlocked);
{$ENDIF}
{$IFDEF GCCLSRV}
    if GClientOptions.UseSounds
        and ((GClientInfo.ClientState = ClientState_Session)
          or (GClientInfo.ClientState = ClientState_OperatorSession))
        and (MinutesBetween(GClientInfo.Start,GClientInfo.Stop) > 5) then begin
      if (Now >= IncMinute(GClientInfo.Stop,-5{GClientOptions.UseTextMessageMin}))
          then begin
        if (Now < GClientInfo.Stop) and not FbIsSoundUsed then begin
          FbIsSoundUsed := True;
          //Play Sound
          //���� ������ �� ����������� - ������ ������ � ������������
        end;
      end else
        FbIsSoundUsed := False;
    end;
{$ENDIF}
{$IFDEF GCCL}
    if GClientOptions.UseBaloons
        and ((GClientInfo.ClientState = ClientState_Session)
          or (GClientInfo.ClientState = ClientState_OperatorSession))
        and (MinutesBetween(GClientInfo.Start,IncSecond(GClientInfo.Stop))
        > GClientOptions.UseTextMessageMin) then begin
      if (Now >= IncMinute(GClientInfo.Stop,-5{GClientOptions.UseTextMessageMin}))
          then begin
        if (Now < GClientInfo.Stop) and not FbIsBaloonsUsed then begin
          FbIsBaloonsUsed := True;
          //Show Baloons
  {$IFDEF MSWINDOWS}
          frmMain.modernTrayIcon.ShowBalloonHint('��������������',
              '����� 5 ����� ���� ����� ��������!');
  {$ENDIF}
  {$IFDEF LINUX}
    cmd := TExecuteCommandRemoteCommand.Create('scripts/warn5');
    cmd.Execute;
    cmd.Free;
  {$ENDIF}
        end;
      end else
        FbIsBaloonsUsed := False;
    end;
{$ENDIF}
{$IFDEF GCCLSRV}
    if GClientOptions.UseTextMessage
        and ((GClientInfo.ClientState = ClientState_Session)
          or (GClientInfo.ClientState = ClientState_OperatorSession))
        and (MinutesBetween(GClientInfo.Start,IncSecond(GClientInfo.Stop))
        > GClientOptions.UseTextMessageMin) then begin
      if (Now >= IncMinute(GClientInfo.Stop,-GClientOptions.UseTextMessageMin))
          then begin
        if (Now < GClientInfo.Stop) and not FbIsTextMessageUsed then begin
          FbIsTextMessageUsed := True;
{$IFDEF MSWINDOWS}
          //Show TextMessage
          if GClientOptions.UseTextMessageBlinking then
            ShowTextInAllVideoModesBlinking(
                '����� ' + IntToStr(GClientOptions.UseTextMessageMin)
                + ' ����� ���� ����� ��������!'+Chr(13)+Chr(10)
                + '��������� ����� ������������! '+Chr(13)+Chr(10),3)
          else
            ShowTextInAllVideoModesSwitchDesktops(
                '����� ' + IntToStr(GClientOptions.UseTextMessageMin)
                + ' ����� ���� ����� ��������!'+Chr(13)+Chr(10)
                + '��������� ����� ������������! '+Chr(13)+Chr(10),3);
{$ENDIF}
{$IFDEF LINUX}
          //Show TextMessage
{$ENDIF}
        end;
      end else
        FbIsTextMessageUsed := False;
    end;
    // RunScript caNMinutLeft
    if ((GClientInfo.ClientState = ClientState_Session)
        or (GClientInfo.ClientState = ClientState_OperatorSession))
        and (MinutesBetween(GClientInfo.Start,IncSecond(GClientInfo.Stop))
        > GClientOptions.UseTextMessageMin) then begin
      if (Now >= IncMinute(GClientInfo.Stop,-GClientOptions.UseTextMessageMin))
          then begin
        if (Now < GClientInfo.Stop)
            and not FbIsNMinutesLeftRunScriptUsed then begin
          FbIsNMinutesLeftRunScriptUsed := True;
          RunClientScript(caNMinutesLeft);
        end;
      end else
        FbIsNMinutesLeftRunScriptUsed := False;
    end;
{$ENDIF}
//end;
  except
    on e: Exception do begin
      Debug.Trace0('_DoChecking Error! ' + e.Message);
    end;
  end;
{$IFDEF MSWINDOWS}
    dwWaitStatus := SleepEx(TIMEOUT_DEF, TRUE);
    if (WAIT_IO_COMPLETION = dwWaitStatus) then begin
      break;
    end;
{$ENDIF}
{$IFDEF LINUX}
  Sleep(TIMEOUT_DEF)
{    dwWaitStatus := SleepEx(TIMEOUT_DEF, TRUE);
    if (WAIT_IO_COMPLETION = dwWaitStatus) then begin
      break;
    end;
}
{$ENDIF}
  end;
end; // TBlockingsAndNotifications._DoChecking



end.
