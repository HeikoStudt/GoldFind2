// ----------------------------------------------------------------------------
// DLL-interface for TAgtGrp-object
// ----------------------------------------------------------------------------

unit DllGrp;

interface

const
  // Flag-masks for .Flags:
  AGTGRPFLAG_ISFOLDER  = $08; // folder
  AGTGRPFLAG_SUBSCRIBE = $80; // newsgroup, subscribed
  AGTGRPFLAG_WASSUB    = $04; // newsgroup, was subscribed
  // none of the above flags: // newsgroup, not/never subscribed

  AGTGRPFLAG_HASARTFILE = AGTGRPFLAG_ISFOLDER
                       or AGTGRPFLAG_SUBSCRIBE
                       or AGTGRPFLAG_WASSUB;
  // If one of the flags is set, there _might_ be an article-file for the group.
  // To be sure, you can check it with 'HasArticles'.

type
  LPSTR = PAnsiChar;
  DWORD = Integer;
  BOOL  = LongBool;

function AgtGrpOpen( AgentPath: LPSTR; var HGrp : DWORD ) : DWORD; stdcall;
function AgtGrpClose( HGrp : DWORD ) : DWORD; stdcall;
function AgtGrpCount( HGrp : DWORD ) : DWORD; stdcall;
function AgtGrpLoad( HGrp, GrpNo : DWORD ) : DWORD; stdcall;

function AgtGrpID( HGrp : DWORD ) : DWORD; stdcall;
function AgtGrpHasArticles( HGrp : DWORD ) : BOOL; stdcall;
function AgtGrpIsFolder( HGrp : DWORD ) : BOOL; stdcall;
function AgtGrpIsNewsgroup( HGrp : DWORD ) : BOOL; stdcall;
function AgtGrpFlags( HGrp : DWORD ) : DWORD; stdcall;
function AgtGrpName( HGrp : DWORD; GrpName: LPSTR; MaxSize: DWORD ) : DWORD; stdcall;

function AgtGrpIdToName( HGrp, GrpID : DWORD; GrpName: LPSTR; MaxSize: DWORD ) : DWORD; stdcall;
function AgtGrpNoToName( HGrp, GrpNo : DWORD; GrpName: LPSTR; MaxSize: DWORD ) : DWORD; stdcall;
function AgtGrpNameToId( HGrp : DWORD; GrpName: LPSTR ) : DWORD; stdcall;
function AgtGrpNameToNo( HGrp : DWORD; GrpName: LPSTR ) : DWORD; stdcall;
function AgtGrpIdToNo( HGrp, GrpID: DWORD ) : DWORD; stdcall;
function AgtGrpNoToId( HGrp, GrpNo: DWORD ) : DWORD; stdcall;

implementation

uses
  SysUtils, ObjGrp, ObjArray;

var
  AgtGrpList : TObjArray;

procedure DllAgtGrpInit;
begin
     AgtGrpList := TObjArray.Create( 10, 10 );
end;

procedure DllAgtGrpExit;
var  HGrp : Integer;
begin
     for HGrp:=0 to AgtGrpList.Count-1 do begin
        if AgtGrpList.IsValid(HGrp) then AgtGrpClose( HGrp );
     end;
     AgtGrpList.Free;
end;

function AgtGrpOpen( AgentPath: LPSTR; var HGrp : DWORD ) : DWORD;
var  AgtGrp : TAgtGrp;
begin
     AgtGrp := TAgtGrp.Create( AgentPath );
     HGrp   := AgtGrpList.GetFreeIndex;
     Result := AgtGrp.Open;
     if Result=0 then AgtGrpList.Objects[HGrp]:=AgtGrp;
end;

function AgtGrpClose( HGrp : DWORD ) : DWORD;
begin
     if not AgtGrpList.IsValid(HGrp) then begin Result:=-1; exit; end;
     TAgtGrp( AgtGrpList.Objects[HGrp] ).Close;
     TAgtGrp( AgtGrpList.Objects[HGrp] ).Free;
     AgtGrpList.Objects[HGrp] := nil;
     Result := 0;
end;

function AgtGrpCount( HGrp : DWORD ) : DWORD;
begin
     if not AgtGrpList.IsValid(HGrp) then begin Result:=-1; exit; end;
     Result := TAgtGrp(AgtGrpList.Objects[HGrp]).Count;
end;

function AgtGrpLoad( HGrp, GrpNo : DWORD ) : DWORD;
begin
     if not AgtGrpList.IsValid(HGrp) then begin Result:=-1; exit; end;
     TAgtGrp(AgtGrpList.Objects[HGrp]).Load( GrpNo );
     Result := 0;
