unit uTariffication;

interface

uses
  gcconst;

type
  // ����� �������� ��������� ������
  TTarifVariants = class
  private
    FnTrafficLimit: Integer; //����� ����������� �����
    FfTrafficCost: Double;  //��������� �����
    FbTrafficSeparatePayment: Boolean; //��������� ������ �����
    FbFreePacket: Boolean; //����� ����� ���������� � ����� �����
  public
    constructor Create;
    // ToDo ����� ������� � ������� � ���������� �� ��� ������ � ��� ����������
    function IsAvailable(curtime: TDateTime):boolean;
    function TypeIntersect(startR,stopR: TDateTime):integer;
    function GetDaysofweekStop:string;
  public
    id: longword;               // id � ���� ������
    idTarif: integer;           // id ������, � �������� ������� �����������
    name: string;               // �������� ��������
    start: TDateTime;           // ������ (����������� ������ ����� �����)
    stop: TDateTime;            // ����� (����������� ������ ����� �����)
    cost: double;               // ��������� (�� ��� ��� �� ���� ��������)
    ispacket: boolean;          // � ��� ��, �� ���� ������� �� ��� ��� �������� ���������
    daysofweek: string;         // ��� ������, ��� ������ = "1234567"
    DaysofweekStop: string;     // ��� ������, � ������� ���������� Stop ���������
    bCondition: boolean;        // true, ���� ������ �������
    ConditionType: string;      // ��� ��������� � ������� (CONDITION_EQUALMORE)
    ConditionValue: integer;    // ���������� ����� � ��������� � �������
    property TrafficLimit: Integer read FnTrafficLimit write FnTrafficLimit;
    property TrafficCost: Double read FfTrafficCost write FfTrafficCost;
    property TrafficSeparatePayment: Boolean
        read FbTrafficSeparatePayment write FbTrafficSeparatePayment;
    property FreePacket: Boolean
        read FbFreePacket write FbFreePacket;

  end;

  // ����� ������
  TTarif = class
  public
    constructor Create;
    destructor Destroy; override;
    function CalculateTimeLength(start: TDateTime; money: double; vip: Integer; discount:integer):TDateTime;
    function CalculateCost(start,stop: TDateTime;
        vip: Integer; discount:integer; AbClearSeconds: Boolean):double;
    // ��������� ������� �� �����
    function TimeFromSeconds(seconds: longword): TDateTime;
    function GetWholeStartByIndex(idWhole: longword): TDateTime;
    function GetWholeStopByIndex(idWhole: longword): TDateTime;
    function GetWholeLengthByIndex(idWhole: longword): TDateTime;
    function GetWholeAtMidnightByIndex(idWhole: longword): Boolean;
    function GetWholeCostByIndex(idWhole: longword; idComp: longword): double;
    function GetWholeNameByIndex(idWhole: longword): string;
    function GetWholePrevDay(curtime: TDateTime; idWhole: longword): boolean;
    function GetWholeTrafficLimit(AnWhole: longword; AdtStart: TDateTime;
        AdtStop: TDateTime): Double;
    function GetWholeTrafficCost(AnWhole: longword): Double;
    function GetWholeTrafficSeparatePayment(AnWhole: longword): Boolean;

    // �������� ����������� �����
    function GetInexpensiveTarifVariant(
      const AdtMoment: TDateTime; // ������ �������
      const AbCalcByTime: Boolean; // ������ �� ������� ��� �� �������
      const AdtLength: TDateTime; // ���������� ����� (��� �������)
      const AfMoney: Double // ���������� ������ (��� �������)
      ): TTarifVariants;

    // �������� ����������� ����� �� �������
    function GetInexpensiveTarifVariantByTime(
      const AdtMoment: TDateTime; // ������ �������
      const AdtLength: TDateTime // ���������� ����� (��� �������)
      ): TTarifVariants;

    // �������� ����������� ����� �� �������
    function GetInexpensiveTarifVariantByMoney(
      const AdtMoment: TDateTime; // ������ �������
      const AfMoney: Double // ���������� ������ (��� �������)
      ): TTarifVariants;


    //���������� Whole ��� �������, � ������� ������� ��� ���������
    function GetTarifVariantByWhole(
      AnWhole: Integer;
      AdtMoment: TDateTime;
      AdtLength: TDateTime
      ): TTarifVariants;


    // ������� ���������� ������� ������ ��� ����� � �������� �����
    function fnRoundTime(length: TDateTime; stepsec: word; direction: integer): TDateTime;
    // ������� ����������� ����� ������ ��� ����� �� ��������� ����
    function fnRoundMoney(money: double; stepmoney: double; direction: integer): double;
    // ����� � ������ ������
    function CorrectedMoney(AfMoney: Double; AnDiscount: Integer): Double;
  private
    // ������� �������� ������� ������ �� �����
    function MegaFunctionCalcTimeByCost(start: TDateTime; cost: double):TDateTime;
    // ������� �������� ����� ������ �� �������
    function MegaFunctionCalcCostByTime(start,stop: TDateTime):double;
  private
    rc: integer;    // index of r
    FnBytesInMB: Integer;
    FnSpeedLimitInKB: Integer;
    FstrPluginGroupName: String;
  public
    hourcost: double;
    id: longword;
    name: string;
    internet: integer;
    calctraffic: integer;
    roundtime: integer;
    roundmoney: double;
    variantscount: integer;
    idGroup: Integer;
    userlevel: Integer; // ��������� ������� ������� ������������
    useseparatesumm: integer; // ������������ ��������� ��������� ����
    startmoneymin: integer;   // ����������� ��������� ����� ������
    startmoneymax: integer;   // ������������ ��������� ����� ������
    addmoneymin: integer;     // ����������� ����� ������� ������
    addmoneymax: integer;     // ������������ ������� ����� ������� ������
    maximumtrust: integer;    // ����� �������

    tarifvariants: array[0..(MAX_TARIFS_VARIANTS-1)] of TTarifVariants;
    property BytesInMB: Integer read FnBytesInMB write FnBytesInMB;
    property SpeedLimitInKB: Integer
        read FnSpeedLimitInKB write FnSpeedLimitInKB;
    property PluginGroupName: String
        read FstrPluginGroupName write FstrPluginGroupName;
  end;


