unit AgtStat;

interface

procedure AgtStat_PerDay;
procedure AgtStat_PerWeekDay;
procedure AgtStat_PerHour;
procedure AgtStat_PerMonth;
procedure AgtStat_Header( InitHdrNam: String );
procedure AgtStat_DauJones( FromPart: String;
                            SortByRatio: Boolean;
                            GroupByName: Boolean );
procedure AgtStat_Path_Relayers;
procedure AgtStat_Path_Feeds( sFeedMax: String );
procedure AgtStat_Path_FeedsOf( Newsserver: String );

implementation

uses Classes, SysUtils, Forms, Dialogs,
     {$IFDEF USEDLL} AgtDllI, {$ELSE} DllGrp, DllArt, {$ENDIF}
     AgtBase, Main, uperlre, uEncoding, cStats, cArts, series, graphics, Windows, Options;

const
  GroundDate = 25569.0; // =EncodeDate(1970,1,1)

type
  plArray = ^lArray;
  lArray = array[0..1000] of LongInt;

function ValToPercent( l, g : LongInt ) : String;
var  Wert : Single;
begin
     if g=0 then g:=1;
     Wert := 100.0 * l / g;
     Result := FloatToStrF( Wert, ffFixed, 7, 2 );
end;

function StatDayBaseText: String;
begin
     if DayDates then begin
        Result := 'between ' + DateToStr(DayFrom) + ' and ' + DateToStr(DayTil);
     end else begin
        Result := 'within last ' + IntToStr(ForDays) + ' days';
     end;
end;

procedure AddSerieInChart(DataCount : Integer; Data: plArray; sColor : tColor; sTitle, sXAxisTitle, sGroupName : String; sInverted : Boolean);
VAR
   TempSerie : tLineSeries;
   i : integer;
begin
     tempserie := tLineSeries.create(nil);

     with form1.chart do begin
       title.Text.clear;
       title.text.Add(sTitle);
       BottomAxis.Inverted := sInverted;
       BottomAxis.Title.Caption := sXAxisTitle;
     end;
     with tempserie do begin
       Assign( form1.chart.SeriesList[0]);
       Clear;
       tempserie.Title := sGroupname;
       ShowInLegend := true;
       SeriesColor := sColor;
       for i:=0 to DataCount do
         AddY(Data^[i]);
//         AddXY(i,Data^[i],IntToStr(i));
     end;
     form1.chart.addseries(TempSerie);
end;

function IsStartOfWeek( dt: TDateTime ): Boolean; /// neu  //JH
var  dw1: Integer;
begin
   dw1 := ord( GetLocaleChar( GetThreadLocale, LOCALE_IFIRSTDAYOFWEEK, '0' ) )
        - ord('0') + 2 {-> DayOfWeek-format};
   if dw1 > 7 then dec( dw1, 7 );
   Result := ( DayOfWeek(dt) = dw1 );
end;

function FillBlanks( count : integer) : String;
var i : integer;
begin
  Result := '';
  for i := 1 to count do
    Result := Result + ' ';
end;

function GoodTab( count : Integer; const s : string) : string;
begin
  Result := FillBlanks(count-(length(s))) + s;
end;

procedure AgtStat_PerDay;
var  TG   : TAgtGroupMem;
     i    : Integer;
     gnr,anr,l, Tage, GrpCnt: LongInt;
     s, tit    : String;
     ADT : TDateTime;
     FromDT, TilDT : TDateTime;
     AnzTage: LongInt;
     GrpCount, SumCount: plArray;

begin
     if not Form1.FindBegin then exit;

     if DayDates then begin
        FromDT := DayFrom;
        TilDT  := DayTil;
     end else begin
        FromDT  := int(Now)-ForDays;
        TilDT   := int(Now);
     end;

     AnzTage := trunc(TilDT) - trunc(FromDT) + 1;
     GetMem( GrpCount, AnzTage*sizeof(LongInt) );
     GetMem( SumCount, AnzTage*sizeof(LongInt) );
     for i:=0 to AnzTage-1 do SumCount^[i]:=0;
     GrpCnt := 0;

     Form1.rtfStat.Lines.Clear;
     tit := 'Statistics: Messages per Day ('+DateToStr(FromDT)+' - '+DateToStr(TilDT)+')';
     Form1.rtfStat.Lines.Add( tit );
     Form1.rtfStat.Lines.Add( '' );
     Application.ProcessMessages;

     for gnr:=0 to Form1.lstGroups.Items.Count-1 do begin
        if not(Form1.Stop) and (Form1.lstGroups.Selected[gnr]) then begin
           TG := TAgtGroupMem( Form1.lstGroups.Items.Objects[gnr] );

           for i:=0 to AnzTage-1 do GrpCount^[i]:=0;
           OpenMyArt( Opt.Database.Names[TG.PathIdx], TG.GrpID );

           for anr:=0 to AgtArtCount(HArt)-1 do begin
              inc( Form1.BalkenCount );
              if (Form1.BalkenCount mod 25)=0 then begin
                 Form1.FindStatus(TG,anr);
                 Form1.BalkenG.Progress := Form1.BalkenCount;
              end;

              AgtArtLoadIndex( HArt, anr );
              l := AgtArtUnixTime(HArt,0);
              if DayOK( l ) then begin
                 ADT := GroundDate + (l div 86400);
                 ADT := TilDT - ADT;
                 Tage := trunc(ADT);
                 inc(Form1.FindCount);
                 inc(GrpCount^[Tage]);
                 inc(SumCount^[Tage]);
              end;
           end;

           CloseMyArt;

           Form1.rtfStat.Lines.Add( TG.GrpNam );
           form1.rtfStat.Lines.Add( '' );
           Form1.rtfStat.Lines.Add( '   Mon   Tue   Wed   Thu   Fri   Sat   Sun');
           //Form1.rtfStat.Lines.Add( ' Mon | Tue | Wed | Thu | Fri | Sat | Sun |');
           inc( GrpCnt );
           s := '';
           for i:=AnzTage-1 downto 0 do begin
              if (s>'') and IsStartOfWeek(TilDT-i) then begin
                if length(s)<42 then
                  s := GoodTab(42,s);
                s := s + #13#10;//'    '; /// neu
              end;
              s := s + GoodTab(6,Format(' %3d',[GrpCount^[i]]));
              /// raus: if (i<>0) and [...] then s := s + '    ';
           end;
           Form1.rtfStat.Lines.Add( s );
           Form1.rtfStat.Lines.Add( '' );
           form1.rtfStat.Lines.Add( '' );

           AddSerieInChart(AnzTage-1, GrpCount, GrpCnt*4048, tit, 'Days back', TG.GrpNam, true);  //ToDo: Color für Series

           Application.ProcessMessages;

        end;
        Application.ProcessMessages;
     end;

     if GrpCnt > 1 then begin
        Form1.rtfStat.Lines.Add( 'All selected groups' );
        form1.rtfStat.Lines.Add( '' );
        Form1.rtfStat.Lines.Add( '   Mon   Tue   Wed   Thu   Fri   Sat   Sun  ');
        s := '';
        for i:=AnzTage-1 downto 0 do begin
           if (s>'') and IsStartOfWeek(TilDT-i) then begin
             if length(s)<42 then
               s := GoodTab(42,s);
             s := s + #13#10;//'    '; /// neu
           end;
           s := s + GoodTab(6,Format(' %3d',[SumCount^[i]]));
           /// raus: if (i<>0) and [...] then s := s + '    ';
        end;
        Form1.rtfStat.Lines.Add( s );
        Form1.rtfStat.Lines.Add( '' );
     end;

     FreeMem( GrpCount, AnzTage*sizeof(LongInt) );
     FreeMem( SumCount, AnzTage*sizeof(LongInt) );

     Form1.FindEnd;
     Form1.rtfStat.SelStart := 0;
     Form1.rtfStat.SetFocus;
