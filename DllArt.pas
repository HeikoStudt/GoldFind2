// ----------------------------------------------------------------------------
// DLL-interface for TAgtArt-object
// ----------------------------------------------------------------------------

unit DllArt;

interface

type
  LPSTR = PAnsiChar;
  DWORD = Integer;
  BOOL  = LongBool;

function AgtArtOpen( AgentPath: LPSTR; GrpID: DWORD; var HArt : DWORD ) : DWORD; stdcall;
function AgtArtClose( HArt : DWORD ) : DWORD; stdcall;
function AgtArtCount( HArt : DWORD ) : DWORD; stdcall;
function AgtArtLoadIndex( HArt, ArtNo : DWORD ) : DWORD; stdcall;
function AgtArtLoadBody( HArt, ArtNo : DWORD ) : DWORD; stdcall;
function AgtArtLoad( HArt, ArtNo : DWORD ) : DWORD; stdcall;

function AgtArtHasBody( HArt : DWORD ) : BOOL; stdcall;
function AgtArtUnixTime( HArt, GMTDiffSeconds : DWORD ) : DWORD; stdcall;
function AgtArtDateTime( HArt, GMTDiffSeconds : DWORD ) : Double; stdcall;
function AgtArtTextLen( HArt : DWORD ) : DWORD; stdcall;
function AgtArtTextPtr( HArt : DWORD ) : LPSTR; stdcall;
function AgtArtText( HArt : DWORD; TextBuf: LPSTR; MaxSize: DWORD ) : DWORD; stdcall;

function AgtArtSkipOverviewLine( HArt : DWORD ) : DWORD; stdcall;
function AgtArtConvertToExportFormat( HArt : DWORD ) : DWORD; stdcall;

function AgtArtHeaderStartPtr( HArt : DWORD; HdrName: LPSTR ) : LPSTR; stdcall;
function AgtArtHeaderValue( HArt : DWORD; HdrName, HdrValue: LPSTR; MaxSize: DWORD ) : DWORD; stdcall;

implementation

uses
  SysUtils, ObjArt, ObjArray;

var
  AgtArtList : TObjArray;

procedure DllAgtArtInit;
begin
     AgtArtList := TObjArray.Create( 10, 10 );
end;

procedure DllAgtArtExit;
var  HArt : Integer;
begin
     for HArt:=0 to AgtArtList.Count-1 do begin
        if AgtArtList.IsValid(HArt) then AgtArtClose( HArt );
     end;
     AgtArtList.Free;
end;

function AgtArtOpen( AgentPath: LPSTR; GrpID: DWORD; var HArt : DWORD ) : DWORD;
var  AgtArt : TAgtArt;
begin
     AgtArt := TAgtArt.Create( AgentPath );
     HArt   := AgtArtList.GetFreeIndex;
     Result := AgtArt.Open( GrpID );
     if Result=0 then AgtArtList.Objects[HArt] := AgtArt;
end;

function AgtArtClose( HArt : DWORD ) : DWORD;
begin
     if not AgtArtList.IsValid(HArt) then begin Result:=-1; exit; end;
     TAgtArt( AgtArtList.Objects[HArt] ).Close;
     TAgtArt( AgtArtList.Objects[HArt] ).Free;
     AgtArtList.Objects[HArt] := nil;
     Result := 0;
end;

function AgtArtCount( HArt : DWORD ) : DWORD;
begin
     if not AgtArtList.IsValid(HArt) then begin Result:=-1; exit; end;
     Result := TAgtArt(AgtArtList.Objects[HArt]).Count;
end;

function AgtArtLoadIndex( HArt, ArtNo : DWORD ) : DWORD;
begin
     if not AgtArtList.IsValid(HArt) then begin Result:=-1; exit; end;
     TAgtArt(AgtArtList.Objects[HArt]).LoadIndex( ArtNo );
     Result := 0;
end;

function AgtArtLoadBody( HArt, ArtNo : DWORD ) : DWORD;
begin
     if not AgtArtList.IsValid(HArt) then begin Result:=-1; exit; end;
     TAgtArt(AgtArtList.Objects[HArt]).LoadBody( ArtNo );
     Result := 0;
