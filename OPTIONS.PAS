unit OPTIONS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, inifiles;

const
  AgtDataPathMax = 7;
  iniOptions     = 'Options';

type
  TForm2 = class(TForm)
    PageControl1: TPageControl;
    tsDatabase: TTabSheet;
    tsVis: TTabSheet;
    tsMisc: TTabSheet;
    Panel1: TPanel;
    btnOK: TButton;
    grpFind: TGroupBox;
    Label7: TLabel;
    Label15: TLabel;
    Label10: TLabel;
    chkIgnoreFolders: TCheckBox;
    txtProgressRate: TEdit;
    chkREIgnoreCase: TCheckBox;
    grpSetup: TGroupBox;
    txtPath: TEdit;
    txtPath1: TEdit;
    txtPath2: TEdit;
    txtPath3: TEdit;
    txtPath4: TEdit;
    txtPath5: TEdit;
    txtPath6: TEdit;
    txtPath7: TEdit;
    chkPath0: TCheckBox;
    chkPath1: TCheckBox;
    chkPath2: TCheckBox;
    chkPath3: TCheckBox;
    chkPath4: TCheckBox;
    chkPath5: TCheckBox;
    chkPath6: TCheckBox;
    chkPath7: TCheckBox;
    grpDisplay: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    chkShowHdr: TCheckBox;
    chkShowBody: TCheckBox;
    chkShowSig: TCheckBox;
    chkShowGrpNam: TCheckBox;
    txtFont: TEdit;
    cmdFont: TButton;
    chk3DChart: TCheckBox;
    Label3: TLabel;
    txtGMT: TEdit;
    Label1: TLabel;
    FontDialog1: TFontDialog;
    procedure btnOKClick(Sender: TObject);
    procedure txtGMTChange(Sender: TObject);
    procedure txtProgressRateChange(Sender: TObject);
    procedure chkShowGrpNamClick(Sender: TObject);
    procedure chkIgnoreFoldersClick(Sender: TObject);
    procedure chkREIgnoreCaseClick(Sender: TObject);
    procedure cmdFontClick(Sender: TObject);
    procedure chkPath0Click(Sender: TObject);
    procedure txtPathExit(Sender: TObject);
    procedure chk3DChartClick(Sender: TObject);
    procedure chkShowHdrClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

  Bool = Boolean;

  tVisual = record
    shortGroups : Bool;
    ShowHeader  : Bool;
    ShowBody    : Bool;
    ShowSig     : Bool;

    ChartIn3d   : Bool;
    ResultFont  : tFont;
  end;

  tMisc = record
    Find_MaxArticles  : Integer;
    find_Ignore_Mailfolders : Bool;
    Find_RegexCase    : Integer;
    Find_Progressrate : Integer;

    TimeZone          : Integer;
  end;

  tDatabase = record
    Names     : Array [0..AgtDataPathMax] of String;
    Activated : Array [0..AgtDataPathMax] of Bool;
  end;

  tOpt = Record
    Visual : tVisual;
    Misc   : tMisc;
    Database  : tDatabase;
  end;

  procedure init;
  procedure PressedKey(c : char);

var
  Form2: TForm2;
  AgtIni : TIniFile;
  Opt : tOpt;

implementation

uses Main, uPerlre, JAbout;

{$R *.DFM}

procedure PressedKey(c : char);
begin
  case c of
    'h': form2.chkShowHdr.Checked := not form2.chkShowHdr.Checked;
  end;
end;

procedure init;
var
  i : integer;
  s : string;
begin
  with form2 do begin
    with Opt.Database do begin
      txtPath.Text     := Names[0];
      txtPath.Enabled  := Activated[0];
      chkPath0.Checked := Activated[0];

      txtPath1.Text    := Names[1];
      txtPath1.Enabled := Activated[1];
      chkPath1.Checked := Activated[1];

      txtPath2.Text    := Names[2];
      txtPath2.Enabled := Activated[2];
      chkPath2.Checked := Activated[2];

      txtPath3.Text     := Names[3];
      txtPath3.Enabled  := Activated[3];
      chkPath3.Checked  := Activated[3];

      txtPath4.Text     := Names[4];
      txtPath4.Enabled  := Activated[4];
      chkPath4.Checked  := Activated[4];

      txtPath5.Text     := Names[5];
      txtPath5.Enabled  := Activated[5];
      chkPath5.Checked  := Activated[5];

      txtPath6.Text     := Names[6];
      txtPath6.Enabled  := Activated[6];
      chkPath6.Checked  := Activated[6];

      txtPath7.Text     := Names[7];
      txtPath7.Enabled  := Activated[7];
      chkPath7.Checked  := Activated[7];
     end;

     chkShowGrpNam.Checked := Opt.Visual.shortGroups;

     txtProgressRate.Text := IntToStr(Opt.Misc.Find_Progressrate);

     txtGMT.Text := IntToStr(Opt.Misc.TimeZone);;

     s := AgtIni.ReadString( iniOptions, 'Show', '' );
     if s='' then s:='7';
     i := StrToInt( s );
     chkShowHdr.Checked  := (i and 1)=1;
     chkShowBody.Checked := (i and 2)=2;
     chkShowSig.Checked  := (i and 4)=4;
     chkShowHdrClick(nil);

     chk3DChart.checked := AgtIni.ReadBool('Setup', 'Chart3d', true);

     {Artikel-Font}
     txtFont.font := Opt.Visual.ResultFont;

     txtFont.Text := Opt.Visual.ResultFont.Name+' ('+IntToStr(Opt.Visual.ResultFont.Size)+')';
  end;