end;

procedure AgtStat_PerWeekDay;
var  TG   : TAgtGroupMem;
     i    : Integer;
     gnr,anr,l, Tage, GrpCnt: LongInt;
     tit    : String;
     ADT : TDateTime;
     FromDT, TilDT : TDateTime;
     AnzTage: LongInt;
     GrpCount{, SumCount}: plArray;
     dSUN, dMON, dTUE, dWED, dTHU, dFRI, dSAT : Integer;

begin
     if not Form1.FindBegin then exit;

     if DayDates then begin
        FromDT := DayFrom;
        TilDT  := DayTil;
     end else begin
        FromDT  := int(Now)-ForDays;
        TilDT   := int(Now);
     end;

     AnzTage := trunc(TilDT) - trunc(FromDT) + 1;
     GetMem( GrpCount, AnzTage*sizeof(LongInt) );
//     GetMem( SumCount, AnzTage*sizeof(LongInt) );
//     for i:=0 to AnzTage-1 do SumCount^[i]:=0;
     GrpCnt := 0;

     Form1.rtfStat.Lines.Clear;
     tit := 'Statistics: Messages per Weekday ('+DateToStr(FromDT)+' - '+DateToStr(TilDT)+')';
     Form1.rtfStat.Lines.Add( tit );
     Form1.rtfStat.Lines.Add( '' );
     Application.ProcessMessages;

     for gnr:=0 to Form1.lstGroups.Items.Count-1 do begin
        if not(Form1.Stop) and (Form1.lstGroups.Selected[gnr]) then begin
           TG := TAgtGroupMem( Form1.lstGroups.Items.Objects[gnr] );

           for i:=0 to AnzTage-1 do GrpCount^[i]:=0;
           OpenMyArt( Opt.Database.Names[TG.PathIdx], TG.GrpID );

           for anr:=0 to AgtArtCount(HArt)-1 do begin
              inc( Form1.BalkenCount );
              if (Form1.BalkenCount mod 25)=0 then begin
                 Form1.FindStatus(TG,anr);
                 Form1.BalkenG.Progress := Form1.BalkenCount;
              end;

              AgtArtLoadIndex( HArt, anr );
              l := AgtArtUnixTime(HArt,0);
              if DayOK( l ) then begin
                 ADT := GroundDate + (l div 86400);
                 ADT := TilDT - ADT;
                 Tage := trunc(ADT);
                 inc(Form1.FindCount);
                 inc(GrpCount^[Tage]);
//                 inc(SumCount^[Tage]);
              end;
           end;

           CloseMyArt;

           Form1.rtfStat.Lines.Add( TG.GrpNam );
           inc( GrpCnt );
           dSUN := 0; dMON := 0; dTUE := 0;
           dWED := 0; dTHU := 0; dFRI := 0;
           dSAT := 0;

           for i:=AnzTage-1 downto 0 do begin
              if (i<>0) then
              case DayOfWeek(TilDT-i) of //SUN, MON, TUE, WED, THU, FRI, SAT
                1: inc(dSun,GrpCount^[i]);
                2: inc(dMon,GrpCount^[i]);
                3: inc(dTue,GrpCount^[i]);
                4: inc(dWed,GrpCount^[i]);
                5: inc(dThu,GrpCount^[i]);
                6: inc(dFri,GrpCount^[i]);
                7: inc(dSat,GrpCount^[i]);
              else
              end;
           end;
           with Form1.rtfStat.Lines do begin
             Add( 'Monday:    '+ IntToStr(dMon));
             Add( 'Tuesday:   '+ IntToStr(dTue));
             Add( 'Wednesday: '+ IntToStr(dWed));
             Add( 'Thursday:  '+ IntToStr(dThu));
             Add( 'Friday:    '+ IntToStr(dFri));
             Add( 'Saturday:  '+ IntToStr(dSat));
             Add( 'Sunday:    '+ IntToStr(dSun));
             Add( '' );
           end;

//           AddSerieInChart(AnzTage-1, GrpCount, GrpCnt*4048, tit, 'Days back', TG.GrpNam, true);  //ToDo: Color für Series

           Application.ProcessMessages;

        end;
        Application.ProcessMessages;
     end;

{     if GrpCnt > 1 then begin
        Form1.rtfStat.Lines.Add( 'All selected groups' );
        s := '';
        for i:=AnzTage-1 downto 0 do begin
           s := s + Format(' %3d',[SumCount^[i]]);
           if (i<>0) and (DayOfWeek(TilDT-i)=DayOfWeek(Now)) then s := s + '    ';
        end;
        Form1.rtfStat.Lines.Add( s );
        Form1.rtfStat.Lines.Add( '' );
     end;
}
     FreeMem( GrpCount, AnzTage*sizeof(LongInt) );
//     FreeMem( SumCount, AnzTage*sizeof(LongInt) );

     Form1.FindEnd;
     Form1.rtfStat.SelStart := 0;
     Form1.rtfStat.SetFocus;
end;

procedure AgtStat_PerMonth;
var  TG   : TAgtGroupMem;
     i    : Integer;
     gnr,anr,l, GrpCnt: LongInt;
     s, tit    : String;
     ADT : TDateTime;
     FromDT, TilDT : TDateTime;
     GrpTS, SumTS: TStatList;
     TempSerie : tLineSeries;

begin
     if not Form1.FindBegin then exit;

     if DayDates then begin
        FromDT := DayFrom;
        TilDT  := DayTil;
     end else begin
        FromDT  := int(Now)-ForDays;
        TilDT   := int(Now);
     end;

     GrpTS := TStatList.Create;
     SumTS := TStatList.Create;
     GrpCnt := 0;

     Form1.rtfStat.Lines.Clear;
     tit := 'Statistics: Messages per Month ('+DateToStr(FromDT)+' - '+DateToStr(TilDT)+')';
     Form1.rtfStat.Lines.Add( tit );
     Form1.rtfStat.Lines.Add( '' );
     Application.ProcessMessages;

     for gnr:=0 to Form1.lstGroups.Items.Count-1 do begin
        if not(Form1.Stop) and (Form1.lstGroups.Selected[gnr]) then begin
           GrpTS.Clear;
           TG := TAgtGroupMem( Form1.lstGroups.Items.Objects[gnr] );

           OpenMyArt( Opt.Database.Names[TG.PathIdx], TG.GrpID );

           for anr:=0 to AgtArtCount(HArt)-1 do begin
              inc( Form1.BalkenCount );
              if (Form1.BalkenCount mod 25)=0 then begin
                 Form1.FindStatus(TG,anr);
                 Form1.BalkenG.Progress := Form1.BalkenCount;
              end;

              AgtArtLoadIndex( HArt, anr );
              l := AgtArtUnixTime(HArt,0);
              if DayOK( l ) then begin
                 ADT := GroundDate + (l div 86400);
                 s := FormatDateTime( 'yyyy.mm', ADT );
                 GrpTS.Add( s );
                 SumTS.Add( s );
                 inc(Form1.FindCount);
              end;
           end;

           CloseMyArt;

           Form1.rtfStat.Lines.Add( TG.GrpNam );
           inc( GrpCnt );
           for i:=0 to GrpTS.Count-1 do begin
              s := GrpTS.Keys[i] + GoodTab(12,Format(' %5d',[GrpTS.Infos[i].Counter]));
              Form1.rtfStat.Lines.Add( s );
           end;
           Form1.rtfStat.Lines.Add( '' );
           Application.ProcessMessages;


           tempserie := tLineSeries.create(nil);

           with form1.chart do begin
             title.Text.clear;
             title.text.Add(Tit);
             BottomAxis.Inverted := false;
             BottomAxis.Title.Caption := 'Month';
           end;
           with tempserie do begin
             Assign( form1.chart.SeriesList[0]);
             Clear;
             title := tg.GrpNam;
             ShowInLegend := true;
             SeriesColor := GrpCnt*2048;
             for i:=0 to GrpTS.Count-1 do
               AddY(GrpTS.Infos[i].counter);