var
  Tarifs: array[0..(MAX_TARIFS-1)] of TTarif;
  TarifsCount: integer = 0; // ������� ���������� �������
  GbInexpensiveTarifVariantNotExistsMessageShowed: Boolean;

implementation

uses
  SysUtils,
  DateUtils,
  Math,
  Types,
  uVirtualTime,
  uRegistry,
  gccomputers,
  gclangutils,
  frmGCMessageBox,
  gcfunctions,
  udmActions;


function TTarif.GetWholeStartByIndex(idWhole: longword): TDateTime;
var
  i: integer;
begin
  GetWholeStartByIndex := StrToTime('0:00:00');
  for i:=0 to variantscount-1 do
    if (tarifvariants[i].id = idWhole) then begin
      if tarifvariants[i].FreePacket then
        GetWholeStartByIndex := TimeOf(GetVirtualTime)
      else
        GetWholeStartByIndex := tarifvariants[i].start;
    end;
end;

function TTarif.GetWholeStopByIndex(idWhole: longword): TDateTime;
var
  i: integer;
begin
  GetWholeStopByIndex := StrToTime('0:00:00');
  for i:=0 to variantscount-1 do
    if (tarifvariants[i].id = idWhole) then begin
      if tarifvariants[i].FreePacket then
        GetWholeStopByIndex := TimeOf(TimeOf(GetVirtualTime)
        + tarifvariants[i].start)
      else
        GetWholeStopByIndex := tarifvariants[i].stop;
    end;
end;

function TTarif.GetWholeAtMidnightByIndex(idWhole: longword): Boolean;
var
  i: integer;
  dtStart, dtStop : TDateTime;
  s:String;
begin
  GetWholeAtMidnightByIndex := False;
  for i:=0 to variantscount-1 do
    if (tarifvariants[i].id = idWhole) then begin
      dtStart := tarifvariants[i].start;
      dtStop := tarifvariants[i].stop;
      s:= DateTimeToStr(dtStart) + '  ' + DateTimeToStr(dtStop);
      ReplaceDate(dtStart,StrToDate('01.01.2001'));
      ReplaceDate(dtStop,StrToDate('01.01.2001'));
      s:= DateTimeToStr(dtStart) + '  ' + DateTimeToStr(dtStop);
      if (dtStart < dtStop) then
        GetWholeAtMidnightByIndex := False
      else
        GetWholeAtMidnightByIndex := True;
    end;
end;

function TTarif.GetWholeTrafficLimit(AnWhole: longword; AdtStart: TDateTime;
    AdtStop: TDateTime): Double;
