//////////////////////////////////////////////////////////////////////////////
//
// TNullRemoteCommand
// ����� "������" ������, ����������� �� ������������ �������.
// "������" ������� �� ��������� ������� �������� ��������.
//
// �������� ���� - 05.2005
//
//////////////////////////////////////////////////////////////////////////////

unit uNullRemoteCommand;

interface

uses
  // project units
  uRemoteCommand;

type

  //
  // TNullRemoteCommand
  //

  TNullRemoteCommand = class(TRemoteCommand)
  public
    // public methods
    procedure Execute(); override;

  end; // TNullRemoteCommand


implementation

uses
  // project units
  uDebugLog;
  

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// public methods

procedure TNullRemoteCommand.Execute();
begin
  Debug.Trace0('TNullRemoteCommand.Execute');
end; // TNullRemoteCommand.Execute


end. ////////////////////////// end of file //////////////////////////////////
