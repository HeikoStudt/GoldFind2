// ----------------------------------------------------------------------------
// TAgtArt-object to read the articles by OLE
// ----------------------------------------------------------------------------

unit ObjArt;

interface

uses uHamDLL;

const
  FLAG2_HASBODY  = $08;
  ArtIdxLen      =  32;
  ArtDatLen      = 512;
  ArtDataLimit   = ArtDatLen - 8;
  BlocksPerIndex = 126;

type
   TAgtArt = class
   private
     HamsterOLE     : OleVariant;

     fDLL           : tDLLUse; //DLL
     UseDLL         : Boolean; //DLL

     GrpHdl         : Integer;
     IsOpen         : Boolean;
     FDataPath      : String;
     ArtNoMin       : Integer;
     fArtCount      : Integer;

     Art_Text       : PChar;
     Art_TextSize   : LongInt;

     ArtTime        : longint;

     s1 : string;
     s2 : string;

     procedure DataFree;
     function  GetCount : Integer;
     function  GetTextAsString : String;
   public
     function  Open( GroupID: Integer ) : Integer;
     procedure Close;
     property  Count : Integer read GetCount;
     property  DataPath : String read FDataPath;

     procedure LoadIndex( ArtNo: Integer );
     procedure LoadBody ( ArtNo: Integer );
     procedure Load     ( ArtNo: Integer );

     function  UnixTime( GMTDiffSeconds: Integer ) : Integer;
     function  DateTime( GMTDiffSeconds: Integer ) : TDateTime;
     function  HasBody : Boolean;

     property  TextLen : Integer read Art_TextSize;
     property  TextPtr : PChar read Art_Text;
     property  Text : String read GetTextAsString;

     function  HeaderStartPtr( HdrName : String ) : PChar;
     function  HeaderValue( HdrName : String ) : String;
     procedure SkipOverviewLine;
     procedure ConvertToExportFormat;

     constructor Create( const AgentPath: String );
     destructor  Destroy; override;
   end;

implementation

uses
  SysUtils, ComObj, Windows, uEncoding, uArticle, activeX;

const
  GroundDate = 25569.0; // =EncodeDate(1970,1,1)

function StrIFind( Base, Find: PChar ) : PChar;
var  p, bl, fl : Integer;
     FindBase  : PChar;
begin
     Result := nil;

     fl := StrLen(Find);
     if fl=0 then exit;

     bl := StrLen( Base );
     if bl<fl then exit;

     FindBase := Base;
     for p:=0 to bl-fl do begin
        if StrLIComp( FindBase, Find, fl )=0 then begin
           Result := FindBase;
           break;
        end;
        inc(FindBase);
     end;
end;

function UnixTime2DT( UnixTime : Integer ) : TDateTime;
var  t, Days, Hours, Mins, Secs : Integer;
begin
     t := UnixTime;

     Days  := t div 86400;  t    := t mod 86400;
     Hours := t div 3600;   t    := t mod 3600;
     Mins  := t div 60;     Secs := t mod 60;

     if Secs < 0 then begin inc(Secs,60); dec(Mins ,1); end;
     if Mins < 0 then begin inc(Mins,60); dec(Hours,1); end;
     {Hours := Hours + GMTDelta;}
     if Hours< 0 then begin inc(Hours,24); dec(Days); end;
     if Hours>23 then begin dec(Hours,24); inc(Days); end;

     Result := GroundDate + Days + EncodeTime(Hours,Mins,Secs,0);
end;

procedure TAgtArt.DataFree;
begin
  Art_Text     := nil;
  Art_TextSize := 0;
end;

function TAgtArt.Open( GroupID: Integer ) : Integer;
var
  fPath, fGroup : string;
begin
     Result := -1;

     if IsOpen then Close;

     try
        HamsterOLE := CreateOLEObject(FDataPath);
        try
          fGroup     := HamsterOLE.NewsGrpName (GroupID);
          GrpHdl     := HamsterOLE.NewsGrpOpen (fGroup);
          ArtNoMin   := HamsterOLE.NewsArtNoMin(GrpHdl);
          fArtCount  := HamsterOLE.NewsArtNoMax(GrpHdl)-ArtNoMin+1;
        except
          raise;
        end;
        IsOpen     := True;
        if UseDLL then begin //DLL
          fPath  := HamsterOLE.ControlGetGroupsPath;

          if GrpHdl<>-1 then HamsterOLE.NewsGrpClose(GrpHdl);
          HamsterOLE := Unassigned;

          fDll.SetPath(fPath);
          fDLL.SetGroup(fGroup);
        end;
        Result     := 0;
     except
         on E:Exception do begin
            MessageBox(0,Pchar('ERROR: '+E.Message),'Object "Hamster.App" could not be created!',0);
            exit;
         end;
     end;
