// ----------------------------------------------------------------------------
// TAgtGrp-object to read the groups-files
// ----------------------------------------------------------------------------

unit ObjGrp;

interface

uses
  SysUtils;

type
  AgtGroupIndex_Type = record
    NameStart : array[1..3] of Byte;
    GrpFlag   : Byte;
    GUnknown1 : array[5..8] of Byte;
    GrpID     : LongInt;
    GUnknown3 : array[13..16] of Byte;
  end;

type
   TAgtGrp = class
   private
     HamsterOLE   : OleVariant;

     GrpHdl       : Integer;
     IsOpen       : Boolean;
     FDataPath    : String;
     GroupsCount  : LongInt;
     function  GetCount : Integer;
     function  GetName : String;
     function  GetFlags : Integer;
     function  GetID : Integer;
   public
     function  Open : Integer;
     procedure Close;
     property  Count : Integer read GetCount;
     property  DataPath : String read FDataPath;

     procedure Load( GrpNo: Integer );
     property  Name  : String read GetName;
     property  Flags : Integer read GetFlags;
     property  ID    : Integer read GetID;
     function  HasArticles : Boolean;
     function  IsFolder : Boolean;
     function  IsNewsgroup : Boolean;

     function  IdToName( GrpID: Integer ) : String;
     function  NameToId( GrpName: String ) : Integer;
     function  IdToNo( GrpID: Integer ) : Integer;
     function  NoToId( GrpNo: Integer ) : Integer;
     function  NameToNo( GrpName: String ) : Integer;
     function  NoToName( GrpNo: Integer ) : String;

     constructor Create( const AgentPath: String );
     destructor  Destroy; override;
   end;

implementation

uses Main,Windows,ComObj, activex;

const
  FLAG_ISFOLDER   = $08; // folder
  FLAG_SUBSCRIBE  = $80; // newsgroup, subscribed
  FLAG_WASSUB     = $04; // newsgroup, was subscribed
  FLAG_HASARTFILE = FLAG_ISFOLDER or FLAG_SUBSCRIBE or FLAG_WASSUB;

function TAgtGrp.Open : Integer;
begin
     if IsOpen then Close;
     Result := -1;
     try
        HamsterOLE := CreateOleObject( FDataPath );
//        HamsterOLE := CreateCOMObject( StringToGUID(FDataPath) );
        GroupsCount  := HamsterOLE.NewsGrpCount;

        IsOpen := True;
        Result := 0;
     except
         on E:Exception do begin
            MessageBox(0,Pchar('ERROR: '+E.Message),'Object "Hamster.App" could not be created!',0);
            exit;
         end;
     end;
end;

procedure TAgtGrp.Close;
begin
     if IsOpen then begin
        if GrpHdl<>-1 then HamsterOLE.NewsGrpClose(GrpHdl);
        HamsterOLE := Unassigned;
        IsOpen := False;
     end;
end;

function TAgtGrp.GetCount : Integer;
begin
     if IsOpen then Result := GroupsCount
               else Result := 0;
end;

procedure TAgtGrp.Load( GrpNo: Integer );
begin
     if not IsOpen then exit;

     try
        if (GrpNo<0) or (GrpNo>=Count) then begin
           if GrpHdl<>-1 then HamsterOLE.NewsGrpClose(GrpHdl);
           GrpHdl := -1;
        end else begin
           if GrpHdl<>-1 then HamsterOLE.NewsGrpClose(GrpHdl);
           GrpHdl := HamsterOLE.NewsGrpOpen(HamsterOLE.NewsGrpName(GrpNo));
        end;
     except
        GrpHdl := -1;
     end;
end;

function TAgtGrp.GetName : String;
begin
     Result := '';
     if not IsOpen then exit;
     try
        Result := HamsterOLE.NewsGrpNameByHandle(GrpHdl);
     except
        Result := '';
     end;
end;

function TAgtGrp.GetFlags : Integer;
begin
{     if IsOpen then Result := GroupIndex.GrpFlag
               else Result := 0;
               }
    Result := FLAG_SUBSCRIBE;
end;

function TAgtGrp.GetID : Integer;
begin
     if IsOpen then Result := HamsterOLE.NewsGrpIndex(HamsterOLE.NewsGrpNameByHandle(GrpHdl))
               else Result := 0;
end;

function TAgtGrp.HasArticles : Boolean;
begin
     try
        Result := (HamsterOLE.NewsArtCount(GrpHdl)>0);
     except
        Result := False;
     end;
end;

function TAgtGrp.IsFolder : Boolean;
begin
   Result := false;
//     Result := (GetFlags and FLAG_ISFOLDER)<>0;
end;

function TAgtGrp.IsNewsgroup : Boolean;
begin
     Result := true;
//     Result := (GetFlags and FLAG_ISFOLDER)=0;
end;

function TAgtGrp.IdToName( GrpID: Integer ) : String;
var  GrpNo : Integer;
begin
     grpNo := IdToNo(GrpId);
     if GrpNo<0 then begin
        Result := '';
     end else begin
       Result := HamsterOLE.NewsGrpName(GrpID);
       Load(GrpNo);
     end;
end;

function TAgtGrp.NameToId( GrpName: String ) : Integer;
//var  GrpNo : Integer;
begin
{     if GrpNo<0 then begin
        Result := -1;
     end else begin
     }
       Result := HamsterOLE.NewsGrpIndex(GrpName);
       Load(Result);
//     end;
end;

function TAgtGrp.IdToNo( GrpID: Integer ) : Integer;
//var  i : Integer;
begin
//     Result := -1;
//     Result := HamsterOLE.NewsGrpIndex(HamsterOLE.GetNameByHandle(GrpID));
     Result := GrpID;
     Load(Result);
{     for i:=0 to Count-1 do begin
        Load( i );
        if ID=GrpID then begin Result:=i; break; end;
     end;
     }
end;

function TAgtGrp.NoToId( GrpNo: Integer ) : Integer;      //ToDo
begin
{     if (GrpNo<0) or (GrpNo>=Count) then begin
        Result := -1;
     end else begin
        Load( GrpNo );
        Result := ID;
     end;}
     Result := GrpNo;
     Load(Result);
end;

function TAgtGrp.NameToNo( GrpName: String ) : Integer;
//var  i : Integer;
begin
     Result := HamsterOLE.NewsGrpIndex(GrpName);
     Load(Result);
{     Result := -1;
     GrpName := Lowercase(GrpName);
     for i:=0 to Count-1 do begin
        Load( i );
        if Lowercase(Name)=GrpName then begin Result:=i; break; end;
     end;
     }
end;

function TAgtGrp.NoToName( GrpNo: Integer ) : String;
begin
     if (GrpNo<0) or (GrpNo>=Count) then begin
        Result := '';
     end else begin
       Load( GrpNo);
       Result := HamsterOLE.GrpName(GrpNo);
     end;
{     if (GrpNo<0) or (GrpNo>=Count) then begin
        Result := '';
     end else begin
        Load( GrpNo );
        Result := Name;
     end;
     }
end;

constructor TAgtGrp.Create( const AgentPath: String );
begin
     inherited Create;

     IsOpen   := False;

     GrpHdl := -1;
     FDataPath := AgentPath;
     if FDataPath='' then begin
       FDataPath := 'Hamster.App';
     end;
end;

destructor TAgtGrp.Destroy;
begin
     if IsOpen then Close;

     inherited Destroy;
end;

end.