//               AddXY(i,GrpTS.Infos[i].counter,GrpTS.Keys[i]);

           end;
           form1.chart.addseries(TempSerie);

        end;
        Application.ProcessMessages;
     end;

     if GrpCnt > 1 then begin
        Form1.rtfStat.Lines.Add( 'All selected groups' );
        for i:=0 to SumTS.Count-1 do begin
           s := SumTS.Keys[i] + GoodTab(12,Format(' %5d',[SumTS.Infos[i].Counter]));
           Form1.rtfStat.Lines.Add( s );
        end;
        Form1.rtfStat.Lines.Add( '' );
     end;

     GrpTS.Free;
     SumTS.Free;

     Form1.FindEnd;
     Form1.rtfStat.SelStart := 0;
     Form1.rtfStat.SetFocus;
end;

procedure AgtStat_PerHour;
var  TG   : TAgtGroupMem;
     i    : Integer;
     gnr,anr,l: LongInt;
     s, tit    : String;
     FromDT, TilDT : TDateTime;
     Intervals, ZaehlSum: LongInt;
     ZaehlAnz : plArray;
     Hour, mm, ss, ms: Word;
     GrpCnt : Integer;

begin
     if not Form1.FindBegin then exit;

     if DayDates then begin
        FromDT := DayFrom;
        TilDT  := DayTil;
     end else begin
        FromDT  := int(Now)-ForDays;
        TilDT   := int(Now);
     end;

     Intervals := 24;
     GetMem( ZaehlAnz, Intervals*sizeof(LongInt) );
     for i:=0 to Intervals-1 do ZaehlAnz^[i]:=0;
     ZaehlSum := 0;

     Form1.rtfStat.Lines.Clear;
     tit := 'Statistics: Messages per hour ('+DateToStr(FromDT)+' - '+DateToStr(TilDT)+')';
     Form1.rtfStat.Lines.Add( tit );
     Form1.rtfStat.Lines.Add( '' );
     Application.ProcessMessages;

     GrpCnt := 0;

     for gnr:=0 to Form1.lstGroups.Items.Count-1 do begin
        if not(Form1.Stop) and (Form1.lstGroups.Selected[gnr]) then begin
           TG := TAgtGroupMem( Form1.lstGroups.Items.Objects[gnr] );

           Form1.rtfStat.Lines.Add( TG.GrpNam );
           OpenMyArt( Opt.Database.Names[TG.PathIdx], TG.GrpID );

           for anr:=0 to AgtArtCount(HArt)-1 do begin
              inc( Form1.BalkenCount );
              if (Form1.BalkenCount mod 25)=0 then begin
                 Form1.FindStatus(TG,anr);
                 Form1.BalkenG.Progress := Form1.BalkenCount;
              end;

              AgtArtLoadIndex( HArt, anr );
              l := AgtArtUnixTime(HArt,0);
              if DayOK( l ) then begin
                 DecodeTime( AgtArtDateTime(HArt,0), Hour, mm, ss, ms );
                 inc(Form1.FindCount);
                 inc(ZaehlAnz^[Hour]);
                 inc( ZaehlSum );
              end;
           end;

           CloseMyArt;

           AddSerieInChart(23, ZaehlAnz, GrpCnt*4048, tit, 'Hour-Intervall', TG.GrpNam, false);  //ToDo: Color für Series
           inc(GrpCnt);

        end;
        Application.ProcessMessages;
     end;

     Form1.rtfStat.Lines.Add( '' );
     s := ' Msgs';
     s := s + FillBlanks(8) + '%';
     s := s + FillBlanks(8) + 'Interval';
     Form1.rtfStat.Lines.Add( s );
     for i:=0 to Intervals-1 do begin
        s  := GoodTab(6,Format( '%5d', [ ZaehlAnz^[i] ] ));
        s  := s + GoodTab(10,ValToPercent(ZaehlAnz^[i],ZaehlSum)+'%');
        s  := s + GoodTab(15,Format( '%d%d', [ i div 10, i mod 10 ] ) + ':00-'
                           + Format( '%d%d', [ i div 10, i mod 10 ] ) + ':59');
        Form1.rtfStat.Lines.Add( s );
     end;
     Form1.rtfStat.Lines.Add( '' );
     s := GoodTab(6,Format( '%5d', [ ZaehlSum ] ));
     s := s + GoodTab(10,ValToPercent(ZaehlSum,ZaehlSum)+'%');
     s := s + GoodTab(16,'(probe count)');
     Form1.rtfStat.Lines.Add( s );
     Form1.rtfStat.Lines.Add( '' );

     FreeMem( ZaehlAnz, Intervals*sizeof(LongInt) );

     Form1.FindEnd;
     Form1.rtfStat.SelStart := 0;
     Form1.rtfStat.SetFocus;
end;

function DauJones( ArtText: PChar; AddEach: Boolean;
                   GrpTS, SumTS: TStatList ): Integer;
var  Art  : TArt;
     s, h    : String;
     i, j, k, n : Integer;
     qc   : Char;

     procedure DauAdd( Pts: Integer; Why: String );
     begin
          Result := Result + Pts;
          if AddEach then begin
             GrpTS.Add( Why, Pts, 2 );
             SumTS.Add( Why, Pts, 2 );
          end;
     end;