end;

procedure TForm2.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure SelectNewPath( PathIndex: Integer; NewPath: String );
var  s: String;
begin
     s := Lowercase( NewPath );
     Opt.Database.Names[PathIndex] := s;
     if PathIndex=0 then AgtIni.WriteString( iniOptions, 'AgtPath', s )
                    else AgtIni.WriteString( iniOptions, 'AgtPath'+IntToStr(PathIndex), s );
     form1.FillGroups;
end;

procedure TForm2.txtGMTChange(Sender: TObject);
var  s : String;
begin
     s := txtGMT.Text;
     if s='' then s:='0';
     try
        Opt.Misc.TimeZone := StrToInt(s);
     except
        Opt.Misc.TimeZone := 0;
     end;

     if abs(Opt.Misc.TimeZone)>24 then Opt.Misc.Timezone:=Opt.misc.Timezone div 100;
     s := IntToStr(Opt.Misc.Timezone);
     AgtIni.WriteString( iniOptions, 'GMTDelta', s );
     if txtGMT.Text<>s then txtGMT.Text:=s;
end;

procedure TForm2.txtProgressRateChange(Sender: TObject);
var  s : String;
begin
     s := txtProgressRate.Text;
     if s='' then s:='25';
     try
        Opt.Misc.Find_Progressrate := StrToInt(s);
     except
        Opt.Misc.Find_Progressrate := 25;
     end;

     if Opt.Misc.Find_Progressrate<1 then Opt.Misc.Find_Progressrate:=1;
     if Opt.Misc.Find_Progressrate>1000 then Opt.Misc.Find_Progressrate:=1000;
     s := IntToStr(Opt.Misc.Find_Progressrate);
     AgtIni.WriteString( iniOptions, 'ProgressRate', s );
     if txtProgressRate.Text<>s then txtProgressRate.Text:=s;
end;

procedure TForm2.chkShowGrpNamClick(Sender: TObject);
begin
     if chkShowGrpNam.Checked then begin
        Opt.Visual.shortGroups := true;
        AgtIni.WriteString( iniOptions, 'ShortGrpNam', '1' );
     end else begin
        Opt.Visual.shortGroups := false;
        AgtIni.WriteString( iniOptions, 'ShortGrpNam', '0' );
     end;
end;

procedure TForm2.chkIgnoreFoldersClick(Sender: TObject);
begin
     if Form1.StartUp then exit;
     if chkIgnoreFolders.Checked then begin
        AgtIni.WriteString( iniOptions, 'IgnoreFolders', '1' );
     end else begin
        AgtIni.WriteString( iniOptions, 'IgnoreFolders', '0' );
     end;
     form1.FillGroups;
end;

procedure TForm2.chkREIgnoreCaseClick(Sender: TObject);
begin
     if form1.StartUp then exit;
     if chkREIgnoreCase.Checked then begin
        AgtIni.WriteString( iniOptions, 'REIgnoreCase', '1' );
        Opt.Misc.Find_RegexCase := PCRE_CASELESS;
     end else begin
        AgtIni.WriteString( iniOptions, 'REIgnoreCase', '0' );
        Opt.Misc.Find_RegexCase := 0;
     end;
end;