end;

procedure TAgtArt.Close;
begin
     DataFree;

     if IsOpen then begin
        if UseDLL then begin //DLL
          fDll.SetGroup('');
        end else begin
          if GrpHdl<>-1 then HamsterOLE.NewsGrpClose(GrpHdl);
          HamsterOLE := Unassigned;
        end;
        IsOpen := False;
     end;
end;

function TAgtArt.GetCount : Integer;
begin
     if isOpen then begin
//       Result := HamsterOLE.NewsArtCount(GrpHdl)
       Result := fArtCount; //HamsterOLE.NewsArtNoMax(GrpHdl)-ArtNoMin+1;
       if Result<0 then
         Result := 0
     end else
       Result := 0;
end;

function RFCDTToInt(const s : string) : longint;

    const OldDefault = 29221.0; // =EncodeDate(1980,1,1)
          GroundDate = 25569.0; // =EncodeDate(1970,1,1)
    function RfcDateTimeToDateTimeGMT( const RfcDateTime: String; const ErrorDefault: TDateTime ) : TDateTime;
      function TrimWhSpace( s : String ) : String;
      begin
         repeat
            if      copy(s,1,1)=' '         then System.Delete(s,1,1)
            else if copy(s,1,1)=#9          then System.Delete(s,1,1)
            else if copy(s,length(s),1)=' ' then System.Delete(s,length(s),1)
            else if copy(s,length(s),1)=#9  then System.Delete(s,length(s),1)
            else break;
         until False;
         Result := s;
      end;

      function MinutesToDateTime( const Minutes: Integer ): TDateTime;
      begin
         Result := ( Minutes / 60.0 / 24.0 );
      end;

      function RfcTimezoneToBiasMinutes( RfcTimeZone: String ): Integer;
      begin
         Result := 0;
         if RfcTimeZone='' then exit;

         if RfcTimeZone[1] in [ '+', '-' ] then begin

            Result := strtointdef( copy(RfcTimeZone,2,2), 0 ) * 60
                    + strtointdef( copy(RfcTimeZone,4,2), 0 );
            if (Result<0) or (Result>=24*60) then Result:=0;
            if RfcTimeZone[1]='+' then Result:=-Result;

         end else begin

            RfcTimeZone := UpperCase( RfcTimeZone );

            if      RfcTimeZone='GMT' then Result:=  0
            else if RfcTimeZone='UT'  then Result:=  0

            else if RfcTimeZone='EST' then Result:= -5*60
            else if RfcTimeZone='EDT' then Result:= -4*60
            else if RfcTimeZone='CST' then Result:= -6*60
            else if RfcTimeZone='CDT' then Result:= -5*60
            else if RfcTimeZone='MST' then Result:= -7*60
            else if RfcTimeZone='MDT' then Result:= -6*60
            else if RfcTimeZone='PST' then Result:= -8*60
            else if RfcTimeZone='PDT' then Result:= -7*60

            else if (length(RfcTimeZone)=1) then
              if (RfcTimeZone[1] in ['A'..'M']) then begin
                Result := -60 * (ord(RFCTimeZone[1])-ord('A')+1)
              end else if (RfcTimeZone[1] in ['N'..'Y']) then begin
                Result :=  60 * (ord(RFCTimeZone[1])-ord('N')+1)
              end else if RfcTimeZone[1]='Z' then
                Result := 0;
         end;
      end;



    var  s, h, tz : String;
         i, yyyy, mm, dd, hh, nn, ss : Integer;
    const
       RFC_DAY_NAMES   = 'SunMonTueWedThuFriSat';
       RFC_MONTH_NAMES = 'JanFebMarAprMayJunJulAugSepOctNovDec';
    begin
       s := TrimWhSpace( RfcDateTime );
       if s='' then begin Result:=ErrorDefault; exit; end;

       try
          // Date: Fri, 27 Mar 1998 12:12:50 +1300

          i := Pos( ',', s );
          if (i>0) and (i<10) then begin
             System.Delete( s, 1, i ); // "Tue,", "Tuesday,"
             s := Trim(s);
          end;

          i := Pos(' ',s);
          dd := strtoint( copy(s,1,i-1) );
          System.Delete( s, 1, i );
          s := Trim(s);

          i := Pos(' ',s);
          h := lowercase( copy(s,1,i-1) );
          mm := ( ( Pos(h,LowerCase(RFC_MONTH_NAMES)) - 1 ) div 3 ) + 1;
          System.Delete( s, 1, i );
          s := Trim(s);

          i := Pos(' ',s);
          yyyy := strtoint( copy(s,1,i-1) );
          if yyyy<100 then begin
             if yyyy>=50 then yyyy:=yyyy+1900 else yyyy:=yyyy+2000;
          end;
          System.Delete( s, 1, i );
          s := Trim(s);

          i := Pos(' ',s);
          if i=0 then begin
             h := s;
             tz := '';
          end else begin
             h := Trim( copy(s,1,i-1) );
             tz := UpperCase( Trim( copy(s,i+1,32) ) );
          end;

          i:=Pos(':',h); if i=2 then h:='0'+h;
          hh := strtoint( copy(h,1,2) );
          nn := strtoint( copy(h,4,2) );
          ss := strtoint( copy(h,7,2) );

          Result := EncodeDate( yyyy, mm, dd )
                  + MinutesToDateTime( RfcTimezoneToBiasMinutes( tz ) ) // -> GMT
                  + EncodeTime( hh, nn, ss, 0 );
       except
          Result := ErrorDefault
       end;
    end;