begin
     Result := 0;

     s := LowerCase( GetArtHeader('From:') );

     i := Pos( '@', s );
     if (i<=1) or (i=length(s)) then begin
        DauAdd(50,'invalid From:');
     end else begin
        h := copy( s, i+1, 255 );
        if Pos('.',h)=0 then DauAdd(50,'invalid From:');
     end;

     for n:=1 to 2 do begin
        if Pos('@dev.nul',s)>0 then DauAdd(25,'From:-fake assumed');
        if Pos('xxx'     ,s)>0 then DauAdd(25,'From:-fake assumed');

        i := Pos('this',s);
        if i>0 then begin
           j:=Pos('remove',s); if (j>0) and (j<i) then DauAdd(25,'From:-fake assumed');
           j:=Pos('erase' ,s); if (j>0) and (j<i) then DauAdd(25,'From:-fake assumed');
           j:=Pos('del'   ,s); if (j>0) and (j<i) then DauAdd(25,'From:-fake assumed');
           j:=Pos('cut'   ,s); if (j>0) and (j<i) then DauAdd(25,'From:-fake assumed');
        end;

        i := Pos('spam',s);
        if i>0 then begin
           j:=Pos('no'  ,s); if (j>0) and (j<i) then DauAdd(25,'From:-fake assumed');
           j:=Pos('stop',s); if (j>0) and (j<i) then DauAdd(25,'From:-fake assumed');
           j:=Pos('dont',s); if (j>0) and (j<i) then DauAdd(25,'From:-fake assumed');
           j:=Pos('anti',s); if (j>0) and (j<i) then DauAdd(25,'From:-fake assumed');
        end;

        i := Pos('sig',s);
        if i>0 then begin
           j:=Pos('see',s); if (j>0) and (j<i) then DauAdd(25,'From:-fake assumed');
        end;

        s := ROT13(s);
     end;

     s := LowerCase( GetArtHeader('From:') );
     n := 1;
     repeat
           i := Pos(' ',s);
           j := Pos('_',s);
           if i=0 then i:=j;
           if (i>0) and (j>0) and (j<i) then i:=j;
           if i>0 then begin inc(n); System.Delete(s,1,i); end;
     until i=0;
     if n<3 then DauAdd(10,'no name in From: assumed');

     s := LowerCase( FilterMailAdr( GetArtHeader('From:'    ) ) );
     h := LowerCase( FilterMailAdr( GetArtHeader('Reply-To:') ) );
     if h<>'' then begin
        if s=h then DauAdd(1,'Reply-To: = From:');
        i := Pos('@',h);
        if (i=0) then DauAdd(25,'invalid Reply-To:');
        if (i=1) or (i=length(h)) then begin i:=0; DauAdd(25,'invalid Reply-To:'); end;
        if (i=2) and (h[1]='<')   then begin i:=0; DauAdd(25,'invalid Reply-To:'); end;
        if i>0 then begin
           h := copy(h,i+1,255);
           if Pos('.',h)=0 then DauAdd(25,'invalid Reply-To:');
        end;
     end;

     s := GetArtHeader('Message-ID:');
     i := Pos('@',s);
     if i=0 then DauAdd(5,'invalid M-ID:')
     else begin
        if Pos('.',s)=0 then DauAdd(5,'invalid M-ID: assumed');
     end;

     s := GetArtHeader('Newsgroups:');
     n := 0;
     repeat
        i:=Pos(',',s);
        if i>0 then begin inc(n); System.Delete(s,1,i); end;
     until i=0;

     s := GetArtHeader('Followup-To:');
     if s<>'' then begin
        if Pos(',',s)=0 then n:=0 else inc(n);
     end;
     if n>0 then DauAdd( n*10, 'crosspost w/o FollowUp-To' );

     Art := TArt.Create;
     Art.Text := ArtText;

     for i:=0 to Art.Count-1 do begin
        s := Lowercase(Trim(Art[i]));
        if copy(s,1,13)='content-type:' then begin
           if Pos('html',s)>0 then DauAdd(50,'html');
           if Pos('vcard',s)>0 then DauAdd(25,'vcard');
           if Pos('application/octet-stream',s)>0 then begin
              h := LowerCase( GetArtHeader('Newsgroups:') );
              if Pos('bina',h)+Pos('datei',h)=0 then DauAdd(50,'binary in non-b.-group assumed');
           end;
        end;
     end;

     n := 0;
     for i:=0 to Art.Count-1 do begin
        s := Art[i];
        if s='' then break;
        for k:=1 to length(s) do begin
           if Ord(s[k])>=$80 then begin inc(n); break; end;
        end;
        if n>0 then begin DauAdd(5,'uncoded 8bit-chars in header'); break; end;
     end;

     Art.SkipBoundary;
     Art.SkipHeader;
     qc := Art.GetQuoteChar;

     if Art.Count>10 then begin
        n := 0;
        for i:=0 to Art.Count-1 do begin
           s := Art[i];
           if (s='-- ') or (s='--=20') or (s='-- =') then break;
           s := Trim(s);
           if (s<>'') and (s<>qc) then begin
              if s[1]=qc then inc(n) else dec(n);
           end;
        end;
        if n>=10 then DauAdd( n ,'quote-ratio');

        n := 0;
        for i:=0 to Art.Count-1 do begin
           s := Art[i];
           if (s='-- ') or (s='--=20') or (s='-- =') then break;
           if Pos('-----== Posted via D',s)=1 then break; // Deja News
           s := Trim(s);
           if (s<>'') and (s<>qc) then begin
              if copy(s,1,1)=qc then
                 inc(n)
              else begin
                 if n>9 then DauAdd( n ,'mega-quote');
                 n := 0;
              end;
           end;
        end;
        if n>9 then DauAdd( n*2 ,'trailing mega-quote');
     end;

     k := -1;
     for i:=0 to Art.Count-1 do begin
        s := Art[i];
        if (s='-- ') or (s='--=20') or (s='-- =') then begin
           n := (Art.Count-1) - i;
           if n>4 then begin
              if Art[Art.Count-1]='' then dec(n);
              if n>4 then DauAdd(n,'.sig > 4 lines');
           end;
           k := i;
           break;
        end;
     end;
     if k<0 then begin
        j := Art.Count - 1;
        while (j>0) and (Trim(Art[j])='') do dec(j);
        dec(j,2);
        k := -1;
        for i:=0 to j do begin
           s := Art[i];
           if (copy(s,1,2)='--') and (copy(s,1,5)<>'-----') and (length(s)<10) then begin
              if s<>'-->' then k:=i;
           end;
        end;
        if k>0 then begin
           DauAdd(1,'pseudo-.sig assumed "'+Art[k]+'"');
           n := (Art.Count-1) - k;
           if n>4 then begin
              if Art[Art.Count-1]='' then dec(n);
              if n>4 then DauAdd(n,'pseudo-.sig > 4 lines assumed');
           end;
        end;
     end;
     n := 0;
     j := Art.Count-1;
     while (j>=0) and (Art[j]='') do begin inc(n); dec(j); end;
     if n>1 then DauAdd(n-1,'trailing empty-lines');

     Art.Free;

     if Result<0 then Result:=0; // no bonus-points

     if AddEach then begin
        GrpTS.Add( '(probe count)', Result, 0 );
        SumTS.Add( '(probe count)', Result, 0 );
        if Result<=0 then begin
           GrpTS.Add( '"DAU Jones ;-)" tested and approved!', 0, 1 );
           SumTS.Add( '"DAU Jones ;-)" tested and approved!', 0, 1 );
        end else begin
           GrpTS.Add( '"DAU Jones ;-)" failed!', Result, 1 );
           SumTS.Add( '"DAU Jones ;-)" failed!', Result, 1 );
        end;
     end;
end;

procedure AgtStat_DauJones( FromPart: String;
                            SortByRatio: Boolean;
                            GroupByName: Boolean );
const DAUHeader = 'DAU Jones ;-) ';

   procedure Report( const Title: String;
                     const TS: TStatList );
   var  s: String;
        i, summsg, sumdau, d, l: Integer;
        TH: TStatInfo;
   begin
     if FromPart<>'' then SortByRatio:=False; // nur bei Ranking
     if SortByRatio then TS.SortBy_Group_WCRatioDesc
                    else TS.SortBy_GroupDesc_Weight;

     Form1.rtfStat.Lines.Add( Title );

     s := 'Pos.' + #9 + 'DAUs';
     s := s      + #9 + 'Msgs';
     s := s      + #9 + 'Ratio';
     if FromPart='' then s := s + #9 + 'Who'
                    else s := s + #9 + 'Why';
     Form1.rtfStat.Lines.Add( s );

     if FromPart='' then begin
        for i:=0 to TS.Count-1 do begin
           TH := TS.Infos[i];
           if TH.Weight>0 then begin
              s := inttostr(i+1) + #9 + IntToStr(TH.Weight);
              s := s + #9 + IntToStr(TH.Counter);
              s := s + #9 + FloatToStrF( 1.0*TH.Weight/TH.Counter, ffFixed, 7, 2 );
              s := s + #9 + TS.Keys[i];
              Form1.rtfStat.Lines.Add( s );
           end;
        end;
     end else begin
        summsg := 1;
        sumdau := 1;
        d := -1;
        l := 0;
        for i:=0 to TS.Count-1 do begin
           TH := TS.Infos[i];
           if TH.Group<>d then begin
              d := TH.Group;
              l := 0;
              Form1.rtfStat.Lines.Add( '' );
           end;
           inc( l );
           if TH.Group=0 then begin
              summsg := TH.Counter;
              sumdau := TH.Weight;
              s := inttostr(TH.Group)+'.'+inttostr(l) + #9 + IntToStr(TH.Weight);
              s := s + #9 + IntToStr(TH.Counter);
              s := s + #9 + FloatToStrF( 1.0*TH.Weight/TH.Counter, ffFixed, 7, 2 );
           end else begin
              if TH.Group=1 then begin
                 s := inttostr(TH.Group)+'.'+inttostr(l) + #9 + IntToStr(TH.Weight);
                 s := s + #9 + IntToStr(TH.Counter);
                 s := s + #9 + FloatToStrF( 100.0*TH.Counter/summsg, ffFixed, 7, 2 )+'%';
              end else begin
                 s := inttostr(TH.Group)+'.'+inttostr(l) + #9 + IntToStr(TH.Weight);
                 s := s + #9; // + IntToStr(TH.Anz);
                 s := s + #9 + FloatToStrF( 100.0*TH.Weight/sumdau, ffFixed, 7, 2 )+'%';
              end;
           end;
           s := s + #9 + TS.Keys[i];
           Form1.rtfStat.Lines.Add( s );
        end;
     end;

     Form1.rtfStat.Lines.Add( '' );
     Application.ProcessMessages;
   end;