end;

function AgtArtLoad( HArt, ArtNo : DWORD ) : DWORD;
begin
     if not AgtArtList.IsValid(HArt) then begin Result:=-1; exit; end;
     TAgtArt(AgtArtList.Objects[HArt]).Load( ArtNo );
     Result := 0;
end;

function AgtArtHasBody( HArt : DWORD ) : BOOL;
begin
     if not AgtArtList.IsValid(HArt) then begin Result:=False; exit; end;
     Result := TAgtArt(AgtArtList.Objects[HArt]).HasBody;
end;

function AgtArtUnixTime( HArt, GMTDiffSeconds : DWORD ) : DWORD;
begin
     if not AgtArtList.IsValid(HArt) then begin Result:=-1; exit; end;
     Result := TAgtArt(AgtArtList.Objects[HArt]).UnixTime(GMTDiffSeconds);
end;

function AgtArtDateTime( HArt, GMTDiffSeconds : DWORD ) : Double;
begin
     if not AgtArtList.IsValid(HArt) then begin Result:=-1; exit; end;
     Result := TAgtArt(AgtArtList.Objects[HArt]).DateTime(GMTDiffSeconds);
end;

function AgtArtTextLen( HArt : DWORD ) : DWORD;
begin
     if not AgtArtList.IsValid(HArt) then begin Result:=-1; exit; end;
     Result := TAgtArt(AgtArtList.Objects[HArt]).TextLen;
end;

function AgtArtTextPtr( HArt : DWORD ) : LPSTR;
begin
     if not AgtArtList.IsValid(HArt) then begin Result:=nil; exit; end;
     Result := TAgtArt(AgtArtList.Objects[HArt]).TextPtr;
end;

function AgtArtText( HArt : DWORD; TextBuf: LPSTR; MaxSize: DWORD ) : DWORD;
var  p : PChar;
     i : Integer;
begin
     if not AgtArtList.IsValid(HArt) then begin Result:=-1; exit; end;

     p := TAgtArt(AgtArtList.Objects[HArt]).TextPtr;
     i := TAgtArt(AgtArtList.Objects[HArt]).TextLen;

     if i>=MaxSize then begin
        strlcopy( TextBuf, p, MaxSize );
        Result := -i;
     end else begin
        strcopy( TextBuf, p );
        Result := i;
     end;
end;

function AgtArtSkipOverviewLine( HArt : DWORD ) : DWORD;
begin
     if not AgtArtList.IsValid(HArt) then begin Result:=-1; exit; end;
     TAgtArt(AgtArtList.Objects[HArt]).SkipOverviewLine;
     Result := 0;
end;

function AgtArtConvertToExportFormat( HArt : DWORD ) : DWORD;
begin
     if not AgtArtList.IsValid(HArt) then begin Result:=-1; exit; end;
     TAgtArt(AgtArtList.Objects[HArt]).ConvertToExportFormat;
     Result := 0;
end;

function AgtArtHeaderStartPtr( HArt : DWORD; HdrName: LPSTR ) : LPSTR;
begin
     if not AgtArtList.IsValid(HArt) then begin Result:=nil; exit; end;
     Result := TAgtArt(AgtArtList.Objects[HArt]).HeaderStartPtr( HdrName );
end;

function AgtArtHeaderValue( HArt : DWORD; HdrName, HdrValue: LPSTR; MaxSize: DWORD ) : DWORD;
var  s : String;
begin
     if not AgtArtList.IsValid(HArt) then begin Result:=-1; exit; end;
     s := TAgtArt(AgtArtList.Objects[HArt]).HeaderValue( HdrName );
     if length(s)>=MaxSize then begin
        strlcopy( HdrValue, PChar(s), MaxSize );
        Result := -length(s);
     end else begin
        strcopy( HdrValue, PChar(s) );
        Result := length(s);
     end;
end;

initialization
  DllAgtArtInit;

finalization
  DllAgtArtExit;

end.
