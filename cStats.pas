unit cStats;

interface

uses SysUtils, Classes;

type
  TStatInfo = class(TObject)
     Counter: LongInt; // number of entries added
     Weight : Longint; // used instead of Counter if not all entries count as 1
                       // or if an additional value is needed (DAU Jones pts.)
     Group  : Integer; // used to separate stats stored within one list
     function WCRatio: Double;
  end;

  TStatList = class
     private
        FList: TStringList;
        
        function GetCount: Integer;
        function GetKey ( Index: Integer ): String;
        function GetInfo( Index: Integer ): TStatInfo;
        function GetCounterSum: Integer;

     public
        property Count: Integer read GetCount;
        property Keys [ Index: Integer ]: String    read GetKey;
        property Infos[ Index: Integer ]: TStatInfo read GetInfo;
        property CounterSum: Integer read GetCounterSum;

        procedure Clear;
        procedure Add( Key   : String;
                       Weight: Integer = 1;
                       Group : Integer = 0 );
        procedure SortBy_Counter;
        procedure SortBy_Weight;
        procedure SortBy_GroupDesc_Counter;
        procedure SortBy_GroupDesc_Weight;
        procedure SortBy_Group_WCRatioDesc;

        constructor Create;
        destructor Destroy; override;
  end;


implementation

{ TStatInfo }

function TStatInfo.WCRatio: Double;
begin
   if Counter = 0 then Result := 0
                  else Result := Weight / Counter;
end;

{ TStatList }

procedure TStatList.Add(Key: String; Weight, Group: Integer);
var  TH   : TStatInfo;
     Index: Integer;
begin
     Index := FList.IndexOf( Key );
     if Index >= 0 then begin
        TH := Infos[Index];
        inc( TH.Counter );
        inc( TH.Weight, Weight );
        TH.Group := Group;
     end else begin
        TH := TStatInfo.Create;
        TH.Counter := 1;
        TH.Weight := Weight;
        TH.Group := Group;
        FList.AddObject( Key, TH );
     end;
end;

procedure TStatList.Clear;
var  i: Integer;
begin
   for i:=0 to FList.Count-1 do begin
      if Assigned( FList.Objects[i] ) then TStatInfo( FList.Objects[i] ).Free;
   end;
   FList.Clear;
   FList.Sorted := True;
end;

constructor TStatList.Create;
begin
   inherited Create;
   FList := TStringList.Create;
   FList.Sorted := True;
end;

destructor TStatList.Destroy;
begin
   if Assigned( FList ) then begin Clear; FreeAndNil(FList) end;
   inherited Destroy;
end;

function TStatList.GetCount: Integer;
begin
   Result := FList.Count;
end;

function TStatList.GetInfo(Index: Integer): TStatInfo;
begin
   Result := TStatInfo( FList.Objects[ Index ] );
end;

function TStatList.GetKey(Index: Integer): String;
begin
   Result := FList.Strings[ Index ];
end;

function TStatList.GetCounterSum: Integer;
var  i: Integer;
begin
   Result := 0;
   for i:=0 to Count-1 do inc( Result, Infos[i].Counter );
end;

function CompareBy_Weight( List: TStringList; Index1, Index2: Integer): Integer;
begin
   Result := TStatInfo( List.Objects[Index2] ).Weight
           - TStatInfo( List.Objects[Index1] ).Weight;
end;

procedure TStatList.SortBy_Weight;
begin
   FList.Sorted := False;
   FList.CustomSort( CompareBy_Weight );
end;

function CompareBy_Counter( List: TStringList; Index1, Index2: Integer): Integer;
begin
   Result := TStatInfo( List.Objects[Index2] ).Counter
           - TStatInfo( List.Objects[Index1] ).Counter;
end;

procedure TStatList.SortBy_Counter;
begin
   FList.Sorted := False;
   FList.CustomSort( CompareBy_Counter );
end;

function CompareBy_GroupDesc_Counter( List: TStringList; Index1, Index2: Integer): Integer;
begin
   Result := TStatInfo( List.Objects[Index1] ).Group
           - TStatInfo( List.Objects[Index2] ).Group;
   if Result <> 0 then exit;

   Result := TStatInfo( List.Objects[Index2] ).Counter
           - TStatInfo( List.Objects[Index1] ).Counter;
end;

procedure TStatList.SortBy_GroupDesc_Counter;
begin
   FList.Sorted := False;
   FList.CustomSort( CompareBy_GroupDesc_Counter );
end;

function CompareBy_GroupDesc_Weight( List: TStringList; Index1, Index2: Integer): Integer;
begin
   Result := TStatInfo( List.Objects[Index1] ).Group
           - TStatInfo( List.Objects[Index2] ).Group;
   if Result <> 0 then exit;

   Result := TStatInfo( List.Objects[Index2] ).Weight
           - TStatInfo( List.Objects[Index1] ).Weight;
end;

procedure TStatList.SortBy_GroupDesc_Weight;
begin
   FList.Sorted := False;
   FList.CustomSort( CompareBy_GroupDesc_Weight );
end;

function CompareBy_Group_WCRatioDesc( List: TStringList; Index1, Index2: Integer): Integer;
var  r1, r2: Double;
begin
   Result := TStatInfo( List.Objects[Index2] ).Group
           - TStatInfo( List.Objects[Index1] ).Group;
   if Result <> 0 then exit;

   r1 := TStatInfo( List.Objects[Index1] ).WCRatio;
   r2 := TStatInfo( List.Objects[Index2] ).WCRatio;
   if      r1 < r2 then Result := 1
   else if r1 > r2 then Result := -1;
end;

procedure TStatList.SortBy_Group_WCRatioDesc;
begin
   FList.Sorted := False;
   FList.CustomSort( CompareBy_Group_WCRatioDesc );
end;

end.
