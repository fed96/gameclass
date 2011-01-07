USE GameClass
GO


/* -----------------------------------------------------------------------------
			      ����� ������� ����� 
----------------------------------------------------------------------------- */
ALTER PROCEDURE ReportCurrent
@NewShiftPoint datetime,
@LastShiftPoint datetime OUTPUT,
@Time money OUTPUT,
@Serices money OUTPUT,
@Print money OUTPUT,
@Internet money OUTPUT,
@AccountsAdded money OUTPUT,
@AccountsPayed money OUTPUT,
@AccountsReturned money OUTPUT,
@Rest money OUTPUT
/*WITH ENCRYPTION*/
AS 

set nocount on

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
select @Serices = ISNULL(sum(RS.[summa]),0) from repServices as RS
  where (@LastShiftPoint<=RS.[moment]) and (RS.[moment]<=@NewShiftPoint) and (TypeCost = 1)

-- ������� ������� � ������������� �������
select @Internet =  ISNULL(Sum(SA.TrafficCost),0), @Print =  ISNULL(Sum(S.[PrintCost]),0) from sessions as S
  inner join SessionsAdd as SA on (SA.[idSessions] = S.[id])
  where (S.[postpay]=0)
  and (@LastShiftPoint<=SA.[start]) and (SA.[start]<=@NewShiftPoint) and (S.[idClients]=0)

-- ������� ����� ��� ���������
-- ���������
select @AccountsAdded= ISNULL(Sum(AH.summa),0) from AccountsHistory as AH
 inner join users on (users.id=AH.operator)
 inner join usersgroup on (usersgroup.id=users.idUsersGroup)
where (AH.What=0)  
 and usersgroup.name='Staff'
 and (@LastShiftPoint<=AH.[moment]) and (AH.[moment]<=@NewShiftPoint)
-- ����������
select @AccountsReturned =  ISNULL(Sum(AH.[summa]),0) from AccountsHistory as AH
 inner join users on (users.id=AH.operator)
 inner join usersgroup on (usersgroup.id=users.idUsersGroup)
  where (AH.[What]=1)
  and usersgroup.name='Staff'
  and (@LastShiftPoint<=AH.[moment]) and (AH.[moment]<=@NewShiftPoint)
-- ����������
select @AccountsPayed =  ISNULL(Sum(AH.[summa]),0) from AccountsHistory as AH
  where (AH.[What]=2)
  and (@LastShiftPoint<=AH.[moment]) and (AH.[moment]<=@NewShiftPoint)

select @Time = ISNULL(sum(SA2.[summa]),0) - @Internet from sessions as S
  inner join SessionsAdd as SA on (SA.[idSessions] = S.[id])
  inner join SessionsAdd2 as SA2 on (SA.[id] = SA2.[idSessionsAdd])
  where (S.[postpay]=0)
  and (@LastShiftPoint<=SA2.[moment]) and (SA2.[moment]<=@NewShiftPoint)
  and S.[idClients]=0
SELECT @Rest= SUM(Rest) FROM 
        (SELECT S.[id], S.[CommonPay] + S.[SeparateTrafficPay] - S.[PrintCost] - S.[ServiceCost]
        - SUM(SA.[TimeCost]) - SUM(SA.[TrafficCost]) - SUM(SA.[SeparateTrafficCost]) Rest, S.[status]
        FROM Sessions AS S
        INNER JOIN SessionsAdd AS SA ON (S.[id] = SA.[idSessions])
	WHERE S.PostPay = 0
        GROUP BY S.id, S.status, S.CommonPay, S.SeparateTrafficPay, S.PrintCost, S.ServiceCost) SS
        INNER JOIN SessionsAdd AS SA ON (SS.[id] = SA.[idSessions])
        WHERE ((SA.[start] <= @NewShiftPoint) OR (SS.[status]=0)) AND (@NewShiftPoint < SA.[stop])
SET @Rest = ISNULL(@Rest, 0.0)

GO

/* -----------------------------------------------------------------------------
                               UPDATE Version
----------------------------------------------------------------------------- */
UPDATE Registry SET [value]='3.85.2' WHERE [key]='BaseVersion'
GO


