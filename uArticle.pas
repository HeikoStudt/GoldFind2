unit uArticle;

interface

uses classes;

type tArticle = class
  private
    prHeader : tStringList;
    prBody   : String;//tStringList;
    procedure setArticle(s: string);
    function  getArticle  : string;
    function  GetHeaderContent(header:string):string;  //Own
  public
    property  Header: TStringList read prHeader write prHeader;
    property  body  : String read prBody   write prBody;
    property  inputArticle: String write SetArticle;
    property  wholeArtikel: String read GetArticle;
    property  HeaderContent[header:string]:string read GetHeaderContent;  //Own
    procedure DelHeader(header:string);
    procedure AddHeader(header,content:string);
    procedure AddHeaderFirst(header,content:string);
    constructor create;
    destructor  destroy; override;
end;

implementation

uses sysutils;

function cut(var s :string; const index, count : integer) : string;
begin
  Result := copy(s,index,count);
  System.Delete(s,Index,Count);
end;

procedure StrToStrList(s:string; var sl:TStringList);
var
  i : integer;
begin
  sl.clear;
  i := 1; //pos(#13#10,s);
  while i<>0 do begin
    i := pos(#13#10,s);
    if i <> 0 then begin
      sl.Add(copy(s,1,i-1));
      system.delete(s,1,i+1);
    end else
      sl.Add(s);
  end;
end;


procedure tArticle.setArticle;
var
  i : integer;
begin
  prHeader.clear;
//  prBody.clear;
  prBody:='';
  i := pos(#13#10#13#10,s);
  if i = 0 then i := length(s);
  if i = 0 then exit;

  StrToStrList(cut(s,1,i-1), prHeader);
  if length(s)>=4 then
    System.Delete(s,1,4);
  prBody := s;
//  StrToStrList(b, prBody);
end;

function tArticle.getArticle;
begin
  Result := prHeader.GetText + #13#10#13#10 + prBody;
end;

function tArticle.GetHeaderContent(header:string):string;  //Own
  function LineOfHeader(header:string):integer;
  var
    i   : Integer;
    j   : Integer;
  begin
    j:=length(header);
    LineOfHeader:=-1;
    header := uppercase(header);
    for i:=0 to prHeader.count-1 do
      if uppercase(copy(prHeader[i],1,j))=header then begin
        LineOfHeader:=i;
        exit;
      end;
  end;

const
  WHSP = [' ', #9];

var
  i  : integer;
begin
  i := LineOfHeader(header);
  if i>=0 then begin
    Result := prHeader[i];
    System.Delete(Result,1,length(header)+1);
    inc(i);
    while (prHeader.count>i) and (length(prHeader[i])>0)
      and (prHeader[i][1] in WHSP) do begin
         Result := Result + prHeader[i]; //copy(prHeader[i],1,length(prHeader[i]));
                    //ToDo: Im RFC nachsehen, ob bei Folding der Space gelöscht werden muss. 
         inc(i);
    end;
//    Result := copy(s,length(header)+1,length(s));
  end else
    Result := '';
end;

procedure TArticle.DelHeader(header:string);  //Löscht *nur* eine Zeile
  function LineOfHeader(header:string):integer;
  var
    i   : Integer;
    j   : Integer;
  begin
    j:=length(header);
    LineOfHeader:=-1;
    header := uppercase(header);
    for i:=0 to prHeader.count-1 do
      if uppercase(copy(prHeader[i],1,j))=header then begin
        LineOfHeader:=i;
        exit
      end;
  end;

var
  i : integer;

begin
  i := LineOfHeader(header);
  if i>-1 then
    prHeader.Delete(i);
end;

procedure TArticle.AddHeader(header,content:string);
begin
  prHeader.insert(prHeader.count-1,header + ': ' + content);
end;

procedure TArticle.AddHeaderFirst(header,content:string);
begin
  prHeader.Insert(0, header + ': ' + content);
end;

constructor TArticle.create;
begin
  prHeader := TStringList.create;
//  prBody   := TStringList.create;
end;

destructor TArticle.destroy;
begin
  prHeader.free;
//  prBody.free;
end;


end.