procedure TForm2.cmdFontClick(Sender: TObject);
var  s : String;
begin
     FontDialog1.Font := Opt.Visual.ResultFont;

     if FontDialog1.Execute then begin
        Opt.Visual.ResultFont := FontDialog1.Font;
        txtFont.Text := Opt.Visual.ResultFont.Name+' ('+IntToStr(Opt.Visual.ResultFont.Size)+')';

        with form1.txtArticle.DefAttributes do begin
          Name  := Opt.Visual.ResultFont.Name;
          Size  := Opt.Visual.ResultFont.Size;
          Color := Opt.Visual.ResultFont.Color;
          Style := Opt.Visual.ResultFont.Style;
        end;

        with form1.rtfStat.font do begin
          Name  := Opt.Visual.ResultFont.Name;
          Size  := Opt.Visual.ResultFont.Size;
          Color := Opt.Visual.ResultFont.Color;
          Style := Opt.Visual.ResultFont.Style;
        end;

        AgtIni.WriteString( iniOptions, 'FontName',  Opt.Visual.ResultFont.Name );
        AgtIni.WriteString( iniOptions, 'FontSize',  IntToStr(Opt.Visual.ResultFont.Size) );
        AgtIni.WriteString( iniOptions, 'FontColor', IntToStr(Opt.Visual.ResultFont.Color) );

        s := '';
        if fsBold      in Opt.Visual.ResultFont.Style then s:=s+'B';
        if fsItalic    in Opt.Visual.ResultFont.Style then s:=s+'I';
        if fsUnderline in Opt.Visual.ResultFont.Style then s:=s+'U';
        if fsStrikeOut in Opt.Visual.ResultFont.Style then s:=s+'S';
        AgtIni.WriteString( iniOptions, 'FontStyle', s );

        txtFont.Font := Opt.Visual.ResultFont;
     end;
end;

procedure TForm2.chkPath0Click(Sender: TObject);
var  Chk      : Boolean;
     PathIndex: Byte;
begin
     if form1.Startup then exit;

     Cursor := crHourGlass;
     Application.ProcessMessages;
     Chk := (Sender as TCheckBox).Checked;

     PathIndex := 0;
     if Sender=chkPath0 then begin PathIndex:=0; txtPath.Enabled:=Chk;  end;
     if Sender=chkPath1 then begin PathIndex:=1; txtPath1.Enabled:=Chk; end;
     if Sender=chkPath2 then begin PathIndex:=2; txtPath2.Enabled:=Chk; end;
     if Sender=chkPath3 then begin PathIndex:=3; txtPath3.Enabled:=Chk; end;
     if Sender=chkPath4 then begin PathIndex:=4; txtPath4.Enabled:=Chk; end;
     if Sender=chkPath5 then begin PathIndex:=5; txtPath5.Enabled:=Chk; end;
     if Sender=chkPath6 then begin PathIndex:=6; txtPath6.Enabled:=Chk; end;
     if Sender=chkPath7 then begin PathIndex:=7; txtPath7.Enabled:=Chk; end;

     Opt.Database.Activated[PathIndex] := Chk;
     AgtIni.WriteBool( iniOptions, 'AgtPathEnabled'+inttostr(PathIndex), Chk );

     Cursor := crDefault;
     Application.ProcessMessages;

     if opt.Database.Names[PathIndex]<>'' then form1.FillGroups;
end;

procedure TForm2.txtPathExit(Sender: TObject);
begin
       if Sender=txtPath  then SelectNewPath( 0, txtPath.Text  )
  else if Sender=txtPath1 then SelectNewPath( 1, txtPath1.Text )
  else if Sender=txtPath2 then SelectNewPath( 2, txtPath2.Text )
  else if Sender=txtPath3 then SelectNewPath( 3, txtPath3.Text )
  else if Sender=txtPath4 then SelectNewPath( 4, txtPath4.Text )
  else if Sender=txtPath5 then SelectNewPath( 5, txtPath5.Text )
  else if Sender=txtPath6 then SelectNewPath( 6, txtPath6.Text )
  else if Sender=txtPath7 then SelectNewPath( 7, txtPath7.Text );
end;

procedure TForm2.chk3DChartClick(Sender: TObject);
begin
  form1.Chart.View3D := chk3DChart.checked;
  AgtIni.WriteBool('Setup', 'Chart3d',chk3DChart.checked);
end;

procedure TForm2.chkShowHdrClick(Sender: TObject);
var
  i,x : integer;
begin
     i := AgtIni.ReadInteger( iniOptions, 'Show', 0 );
     x := 1; if chkShowHdr.checked then i:=i or x else i:=i and not(x);
     x := 2; if chkShowBody.checked   then i:=i or x else i:=i and not(x);
     x := 4; if chkShowSig.checked    then i:=i or x else i:=i and not(x);
     AgtIni.WriteInteger( iniOptions, 'Show', i );

     Opt.Visual.ShowHeader := chkShowHdr.checked;
     Opt.Visual.ShowBody   := chkShowBody.checked;
     Opt.Visual.ShowSig    := chkShowSig.checked;
end;

initialization
  Opt.Misc.TimeZone := 0;
  Opt.Visual.ResultFont := tFont.create;
finalization
  try
    Opt.Visual.ResultFont.free;  //ToDo: Löst exception aus! Sollte ich nachfragen 
  except
  end;

end.