var  TG   : TAgtGroupMem;
     GrpCnt, DJ: Integer;
     gnr,anr: LongInt;
     Hdr : String;
     GrpTS, SumTS: TStatList;
begin
     if not Form1.FindBegin then exit;

     Form1.rtfStat.Lines.Clear;
     if FromPart='' then Form1.rtfStat.Lines.Add( DAUHeader + '(Ranking)' )
                    else Form1.rtfStat.Lines.Add( DAUHeader + 'for "'+FromPart+'"' );
     Form1.rtfStat.Lines.Add( '(based on msgs with bodies '+StatDayBaseText+', i.e. not killfiled yet ...)' );
     Form1.rtfStat.Lines.Add( '' );
     Application.ProcessMessages;

     SumTS := TStatList.Create;
     GrpTS := TStatList.Create;
     GrpCnt := 0;

     for gnr:=0 to Form1.lstGroups.Items.Count-1 do begin
        if not(Form1.Stop) and (Form1.lstGroups.Selected[gnr]) then begin
           GrpTS.Clear;
           TG := TAgtGroupMem( Form1.lstGroups.Items.Objects[gnr] );

           OpenMyArt( Opt.Database.Names[TG.PathIdx], TG.GrpID );

           for anr:=0 to AgtArtCount(HArt)-1 do begin
              inc( Form1.BalkenCount );
              if (Form1.BalkenCount mod 25)=0 then begin
                 Form1.FindStatus(TG,anr);
                 Form1.BalkenG.Progress := Form1.BalkenCount;
              end;

              AgtArtLoadBody( HArt, anr );

              if DayOK( AgtArtUnixTime(HArt,0) ) then begin
//                 AgtArtLoadBody( HArt, anr );
                 AgtArtSkipOverviewLine( HArt );
                 ArtTextSize := AgtArtTextLen( HArt );
                 ArtText     := AgtArtTextPtr( HArt );
                 inc( Form1.FindCount );

                 if FromPart='' then begin
                    Hdr := GetArtHeader('From:');
                    if GroupByName then Hdr := FilterNameOfFrom( Hdr );
                    DJ := DauJones( ArtText, False, nil, nil );
                    GrpTS.Add( Hdr, DJ, 0 );
                    SumTS.Add( Hdr, DJ, 0 );
                 end else begin
                    Hdr := LowerCase( GetArtHeader('From:') );
                    if GroupByName then Hdr := FilterNameOfFrom( Hdr );
                    if (FromPart='@') or (Pos(LowerCase(FromPart),Hdr)>0) then begin
                       DauJones( ArtText, True, GrpTS, SumTS );
                    end;
                 end;
              end;
           end;

           CloseMyArt;
           Application.ProcessMessages;

           Report( TG.GrpNam, GrpTS );
           inc( GrpCnt );
        end;
        Application.ProcessMessages;
     end;

     if GrpCnt > 1 then Report( 'All selected groups', SumTS );

     GrpTS.Free;
     SumTS.Free;

     Form1.FindEnd;
     Form1.rtfStat.SelStart := 0;
     Form1.rtfStat.SetFocus;
end;

procedure AgtStat_Header( InitHdrNam: String );
var  TG   : TAgtGroupMem;
     i    : Integer;
     gnr,anr,l,gsum, GrpCnt: LongInt;
     s    : String;
     Hdr, Cmp : String;
     TH  : TStatInfo;
     GrpTS, SumTS: TStatList;
     GrpUsers, SumUsers: TStringList;
     HdrNam : String;
     Special : Byte;
     IsRegex : Boolean;

     function GetRegExMatch: String;
     var  Art   : TStringList;
          Lin, e: Integer;
          h     : String;
     begin
          Result := '';
          Art := TStringList.Create;
          Art.Text := String( ArtText );
          for lin:=0 to Art.Count-1 do begin
             if Art[lin]='' then break; // end-of-headers
             h := Art[lin];
             if regex.MatchS( DecodeHeadervalue( h[1], length(h) ) ) then begin
                if regex.SubExpCount<=1 then begin
                   Result := Art[lin];
                end else begin
                   for e:=1 to regex.SubExpCount do begin
                      Result := Result + copy( Art[lin],
                                               regex.SubExp[e].StartP ,
                                               regex.SubExp[e].Len );
                   end;
                end;
                break;
             end;
          end;
          Art.Free;
     end;