var
  dtMoment: TDateTime;
  fTrafficLimit: Double; //���� ����� �� ������ ������ ��� ���������� �� �������
  tv : TTarifVariants;
begin
  GetWholeTrafficLimit := 0;
//  tv := GetTarifVariantByWhole(AnWhole,GetVirtualTime); �� ����� ������  GetVirtualTime
  tv := GetTarifVariantByWhole(AnWhole,AdtStart,AdtStop-AdtStart);
  if (tv = Nil) or not GetWholeTrafficSeparatePayment(AnWhole) then
    exit;
  dtMoment := AdtStart;
  fTrafficLimit := 0;
  while (dtMoment < AdtStop) do begin
    fTrafficLimit := fTrafficLimit +
      GetTarifVariantByWhole(AnWhole,dtMoment,AdtStop-AdtStart).TrafficLimit*1024/60; //��������� �
    dtMoment := dtMoment + EncodeTime(0,1,0,0); // ���������� �� 1 ������
  end;
  GetWholeTrafficLimit := Round(fTrafficLimit);
end;

function TTarif.GetWholeTrafficCost(AnWhole: longword): Double;
var
  tv : TTarifVariants;
begin
  GetWholeTrafficCost := 0;
  tv := GetTarifVariantByWhole(AnWhole,GetVirtualTime,0);
  if (tv <> Nil) then
    GetWholeTrafficCost := tv.TrafficCost;
end;

function TTarif.GetWholeTrafficSeparatePayment(AnWhole: longword): Boolean;
var
  tv : TTarifVariants;
begin
  GetWholeTrafficSeparatePayment := False;
  tv := GetTarifVariantByWhole(AnWhole,GetVirtualTime,0);
  if (tv <> Nil) then
    GetWholeTrafficSeparatePayment := tv.TrafficSeparatePayment
        and (internet = 1);
end;

function TTarif.GetWholePrevDay(curtime: TDateTime; idWhole: longword): boolean;
var
  i,j: integer;
  fuckit: boolean;
  curday, prevday: integer;
  lefttime, righttime: TDateTime;
begin
  GetWholePrevDay := false;
  for i:=0 to variantscount-1 do
    if (tarifvariants[i].id = idWhole) then
    begin
      if tarifvariants[i].FreePacket then
        exit;
      // ��������� ������� ���� ������
      curday := DayOfWeek(curtime);
      curday := curday - 1;
      if (curday = 0) then curday := 7;
      prevday := curday - 1;
      if prevday=0 then prevday := 7;
      fuckit := false;
      for j:=1 to StrLen(PChar(tarifvariants[i].daysofweek)) do
      begin
        if (StrToInt(tarifvariants[i].daysofweek[j]) = curday) then
        begin
          lefttime := StrToDate(DateToStr(curtime));
          lefttime := IncHour(lefttime,HourOf(tarifvariants[i].start));
          lefttime := IncMinute(lefttime,MinuteOf(tarifvariants[i].start));
          righttime := lefttime;
          righttime := IncHour(righttime, HourOf(tarifvariants[i].stop));
          righttime := IncMinute(righttime, MinuteOf(tarifvariants[i].stop));
          if ((lefttime<=curtime) and (curtime<righttime)) then  fuckit := true;
        end;
        if (StrToInt(tarifvariants[i].daysofweek[j]) = prevday) then
          GetWholePrevDay := true;
      end;
      if (fuckit = true) then GetWholePrevDay := false;
    end;
end;


function TTarif.GetWholeNameByIndex(idWhole: longword): string;
var
  i: integer;
begin
  GetWholeNameByIndex := '';
  for i:=0 to variantscount-1 do
    if (tarifvariants[i].id = idWhole) then GetWholeNameByIndex := tarifvariants[i].name;
end;


function TTarif.GetWholeLengthByIndex(idWhole: longword): TDateTime;
var
  i: integer;
begin
  GetWholeLengthByIndex := StrToTime('0:00:00');
  for i:=0 to variantscount-1 do
    if (tarifvariants[i].id = idWhole) then begin
      if tarifvariants[i].FreePacket then
        GetWholeLengthByIndex := TimeOf(tarifvariants[i].Start)
      else begin
        if (tarifvariants[i].stop > tarifvariants[i].start) then
          GetWholeLengthByIndex := TimeOf(tarifvariants[i].stop
              - tarifvariants[i].start)
        else
          GetWholeLengthByIndex := 1.0 - TimeOf(tarifvariants[i].start
              - tarifvariants[i].stop);
      end;
    end;
