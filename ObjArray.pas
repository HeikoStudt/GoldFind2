// ----------------------------------------------------------------------------
// Simple array-object to keep a list of the objects currently used by Dll.
// ----------------------------------------------------------------------------

unit ObjArray;

interface

type
  PObjArrayType = ^TObjArrayType;
  TObjArrayType = array[0..0] of TObject;

  TObjArray = class
  private
    FCount   : Integer;
    FGrow    : Integer;
    FObjects : PObjArrayType;
    function  GetObject( Index: Integer ) : TObject;
    procedure SetObject( Index: Integer; Value: TObject );
    procedure Grow( NewCount: Integer );
  public
    property Count: Integer read FCount;
    property Objects[Index: Integer]: TObject read GetObject write SetObject;
    function GetFreeIndex : Integer;
    function IsValid( Index: Integer ) : Boolean;
    constructor Create( InitCount, InitGrow: Integer );
    destructor Destroy; override;
  end;

implementation

function TObjArray.GetObject( Index: Integer ) : TObject;
begin
     if IsValid(Index) then Result:= FObjects[Index]
                       else Result := nil;
end;

procedure TObjArray.SetObject( Index: Integer; Value: TObject );
begin
     if (Index>=0) and (Index<FCount) then FObjects[Index] := Value;
end;

function TObjArray.GetFreeIndex : Integer;
var  i : Integer;
begin
     for i:=0 to FCount-1 do begin
        if FObjects[i]=nil then begin Result:=i; exit; end;
     end;

     Result := FCount;
     Grow( FCount + FGrow );
end;

procedure TObjArray.Grow( NewCount: Integer );
var  NewValues : PObjArrayType;
     i         : Integer;
begin
     if NewCount<=FCount then exit;

     GetMem( NewValues, NewCount * sizeof(Pointer) );
     for i:=0 to FCount-1 do NewValues[i]:=FObjects[i];
     for i:=FCount to NewCount-1 do FObjects[i]:=nil;
     FreeMem( FObjects, FCount * sizeof(Pointer) );

     FObjects := NewValues;
     FCount  := NewCount;
end;

function TObjArray.IsValid( Index: Integer ) : Boolean;
begin
     Result := False;
     if (Index<0) or (Index>=FCount) then exit;
     if FObjects[Index]=nil then exit;
     Result := True;
end;

constructor TObjArray.Create( InitCount, InitGrow: Integer );
var  i : Integer;
begin
     inherited Create;

     FCount := InitCount; if FCount<1 then FCount:=1;
     FGrow  := InitGrow;  if FGrow <1 then FGrow :=1;
     
     GetMem( FObjects, FCount * sizeof(Pointer) );
     for i:=0 to FCount-1 do FObjects[i]:=nil;
end;

destructor TObjArray.Destroy;
begin
     FreeMem( FObjects, FCount * sizeof(Pointer) );
     inherited Destroy;
end;

end.
