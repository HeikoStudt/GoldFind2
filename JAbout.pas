unit JAbout;

interface

uses Windows, ExtCtrls, StdCtrls, Controls, Classes, Forms, Graphics;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    OKButton: TButton;
    Shape1: TShape;
    ProgramIcon: TImage;
    Memo1: TMemo;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox = nil;

implementation

{$R *.DFM}

uses SysUtils;

function GetMyVersionInfo : String;
var  vlen, dw: DWORD;
     vstr    : Pointer;
     p       : Pointer;
     s       : String;
begin
     // Versionsnummer ermitteln
     GetMyVersionInfo := '?.?';

     vlen := GetFileVersionInfoSize( PChar(Application.ExeName), dw );
     if vlen=0 then exit;

     GetMem( vstr, vlen + 1 );
     if GetFileVersionInfo( PChar(Application.ExeName), dw, vlen, vstr ) then begin
        if VerQueryValue( vstr, '\', p, dw ) then begin
           s := 'Vr. ' + inttostr( hiword(PVSFixedFileInfo(p)^.dwProductVersionMS) ) + '.'
                           + inttostr( loword(PVSFixedFileInfo(p)^.dwProductVersionMS) );
           s := s + ' (Build ' + inttostr( hiword(PVSFixedFileInfo(p)^.dwFileVersionMS) ) + '.'
                                         + inttostr( loword(PVSFixedFileInfo(p)^.dwFileVersionMS) ) + '.'
                                         + inttostr( hiword(PVSFixedFileInfo(p)^.dwFileVersionLS) ) + '.'
                                         + inttostr( loword(PVSFixedFileInfo(p)^.dwFileVersionLS) ) + ')';
           GetMyVersionInfo := s;
        end;
     end;
     FreeMem( vstr, vlen + 1 );
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
     Version.Caption := GetMyVersionInfo;
end;

procedure TAboutBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Release;
     AboutBox := nil;
end;

end.