end;

function TTarif.GetWholeCostByIndex(idWhole: longword; idComp: longword): double;
var
  i: integer;
begin
  GetWholeCostByIndex := 0;
  for i:=0 to variantscount-1 do
    if (tarifvariants[i].id = idWhole) then
    begin
//TODOVIP      if (Comps[ComputersGetIndex(idComp)].vip) then
//        GetWholeCostByIndex := fnRoundMoney(tarifvariants[i].cost*(1+Options.VIPk/100),roundmoney,1)
//      else
        GetWholeCostByIndex := tarifvariants[i].cost;
      break;
    end;
end;

constructor TTarifVariants.Create;
begin
  DaysofweekStop := '';
end;

// ���������� ������ ���� ��������� ���������
function TTarifVariants.GetDaysofweekStop:string;
var
  i: integer;
  NextDay: string;
begin
  if (DaysofweekStop<>'') then begin
    GetDaysofweekStop := DaysofweekStop;
    exit;
  end;

  for i:=1 to StrLen(PChar(daysofweek)) do begin
    NextDay := daysofweek[i];
    if ((TimeOf(start)>TimeOf(stop)) or ((TimeOf(start)=EncodeTime(0,0,0,0)) and (TimeOf(stop)=EncodeTime(0,0,0,0)))) then begin
      NextDay := IntToStr(StrToInt(NextDay)+1);
      if (NextDay = '8') then NextDay := '1';
    end;
    DaysofweekStop := DaysofweekStop + NextDay;
  end;

  GetDaysofweekStop := DaysofweekStop;
end;

function TTarifVariants.IsAvailable(curtime: TDateTime):boolean;
var
  bFreePacketAvailable: Boolean;
  nTodayDayOfWeek, nTomorrowDayOfWeek: Integer;
begin
  IsAvailable := false;
  // ��� ������� ���������� true ������ ��� �������� ��������� �������
  if (ispacket = false) then exit;
  if FreePacket then begin
    //����� �������� ���� � ���� ������ ���� ������� � ������
    //��� ������ ������� � �� ����� ����� ������� �������
    nTodayDayOfWeek := DayOfTheWeek(curtime);
    nTomorrowDayOfWeek := nTodayDayOfWeek + 1;
    if (nTomorrowDayOfWeek > 7) then
      nTomorrowDayOfWeek := 1;
    bFreePacketAvailable := False;
    if (Pos(IntToStr(nTodayDayOfWeek), daysofweek)<>0)
        and (Pos(IntToStr(nTomorrowDayOfWeek), daysofweek)<>0) then
      bFreePacketAvailable := True;
    if (Pos(IntToStr(nTodayDayOfWeek), daysofweek)<>0)
        and (EncodeTime(23, 59, 59, 99) - TimeOf(Start) > TimeOf(curtime)) then
      bFreePacketAvailable := True;
    Result := bFreePacketAvailable;
    exit;
  end;
  IsAvailable := (TypeIntersect(curtime, curtime) <> INTERSECT_NOT);
end;

constructor TTarif.Create;
begin
  variantscount := 0;
  GbInexpensiveTarifVariantNotExistsMessageShowed := False;
end;

destructor TTarif.Destroy;
var
  i: integer;
begin
  if (variantscount>0) then
    for i:=0 to (variantscount-1) do
      tarifvariants[i].Destroy;
end;

// ������� �������� ������� ������ �� �����
function TTarif.CalculateTimeLength(start: TDateTime; money: double; vip: Integer; discount:integer):TDateTime;
var
  new_stop, new_length: TDateTime;
  n : Integer;
begin
  //��� ������� ������ ����������� �����
  if (id = ID_TARIF_REMONT) then exit;
  //��� �������
//  start := RecodeSecond(RecodeMilliSecond(start, 0),0);
  if (discount = 100) then begin
    CalculateTimeLength := EncodeTime(12,0,0,0);//IncHour(start,12);
    exit;
  end;
 // ��������� ����������� ������
 if useseparatesumm > 0 then
   begin
     if (money < startmoneymin) then
       begin
       CalculateTimeLength := 0;
       exit;
     end;
   end
 else
   begin
     if (money < GRegistry.Options.StartMoneyMinimum) then
       begin
         CalculateTimeLength := 0;
         exit;
       end;
   end;

 // vip � �������� �������, ���� VIP - ����� ������ :)
