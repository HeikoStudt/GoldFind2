unit uHamDLL;

interface

uses KWKHamster_TLB, sysutils;

type
 eNotInitialized = class(Exception);
 eFileNotFound   = class(Exception);
 tDLLUse = class
  private
    fDLL       : clsHamster;
    fGroup     : string;
    fPath      : String;
    fOpen      : Boolean;
    function GoToArt(Nummer : Integer) : Boolean;
  public
    procedure SetGroup(group : string);
    function  GetPosting(ArtNummer : Integer) : String;
    function  GetAgentFormatPosting(ArtNo: Integer; var ArtTime : longint): String;
    procedure SetPath(Path : string);
    procedure SetDATAdat(FileName : string);
    function  GetDateTime(ArtNummer : Integer) : String;
    Constructor Create;
    Destructor Destroy; override;
end;

implementation

constructor tDLLUse.Create;
begin
  inherited;
  fDll   := coClsHamster.Create;
  fOpen  := false;
  fPath  := '';
  fGroup := '';
end;

procedure tDLLUse.SetDATAdat(FileName: string);
begin
  if fOpen then
    fDll.CloseConnection;
  fOpen := false;
  
  if (filename='') then begin
    fPath  := '';
    fGroup := '';
    exit;
  end;

  if not fileexists(filename) then
    raise eFileNotFound.Create('Leerer Filename wurde übergeben oder das File wurde nicht gefunden!');

  fDLL.OpenConnection(filename);

  filename := ExtractFilePath(Filename);
  if filename[length(filename)]='\' then
    system.delete(filename,length(filename),1);
  fPath  := copy(filename,1,LastDelimiter('\',filename));
  fGroup := copy(filename,LastDelimiter('\',filename)+1,length(filename));
  fOpen  := true;
end;

procedure tDLLUse.SetPath(Path: string);
begin
  if Path[length(Path)]<>'\' then
    Path := Path + '\';
  if fPath='' then
    fPath := Path
  else begin
    fPath := Path;
    if fOpen then
      fDll.CloseConnection;
    fOpen := false;
    if fPath = '' then exit;

    fDLL.OpenConnection(fPath + fGroup + '\data.dat');
    fOpen := true;
  end;
end;

procedure tDLLUse.SetGroup(group: string);
begin
  if fOpen then
    fDll.CloseConnection;
  fOpen := false;

  if Group = '' then begin
    fGroup := '';
    exit;
  end;

  if Group[1]='\' then
    Group := copy(Group,2,length(Group));
  fGroup := Group;
  fDLL.OpenConnection(fPath + fGroup + '\data.dat');
  fOpen := true;
end;

function tDLLUse.GoToArt(Nummer: Integer) : Boolean;
begin
  Result := false;
  if not fOpen then
    raise eNotInitialized.Create('Keine Gruppe ausgewählt!');
  if Nummer>0 then begin
    fDll.AbsolutePosition := Nummer;
    Result := true;
  end;
end;

const
  GroundDate = 25569; // =EncodeDate(1970,1,1)

function tDLLUse.GetAgentFormatPosting(ArtNo: Integer; var ArtTime : longint): String;
var s : string;
begin
  if GoToArt(ArtNo) then begin

    s := fDll.posting.DateTime;
    if s<>'' then
      ArtTime := round((StrToDateTime(s) - GroundDate) * 86400)
    else
      ArtTime := GroundDate;
      
    Result := fDLL.Posting.Subject + #9
            + fDLL.Posting.Name
            + ' <' + fDLL.Posting.EMail + '>' + #9
            + IntToStr(ArtTime) + #13#10
            + fDLL.posting.Header + #13#10#13#10
            + fDLL.posting.Body;
  end;
end;

function tDLLUse.GetDateTime(ArtNummer: Integer): String;
begin
  GoToArt(ArtNummer);
  Result := fDLL.posting.DateTime;
end;

function tDLLUse.GetPosting(ArtNummer: Integer) : string;
begin
  GoToArt(ArtNummer);
  Result := fDLL.posting.Header + #13#10#13#10 + fDLL.posting.Body;
end;

destructor tDLLUse.Destroy;
begin
  if fOpen then
    fDll.CloseConnection;
//  fDll._Release;
//ToDo: Überprüfen, ob nicht benötigt
  inherited;
end;

end.
