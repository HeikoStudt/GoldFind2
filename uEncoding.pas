// ============================================================================
// Encoding of message-headers.
// Copyright (c) 1999, Juergen Haible. All Rights Reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
// ============================================================================

unit uEncoding; // Encoding of message-headers.

// ----------------------------------------------------------------------------
// Encoding of message-headers.
// Adapted from various sources I can't remember in detail - the tin-sources
// (www.tin.org) were surely amongst them.
// ----------------------------------------------------------------------------

interface

function EncodeB64( const BufTxt; BufLen: Integer ): String;
function DecodeB64( const BufB64; BufLen: Integer ): String;

function xEncodeQP( const BufTxt; BufLen: Integer ): String;
function DecodeQP ( const BufQP;  BufLen: Integer ): String;

function DecodeHeadervalue( const BufHdrVal; BufLen: Integer ): String;

// ----------------------------------------------------------------------------

implementation

uses SysUtils;

const
   Base64Pad       = '=';
   Base64Alphabet  : PChar   = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdef'
                             + 'ghijklmnopqrstuvwxyz0123456789+/';
var
   Base64TableBuilt: Boolean = False;
   Base64Table: array[#0..#255] of Byte;

function EncodeB64( const BufTxt; BufLen: Integer ): String;
var  BufPtr, BufEnd: PChar;
     i, Count, Temp: Integer;
begin
   Result := '';

   BufPtr := @BufTxt;
   BufEnd := BufPtr + BufLen;

   while BufPtr<BufEnd do begin
      Temp := 0;
      Count := 0;
      for i:=0 to 2 do begin
         Temp := (Temp shl 8);
         if BufPtr<BufEnd then begin
            Temp := Temp or ord( BufPtr^ );
            inc( BufPtr );
            inc( Count );
         end;
      end;

      Result := Result + Base64Alphabet[ (Temp shr 18) and $3F ]
                       + Base64Alphabet[ (Temp shr 12) and $3F ];
      if Count>=2 then Result := Result + Base64Alphabet[ (Temp shr 6) and $3F ]
                  else Result := Result + Base64Pad;
      if Count>=3 then Result := Result + Base64Alphabet[ Temp and $3F ]
                  else Result := Result + Base64Pad;
   end;
end;

function DecodeB64( const BufB64; BufLen: Integer ): String;
var  BufPtr, BufEnd: PChar;
     Pattern, Bits : Integer;
     b64: Byte;
begin
   Result := '';

   try
      if not Base64TableBuilt then begin
         FillChar( Base64Table, sizeof(Base64Table), $FF );
         for b64:=0 to 63 do Base64Table[ Base64Alphabet[b64] ] := b64;
         Base64TableBuilt := True;
      end;

      BufPtr := @BufB64;
      BufEnd := BufPtr + BufLen;

      Pattern := 0;
      Bits    := 0;

      while BufPtr<BufEnd do begin
         b64 := Base64Table[ BufPtr^ ];
         inc( BufPtr );
         if b64<>$FF then begin
            Pattern := (Pattern shl 6) or b64;
            inc( Bits, 6 );
            if Bits>=8 then begin
               dec( Bits, 8 );
               Result := Result + chr( ( Pattern shr Bits ) and $FF );
            end;
         end;
      end;
   except
      Result := '';
   end;
end;

// ----------------------------------------------------------------------------

function xEncodeQP( const BufTxt; BufLen: Integer ): String;
// Note: Just "quick&dirty" for testing purposes.
var  BufPtr, BufEnd: PChar;
     ch: Char;
begin
   Result := '';

   BufPtr := @BufTxt;
   BufEnd := BufPtr + BufLen;

   while BufPtr<BufEnd do begin
      ch := BufPtr^;
      inc( BufPtr );

      case ch of
         #0..#31,
         #61,
         #127..#255: Result := Result + '=' + inttohex(ord(ch),2);
         #32:        Result := Result + '_';
         else        Result := Result + ch;
      end;
   end;
end;

function DecodeQP( const BufQP; BufLen: Integer ): String;

   function Nibble( c: Char ): Byte;
   begin
      case c of
         '0'..'9': Result := Byte(c) - Byte('0');
         'A'..'F': Result := Byte(c) - Byte('A') + 10;
         'a'..'f': Result := Byte(c) - Byte('a') + 10;
         else      Result := 255;
      end;
   end;

var  BufPtr, BufEnd: PChar;
     ch            : Char;
     hi, lo        : Byte;
begin
   Result := '';

   BufPtr := @BufQP;
   BufEnd := BufPtr + BufLen;

   while BufPtr<BufEnd do begin
      ch := BufPtr^;
      inc( BufPtr );

      if ch='=' then begin

         if BufPtr>=BufEnd then break;
         ch := BufPtr^;
         inc( BufPtr );

         if (ch<>#13) and (ch<>#10) then begin
            if BufPtr>=BufEnd then break;
            hi := Nibble(ch);
            lo := Nibble(BufPtr^);
            inc( BufPtr );
            if (hi=255) or (lo=255) then exit;
            ch := chr( (hi shl 4) + lo );
            Result := Result + ch;
         end;

      end else begin

         if (ch<>'_') then Result := Result + ch
                      else Result := Result + ' ';

      end;
   end;
end;

// ----------------------------------------------------------------------------

function isspace( c: Char ): Boolean;
begin
   Result := ( c in [ #9, #10, #11, #12, #13, ' ' ] );
end;

function DecodeHeadervalue( const BufHdrVal; BufLen: Integer ): String;
var  BufPtr, BufEnd, Temp: PChar;
     Encoding: Char;
     CharSet : String;
begin
   Result := '';

   BufPtr := @BufHdrVal;
   BufEnd := BufPtr + BufLen;

   while BufPtr<BufEnd do begin

      if BufPtr^='=' then begin

         inc( BufPtr );
         if (BufPtr>=BufEnd) then break;

         if BufPtr^<>'?' then begin

            Result := Result + '=' + BufPtr^;
            inc( BufPtr );

         end else begin

            CharSet := '';
            inc( BufPtr );
            while (BufPtr<BufEnd) and (BufPtr^<>'?') do begin
               CharSet := CharSet + BufPtr^;
               inc( BufPtr );
            end;
            if (BufPtr>=BufEnd) then break;

            inc( BufPtr );
            if (BufPtr>=BufEnd) then break;
            Encoding := BufPtr^;

            inc( BufPtr );
            if (BufPtr>=BufEnd) then break;
            if BufPtr^='?' then begin

               inc( BufPtr );
               if (BufPtr>=BufEnd) then break;
               Temp := StrScan( BufPtr, '?' );

               if Temp<>nil then begin
                  if UpperCase(Encoding)='B' then
                     Result := Result + DecodeB64( BufPtr^, Temp - BufPtr )
                  else
                     Result := Result + DecodeQP ( BufPtr^, Temp - BufPtr );

                  BufPtr := Temp + 1;
                  if (BufPtr<BufEnd) and (BufPtr^='=') then inc(BufPtr);

                  Temp := BufPtr;
                  while (Temp<BufEnd) and isspace(Temp^) do inc(Temp);
                  if (Temp<BufEnd) and (Temp^='=') then BufPtr:=Temp;
               end;

            end;

         end;

      end else begin

         Result := Result + BufPtr^;
         inc( BufPtr );

      end;

   end;
end;

// ----------------------------------------------------------------------------

end.