//TODOVIP if (vip) then money := money / (1 + Options.VIPk/100);
 //������ : ����������� ������ �� ������� ������
 //!!������� ������ ������, ��� ������ �� �.�. >100%, � ������� �����!
 if (discount > 0) and (discount < 100) then
   money := money /(1 - discount/100);

 // ��������� ����� � ������� ������� ToDo!�������� �� ���������
  money := fnRoundMoney(money, roundmoney, -1);
 // ��������� ����� �����, ������ �� ����������� ������ � �� ���������� �����

 new_stop := MegaFunctionCalcTimeByCost(start,money);
{  n := MinutesBetween(start,new_stop);
// new_stop := RecodeSecond(RecodeMilliSecond(new_stop, 0),0);
  n := MinutesBetween(start,new_stop);
 }
 // ������ ����� ��������� ���������� �� ������� � ������� �������
 //if ( not ((HourOf(new_stop) = 23) and (MinuteOf(new_stop)=59)) ) then
 new_length := fnRoundTime(new_stop-start, roundtime, -1);
 n := MinutesBetween(start,start+new_length);
 CalculateTimeLength := new_length;
end;

// ������� �������� ����� ������ �� �������
function TTarif.CalculateCost(start,stop: TDateTime; vip: Integer;
    discount:integer; AbClearSeconds: Boolean):double;
var
  new_stop: TDateTime;
  summa: double;
  n: Integer;
begin
  Result := 0;
  //��� ������� ��������� 0
  if (id = ID_TARIF_REMONT) then exit;

 // �������� ����� ����� ������!
// new_stop := start + fnRoundTime(stop-start, roundtime, 1);
  if AbClearSeconds then begin
    start := RecodeSecond(RecodeMilliSecond(start, 0),0);
    stop := RecodeSecond(RecodeMilliSecond(stop, 0),0);
  end;
  new_stop := stop;
  n := MinutesBetween(start,new_stop);
 //��������� ������ (����������, ��������� ... � ����������� �� ���������)
 summa := MegaFunctionCalcCostByTime(start,new_stop);

 // cost1 := (TotalSeconds(new_length)/3600)*price;
//TODOVIP if (vip) then summa := summa *(1 + Options.VIPk/100);
 //������ : ��������� ��������� �� ������� ������
 if (discount > 0) and (discount < 100) then
   summa := summa *(1 - discount/100);
// summa := fnRoundMoney(summa, roundmoney, 1);
 summa := fnRoundMoney(summa, roundmoney, 1);
 // � ������ ��������� ����������� ������
{  if (summa < GRegistry.Options.StartMoneyMinimum) then
    summa := GRegistry.Options.StartMoneyMinimum;
}
  if useseparatesumm > 0 then
    begin
      if (summa < startmoneymin) then
      summa := startmoneymin;
    end
  else
    begin
      if (summa < GRegistry.Options.StartMoneyMinimum) then
        summa := GRegistry.Options.StartMoneyMinimum;
    end;

 if (discount = 100) then
  summa := 0;
 CalculateCost := summa;
end;

function TTarif.TimeFromSeconds(seconds: longword): TDateTime;
var
  hour_, min_, sec_: word;
begin
  hour_ := trunc(seconds/3600);
  min_ := trunc((seconds - hour_*3600)/60);
  sec_ := seconds - hour_*3600 - min_*60;
  if (hour_>23) then begin
    hour_ := 23;
    min_ := 59;
    sec_ := 0;
  end;
  TimeFromSeconds := EncodeTime(hour_,min_,sec_,0);
end;

// ������� ���������� ������� ������ ��� ����� � �������� �����
function TTarif.fnRoundTime(length: TDateTime; stepsec: word; direction: integer): TDateTime;
var
  diffsec,old_diffsec: longword;
  i1: longword;
begin
  // ����� ������
  diffsec := TotalSeconds(length);
  if (diffsec < 2) then diffsec := diffsec + GLOBAL_TIMER;
  
  if direction > 0 then diffsec := diffsec - 1;
  old_diffsec := diffsec; 
  i1 := Round(diffsec / stepsec);
  if ((i1 * stepsec) <= diffsec) then
    diffsec := (i1 + 1) * stepsec
  else
    diffsec := i1 * stepsec;

  //���� ����������� ���������� ������ ����, �� ��������� � ������� �������
  if (direction < 0) then
    if diffsec > old_diffsec then diffsec := diffsec - stepsec;

  fnRoundTime := TimeFromSeconds(diffsec);
end;