end;

function AgtGrpID( HGrp : DWORD ) : DWORD;
begin
     if not AgtGrpList.IsValid(HGrp) then begin Result:=-1; exit; end;
     Result := TAgtGrp(AgtGrpList.Objects[HGrp]).ID;
end;

function AgtGrpHasArticles( HGrp : DWORD ) : BOOL;
begin
     if not AgtGrpList.IsValid(HGrp) then begin Result:=False; exit; end;
     Result := TAgtGrp(AgtGrpList.Objects[HGrp]).HasArticles;
end;

function AgtGrpIsFolder( HGrp : DWORD ) : BOOL;
begin
     if not AgtGrpList.IsValid(HGrp) then begin Result:=False; exit; end;
     Result := TAgtGrp(AgtGrpList.Objects[HGrp]).IsFolder;
end;

function AgtGrpIsNewsgroup( HGrp : DWORD ) : BOOL;
begin
     if not AgtGrpList.IsValid(HGrp) then begin Result:=False; exit; end;
     Result := TAgtGrp(AgtGrpList.Objects[HGrp]).IsNewsgroup;
end;

function AgtGrpFlags( HGrp : DWORD ) : DWORD;
begin
     if not AgtGrpList.IsValid(HGrp) then begin Result:=-1; exit; end;
     Result := TAgtGrp(AgtGrpList.Objects[HGrp]).Flags;
end;

function AgtGrpName( HGrp : DWORD; GrpName: LPSTR; MaxSize: DWORD ) : DWORD;
var  s : String;
begin
     if not AgtGrpList.IsValid(HGrp) then begin Result:=-1; exit; end;
     s := TAgtGrp(AgtGrpList.Objects[HGrp]).Name;
     if length(s)>=MaxSize then begin
        strlcopy( GrpName, PChar(s), MaxSize );
        Result := -length(s);
     end else begin
        strcopy( GrpName, PChar(s) );
        Result := length(s);
     end;
end;

function AgtGrpIdToName( HGrp, GrpID : DWORD; GrpName: LPSTR; MaxSize: DWORD ) : DWORD;
var  s : String;
begin
     if not AgtGrpList.IsValid(HGrp) then begin Result:=-1; exit; end;
     s := TAgtGrp(AgtGrpList.Objects[HGrp]).IdToName( GrpID );
     if length(s)>=MaxSize then begin
        strlcopy( GrpName, PChar(s), MaxSize );
        Result := -length(s);
     end else begin
        strcopy( GrpName, PChar(s) );
        Result := length(s);
     end;
end;

function AgtGrpNoToName( HGrp, GrpNo : DWORD; GrpName: LPSTR; MaxSize: DWORD ) : DWORD;
var  s : String;
begin
     if not AgtGrpList.IsValid(HGrp) then begin Result:=-1; exit; end;
     s := TAgtGrp(AgtGrpList.Objects[HGrp]).NoToName( GrpNo );
     if length(s)>=MaxSize then begin
        strlcopy( GrpName, PChar(s), MaxSize );
        Result := -length(s);
     end else begin
        strcopy( GrpName, PChar(s) );
        Result := length(s);
     end;
end;

function AgtGrpNameToId( HGrp : DWORD; GrpName: LPSTR ) : DWORD;
begin
     if not AgtGrpList.IsValid(HGrp) then begin Result:=-1; exit; end;
     Result := TAgtGrp(AgtGrpList.Objects[HGrp]).NameToId(GrpName);
end;

function AgtGrpNameToNo( HGrp : DWORD; GrpName: LPSTR ) : DWORD;
begin
     if not AgtGrpList.IsValid(HGrp) then begin Result:=-1; exit; end;
     Result := TAgtGrp(AgtGrpList.Objects[HGrp]).NameToNo(GrpName);
end;

function AgtGrpIdToNo( HGrp, GrpID: DWORD ) : DWORD;
begin
     if not AgtGrpList.IsValid(HGrp) then begin Result:=-1; exit; end;
     Result := TAgtGrp(AgtGrpList.Objects[HGrp]).IdToNo(GrpID);
end;

function AgtGrpNoToId( HGrp, GrpNo: DWORD ) : DWORD;
begin
     if not AgtGrpList.IsValid(HGrp) then begin Result:=-1; exit; end;
     Result := TAgtGrp(AgtGrpList.Objects[HGrp]).NoToId(GrpNo);
end;

initialization
  DllAgtGrpInit;

finalization
  DllAgtGrpExit;

end.
