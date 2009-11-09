USE GameClass
GO

/* -----------------------------------------------------------------------------
          � ������� ������ �����, ������������ � ���� ��������
					���������� �� �������
----------------------------------------------------------------------------- */
DECLARE @SQLCode nvarchar(4000)
SET @SQLCode = N'
ALTER PROCEDURE ReportCurrent
@NewShiftPoint datetime
/*WITH ENCRYPTION*/
AS 
BEGIN
set nocount on

declare @LastShiftPoint datetime
declare @ServiceSumma money
declare @printed int
declare @traffic bigint
declare @AccountsAdded money
declare @AccountsReturned money
declare @AccountsPayed money

-- ��� ����� �������� ������ ���������� ���������� �����
if exists (select * from JournalOp)  
 select top 1 @LastShiftPoint=[moment] from JournalOp where [moment]<=@NewShiftPoint order by [moment] desc
else
 select top 1 @LastShiftPoint=SA.[start] from SessionsAdd as SA order by SA.[start]

if (@LastShiftPoint is NULL) 
begin
  select top 1 @LastShiftPoint = S.[moment] from Services as S order by [moment] desc
end

set @LastShiftPoint=ISNULL(@LastShiftPoint,@NewShiftPoint)
-- ������� ���� ���������� ������ ��������� (����������� ���������) 

-- ������� ���.�������� (�����)
select @ServiceSumma=ISNULL(sum(RS.[summa]),0) from repServices as RS
  where (@LastShiftPoint<=RS.[moment]) and (RS.[moment]<=@NewShiftPoint) and (TypeCost = 1)

-- ������� ������� � ������������� �������
select @traffic =  ISNULL(Sum(CAST(s.[traffic] AS bigint)),0), @printed =  ISNULL(Sum(s.[printed]),0) from sessions as S
  inner join SessionsAdd as SA on (SA.[idSessions] = S.[id])
  where (S.[postpay]=0)
  and (@LastShiftPoint<=SA.[start]) and (SA.[start]<=@NewShiftPoint)

-- ������� ����� ��� ���������
-- ���������
select @AccountsAdded= ISNULL(Sum(AH.summa),0) from AccountsHistory as AH
 inner join users on (users.id=AH.operator)
 inner join usersgroup on (usersgroup.id=users.idUsersGroup)
where (AH.What=0)  
 and usersgroup.name=''Staff''
 and (@LastShiftPoint<=AH.[moment]) and (AH.[moment]<=@NewShiftPoint)
 AND (users.name <> ''gcsync'')
-- ����������
select @AccountsReturned =  ISNULL(Sum(AH.[summa]),0) from AccountsHistory as AH
 inner join users on (users.id=AH.operator)
 inner join usersgroup on (usersgroup.id=users.idUsersGroup)
  where (AH.[What]=1)
  and usersgroup.name=''Staff''
  and (@LastShiftPoint<=AH.[moment]) and (AH.[moment]<=@NewShiftPoint)
 AND (users.name <> ''gcsync'')
-- ����������
select @AccountsPayed =  ISNULL(Sum(AH.[summa]),0) from AccountsHistory as AH
  inner join users on (users.id=AH.operator)
  where (AH.[What]=2)
  and (@LastShiftPoint<=AH.[moment]) and (AH.[moment]<=@NewShiftPoint)
  AND (users.name <> ''gcsync'')

select ISNULL(sum(SA2.[summa]),0) as time, @ServiceSumma as service, @traffic as traffic, @printed as printed, 
  @AccountsAdded as AccountsAdded,  @AccountsPayed as AccountsPayed, @AccountsReturned as AccountsReturned, 
  @LastShiftPoint as LastShiftPoint from sessions as S
  inner join SessionsAdd as SA on (SA.[idSessions] = S.[id])
  inner join SessionsAdd2 as SA2 on (SA.[id] = SA2.[idSessionsAdd])
  where (S.[postpay]=0)
  and (@LastShiftPoint<=SA2.[moment]) and (SA2.[moment]<=@NewShiftPoint)
  and S.[idClients]=0
END
'

IF EXISTS (SELECT * FROM Registry WHERE ([key]='BaseVersion') AND ([value]='3.84'))
  EXEC sp_executesql @SQLCode

DECLARE @Report varchar(8000)

SET @Report = 'select
  CONVERT(varchar(20),AccountsHistory.[moment],20) as [����],
  Accounts.[name] as [��� ������� ������],
  (case WHEN ([what] = 0) THEN ''����������     ''
    WHEN ([what] = 1) THEN ''����������     ''
    WHEN ([what] = 2) THEN ''���������      ''
    ELSE ''������         '' END) as [��������],
 AccountsHistory.[summa] as [�����], Users.name as [��������]
from AccountsHistory
inner join Accounts on (AccountsHistory.[idAccounts] = Accounts.[id])
inner join Users on (AccountsHistory.operator = Users.id)
where ([moment]  >= %TIME-START%) and ([moment]<=%TIME-STOP%)
order by [����] desc'

IF EXISTS (SELECT * FROM Registry WHERE ([key]='BaseVersion') AND ([value]='3.84'))
  UPDATE CustomReports SET sqlcode=@Report WHERE id=N'{DF349E8D-D232-42BF-A686-6F71F733DC0F}'