// ������� ����������� ����� ������ ��� ����� �� ��������� ����
function TTarif.fnRoundMoney(money: double; stepmoney: double; direction: integer): double;
var
  oldmoney, roundmoney, newmoney: double;
  i1: longword;
  range:integer;
  nPartCount: Integer;
  fRoundedMoney: Double;
begin
//� ��� ��������� ������� ������� �������
//nPartCount := Trunc(money/stepmoney);
  fRoundedMoney := money/stepmoney;
  nPartCount := Trunc(fRoundedMoney);
  fRoundedMoney := stepmoney * nPartCount;
  if (direction > 0) and (abs(money-fRoundedMoney) > 0.00001) then
    fRoundedMoney := fRoundedMoney + stepmoney;
  Result := fRoundedMoney;
{  oldmoney := money;
  i1 := Round(money / stepmoney);
  roundmoney := stepmoney * i1;
  range := Round(log10(stepmoney));
  roundmoney := RoundTo(roundmoney,range-1);
  newmoney := RoundTo(money,range-1);
  if ( roundmoney < newmoney) then
    newmoney := (i1 + 1) * stepmoney
  else
    newmoney := i1 * stepmoney;

  // ���� ����������� ���������� ������ ����, �� ��������� � ������� �������
  if (direction < 0) then
    if newmoney > oldmoney then newmoney := newmoney - stepmoney;

  fnRoundMoney := newmoney;
}

end;

function TTarif.CorrectedMoney(AfMoney: Double; AnDiscount: Integer): Double;
begin
  Result := AfMoney;
  //������ : ��������� ��������� �� ������� ������
  if (AnDiscount > 0) and (AnDiscount < 100) then
    Result := AfMoney *(1 - AnDiscount/100);
  Result := fnRoundMoney(Result, roundmoney, 1);
  // � ������ ��������� ����������� ������
  if (Result < GRegistry.Options.StartMoneyMinimum) then
    Result := GRegistry.Options.StartMoneyMinimum;
  if (AnDiscount = 100) then
    Result := 0;
end;

function TTarif.MegaFunctionCalcTimeByCost(start: TDateTime;
    cost: double):TDateTime;
var
  moment: TDateTime;
  summa: double;
  bExit: Boolean;
  nMin: Integer; //���������� �����
  nSec: Integer; //���������� ������
  fConst: Double;
begin
  summa := cost;
  moment := start;
  nMin := 0;
  //���� ���������� ������ ������, ������� �� �������,
  // ����� �� ������� ����������
  // ��������� ������� (������ ����������),
  // ����������� �� ����� ������� �� ���������� ������
  //���� ������ ����� �� �����
  if (roundtime < 60) then begin
    while (roundto(summa,-3) >= 0) and (nMin <= 1441) do begin
      summa := summa - GetInexpensiveTarifVariantByMoney(moment,cost).cost/60;
      moment := IncMinute(moment,1);
      Inc(nMin);
    end;
    //����� ���������� ������������� ������������ �� ��� �����
    moment := IncMinute(moment, -1);
    summa := summa + GetInexpensiveTarifVariantByMoney(moment,cost).cost/60;
  end;
  //������ � ��� ���� 0, ���� >0
  fConst := roundtime / 60 / 60;
  while (roundto(summa,-3) >= 0) and ((moment-start) < 1.0) do begin
    summa := summa - GetInexpensiveTarifVariantByMoney(moment,cost).cost
        * fConst;
    moment := IncSecond(moment,roundtime);
  end;
  //����� ���������� ������������� ������������ �� ��� �����
  moment := IncSecond(moment, -roundtime);
  summa := summa + GetInexpensiveTarifVariantByMoney(moment,cost).cost
        * fConst;
  // �����-�� ������ �������
  if (summa < 0) then
      moment := IncSecond(moment, -roundtime);
  MegaFunctionCalcTimeByCost := moment;
end;

function TTarif.MegaFunctionCalcCostByTime(start,stop: TDateTime):double;
var
  moment: TDateTime;
  summa: double;
  dtStopWithoutLastMinutes: TDateTime;
  nLastMinutes: Integer;
  fConst: Double;
