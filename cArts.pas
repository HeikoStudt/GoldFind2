unit cArts;

interface

uses SysUtils, Classes;

type
  TArt = class(TStringList)
     procedure SkipHeader;
     procedure SkipBoundary;
     procedure TrimLines;
     function GetQuoteChar: Char;
  end;

function FilterMailAdr( h: String ) : String;
function StatDomainOf( h: String ) : String;
function FilterNameOfFrom( F: String ) : String;
function FilterSubject( S: String ) : String;
function ROT13( s: String ) : String;


implementation

uses uEncoding, AgtBase;

function FilterMailAdr( h: String ) : String;
var  p, pat : Integer;
begin
     pat := Pos( '@', h );
     if pat>0 then begin
        repeat
           p := Pos( ' ', h );
           if p>0 then begin
              if p<pat then h:=copy(h,p+1,255) else h:=copy(h,1,p-1);
           end;
        until p=0;
     end;

     if copy(h,1,1)='<' then System.Delete( h, 1, 1 );
     if copy(h,length(h),1)='>' then System.Delete( h, length(h), 1 );

     Result := h;
end;

function StatDomainOf( h: String ) : String;
var  p, pat : Integer;
begin
     Result := h;

     pat := Pos( '@', h );
     if pat=0 then exit;

     System.Delete( h, 1, pat );
     Result := h;

     repeat
        p := Pos( '.', h );
        if p=0 then exit;

        if Pos( '.', copy(h,p+1,255) ) > 0 then begin
           System.Delete( h, 1, p );
        end else begin
           Result := h;
           break;
        end;
     until p=0;
end;

function FilterNameOfFrom( F: String ) : String;
var  j : Integer;
     s : String;
begin
     s := DecodeHeadervalue( F[1], length(F) );
     j := Pos( '(', s );
     if j>0 then begin
        System.Delete( s, 1, j );
        j := Pos( ')', s );
        if j>0 then s:=copy(s,1,j-1);
     end else begin
        // From: "xxx" <yyy@zzz>
        j := Pos( '<', s );
        if j>=5 then s := Trim( copy(s,1,j-1) );
        if copy(s,1,1)='"' then System.Delete(s,1,1);
        if copy(s,length(s),1)='"' then System.Delete(s,length(s),1);
     end;

     s := Trim( s );
     if s='' then s:=F;
     Result := s;
end;

function FilterSubject( S: String ) : String;
var  j: Integer;
     h: String;
begin
   h := LowerCase( copy(S,1,3) );
   if h='re:' then System.Delete( S, 1, 3 );
   j := Pos( '(was:', S );
   if j>0 then S:=copy(S,1,j-1);
   Result := TrimWhSpace( S );
end;

function ROT13( s: String ) : String;
var  i : Integer;
     c : Char;
begin
     for i:=1 to length(s) do begin
        c := s[i];
        if c in ['a'..'z'] then begin
           c := Chr( Ord(c)+13 );
           if c>'z' then c := Chr( Ord(c)-26 );
        end else begin
           if c in ['A'..'Z'] then begin
              c := Chr( Ord(c)+13 );
              if c>'z' then c := Chr( Ord(c)-26 );
           end;
        end;
        s[i] := c;
     end;
     Result := s;
end;


{ TArt }
procedure TArt.SkipHeader;
begin
     while (Count>0) and (Strings[0]<>'') do   Delete(0);
     if    (Count>0) and (Strings[0]= '') then Delete(0);
end;

procedure TArt.TrimLines;
var  i : Integer;
begin
     for i:=0 to Count-1 do Strings[i]:=Trim(Strings[i]);
end;

procedure TArt.SkipBoundary;
var  i, j : Integer;
     b, s : String;
begin
     b := '';
     for i:=0 to Count-1 do begin
        s := Strings[i];

        if b='' then begin
           if (Pos('content-type:',Lowercase(s))>0) and
              (Pos('multipart',Lowercase(s)) > 0) then begin
              j := Pos('boundary="',Lowercase(s));
              if j>0 then begin
                 b := copy( s, j+10, 255 );
                 b := copy(b,1,length(b)-1);
              end;
           end;
        end else begin
           if s='--'+b then Strings[i]:='';
        end;
     end;
end;

function TArt.GetQuoteChar: Char;
var  i : Integer;
     s : String;
begin
     Result := '>';
     for i:=0 to Count-1 do begin
        s := Strings[i] + ' ';
        if s[1] in ['>',':','|'] then begin Result:=s[1]; break; end;
     end;
end;


end.