SET @Report = 'declare @sum money
declare @dopsumma money
declare @repair int
declare @uncontrol int
declare @uncontrolClub int
declare @AccountsAdded money
declare @AccountsReturned money
declare @AccountsPayed money
declare @PrintedPages int
declare @PrinterPayed money
declare @Traffic numeric(12,2)
declare @OperatorTraffic numeric(12,2)
set @sum=0
set @repair=0
set @uncontrol=0
set @uncontrolClub=0
set @dopsumma=0
select @sum=sum(summa) from repDetails where (moment>=%TIME-START%) and (moment<=%TIME-STOP%) and idClients=0
select @repair=sum(length) from repRepair where (moment>=%TIME-START%) and (moment<=%TIME-STOP%)
select @uncontrol=sum(length)  from repUncontrol where (repUncontrol.start>=%TIME-START%) and (repUncontrol.stop<=%TIME-STOP%)
select @uncontrolClub=sum(length) from repUncontrolClub where (repUncontrolClub.start>=%TIME-START%) and  (repUncontrolClub.stop<=%TIME-STOP%)
select @dopsumma = sum(count*price) from [repServices]
where (repServices.moment between %TIME-START% and %TIME-STOP%) and (TypeCost = 1)

set @sum=isnull(@sum,0)
set @repair=isnull(@repair,0)
set @uncontrol=isnull(@uncontrol,0)
set @uncontrolClub=isnull(@uncontrolClub,0)
set @dopsumma=isnull(@dopsumma,0)

select @AccountsAdded= ISNULL(Sum(AH.summa),0) from AccountsHistory as AH
 inner join users on (users.id=AH.operator)
 inner join usersgroup on (usersgroup.id=users.idUsersGroup)
where (AH.What=0)
 and usersgroup.name=''Staff''
 and (%TIME-START%<=AH.moment) and (AH.moment<=%TIME-STOP%)
 AND users.name <> ''gcsync''


select @AccountsReturned=ISNULL(Sum(AH.summa),0) from AccountsHistory as AH
 inner join users on (users.id=AH.operator)
 inner join usersgroup on (usersgroup.id=users.idUsersGroup)
where (AH.What=1)
 and usersgroup.name=''Staff''
 and (%TIME-START%<=AH.moment) and (AH.moment<=%TIME-STOP%)
 AND users.name <> ''gcsync''

select @AccountsPayed=ISNULL(sum(summa),0) from repDetails
where (moment>=%TIME-START%)  and (moment<=%TIME-STOP%)
  and idClients<>0
  AND operator <> ''gcsync''


select @PrintedPages=ISNULL(sum(printed),0) from Sessions
  where (started>=%TIME-START%)  and (started<=%TIME-STOP%)
select @PrinterPayed=ISNULL(CAST([value] as money),0) from Registry
  where [key]=''printers\DefaultPrinter''
set @PrinterPayed = @PrinterPayed*@PrintedPages

select @Traffic=sum(CAST(Sessions.traffic as numeric(12,2)))/1024/1024
from Sessions
where
 Sessions.[started] > %TIME-START% and Sessions.[started] < %TIME-STOP%

select @OperatorTraffic=sum(CAST(traffic as numeric(12,2)))/1024/1024
from JournalOp
where [moment] > %TIME-START% and [moment] < %TIME-STOP%

set @Traffic = ISNULL(@Traffic, 0) + ISNULL(@OperatorTraffic, 0)

CREATE TABLE #t (
[id] [int] IDENTITY (1, 1) NOT NULL ,
[name] [varchar] (200) COLLATE Cyrillic_General_CI_AS NULL ,
[result] [varchar] (20) COLLATE Cyrillic_General_CI_AS NULL
) ON [PRIMARY]
INSERT INTO #t (name,result) VALUES (N''�������� �������'', CAST ( @sum+@dopsumma+@AccountsAdded-@AccountsReturned AS VARCHAR(255)) )
INSERT INTO #t (name,result) VALUES (N''- - - -'', '''')
INSERT INTO #t (name,result) VALUES (N''�� ������ �����������'', CAST ( @sum AS VARCHAR(255)) )
INSERT INTO #t (name,result) VALUES (N''�� ������ �����'', CAST ( @dopsumma AS VARCHAR(255)) )
INSERT INTO #t (name,result) VALUES (N''��������� �� ����� ������� �������'', CAST ( @AccountsAdded AS VARCHAR(255)))
INSERT INTO #t (name,result) VALUES (N''���������� �� ������ ������� �������'', CAST ( @AccountsReturned AS VARCHAR(255)))
INSERT INTO #t (name,result) VALUES (N''������������ ������� (��)'', CAST ( @Traffic AS VARCHAR(255)))
INSERT INTO #t (name,result) VALUES (N''- - - -'', '''')
INSERT INTO #t (name,result) VALUES (N''���������� �� ������ ������� �������'', CAST ( @AccountsPayed AS VARCHAR(255)))
INSERT INTO #t (name,result) VALUES (N''�������� �� ������'', CAST ( @PrinterPayed AS VARCHAR(255)))
INSERT INTO #t (name,result) VALUES (N''��������� �� ������ (�����)'', @repair)
INSERT INTO #t (name,result) VALUES (N''�� ���� �������� ����������� (�����)'', @uncontrol)
INSERT INTO #t (name,result) VALUES (N''�� ��� ������� GameClass (�����)'', @uncontrolClub)
SELECT name [��������], result [��������] FROM #t order by [id] asc

if object_id(''tempdb..#t'') is not null DROP TABLE #t
'

IF EXISTS (SELECT * FROM Registry WHERE ([key]='BaseVersion') AND ([value]='3.84'))
  UPDATE CustomReports SET sqlcode=@Report WHERE id=N'{A2D71DA5-35B9-43AD-A829-A765E0927F90}'


/* -----------------------------------------------------------------------------
                               UPDATE Version
----------------------------------------------------------------------------- */
UPDATE Registry SET [value] = '1.0.2', [Public] = 0 WHERE [key]='SyncOptions\Version'
GO