begin
  summa := 0;
  //���� ����� ������ �����, �� ��� ��.����� �������, ������� ������������
  if (stop-start)>1.0 {�����} then
    stop := start + 1.0;
  moment := start;
  //���� ���������� ������ ������, ������� �� �������,
  // ����� �� ������� ����������
  // ��������� ������� (������ ����������),
  // ����������� �� ����� ������� �� ���������� ������
  if (roundtime < 60) then begin
    nLastMinutes := (roundtime + 59) div 60;
    dtStopWithoutLastMinutes := IncMinute(stop, -nLastMinutes);
    while (CompareDateTime(moment, dtStopWithoutLastMinutes)
        = LessThanValue) do begin
      summa := summa
          + GetInexpensiveTarifVariantByTime(moment,stop-start).cost/60;
      moment := IncMinute(moment,1);
    end;
  end;
  fConst := roundtime / 60 / 60;
  while (CompareDateTime(moment, stop) = LessThanValue) do begin
    summa := summa
        + GetInexpensiveTarifVariantByTime(moment,stop-start).cost
        * fConst;
    moment := IncSecond(moment,roundtime);
  end;
  MegaFunctionCalcCostByTime := summa;
end;

function TTarif.GetInexpensiveTarifVariant(
      const AdtMoment: TDateTime; // ������ �������
      const AbCalcByTime: Boolean; // ������ �� ������� ��� �� �������
      const AdtLength: TDateTime; // ���������� ����� (��� �������)
      const AfMoney: Double // ���������� ������ (��� �������)
      ): TTarifVariants;

var
  i, min_index: integer;
  minimum : double;
begin
  Result := Nil;
  if (id = ID_TARIF_REMONT) then exit;
  // ����� ������ ������� - ���� ��� �����������
  min_index := -1;
  minimum := MAX_DOUBLE; //����� ������ �������� �� ����� :)

  for i:=0 to variantscount-1 do
    if (not TarifVariants[i].ispacket) and
      (TarifVariants[i].cost < minimum)
        and IsBetween(TimeOf(AdtMoment),
        TimeOf(TarifVariants[i].start),TimeOf(TarifVariants[i].stop))
        and (Pos(IntToStr(DayOfTheWeek(AdtMoment)),
        TarifVariants[i].daysofweek)<>0)
        then begin
      if (TarifVariants[i].bCondition
          and (TarifVariants[i].ConditionType = CONDITION_EQUALMORE)
          and ((((MinutesBetween(0,AdtLength) >= TarifVariants[i].ConditionValue)
          or (AfMoney/TarifVariants[i].cost*60 >= TarifVariants[i].ConditionValue))
          and AbCalcByTime)
          or (((AfMoney/TarifVariants[i].cost*60 >= TarifVariants[i].ConditionValue)
          and not AbCalcByTime))))
          or not TarifVariants[i].bCondition then begin
        min_index := MinutesBetween(0,AdtLength);
        min_index := i;
        minimum := TarifVariants[i].cost;
      end;
    end;
  if (min_index = -1) then begin
    if not GbInexpensiveTarifVariantNotExistsMessageShowed then begin
      GbInexpensiveTarifVariantNotExistsMessageShowed := True;
    Console.AddEvent(EVENT_ICON_ERROR, LEVEL_ERROR, translate('InexpensiveTarifVariantNotExists'));
    formGCMessageBox.memoInfo.Text := translate('InexpensiveTarifVariantNotExists') + translate('HighCryticalError');
    formGCMessageBox.SetDontShowAgain(false);
    formGCMessageBox.ShowModal;
    dmActions.actExit.Execute;
   end;
    Result := TTarifVariants.Create;
  end else
    Result := TarifVariants[min_index];
end;

// �������� ����������� ����� �� �������
function TTarif.GetInexpensiveTarifVariantByTime(const AdtMoment: TDateTime;
    const AdtLength: TDateTime): TTarifVariants;
var
  fMoney: Double;
  tv: TTarifVariants;
begin
  Result := Nil;
  //������ ���� ������� � ���������, �.�. 50�=1� 135�=3�, � 2�59� != 149� = 134�
  tv := GetInexpensiveTarifVariant(AdtMoment, True, AdtLength, 0);
  if (tv <> Nil) then begin
    fMoney := tv.cost * MinutesBetween(0,AdtLength) / 60;
    Result := GetInexpensiveTarifVariant(AdtMoment, True, AdtLength, fMoney);
  end;
end;

// �������� ����������� ����� �� �������
function TTarif.GetInexpensiveTarifVariantByMoney(const AdtMoment: TDateTime;
    const AfMoney: Double): TTarifVariants;
begin
  Result := GetInexpensiveTarifVariant(AdtMoment, False, 0, AfMoney);
end;

 //���������� Whole ��� �������, � ������� ������� ��� ���������
function TTarif.GetTarifVariantByWhole(AnWhole: Integer; AdtMoment: TDateTime;
    AdtLength: TDateTime): TTarifVariants;
var
  i: Integer;
begin
  Result := Nil;
  if (id = ID_TARIF_REMONT) then exit;
  if (AnWhole = 0) then
    Result := GetInexpensiveTarifVariantByTime(AdtMoment, AdtLength)
  else
    for i:=0 to variantscount-1 do
      if TarifVariants[i].id = AnWhole then
        Result := TarifVariants[i];
end;

// ������� ������ ��� ����������� � ���������� (startR)-(stopR)
function TTarifVariants.TypeIntersect(startR,stopR: TDateTime):integer;
var
  dayR: string;         // ���� ��������� R (R - ��� ������������ �������� ������ �� 24 �����)
  timeStartR: TDateTime;// ����� ������ R
  timeStopR: TDateTime; // ����� ����� R
  timeStartV: TDateTime;// ����� ������ V (V - ��� �������-�������� ������ �� 24 �����)
  timeStopV: TDateTime; // ����� ����� V
  bStartDayV: boolean;  // ���� ���� ����� ���� ������ � V ��� R
  bStopDayV: boolean;   // ���� ���� ����� ���� ����� � V ��� R
begin
  TypeIntersect := INTERSECT_NOT;

  // ������� ���� ��������� R
  dayR := IntToStr(DayOfWeek(startR)-1);
  if (dayR='0') then dayR := '7';

  bStartDayV := (StrScan(PChar(daysofweek),dayR[1])<>nil);
  bStopDayV := (StrScan(PChar(GetDaysofweekStop),dayR[1])<>nil);

  timeStartR := TimeOf(startR);
  timeStopR := TimeOf(stopR);
  timeStartV := TimeOf(start);
  timeStopV := TimeOf(stop);
  if (timeStopV = 0) then timeStopV := 0.999999999;

  // ������ INTERSECT_NOT
  if (not (bStartDayV or bStopDayV)) then begin
    TypeIntersect := INTERSECT_NOT;
    exit;
  end;

  // ���� ���������� � ������ ����, �� ����������� ����� ������
  if ((not bStartDayV) and bStopDayV) then timeStartV := EncodeTime(0,0,0,0);
  // ���� ��������� � ������ ����, �� ����������� ����� �����
  if (bStartDayV and (not bStopDayV)) then timeStopV := EncodeTime(0,0,0,0);

  // ������ ������ (���� ����������)
  if (timeStopV>timeStartV) then
  begin
    // INTERSECT_ALL
    if ((timeStartR>=timeStartV) and (timeStopR<=timeStopV)) then begin
      TypeIntersect := INTERSECT_ALL;
      exit;
    end;
    // INTERSECT_MIDDLE
    if ((timeStartR<timeStartV) and (timeStopR>timeStopV)) then begin
      TypeIntersect := INTERSECT_MIDDLE;
      exit;
    end;
    // INTERSECT_LEFT
    if ((timeStopR>timeStopV) and (timeStartR<timeStopV))then begin
      TypeIntersect := INTERSECT_LEFT;
      exit;
    end;
    // INTERSECT_RIGHT
    if ((timeStartR<timeStartV) and (timeStopR>timeStartV)) then begin
      TypeIntersect := INTERSECT_RIGHT;
      exit;
    end;
  end;

  // ������ ������ (���� ������������)
  if (timeStopV<timeStartV) then
  begin
    // INTERSECT_ALL
    if(
          ((timeStartR<timeStopV) and (timeStopR<=timeStopV)) or
          ((timeStartR>=timeStartV) and (timeStopR>timeStartV)) or
          ((timeStartR>=timeStopV) and (timeStopR<=timeStopV))
     ) then begin
      TypeIntersect := INTERSECT_ALL;
      exit;
    end;
    // INTERSECT_LEFTRIGHT
    if ((timeStopR>timeStartV) and (timeStartR<timeStopV)) then begin
      TypeIntersect := INTERSECT_LEFTRIGHT;
      exit;
    end;
    // INTERSECT_LEFT
    if (timeStartR<timeStopV)then begin
      TypeIntersect := INTERSECT_LEFT;
      exit;
    end;
    // INTERSECT_RIGHT
    if (timeStopR>timeStartV) then begin
      TypeIntersect := INTERSECT_RIGHT;
      exit;
    end;
  end;
end;

end.