begin
     if InitHdrNam='' then exit;

     Special := 0;
     IsRegex := False;

     if copy(InitHdrNam,1,1)='{' then begin
        try
           s := InitHdrNam;
           System.Delete( s, 1, 1 );
           if copy(s,length(s),1)='}' then s:=copy(s,1,length(s)-1);
           regex.CompileRO( s, PCRE_CASELESS );
           IsRegex := True;
        except
           on E:Exception do begin
              MessageDlg( 'Regex-error:' + #13#10 + E.Message, mtError, [mbOK], 0);
              exit;
           end;
        end;
     end else begin
        if copy(InitHdrNam,length(InitHdrNam),1)<>':' then InitHdrNam:=InitHdrNam+':';

        if InitHdrNam[1] in ['1'..'6'] then begin {[Gruppierte] X-Newsreader}
           Special := strtoint(InitHdrNam[1]);
           InitHdrNam := copy(InitHdrNam,2,255);
        end;
     end;

     HdrNam := InitHdrNam;

     if not Form1.FindBegin then exit;

     Form1.rtfStat.Lines.Clear;
     case Special of
          1: s := 'Header-statistics for: '+ HdrNam + ', X-Mailer:, User-Agent:';
          2: s := 'Header-statistics for: Newsreader (grouped, per msg.)';
          3: s := 'Header-statistics for: '+ HdrNam + ' (grouped by domain)';
          4: s := 'Header-statistics for: '+ HdrNam + ' (grouped by name)';
          5: s := 'Header-statistics for: '+ HdrNam + ' (Re:/was: skipped)';
          6: s := 'Header-statistics for: Newsreader (grouped, per user)';
        else s := 'Header-statistics for: '+ HdrNam;
     end;
     Form1.rtfStat.Lines.Add( s );
     Form1.rtfStat.Lines.Add( '(based on msgs with bodies '+StatDayBaseText+')' );
     Form1.rtfStat.Lines.Add( '' );
     Application.ProcessMessages;

     GrpCnt := 0;
     GrpTS := TStatList.Create;
     SumTS := TStatList.Create;

     GrpUsers := TStringList.Create;
     GrpUsers.Sorted := True;
     SumUsers := TStringList.Create;
     SumUsers.Sorted := True;

     for gnr:=0 to Form1.lstGroups.Items.Count-1 do begin
        if not(Form1.Stop) and (Form1.lstGroups.Selected[gnr]) then begin
           GrpTS.Clear;
           GrpUsers.Clear;
           TG := TAgtGroupMem( Form1.lstGroups.Items.Objects[gnr] );

           OpenMyArt( Opt.Database.Names[TG.PathIdx], TG.GrpID );

           for anr:=0 to AgtArtCount(HArt)-1 do begin
              inc( Form1.BalkenCount );
              if (Form1.BalkenCount mod 25)=0 then begin
                 Form1.FindStatus(TG,anr);
                 Form1.BalkenG.Progress := Form1.BalkenCount;
              end;

              AgtArtLoadBody( HArt, anr );
              if DayOK( AgtArtUnixTime(HArt,0) ) then begin
                 AgtArtSkipOverviewLine( HArt );
                 ArtTextSize := AgtArtTextLen(HArt);
                 ArtText     := AgtArtTextPtr(HArt);
                 inc(Form1.FindCount);

                 if IsRegex then begin
                    Hdr := GetRegExMatch;
                 end else begin
                    Hdr := GetArtHeader( HdrNam );
                 end;
                 if (Hdr='') and (Special in [1,2,6]) then Hdr:=GetArtHeader('X-Mailer:');
                 if (Hdr='') and (Special in [1,2,6]) then Hdr:=GetArtHeader('User-Agent:');
                 if Hdr='' then Hdr:='(not set)';

                 if (Special=2) or (Special=6) then begin
                    Cmp := LowerCase( Hdr );
                    if Pos('Forte Free Agent',Hdr)>0 then Hdr:='"Forte Free Agent"';
                    if Pos('Forte Agent',Hdr)>0 then Hdr:='"Forte Agent"';
                    if Pos('Microsoft Outlook',Hdr)>0 then Hdr:='"Microsoft Outlook"';
                    if Pos('Microsoft Internet News',Hdr)>0 then Hdr:='"Microsoft Internet News"';
                    if Pos('Mozilla',Hdr)>0 then Hdr:='"Mozilla/NetScape"';
                    if Pos('MacSOUP',Hdr)>0 then Hdr:='"MacSOUP"';
                    if Pos('News Xpress',Hdr)>0 then Hdr:='"News Xpress"';
                    if Pos('CrossPoint',Hdr)>0 then Hdr:='"CrossPoint"';
                    if Pos('XP ',Hdr)>0 then Hdr:='"CrossPoint"';
                    if Pos('WinVN',Hdr)>0 then Hdr:='"WinVN"';
                    if Pos('slrn',Hdr)>0 then Hdr:='"slrn"';
                    if Pos('trn',Hdr)>0 then Hdr:='"trn"';
                    if Pos('xrn',Hdr)>0 then Hdr:='"xrn"';
                    if Pos('krn',Cmp)>0 then Hdr:='"krn"';
                    if Pos('PMINews',Hdr)>0 then Hdr:='"PMINews"';
                    if Pos('Virtual Access',Hdr)>0 then Hdr:='"Virtual Access"';
                    if Pos('knews',Hdr)>0 then Hdr:='"knews"';
                    if Pos('OUI ',Hdr)>0 then Hdr:='"OUI"';
                    if Pos('Gravity',Hdr)>0 then Hdr:='"Gravity"';
                    if Pos('GoldED',Hdr)>0 then Hdr:='"GoldED"';
                    if Pos('MicroDot',Hdr)>0 then Hdr:='"MicroDot"';
                    if Pos('EmTec',Hdr)>0 then Hdr:='"EmTec"';
                    if Pos('TIN ',Hdr)>0 then Hdr:='"TIN"';
                    if Pos('tin/',Hdr)>0 then Hdr:='"TIN"';
                    if Pos('Gnus',Hdr)>0 then Hdr:='"Gnus"';
                    if Pos('NN ',Hdr)>0 then Hdr:='"NN"';
                    if Pos('ZQWKPro',Hdr)>0 then Hdr:='"ZQWKPro"';
                    if Pos('ProNews',Hdr)>0 then Hdr:='"ProNews"';
                    if Pos('AOL Offline Reader',Hdr)>0 then Hdr:='"AOL Offline Reader"';
                    if Pos('ASH Emailer',Hdr)>0 then Hdr:='"ASH Emailer"';
                    if Pos('VSoup',Hdr)>0 then Hdr:='"VSoup"';
                    if Pos('News Rover',Hdr)>0 then Hdr:='"News Rover"';
                    if Pos('THOR',Hdr)>0 then Hdr:='"THOR"';
                    if Pos('xnews',Cmp)>0 then Hdr:='"Xnews"';
                    if Pos('KNode',Hdr)>0 then Hdr:='"KNode"';
                    if Pos('Lotus Notes',Hdr)>0 then Hdr:='"Lotus Notes"';
                    if Pos('turnpike',Cmp)>0 then Hdr:='"Turnpike"';
                    if Pos('kexpress',Cmp)>0 then Hdr:='"kexpress"';
                    if Pos('ameol',Cmp)>0 then Hdr:='"Ameol"';
                    if Pos('mynews',Cmp)>0 then Hdr:='"MyNews"';
                    if Pos('MT-NewsWatcher',Hdr)>0 then Hdr:='"MT-NewsWatcher"';
                 end;

                 if Special=3 then begin
                    Hdr := StatDomainOf( FilterMailAdr( Hdr ) );
                 end;

                 if Special=4 then begin
                    Hdr := FilterNameOfFrom( Hdr );
                 end;

                 if Special=5 then begin
                    Hdr := FilterSubject( Hdr );
                 end;

                 if Special=6 then begin
                    s := FilterNameOfFrom( GetArtHeader( 'From:' ) );
                    if GrpUsers.IndexOf(s)<0 then begin
                       GrpUsers.Add( s );
                       GrpTS.Add( Hdr );
                    end;
                    if SumUsers.IndexOf(s)<0 then begin
                       SumUsers.Add( s );
                       SumTS.Add( Hdr );
                    end;
                 end else begin
                    GrpTS.Add( Hdr );
                    SumTS.Add( Hdr );
                 end;
              end;
           end;

           CloseMyArt;
           Application.ProcessMessages;

           GrpTS.SortBy_Counter;

           Form1.rtfStat.Lines.Add( TG.GrpNam );
           inc( GrpCnt );
           gsum := GrpTS.CounterSum;
           s := #9 + IntToStr(gsum);
           s := s + #9 + ValToPercent(gsum,gsum)+'%';
           s := s + #9 + '(probe count)';
           if gsum>0 then Form1.rtfStat.Lines.Add( s );
           l := 0;
           for i:=0 to GrpTS.Count-1 do begin
              TH := GrpTS.Infos[i];
              if (TH.Counter>1) or IsRegex then begin
                 s := #9 + IntToStr(TH.Counter);
                 s := s + #9 + ValToPercent(TH.Counter,gsum)+'%';
                 s := s + #9 + GrpTS.Keys[i];
                 Form1.rtfStat.Lines.Add( s );
              end else begin
                 l := l + TH.Counter;
              end;
           end;
           if l>0 then begin
              s := #9 + IntToStr(l);
              s := s + #9 + ValToPercent(l,gsum)+'%';
              s := s + #9 + '(others)';
              Form1.rtfStat.Lines.Add( s );
           end;
           Form1.rtfStat.Lines.Add( '' );
           Application.ProcessMessages;

        end;
        Application.ProcessMessages;
     end;

     if GrpCnt > 1 then begin
        SumTS.SortBy_Counter;
        Form1.rtfStat.Lines.Add( 'All selected groups' );
        gsum := SumTS.CounterSum;
        s := #9 + IntToStr(gsum);
        s := s + #9 + ValToPercent(gsum,gsum)+'%';
        s := s + #9 + '(probe count)';
        if gsum>0 then Form1.rtfStat.Lines.Add( s );
        l := 0;
        for i:=0 to SumTS.Count-1 do begin
           TH := SumTS.Infos[i];
           if (TH.Counter>1) or IsRegex then begin
              s := #9 + IntToStr(TH.Counter);
              s := s + #9 + ValToPercent(TH.Counter,gsum)+'%';
              s := s + #9 + SumTS.Keys[i];
              Form1.rtfStat.Lines.Add( s );
           end else begin
              l := l + TH.Counter;
           end;
        end;
        if l>0 then begin
           s := #9 + IntToStr(l);
           s := s + #9 + ValToPercent(l,gsum)+'%';
           s := s + #9 + '(others)';
           Form1.rtfStat.Lines.Add( s );
        end;
        Form1.rtfStat.Lines.Add( '' );
     end;

     GrpTS.Free;
     SumTS.Free;
     GrpUsers.Free;
     SumUsers.Free;

     Form1.FindEnd;
     Form1.rtfStat.SelStart := 0;
     Form1.rtfStat.SetFocus;
end;

procedure AgtStat_Path_Relayers;
var  TG   : TAgtGroupMem;
     i    : Integer;
     gnr,anr,l: LongInt;
     s    : String;
     Hdr : String;
     TH  : TStatInfo;
     TS  : TStatList;
     HdrPtr : PChar;
     HdrC   : Char;
     HdrFirst : Boolean;
     HdrLast  : String;
begin
     if not Form1.FindBegin then exit;

     Form1.rtfStat.Lines.Clear;
     Form1.rtfStat.Lines.Add( 'Path-statistics: Relayers (Top 100)' );
     Form1.rtfStat.Lines.Add( '(based on msgs with bodies within last 14 days)' );
     Form1.rtfStat.Lines.Add( '' );
     Form1.rtfStat.Lines.Add( 'Pos.'+#9+'Count'+#9+'Weight'+#9+'Relayer' );
     Form1.rtfStat.Lines.Add( '' );
     Application.ProcessMessages;

     TS := TStatList.Create;

     for gnr:=0 to Form1.lstGroups.Items.Count-1 do begin
        if not(Form1.Stop) and (Form1.lstGroups.Selected[gnr]) then begin
           TG := TAgtGroupMem( Form1.lstGroups.Items.Objects[gnr] );

           OpenMyArt( Opt.Database.Names[TG.PathIdx], TG.GrpID );

           for anr:=0 to AgtArtCount(HArt)-1 do begin
              inc( Form1.BalkenCount );
              if (Form1.BalkenCount mod 25)=0 then begin
                 Form1.FindStatus(TG,anr);
                 Form1.BalkenG.Progress := Form1.BalkenCount;
              end;

              AgtArtLoadBody( HArt, anr );

              if DayOK( AgtArtUnixTime(HArt,0) ) then begin
                 ArtTextSize := AgtArtTextLen(HArt);
                 ArtText     := AgtArtTextPtr(HArt);

                 HdrPtr := AgtArtHeaderStartPtr( HArt, 'Path:' );
                 if HdrPtr<>nil then begin
                    inc(Form1.FindCount);
                    Hdr := '';
                    HdrFirst := True;

                    repeat
                       HdrC := HdrPtr^;
                       HdrPtr := (HdrPtr+1);

                       if (HdrC<>#13) and (HdrC<>#0) and (HdrC<>'!') then begin

                          if length(Hdr)<255 then Hdr := Hdr + HdrC;

                       end else begin

                          if Hdr='' then Hdr:='(no value)';
                          if Hdr<>'not-for-mail' then begin
                             if not HdrFirst then begin
                                TS.Add( Hdr );
                                HdrLast := Hdr;
                             end;
                             HdrFirst := False;
                          end;
                          Hdr := '';

                       end;
                    until (HdrC=#13) or (HdrC=#0);

                    TS.Add( HdrLast, -1 );

                 end; {if HdrPtr<>nil ...}
              end;
           end;

           CloseMyArt;
           Application.ProcessMessages;
        end;

        Application.ProcessMessages;
     end;

     {Sortieren nach Anzahl}
     TS.SortBy_Weight;

     {"Bericht" erstellen}
     l := 0;
     for i:=0 to TS.Count-1 do begin
        inc( l );
        if l<=100 then begin
           TH := TS.Infos[i];
           if TH.Weight>1 then begin
              s := IntToStr(l) + #9 + IntToStr(TH.Weight);
              s := s + #9 + ValToPercent(TH.Weight,Form1.FindCount)+'%';
              s := s + #9 + TS.Keys[i];
              Form1.rtfStat.Lines.Add( s );
           end;
        end;
     end;

     Form1.rtfStat.Lines.Add( '' );

     s := #9 + IntToStr(Form1.FindCount);
     s := s + #9 + ValToPercent(Form1.FindCount,Form1.FindCount)+'%';
     s := s + #9 + '(probe count)';
     Form1.rtfStat.Lines.Add( s );
     Form1.rtfStat.Lines.Add( '' );
     Application.ProcessMessages;

     TS.Free;

     Form1.FindEnd;
     Form1.rtfStat.SelStart := 0;
     Form1.rtfStat.SetFocus;
end;

procedure AgtStat_Path_Feeds( sFeedMax: String );
var  TG   : TAgtGroupMem;
     i    : Integer;
     gnr,anr,l: LongInt;
     s    : String;
     Hdr : String;
     TH  : TStatInfo;
     TS  : TStatList;
     HdrPtr : PChar;
     HdrC   : Char;
     HdrFirst : Boolean;
     HdrLast  : String;
     Feed    : array[1..10] of String;
     FeedMax, FeedLfd : LongInt;
begin
     if sFeedMax='' then exit;
     try FeedMax:=strtoint(sFeedMax) except FeedMax:=0 end;
     if FeedMax<1 then FeedMax:=1;
     if FeedMax>10 then FeedMax:=10;

     if not Form1.FindBegin then exit;

     Form1.rtfStat.Lines.Clear;
     Form1.rtfStat.Lines.Add( 'Path-statistics: My Feeds (<= '+IntToStr(FeedMax)+' relayer)' );
     Form1.rtfStat.Lines.Add( '(based on msgs with bodies '+StatDayBaseText+')' );
     Form1.rtfStat.Lines.Add( '' );
     Form1.rtfStat.Lines.Add( 'Pos.'+#9+'Count'+#9+'Weight'+#9+'Relayer' );
     Form1.rtfStat.Lines.Add( '' );
     Application.ProcessMessages;

     TS := TStatList.Create;

     for gnr:=0 to Form1.lstGroups.Items.Count-1 do begin
        if not(Form1.Stop) and (Form1.lstGroups.Selected[gnr]) then begin
           TG := TAgtGroupMem( Form1.lstGroups.Items.Objects[gnr] );

           OpenMyArt( Opt.Database.Names[TG.PathIdx], TG.GrpID );

           for anr:=0 to AgtArtCount(HArt)-1 do begin
              inc( Form1.BalkenCount );
              if (Form1.BalkenCount mod 25)=0 then begin
                 Form1.FindStatus(TG,anr);
                 Form1.BalkenG.Progress := Form1.BalkenCount;
              end;

              AgtArtLoadBody( HArt, anr );
              if DayOK( AgtArtUnixTime(HArt,0) ) then begin
                 ArtTextSize := AgtArtTextLen(HArt);
                 ArtText     := AgtArtTextPtr(HArt);

                 HdrPtr := AgtArtHeaderStartPtr( HArt, 'Path:' );
                 if HdrPtr<>nil then begin
                    inc(Form1.FindCount);
                    Hdr := '';
                    HdrFirst := True;
                    for i:=1 to 10 do Feed[i] :='';
                    FeedLfd := 1;

                    repeat
                       HdrC := HdrPtr^;
                       HdrPtr := (HdrPtr+1);

                       if (HdrC<>#13) and (HdrC<>#0) and (HdrC<>'!') then begin

                          if length(Hdr)<255 then Hdr := Hdr + HdrC;

                       end else begin

                          if Hdr='' then Hdr:='(no value)';
                          if (Hdr<>'not-for-mail') then begin
                             if not HdrFirst then begin
                                if FeedLfd<=FeedMax then begin
                                   Feed[FeedLfd] := Hdr;
                                   inc(FeedLfd);
                                end;
                                HdrLast := Hdr;
                             end;
                             HdrFirst := False;
                          end;
                          Hdr := '';

                       end;
                    until (HdrC=#13) or (HdrC=#0);

                    for i:=1 to FeedMax do begin
                       if Feed[i]=HdrLast then Feed[i]:='';
                    end;
                    if Feed[1]<>'' then begin
                       s := Feed[1];
                       for i:=2 to FeedMax do begin
                          if Feed[i]='' then Feed[i]:='.';
                          if Feed[i]<>'' then s:=s+'!'+Feed[i];
                       end;
                       TS.Add( s );
                    end;

                 end; {if HdrPtr<>nil ...}
              end;
           end;

           CloseMyArt;
           Application.ProcessMessages;
        end;

        Application.ProcessMessages;
     end;

     {Sortieren}
     TS.SortBy_Counter;

     {"Bericht" erstellen}
     l := 0;
     for i:=0 to TS.Count-1 do begin
        TH := TS.Infos[i];
        if TH.Counter>0 then begin
           inc(l);
           if l<=100 then begin
              s := '';
              s := s + IntToStr(l) + #9 + IntToStr(TH.Counter);
              s := s + #9 + ValToPercent(TH.Counter,Form1.FindCount)+'%';
              s := s + #9;
              Hdr := TS.Keys[i];
              s := s + Hdr;
              Form1.rtfStat.Lines.Add( s );
           end;
        end;
     end;

     Form1.rtfStat.Lines.Add( '' );

     s := #9 + IntToStr(Form1.FindCount);
     s := s + #9 + ValToPercent(Form1.FindCount,Form1.FindCount)+'%';
     s := s + #9 + '(probe count)';
     Form1.rtfStat.Lines.Add( s );
     Form1.rtfStat.Lines.Add( '' );
     Application.ProcessMessages;

     TS.Free;

     Form1.FindEnd;
     Form1.rtfStat.SelStart := 0;
     Form1.rtfStat.SetFocus;
end;

procedure AgtStat_Path_FeedsOf( Newsserver: String );
var  TG   : TAgtGroupMem;
     i,k    : Integer;
     gnr,anr,l: LongInt;
     s    : String;
     Hdr : String;
     TH  : TStatInfo;
     TS  : TStatList;
     Path, PredSrv, SuccSrv : String;
     OldGroup : Integer;
     AllFeeds : Boolean;
begin
     if NewsServer='' then begin
        AllFeeds := True;
     end else begin
        AllFeeds := False;
        AgtIni.WriteString( 'Temp', 'FeedsOfSrv', NewsServer );
     end;

     if not Form1.FindBegin then exit;

     Form1.rtfStat.Lines.Clear;
     Form1.rtfStat.Lines.Add( 'Feeds of: ' + Newsserver );
     Form1.rtfStat.Lines.Add( '(based on msgs with bodies '+StatDayBaseText+')' );
     Form1.rtfStat.Lines.Add( '' );
     Form1.rtfStat.Lines.Add( 'Pos.'+#9+'Count'+#9+'Weight'+#9+'Feed' );
     Form1.rtfStat.Lines.Add( '' );
     Application.ProcessMessages;

     TS := TStatList.Create;

     for gnr:=0 to Form1.lstGroups.Items.Count-1 do begin
        if not(Form1.Stop) and (Form1.lstGroups.Selected[gnr]) then begin
           TG := TAgtGroupMem( Form1.lstGroups.Items.Objects[gnr] );

           OpenMyArt( Opt.Database.Names[TG.PathIdx], TG.GrpID );

           for anr:=0 to AgtArtCount(HArt)-1 do begin
              inc( Form1.BalkenCount );
              if (Form1.BalkenCount mod 25)=0 then begin
                 Form1.FindStatus(TG,anr);
                 Form1.BalkenG.Progress := Form1.BalkenCount;
              end;

              AgtArtLoadBody( HArt, anr );
              if DayOK( AgtArtUnixTime(HArt,0) ) then begin
                 ArtTextSize := AgtArtTextLen(HArt);
                 ArtText     := AgtArtTextPtr(HArt);

                 Path := GetArtHeader( 'Path:' );

                 if AllFeeds then begin
                    inc(Form1.FindCount);

                    PredSrv := '';
                    i := Pos('!',Path);
                    if i>0 then begin PredSrv:=copy(Path,1,i-1); System.Delete(Path,1,i); end;
                    while Path<>'' do begin
                       i := Pos('!',Path);
                       if i=0 then begin
                          SuccSrv := Path;
                          Path := '';
                       end else begin
                          SuccSrv := copy(Path,1,i-1);
                          System.Delete(Path,1,i);
                       end;
                       if SuccSrv<>'not-for-mail' then TS.Add( PredSrv + ' <- ' + SuccSrv, 1, 9 );
                       PredSrv := SuccSrv;
                    end;
                 end else begin
                    i := Pos( '!' + NewsServer + '!', Path );
                    if i>0 then begin
                       inc(Form1.FindCount);

                       PredSrv := '';
                       k := i - 1;
                       while (k>0) and (Path[k]<>'!') do begin
                          PredSrv := Path[k] + PredSrv;
                          dec(k);
                       end;
                       if PredSrv='' then PredSrv:='.';

                       SuccSrv := '';
                       k := i + length(NewsServer) + 2;
                       while (k<=length(Path)) and (Path[k]<>'!') do begin
                          SuccSrv := SuccSrv + Path[k];
                          inc(k);
                       end;
                       if SuccSrv='not-for-mail' then SuccSrv:='';
                       if SuccSrv='' then SuccSrv:='.';

                       TS.Add( NewsServer + ' <- ' + SuccSrv, 1, 1 );
                       TS.Add( NewsServer + ' -> ' + PredSrv, 1, 2 );
                    end;
                 end;
              end;
           end;

           CloseMyArt;
           Application.ProcessMessages;
        end;

        Application.ProcessMessages;
     end;

     {Sortieren}
     TS.SortBy_GroupDesc_Counter;

     {"Bericht" erstellen}
     s := #9 + IntToStr(Form1.FindCount);
     s := s + #9 + ValToPercent(Form1.FindCount,Form1.FindCount)+'%';
     s := s + #9 + '(probe count)';
     Form1.rtfStat.Lines.Add( s );

     OldGroup := -1;
     l := 0;
     for i:=0 to TS.Count-1 do begin
        TH := TS.Infos[i];

        if TH.Group<>OldGroup then begin
           Form1.rtfStat.Lines.Add( '' );
           if TH.Group=1 then Form1.rtfStat.Lines.Add( '[IN]' );
           if TH.Group=2 then Form1.rtfStat.Lines.Add( '[OUT]' );
           OldGroup := TH.Group;
           l := 0;
        end;

        inc(l);
        s := '';
        s := s + IntToStr(l) + #9 + IntToStr(TH.Counter);
        s := s + #9 + ValToPercent(TH.Counter,Form1.FindCount)+'%';
        s := s + #9;
        Hdr := TS.Keys[i];
        s := s + Hdr;
        Form1.rtfStat.Lines.Add( s );
     end;

     Application.ProcessMessages;

     TS.Free;

     Form1.FindEnd;
     Form1.rtfStat.SelStart := 0;
     Form1.rtfStat.SetFocus;
end;

end.