begin
    Result := Round((RfcDateTimeToDateTimeGMT(s, OldDefault) - GroundDate) * 86400);
end;


procedure TAgtArt.LoadIndex( ArtNo: Integer );
  function Tabstop (var str : string; var LastTab : Boolean) : string;
  begin
    Result := '';
    if pos(#9,str) <> 0 then begin
      Result := copy(str,1,pos(#9,str)-1);
      str := copy(str,pos(#9,str)+1,length(str));
    end else
      if not LastTab then begin
        Result := str;
        str := '';
        LastTab := true;
      end;
  end;

var
  s : string;
  b : Boolean;

begin
     if not IsOpen then exit;

     try
        //-->Delete komplete LoadIndex
        //-->Doch nicht
        if UseDLL then //DLL
          ArtTime := round((StrToDateTime(fDll.GetDateTime(ArtNo+1))- GroundDate) * 86400)
        else begin
          s := HamsterOLE.NewsArtXOver(GrpHdl,(ArtNo+ArtNoMin));
          if s<>'' then begin
            b := false;
            TabStop(s,b); TabStop(s,b); TabStop(s,b);
            ArtTime := RFCDTToInt(TabStop(s,b));
          end;
        end;
     except
     end;
end;

procedure TAgtArt.LoadBody( ArtNo: Integer );

var ArtText : string;
    s2      : string;
    s       : string;
    Art     : tArticle;

begin
     if not IsOpen then exit;
     DataFree;
     try
       if UseDll then begin //DLL
         s1 := fDll.GetAgentFormatPosting(ArtNo, ArtTime);
       end else begin
         ArtText := HamsterOLE.NewsArtText(GrpHdl,ArtNo+ArtNoMin);

         Art := tArticle.create;
         try
           Art.inputArticle := ArtText;
           ArtTime := RFCDTToInt(Art.HeaderContent['Date:']);
           s := Art.HeaderContent['Subject:']; //Subject
           s2 := DecodeHeadervalue( s[1], length(s) );
           s := Art.HeaderContent['From:'];    //From
           s2 := s2 + #9 + DecodeHeadervalue( s[1], length(s) );
           s2 := s2 + #9 + IntToStr(ArtTime); //Date
         finally
           art.free;
         end;

         s1 := s2 + #13#10 + ArtText; //s1 have to be "global" :-|
       end;

       Art_Text     := Pchar(s1);
       Art_TextSize := Length(Art_Text);
     except
       raise;
     end;
end;

procedure TAgtArt.Load( ArtNo: Integer );
begin
//     LoadIndex( ArtNo );
     LoadBody ( ArtNo );
end;

function TAgtArt.UnixTime( GMTDiffSeconds: Integer ) : Integer;
begin
     if IsOpen then
        Result := ArtTime + GMTDiffSeconds
     else
        Result := 0;
end;

function TAgtArt.DateTime( GMTDiffSeconds: Integer ) : TDateTime;
begin
     Result := UnixTime2DT( UnixTime(GMTDiffSeconds) );
end;

function TAgtArt.HasBody : Boolean;
begin
     Result := true;   //ToDo: endgültiges löschen.
                       //Teilweise schon gelöscht!
end;

function TAgtArt.GetTextAsString : String;
begin
     if (Art_Text=nil) or (Art_TextSize=0) then
        Result := ''
     else
        Result := String( Art_Text );
end;

function TAgtArt.HeaderStartPtr( HdrName : String ) : PChar;
var  HdrLimit, Tmp : PChar;
begin
     // find start of value
     Result := StrIFind( Art_Text, PChar(#13#10+HdrName+' ') );

     if Result=nil then begin
        // some lines are delimited with 0x0d,0x03 instead of 0x0d,0x0a!
        Result := StrIFind( Art_Text, PChar(#13#3+HdrName+' ') );

        if Result=nil then begin
           // Oops, maybe the first entry after a SkipOverviewLine?
           Tmp := StrIFind( Art_Text, PChar(HdrName+' ') );
           if Tmp=Art_Text then Result := ( Tmp + length(HdrName) + 1 );
           exit;
        end;
     end;

     Result := ( Result + length(HdrName) + 3 );

     // within headers?
     HdrLimit := StrIFind( Art_Text, PChar(#13#10+#13#10) );
     if Result>HdrLimit then Result:=nil;
end;

function TAgtArt.HeaderValue( HdrName : String ) : String;
var  HdrBase, HdrEnd: PChar;
begin
     Result := '';

     // find start of value
     HdrBase := HeaderStartPtr( HdrName );
     if HdrBase=nil then exit;

     // find end of line
     HdrEnd := StrScan( HdrBase, #13 );
     if HdrEnd=nil then exit;

     Result := copy( String(HdrBase), 1, HdrEnd-HdrBase );
end;

procedure TAgtArt.SkipOverviewLine;
var  LineEnd : PChar;
begin
     LineEnd := StrScan( Art_Text, #13 );
     if LineEnd=nil then exit;
     Art_TextSize := Art_TextSize - (LineEnd - Art_Text + 2 );
     Art_Text := LineEnd + 2;
end;

procedure TAgtArt.ConvertToExportFormat;
const DOW = 'SunMonTueWedThuFriSat';
      MOY = 'JanFebMayAprMayJunJulAugSepOctNovDec';
var  DT        : TDateTime;
     EndOfLine : PChar;
     LineLen   : Integer;
     Line      : String;
     OldText   : PChar;
     NewText   : String;

     function ParseMail( h: String ) : String;
     var  pAt, p : Byte;
     begin
          Result := '???@???';
          if h='' then exit;

          pAt := Pos( '@', h );
          if pAt>0 then begin
             repeat
                p := Pos( ' ', h );
                if p>0 then begin
                   if p<pAt then h:=copy(h,p+1,255) else h:=copy(h,1,p-1);
                end;
             until p=0;
          end;

          if h<>'' then Result:=h;
     end;

     procedure ExportArticle;
     begin
          // introduction line ("From ???@??? Fri Sep 8 13:21:43 1995")
          NewText := NewText + 'From' + ' ';
          NewText := NewText + ParseMail( HeaderValue('From:') ) + ' ';
          DT := UnixTime2DT( UnixTime(0) );
          NewText := NewText + copy( DOW, DayOfWeek(DT)*3-2, 3 ) + ' ';
          NewText := NewText + copy( MOY, strtoint(FormatDateTime('mm',DT))*3-2, 3 ) + ' ';
          NewText := NewText + FormatDateTime( 'd hh:nn:ss yyyy', DT ) + #13#10;

          // article-text
          repeat
                EndOfLine := StrIFind( OldText, #13#10 );
                if EndOfLine=nil then LineLen := strlen(OldText)
                                 else LineLen := EndOfLine - OldText;

                if (EndOfLine=nil) and (LineLen=0) then break;

                if LineLen=0 then begin
                   Line := ''
                end else begin
                   SetLength( Line, LineLen );
                   StrLCopy( @Line[1], OldText, LineLen );

                   // quote lines with "From ...@..."
                   if (copy(Line,1,5)='From ') and (Pos('@',Line)>0) then Line:='>'+Line;
                end;
                NewText := NewText + Line + #13#10;

                if EndOfLine<>nil then OldText := EndOfLine + 2;
          until EndOfLine=nil;
     end;

begin
     if Art_Text=nil then exit;
     SkipOverviewLine;
     OldText := Art_Text;
     NewText := '';
     ExportArticle;
     s2 := NewText;
//     DataFree;
//     NGDataSize := length(NewText);
//     GetMem( NGData, NGDataSize + 1 );
//     Move( NewText[1], NGData^, NGDataSize );

//     Art_Text := NGData;
//     Art_TextSize := NGDataSize;
     Art_Text     := PChar(NewText);
     Art_Textsize := length(Art_Text);
     if Art_TextSize>0 then (Art_Text+Art_TextSize)^ := #0;
end;

constructor TAgtArt.Create( const AgentPath: String );
begin
     inherited Create;

     UseDll := false; //DLL
                     //ToDo: Options
     if useDLL then fDLL := tDLLUse.create; //DLL

     IsOpen       := False;

     FDataPath := AgentPath;
     if FDataPath='' then begin
       FDataPath := 'Hamster.App';
     end;
end;

destructor TAgtArt.Destroy;
begin
     if IsOpen then Close;

     if UseDll then fDll.free; //DLL

     inherited Destroy;
end;

end.


