unit AgtBase;

interface

uses DllGrp, DllArt, IniFiles;

type
  PAgtGroupMem = ^TAgtGroupMem;
  TAgtGroupMem = class(TObject)
     GrpID  : LongInt;
     GrpNam : String[128];
     ArtCnt : Longint;
     PathIdx: Byte;
     GrpType: String[20];
  end;

  PAgtArticle = ^TAgtArticle;
  TAgtArticle = class(TObject)
     GrpID   : LongInt;
     ArtNo   : LongInt;
     PathIdx : Byte;
     Mid     : String;
     References : String;
     function Clone: TAgtArticle;
  end;

var
//  DataPathName : array[0..AgtDataPathMax] of String;
//  DataPathEnab : array[0..AgtDataPathMax] of Boolean;
  Debug  : Boolean = False;

var
  Version     : String;
  ArtText     : PChar;
  ArtTextSize : LongInt;
  HGrp        : Integer;
  HArt        : Integer;

function TrimWhSpace( const s : String ) : String;
function LoCase( c : Char ) : Char;
function StrIQuickSearch( Base: PChar; Find: String ) : PChar;
function StrIFind( Base, Find: PChar ) : PChar;
function GetArtHeader( HdrName: String ) : String;

procedure OpenMyGrp( AgentPath : String );
procedure CloseMyGrp;
procedure OpenMyArt( AgentPath: String; GrpID: Integer );
procedure CloseMyArt;

function LoadArticleCount( PathIdx, GrpID : Integer; LoadIt: Boolean ) : Integer;

implementation

uses
   SysUtils, Classes, Forms, uEncoding, Dialogs, Options;

var
   ArtCountList : TStringList = nil;

function TrimWhSpace( const s : String ) : String;
var  pb, pe: PChar;
begin
   SetLength( Result, 0 );

   pb := PChar( s );
   while pb^ in [#9,' '] do inc(pb);
   if pb^=#0 then exit;

   pe := strend( pb ) - 1;
   while pe^ in [#9,' '] do dec(pe);

   // Result := copy( pb, 1, pe-pb+1 );
   SetString( Result, pb, pe-pb+1 );
end;

function LoCase( c : Char ) : Char;
begin
     if (c>='A') and (c<='Z') then c:=chr( ord(c) + $20 );
     LoCase := c;
end;

function StrIQuickSearch( Base: PChar; Find: String ) : PChar;
var  tstr : PChar;
     i : Integer;
     flen, tlen : Integer;
     shft: array[#0..#255] of Byte;
     limit, flen1: Integer;
     pFind : PChar;
begin
     StrIQuickSearch := nil; {Default: Nicht gefunden}

     flen := Length(Find);
     if flen=0 then exit; {kein Suchtext}

     tlen := strlen(Base);
     if flen>tlen then exit; {kein Text}

     tstr := Base;
     tlen := strlen(Base);

     limit := tlen-flen;
     flen1 := flen - 1;

     {Shift-Tabelle für Quicksearch erstellen}
     { Mismatch-Default = Verschiebung um (Suchlänge+1) }
     for i:=0 to 255 do shft[chr(i)] := flen+1;

     {Suchtext vorbereiten}
     GetMem( pFind, flen+1 );
     Find := UpperCase(Find);
     StrPCopy( pFind, Find );

     { Verschiebung für Zeichen im Suchstring }
     for i:=0 to flen-1 do begin
        shft[ LoCase(pFind[i]) ] := flen - i;
        shft[ UpCase(pFind[i]) ] := flen - i;
     end;

     {Quicksearch}
     repeat
        i := flen1;
        while Upcase((tstr+i)^)=(pFind+i)^ do begin
           if i=0 then begin
              StrIQuickSearch:=tstr;
              FreeMem( pFind, flen+1 );
              exit;
           end;
           dec(i);
        end;
        tstr := (tstr + shft[ (tstr+flen)^ ]);
     until (tstr-Base)>=limit;
     FreeMem( pFind, flen+1 );
end;

function StrIFind( Base, Find: PChar ) : PChar;
var  p, bl, fl : Integer;
begin
     Result := nil;

     fl := StrLen(Find);
     if fl=0 then exit;

     bl := StrLen( Base );
     if bl<fl then exit;

     for p:=0 to bl-fl do begin
        if StrLIComp( Base, Find, fl )=0 then begin
           Result := Base;
           break;
        end;
        inc(Base);
     end;
end;

function GetArtHeader( HdrName: String ) : String;
const psize = 2048;
var  i : Integer;
     ps: PChar;
     h : String;
begin
     GetMem( ps, psize );
     i := AgtArtHeaderValue( HArt, PChar(HdrName), ps, psize );
     if i>=0 then begin
        h := String( ps );
        Result := DecodeHeadervalue( h[1], length(h) )
     end else Result:='';
     FreeMem( ps, psize );
end;

procedure OpenMyGrp( AgentPath : String );
var  s : String;
     i : Integer;
begin
     i := AgtGrpOpen( PChar(AgentPath), HGrp );
     if i<>0 then begin
        s := 'Error #' + inttostr(i) + ' opening "' + AgentPath+'"!';
        Application.MessageBox( PChar(s), 'GoldFind.AgtBase.OpenMyGrp', 0 );
        Application.Terminate;
     end;
end;

procedure CloseMyGrp;
begin
     AgtGrpClose( HGrp );
     HGrp := -1;
end;

procedure OpenMyArt( AgentPath: String; GrpID: Integer );
var  s : String;
     i : Integer;
begin
     i := AgtArtOpen( PChar(AgentPath), GrpID, HArt );
     if i<>0 then begin
        s := 'Error #' + inttostr(i) + ' opening "' + AgentPath + IntToStr(GrpID)+'"!';
        Application.MessageBox( PChar(s), 'GoldFind.AgtBase.OpenMyArt', 0 );
        Application.Terminate;
     end;
end;

procedure CloseMyArt;
begin
     AgtArtClose( HArt );
     HArt := -1;
end;

function LoadArticleCount( PathIdx, GrpID : Integer; LoadIt: Boolean ) : Integer;
var  Key : String;
     Idx : Integer;
begin
     if ArtCountList=nil then begin
        ArtCountList := TStringList.Create;
        ArtCountList.Sorted := True;
     end;

     Key := inttohex( GrpID, 8 ) + '|' + LowerCase(Opt.Database.Names[PathIdx]);
     Idx := ArtCountList.IndexOf( Key );

     if Idx>=0 then begin
        Result := LongInt( ArtCountList.Objects[Idx] );
     end else begin
        if LoadIt then begin
           OpenMyArt( Opt.Database.Names[PathIdx], GrpID );
           Result := AgtArtCount( HArt );
           CloseMyArt;
           ArtCountList.AddObject( Key, Pointer( Result ) );
        end else begin
           Result := -1;
        end;
     end;
end;

{ TAgtArticle }

function TAgtArticle.Clone: TAgtArticle;
begin
   Result := TAgtArticle.Create;
   Result.GrpID   := GrpID;
   Result.ArtNo   := ArtNo;
   Result.PathIdx := PathIdx;
end;

initialization

finalization
   if Assigned( ArtCountList ) then FreeAndNil( ArtCountList );

end.

