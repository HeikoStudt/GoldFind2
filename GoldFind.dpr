program GoldFind;

uses
  Forms,
  IniFiles,
  SysUtils,
  Main in 'MAIN.PAS' {Form1},
  Agtbase in 'AGTBASE.PAS',
  Agtstat in 'AGTSTAT.PAS',
  JAbout in 'JAbout.pas' {AboutBox},
  cStats in 'cStats.pas',
  cArts in 'cArts.pas',
  Viewer in 'Viewer.pas' {frmViewer},
  ObjGrp in 'ObjGrp.pas',
  DllArt in 'DllArt.pas',
  DllGrp in 'DllGrp.pas',
  ObjArt in 'ObjArt.pas',
  uArticle in 'uArticle.pas',
  OPTIONS in 'OPTIONS.PAS' {Form2},
  uHamDLL in 'uHamDLL.pas',
  KWKHamster_TLB in '..\..\..\..\..\..\Programme\Borland\Delphi5\Imports\KWKHamster_TLB.pas',
  ObjArray in 'ObjArray.pas';

{$R *.RES}

begin
  Application.Initialize;
  AgtIni := TIniFile.Create( ExtractFilePath( Application.ExeName ) + 'GoldFind.ini' );
  Application.Title := 'GoldFind/32/OLE';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
  AgtIni.Free;
end.

