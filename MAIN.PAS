unit Main;

interface

uses
  Windows, SysUtils, Menus, Graphics, Forms, Dialogs, Gauges, ExtCtrls,
  StdCtrls, ComCtrls, Buttons, Controls, Classes, Tabnotbk, ClipBrd,
  DllGrp, DllArt, AgtBase, AgtStat, JAbout, uperlre, Viewer, ActnList,
  TeeProcs, TeEngine, Chart, Series, uArticle, ExtDlgs, Messages, ShellAPI,
  kProgress;

const
  FindPartMax   = 32;
  FindHow_YES   = 0;
  FindHow_OneOf = 1;
  FindHow_NO    = 2;

type
  ShiftTab_Type = array[#0..#255] of Byte;

  FindPart_Type = record
    Txt : array[0..64] of Char;
    Len : Integer;
    Hdr : array[0..64] of Char;
    How : Byte;
    Shift: ShiftTab_Type;
    IsRE: Boolean;
    ReFoundLen: LongInt;
    PseudoMime: Byte;
  end;

type
  TForm1 = class(TForm)
    TabbedNotebook1: TTabbedNotebook;
    pnlStop: TPanel;
    BalkenG: TGauge;
    btnStop: TBitBtn;
    lblCount: TLabel;
    lblStatGrp: TLabel;
    PopupMenuText: TPopupMenu;
    mnuTxtSelectAll: TMenuItem;
    mnuTxtCopy: TMenuItem;
    rtfStat: TRichEdit;
    N1: TMenuItem;
    mnuExportAll: TMenuItem;
    mnuLaunchViewer: TMenuItem;
    StatusBar1: TStatusBar;
    N2: TMenuItem;
    mnuLaunchAgent: TMenuItem;
    mnuShowViewer: TMenuItem;
    ActionList1: TActionList;
    acShowViewer: TAction;
    Chart: TChart;
    Series1: TFastLineSeries;
    PopupMenuArticleShow: TPopupMenu;
    ROT131: TMenuItem;
    COPY1: TMenuItem;
    MARK1: TMenuItem;
    Panel1: TPanel;
    rgExp: TRadioGroup;
    SavePictureDialog: TSavePictureDialog;
    btnExport: TButton;
    MainMenu1: TMainMenu;
    Datei1: TMenuItem;
    Konfiguration1: TMenuItem;
    Exit1: TMenuItem;
    pnlSelection: TPanel;
    hdrGrp: THeader;
    lstGroups: TListBox;
    btnCountArticles: TButton;
    pnlTime: TPanel;
    Label16: TLabel;
    optStatDays: TRadioButton;
    optStatRange: TRadioButton;
    txtStatDays: TEdit;
    txtStatFrom: TEdit;
    Label17: TLabel;
    Label12: TLabel;
    txtStatTil: TEdit;
    Splitter1: TSplitter;
    PopupMenuMessageMail: TPopupMenu;
    MessageID1: TMenuItem;
    CreateMail1: TMenuItem;
    Help1: TMenuItem;
    Info1: TMenuItem;
    AutoSelection1: TMenuItem;
    New1: TMenuItem;
    Change1: TMenuItem;
    N3: TMenuItem;
    AllGroups1: TMenuItem;
    pnlSearch: TPanel;
    lblFindIn: TLabel;
    lblFindWhat: TLabel;
    cboFind: TComboBox;
    chkHeader: TCheckBox;
    chkSig: TCheckBox;
    chkBody: TCheckBox;
    btnFind: TBitBtn;
    hdrArt: THeader;
    lstArticles: TListBox;
    txtArticle: TRichEdit;
    VSplitter: TSplitter;
    grpStatSel: TGroupBox;
    Label8: TLabel;
    lblStatPar: TLabel;
    Label9: TLabel;
    cboStatType: TComboBox;
    txtStatPar: TEdit;
    btnStat: TBitBtn;
    chkSortByRatio: TCheckBox;
    HeaderControl1: THeaderControl;
    Label4: TLabel;
    txtStopAfter: TEdit;
    N4: TMenuItem;
    ShowHeader1: TMenuItem;
    ShowBody1: TMenuItem;
    ShowSignature1: TMenuItem;
    chkBrowse: TCheckBox;
    procedure lstGroupsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnFindClick(Sender: TObject);
    procedure lstArticlesClick(Sender: TObject);
    procedure lstArticlesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure hdrArtSized(Sender: TObject; ASection, AWidth: Integer);
    procedure hdrGrpSized(Sender: TObject; ASection, AWidth: Integer);
//    procedure cmdPathClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lstArticlesDblClick(Sender: TObject);
//    procedure txtPath1KeyDown(Sender: TObject; var Key: Word;
//      Shift: TShiftState);
    procedure mnuTxtSelectAllClick(Sender: TObject);
    procedure mnuTxtCopyClick(Sender: TObject);
    procedure VSplitterMoved(Sender: TObject);
    procedure txtArticleKeyPress(Sender: TObject; var Key: Char);
    procedure btnCountArticlesClick(Sender: TObject);
    procedure cboStatTypeClick(Sender: TObject);
    procedure btnStatClick(Sender: TObject);
    procedure txtStatParKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure optStatDaysClick(Sender: TObject);
    procedure txtStatDaysExit(Sender: TObject);
    procedure mnuExportAllClick(Sender: TObject);
    procedure PopupMenuTextPopup(Sender: TObject);
    procedure cboFindKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mnuLaunchViewerClick(Sender: TObject);
    procedure mnuLaunchAgentClick(Sender: TObject);
    procedure acShowViewerExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ROT131Click(Sender: TObject);
    procedure MARK1Click(Sender: TObject);
    procedure COPY1Click(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure txtArticleMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Exit1Click(Sender: TObject);
    procedure Konfiguration1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chkHeaderClick(Sender: TObject);
    procedure txtArticleMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Info1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Change1Click(Sender: TObject);
    procedure MenuItemAutoSelClick(Sender: TObject);
    procedure lstGroupsClick(Sender: TObject);
    procedure txtStopAfterChange(Sender: TObject);
    procedure ShowHeader1Click(Sender: TObject);
    procedure ShowBody1Click(Sender: TObject);
    procedure ShowSignature1Click(Sender: TObject);
    procedure TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
  private
    { Private-Deklarationen }
    StatIsActive : Boolean;
    ProgressRateB: LongInt;
    FindParts    : Integer;
    FindPart     : array[0..FindPartMax-1] of FindPart_Type;
    ShortGrpNam  : Boolean;
    ShowPosition : Integer;
    ArtShowDiv   : Integer;
    ArtShowMul   : Integer;
    Zeit         : LongInt;
    PseudoMime   : Boolean;
    LastExport   : String;
    WasCtrl, WasShift: Boolean;
    OldBrowseIndex: Integer;
    procedure UpdateAutoSel;
    procedure ParseFindParts;
    function  StrIFindQ( Base: PChar; fp: Byte ) : PChar;
    function  StrIFindRE( Base: PChar; fp: Byte; HeaderOnly: Boolean ) : Boolean;
    function  StrIFindPosRE( Base: PChar; fp: Byte; HeaderOnly: Boolean ) : PChar;
    function  FoundParts : Boolean;
    procedure FormArtText( FHdr, FBody, FSig: Boolean );
    procedure FindPositions;
    procedure ShowPositions( Direction : Integer );
    procedure ShowArticle( PathIndex: Byte; GrpID, ArtNo: LongInt );
    procedure MarkAllGroups( OnOff : Boolean );
    procedure ClearArticles;
    procedure FindArticles( TG: TAgtGroupMem );
    procedure LoadSections( IniKey: String; hdr: THeader );
    procedure SaveSections( IniKey: String; hdr: THeader );
    procedure DrawSections( hdr, lst: TWinControl; Index: Integer; Rect: TRect; Line: String );
    procedure RelocateCountButton;
    procedure ShowStatSelection;
  public
    { Public-Deklarationen }
    Startup      : Boolean;
    Stop         : Boolean;
    BalkenCount  : LongInt;
    FindCount    : LongInt;
    AllCount     : LongInt;
    procedure FillGroups;
    procedure AgentLaunchByDDE( TA: TAgtArticle );
    function  FindBegin : Boolean;
    procedure FindStatus( TG: TAgtGroupMem; LfdArt: LongInt );
    procedure FindEnd;
  end;

var
  Form1: TForm1;

var
  DayDates: Boolean   = False;
  ForDays    : LongInt   = 21;
  DayFrom : TDateTime = 0;
  DayTil  : TDateTime = 0;

  function DayOK( UnixTime: LongInt ): Boolean;


implementation

{$R *.DFM}

uses uEncoding, Options;

const GroundDate = 25569.0; // =EncodeDate(1970,1,1)

const
  VK_A = $0041;
  VK_C = $0043;
  VK_D = $0044;
  VK_G = $0047;
  VK_H = $0048;
  VK_J = $004A;
  VK_L = $004C;
  VK_N = $004E;
  VK_P = $0050;
  VK_S = $0053;
  VK_U = $0055;
  VK_V = $0056;
  VK_X = $0058;
  VK_Z = $005A;

  FindHistoryMax = 32;
  FindPosMax = 64;

  StatMPD  = 100;
  StatMPWD = 130;
  StatMPH  = 110;
  StatMPM  = 120;
  StatHFR  = 200;
  StatHFgn = 210;
  StatHFgd = 211;
  StatHSU  = 215;
  StatHMg  = 220;
  StatHXN  = 230;
  StatHXNga= 240;
  StatHXNgu= 241;
  StatH    = 250;
  StatHRE  = 260;
  StatPR   = 300;
  StatMF   = 310;
  StatFO   = 320;
  StatDAU  = 400;
  StatDAUn = 401;

var
  FindPosCount : Integer;
  FindPos      : array[0..FindPosMax] of Integer;
  FindLen      : array[0..FindPosMax] of Integer;

{---------------------------------------------------- Allgemeine Funktionen ---}

function GetMyVersionInfo : String;
var  vlen, dw: Cardinal;
     vstr    : Pointer;
     p       : Pointer;
     s       : String;
begin
     {Versionsnummer ermitteln}
     Result := '?.?';

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
           Result := s;
        end;
     end;

     FreeMem( vstr, vlen + 1 );
end;

procedure FindPosAdd( P, L : Integer );
var  i, h : Integer;
begin
     if FindPosCount>=FindPosMax then exit;

     FindPos[FindPosCount] := P;
     FindLen[FindPosCount] := L;
     i := FindPosCount;
     inc( FindPosCount );

     while i>0 do begin
        if FindPos[i]<FindPos[i-1] then begin
           h := FindPos[i-1]; FindPos[i-1]:=FindPos[i]; FindPos[i]:=h;
           h := FindLen[i-1]; FindLen[i-1]:=FindLen[i]; FindLen[i]:=h;
        end else begin
           i := -1;
        end;
        dec(i);
     end;
end;

function TForm1.StrIFindQ( Base: PChar; fp: Byte ) : PChar;
var  tstr : PChar;
     i : Integer;
     flen, tlen : Integer;
     shft: ShiftTab_Type;
     limit, flen1: Integer;
     fstr : PChar;
begin
     StrIFindQ := nil; {Default: Nicht gefunden}

     flen := FindPart[fp].Len;
     if flen=0 then exit; {kein Suchtext}

     tlen := strlen(Base);
     if flen>tlen then exit; {kein Text}

     fstr := FindPart[fp].Txt;
     shft := FindPart[fp].Shift;

     tstr := Base;
     tlen := strlen(Base);

     limit := tlen-flen;
     flen1 := flen - 1;

     {Quicksearch}
     repeat
        i := flen1;
        while Upcase((tstr+i)^)=(fstr+i)^ do begin
           if i=0 then begin StrIFindQ:=tstr; exit; end;
           dec(i);
        end;
        tstr := (tstr + shft[ (tstr+flen)^ ]);
     until (tstr-Base)>=limit;
end;

function StrIFindHdr( Base, Find, HdrNam: PChar ) : PChar;
var  p, bl, fl : Integer;
     HdrBase, HdrEnd: PChar;
begin
     StrIFindHdr := nil; {Default: Nicht gefunden}

     fl := strlen( Find );
     if fl=0 then exit;  {kein Suchtext}

     {Headerbeginn suchen}
     HdrBase := StrIQuickSearch( Base, #13#10 + HdrNam + ' ' );
     if HdrBase=nil then begin
        HdrBase := StrIQuickSearch( Base, #13#3 + HdrNam + ' ' ); // teilweise auch #13#3!
        if HdrBase=nil then exit;
     end;

     HdrBase := (HdrBase+StrLen(HdrNam)+3);

     {Headerende/-l‰nge ermitteln}
     HdrEnd := StrScan(HdrBase,#13);
     if HdrEnd=nil then exit;
     bl := (HdrEnd-HdrBase);
     if bl<fl then exit; {kein gen¸gend langer Basistext}

     for p:=0 to bl-fl do begin
        if StrLIComp( HdrBase, Find, fl )=0 then begin
           StrIFindHdr := HdrBase; {Gefunden}
           exit;
        end;
        inc( HdrBase );
     end;
end;

function TForm1.StrIFindRE( Base: PChar; fp: Byte; HeaderOnly: Boolean ) : Boolean;
var  i, j : Integer;
     flen, tlen : Integer;
     Art: TStringList;
     Hdr: String;
begin
     Result := False; {Default: Nicht gefunden}

     flen := FindPart[fp].Len;
     if flen=0 then exit; {kein Suchtext}

     tlen := strlen(Base);
     if flen>tlen then exit; {kein Text}

     Art := TStringList.Create;
     Art.Text := String( Base );

     if HeaderOnly then begin
        Hdr := Uppercase( String( FindPart[fp].Hdr ) );
        for i:=0 to Art.Count-1 do begin
           if Art[i]='' then break; // end-of-header
           j := Pos( ':', Art[i] );
           if UpperCase( copy(Art[i],1,j) )=Hdr then begin
              if regex.MatchRSO( FindPart[fp].Txt, Art[i], opt.Misc.Find_RegexCase ) then begin
                 Result := True;
                 break;
              end;
           end;
        end;
     end else begin
        for i:=0 to Art.Count-1 do begin
           if regex.MatchRSO( FindPart[fp].Txt, Art[i], Opt.Misc.Find_RegexCase ) then begin
              Result := True;
              break;
           end;
        end;
     end;

     Art.Free;
end;

function TForm1.StrIFindPosRE( Base: PChar; fp: Byte; HeaderOnly: Boolean ) : PChar;
var  i, j : Integer;
     flen, tlen : Integer;
     Art: TStringList;
     Hdr: String;
     LineStart: LongInt;
begin
     Result := nil; {Default: Nicht gefunden}

     flen := FindPart[fp].Len;
     if flen=0 then exit; {kein Suchtext}

     tlen := strlen(Base);
     if flen>tlen then exit; {kein Text}

     Art := TStringList.Create;
     Art.Text  := String( Base );
     LineStart := 0;

     if HeaderOnly then begin
        Hdr := Uppercase( String( FindPart[fp].Hdr ) );
        for i:=0 to Art.Count-1 do begin
           if Art[i]='' then break; // end-of-header
           j := Pos( ':', Art[i] );
           if UpperCase( copy(Art[i],1,j) )=Hdr then begin
              if regex.MatchRSO( FindPart[fp].Txt, Art[i], Opt.Misc.Find_RegexCase ) then begin
                 FindPart[fp].ReFoundLen := regex.SubExp[0].len;
                 Result := Base + LineStart + regex.SubExp[0].StartP - 1;
                 break;
              end;
           end;
           inc( LineStart, length(Art[i]) + 2 );
        end;
     end else begin
        for i:=0 to Art.Count-1 do begin
           if regex.MatchRSO( FindPart[fp].Txt, Art[i], Opt.Misc.Find_RegexCase ) then begin
              FindPart[fp].ReFoundLen := regex.SubExp[0].len;
              Result := Base + LineStart + regex.SubExp[0].StartP - 1;
              break;
           end;
           inc( LineStart, length(Art[i]) + 2 );
        end;
     end;

     Art.Free;
end;

function ExtractNameOfFrom( s: string ) : String;
var  j1, j2 : Byte;
begin
     ExtractNameOfFrom := s;

     j1 := Pos('<',s);
     j2 := Pos('>',s);

     if (j1>0) and (j2>0) and (j1<j2) then begin
        s := Trim( copy(s,1,j1-1)+copy(s,j2+1,255) );
     end else begin
        j1 := Pos('(',s);
        j2 := Pos(')',s);
        if (j1>0) and (j2>0) and (j1<j2) then begin
           s := Trim( copy(s,j1+1,j2-j1-1) );
        end;
     end;

     if (s<>'') and (s[1]='"')  then s:=copy(s,2,255);
     if copy(s,length(s),1)='"' then s:=copy(s,1,length(s)-1);

     if s<>'' then ExtractNameOfFrom:=s;
end;

function ShortGroupname( GrpNam: String ) : String;
var  s : String;
     i : Integer;
begin
     s := copy(GrpNam,1,1);
     for i:=2 to length(GrpNam)-1 do begin
        if copy(GrpNam,i,1)='.' then begin
           if copy(GrpNam,i+1,1)<>'.' then s:=s+'.'+copy(GrpNam,i+1,1);
        end;
     end;
     ShortGroupname := s;
end;

function ArtListTitle( PathIndex: Byte; GrpNam: String; ArtID: Integer ) : String;
var  sGroup, sSubject, sFrom, sDate : String;
     P : PChar;
     DT : TDateTime;
begin
     sGroup := #7 + GrpNam + ' [';
     if PathIndex>0 then sGroup := sGroup + IntToStr(PathIndex) + ':';
     sGroup := sGroup + IntToStr(ArtID) + ']';

     P := ArtText;

     sSubject := '';
     while (length(sSubject)<128) and (P^<>#9) and (P^<>#0) do begin
        sSubject := sSubject + P^;
        P := (P+1);
     end;
     if P^=#9 then P:=(P+1);

     sFrom := '';
     while (length(sFrom)<128) and (P^<>#9) and (P^<>#0) do begin
        sFrom := sFrom + P^;
        P := (P+1);
     end;
     sFrom := ExtractNameOfFrom( sFrom );

     DT := AgtArtDateTime(HArt,Opt.Misc.TimeZone*3600);
     sDate := FormatDateTime(ShortDateFormat+' '+ShortTimeFormat, DT);

     ArtListTitle := sGroup+#9+sSubject+#9+sFrom+#9+sDate;
end;

{----------------------------------------------------------------- Methoden ---}

procedure TForm1.ParseFindParts;
var  s, p, pmime, wo : String;
     j, h : Integer;
     cEnd: Char;
     re: Boolean;
begin
     FindParts := 0;
     s := Trim(cboFind.Text);

     while (s<>'') and (FindParts<FindPartMax) do begin
        h := FindHow_OneOf;
        if copy(s,1,1)='+' then begin
           h:=FindHow_YES;
           System.Delete(s,1,1);
        end else begin
           if copy(s,1,1)='-' then begin
              h:=FindHow_NO;
              System.Delete(s,1,1);
           end;
        end;

        wo := '';
        if copy(s,1,1)='@' then begin
           j := Pos(':',s);
           if j>0 then begin
              wo := copy(s,2,j-1);
              s  := copy(s,j+1,255);
              {ggf. Header-Suche einschalten}
              if not(chkHeader.Checked) then chkHeader.Checked:=True;
           end;
        end;

        cEnd := #32;
        re   := False;
        if copy(s,1,1)='"' then begin cEnd:='"'; System.Delete(s,1,1); end;
        if copy(s,1,1)='{' then begin cEnd:='}'; System.Delete(s,1,1); re:=True; end;

        p := '';
        while (s<>'') and (copy(s,1,1)<>cEnd) do begin
           p := p + s[1];
           System.Delete( s, 1, 1 );
        end;
        if s<>'' then System.Delete( s, 1, 1 );
        while copy(s,1,1)=' ' do System.Delete( s, 1, 1 );

        {if Debug then msgbox('at="'+wo+'" find="'+p+'" mode='+IntToStr(h));}

        if p<>'' then begin
           StrPCopy( FindPart[FindParts].Txt, p );
           if not re then StrUpper( FindPart[FindParts].Txt );
           FindPart[FindParts].Len := strlen( FindPart[FindParts].Txt );
           StrPCopy( FindPart[FindParts].Hdr, Wo );
           StrUpper( FindPart[FindParts].Hdr );
           FindPart[FindParts].How := h;
           FindPart[FindParts].IsRE := re;
           FindPart[FindParts].PseudoMime := 0;
           inc( FindParts );

           if PseudoMime then begin
              pmime := p;
              j := 1;
              while j<=length(pmime) do begin
                 if pmime[j]>=#128 then begin
                    pmime := copy(pmime,1,j-1)
                           + '=' + inttohex(ord(pmime[j]),2)
                           + copy(pmime,j+1,255);
                 end;
                 inc(j);
              end;

              if (pmime<>p) and (FindParts<FindPartMax) then begin
                 StrPCopy( FindPart[FindParts].Txt, pmime );
                 if not re then StrUpper( FindPart[FindParts].Txt );
                 FindPart[FindParts].Len := strlen( FindPart[FindParts].Txt );
                 StrPCopy( FindPart[FindParts].Hdr, Wo );
                 StrUpper( FindPart[FindParts].Hdr );
                 FindPart[FindParts].How := h;
                 FindPart[FindParts].IsRE := re;
                 FindPart[FindParts  ].PseudoMime := 2;
                 FindPart[FindParts-1].PseudoMime := 1;
                 inc( FindParts );
              end;
           end;
        end;

        s := Trim(s);
     end;

     {Shift-Tabelle f¸r Quicksearch erstellen}
     for j:=0 to FindParts-1 do begin
        { Mismatch-Default = Verschiebung um (Suchl‰nge+1) }
        for h:=0 to 255 do FindPart[j].Shift[chr(h)] := FindPart[j].Len+1;

        { Verschiebung f¸r Zeichen im Suchstring }
        for h:=0 to FindPart[j].Len-1 do begin
           FindPart[j].Shift[ LoCase(FindPart[j].Txt[h]) ] := FindPart[j].Len - h;
           FindPart[j].Shift[ UpCase(FindPart[j].Txt[h]) ] := FindPart[j].Len - h;
        end;
     end;
end;

procedure TForm1.MarkAllGroups( OnOff : Boolean );
var  i : Integer;
begin
     lstGroups.Items.BeginUpdate;
     for i:=lstGroups.Items.Count-1 downto 0 do begin
        lstGroups.Selected[i] := OnOff;
     end;
     lstGroups.Items.EndUpdate;
end;

procedure TForm1.FillGroups;
var  g : LongInt;
     s, t : String;
     ps: array[0..256] of Char;
     n : longint;
     f : integer;
     TG: TAgtGroupMem;
     OK: Boolean;
     PathIndex : Byte;
     GrpName : String;
begin
     Caption := Version;
     with tProgressForm.Create(self) do try
       Min := 1;
       ShowModal('GoldFind: Loading Groups...');
       Progress('',0);

       Screen.Cursor := crHourGlass;
       Application.ProcessMessages;

       lstGroups.Items.BeginUpdate;
       ClearArticles;
       for g:=0 to lstGroups.Items.Count-1 do begin
          TG := TAgtGroupMem( lstGroups.Items.Objects[g] );
          TG.Free;
       end;
       lstGroups.Clear;

       for PathIndex:=0 to AgtDataPathMax do begin

          if Opt.Database.Activated[PathIndex] and (Opt.Database.Names[PathIndex]<>'') then begin
             OpenMyGrp( Opt.Database.Names[PathIndex] );

             Max := AgtGrpCount(HGrp)-1;

             for g:=0 to AgtGrpCount(HGrp)-1 do begin
                AgtGrpLoad( HGrp, g );
                f := AgtGrpFlags( HGrp );

                OK := False;
                if AgtGrpHasArticles(HGrp) then begin
                   if (f and AGTGRPFLAG_HASARTFILE)<>0 then begin
                      OK := True;
                      if (f and AGTGRPFLAG_ISFOLDER)<>0 then begin
                         if Opt.Misc.find_Ignore_Mailfolders then OK:=False;
                      end;
                   end;
                end;

                if OK then begin
                   // OpenMyArt( DataPathName[PathIndex], AgtGrpID(HGrp) );
                   // n := AgtArtCount( HArt );
                   // CloseMyArt;

                   n := LoadArticleCount( PathIndex, AgtGrpID(HGrp), True );
                   if (n<>0) or ((f and (AGTGRPFLAG_SUBSCRIBE or AGTGRPFLAG_ISFOLDER))<>0) then begin
                      AgtGrpName( HGrp, ps, 256 );
                      GrpName := string(ps);
                      if not Progress(GrpName,g) then begin
                        Application.Terminate;
                        exit;
                      end;

                      s := GrpName;
                      s := s + #9 + IntToStr(n+1);
  //                    s := s + #9 + IntToHex(AgtGrpID(HGrp),8);

                      if (f and AGTGRPFLAG_ISFOLDER)<>0 then t:='Folder'
                      else if (f and AGTGRPFLAG_SUBSCRIBE)<>AGTGRPFLAG_SUBSCRIBE then t:='Unsub.'
                                                                                 else t:='Group';
                      s := s + #9 + t;
                      s := s + #9 + IntToStr(PathIndex);

                      TG := TAgtGroupMem.Create;
                      TG.GrpID  := AgtGrpID(HGrp);
                      TG.GrpNam := GrpName;
                      TG.GrpType:= t;
                      TG.ArtCnt := n;
                      TG.PathIdx := PathIndex;
                      lstGroups.Items.AddObject( s, TG );
                   end;
                end;
             end;

             CloseMyGrp;

          end;
       end;

       lstGroups.Items.EndUpdate;
       Hide;
     finally
       free;
     end;
     Screen.Cursor := crDefault;
end;

procedure TForm1.ClearArticles;
var  l : LongInt;
     TA: TAgtArticle;
begin
     lstArticles.Items.BeginUpdate;
     for l:=0 to lstArticles.Items.Count-1 do begin
        TA := TAgtArticle( lstArticles.Items.Objects[l] );
        TA.Free;
     end;

     lstArticles.Clear;
     lstArticles.Items.EndUpdate;

     ShowArticle( 0, -1, -1 );
end;

procedure TForm1.FindPositions;
var  B, P  : PChar;
     S, FP : Integer;
begin
     FindPosCount := 0;
     ShowPosition := -1;
     if FindParts<=0 then exit;

     S := txtArticle.GetTextLen + 1;
     if S<=1 then exit;

     GetMem( B, S );
     txtArticle.GetTextBuf( B, S );

     for FP:=0 to FindParts-1 do begin
        if FindPart[FP].How<>FindHow_NO then begin
           P := B;
           repeat
              if FindPart[FP].IsRE then begin

                 try
                    FindPart[FP].ReFoundLen := 1;
                    if FindPart[fp].Hdr[0]=#0 then
                       P := StrIFindPosRE( P, fp, False )
                    else
                       P := StrIFindPosRE( P, fp, True );
                 except
                    on E:Exception do begin
                       MessageDlg( 'Regex-error:' + #13#10 + E.Message, mtError, [mbOK], 0);
                       Stop := True;
                       exit;
                    end;
                 end;

                 if P<>nil then begin
                    FindPosAdd( P - B, FindPart[FP].ReFoundLen );
                    P := ( P + FindPart[FP].ReFoundLen );
                 end;

              end else begin

                 if FindPart[FP].Hdr[0]=#0 then
                    P := StrIFindQ( P, FP )
                 else
                    P := StrIFindHdr( P, FindPart[FP].Txt, FindPart[FP].Hdr );

                 if P<>nil then begin
                    FindPosAdd( P - B, StrLen(FindPart[FP].Txt) );
                    P := (P+1);
                 end;

              end;
           until P=nil;
        end;
     end;

     FreeMem( B, S );
end;

procedure TForm1.ShowPositions( Direction: Integer );
begin
   if FindPosCount=0 then exit;

   ShowPosition := ShowPosition + Direction;
   if ShowPosition<0 then ShowPosition:=FindPosCount-1;
   if ShowPosition>=FindPosCount then ShowPosition:=0;

   txtArticle.SelStart  := FindPos[ShowPosition];
   txtArticle.SelLength := FindLen[ShowPosition];
end;

procedure TForm1.ShowArticle( PathIndex: Byte; GrpID, ArtNo: LongInt );
var
  s      : string;
  Header : Boolean;
  Sig    : Boolean;

  function move(var Text : String; start,finish : integer):String;
  begin
    Result := copy(Text,start,finish);
    Text   := copy(Text,finish+1,length(Text));
  end;

  procedure ParseFKU( s : string; var RE : tRichEdit);
  var
    s2, zus : string;
    i : integer;
  begin
    zus := '';
    RE.SelAttributes.Style := [];
    s := copy(s,1,length(s)-2) + ' ';
    i := Pos(' ', s);
    while (i>0) and not sig do begin
      if not (i=1) then begin
        s2 := move(s,1,i);
        s2 := copy(s2,1,length(s2)-1);
      end else begin
        s2 := '';
        s := copy(s,2,length(s));
      end;

      while (length(s2)>0) and (s2[length(s2)] in ['!', '.', '?', '1', 'ﬂ', ',', ';', ':']) do begin
        zus := s2[length(s2)] + zus;
        system.delete(s2,length(s2),1);
      end;

      if length(s)>0 then
        zus := zus + ' ';

      if (length(s2)>3) then begin
        if (s2[1]='*') and (s2[length(s2)]='*') then
          RE.SelAttributes.Style := [fsBold];
        if (s2[1]='/') and (s2[length(s2)]='/') then
          RE.SelAttributes.Style := [fsItalic];
        if (s2[1]='\') and (s2[length(s2)]='\') then
          RE.SelAttributes.Style := [fsItalic];
        if (s2[1]='_') and (s2[length(s2)]='_') then
          RE.SelAttributes.Style := [fsUnderline];
        if (s2[1]='-') and (s2[length(s2)]='-') then
          RE.SelAttributes.Style := [fsStrikeOut];
      end;

      RE.SelText := s2;
      RE.SelAttributes.Style := [];
      RE.SelText := zus;
      zus := '';

      i := Pos(' ', s);
    end;
    RE.SelText := s + #13#10;
  end;


var
  s2 : string;
  i  : integer;

begin
     FindPosCount := 0;
     ShowPosition := -1;

     if (GrpID<0) or (ArtNo<0) then begin
        txtArticle.SetTextBuf( nil );
     end else begin
        OpenMyArt( Opt.Database.Names[PathIndex], GrpID );
        AgtArtLoad( HArt, ArtNo );
        ArtTextSize := AgtArtTextLen(HArt);
        ArtText     := AgtArtTextPtr(HArt);

        txtArticle.SetTextBuf( nil );
        FormArtText( Opt.Visual.ShowHeader, Opt.Visual.ShowBody, Opt.Visual.ShowSig );

        with txtArticle.DefAttributes do begin
          Name  := Opt.Visual.ResultFont.Name;
          Size  := Opt.Visual.ResultFont.Size;
          Style := Opt.Visual.ResultFont.Style;
        end;

        s := String(ArtText);
{
        with tArticle.create do try
          InputArticle := s;
          copy(HeaderContent['From'],3,MaxInt);
        finally
          free;
        end;
}
        CloseMyArt;

        txtArticle.Lines.BeginUpdate;
        try

          Sig := false;
          Header := opt.Visual.ShowHeader; //Header vorhanden um sie anzuzeigen?

          if Header then
            s := copy(s,pos(#13#10,s)+2,length(s));

  //        if not Header then
  //          s := copy(s,pos(#13#10#13#10,s)+4,length(s));

          while pos(#13#10, s)<>0 do begin
            if Header then
              if pos(#13#10, s)=1 then begin
                Header := false;
                //DecodeBody
              end;

            s2 := move(s,1,pos(#13#10,s)+1);

            if not Header then begin
              if (pos('-- ',s2)=1) and (pos(#13#10+'-- '+#13#10,s)=0) then
                Sig := true;

              if Sig then
                txtArticle.SelAttributes.Color := clGreen
              else if (length(s2)>0) and (s2[1] in ['>', '|', ':']) then
                txtArticle.SelAttributes.Color := clBlue //ToDo: Konfig
              else
                txtArticle.SelAttributes.Color := Opt.Visual.ResultFont.Color;

              ParseFKU(s2, txtArticle);
  //            txtArticle.SetSelTextBuf(Pchar(s2));
            end else begin
              s2 := DecodeHeadervalue( s2[1], length(s2) );
              with txtArticle do begin
                if pos(':', s2)<>0 then begin
                  SelAttributes.Color := clRed; //ToDo: Konfig
                  SetSelTextBuf( PChar(move(s2,1,pos(':',s2)) ));
                  SelAttributes.Color := Opt.Visual.ResultFont.Color;
                end else if (length(s2)>0) and (s2[1] in [#32, #9]) then
                  SelAttributes.Color := clgray;
                SetSelTextBuf( PChar(s2));
              end;
            end;
          end;

          if not sig and not header then
            ParseFKU(move(s,1,length(s)),txtArticle)
          else
            txtArticle.SetSelTextBuf( Pchar(move(s,1,length(s))) );

          FindPositions;


          //Mark *all* founded positions red and italic
          if FindPosCount=0 then begin
            txtArticle.Lines.EndUpdate;
            exit;
          end;
          for i := 0 to FindPosCount-1 do begin
            txtArticle.SelStart  := FindPos[i];
            txtArticle.SelLength := FindLen[i];
            txtArticle.SelAttributes.Color := clRed;
            txtArticle.SelAttributes.Style := [fsItalic, fsBold];
          end;

        finally
          txtArticle.Lines.EndUpdate;
        end;
     end;
end;

function TForm1.FoundParts : Boolean;
var  fp : Integer;
     OK : Boolean;
     NeedOneOf, HasOneOf, SkipNext: Boolean;
begin
     FoundParts := True;
     if FindParts=0 then exit; {keine Auswahl -> "alles finden"}

     NeedOneOf := False;
     HasOneOf  := False;
     OK        := False;
     SkipNext  := False;

     for fp:=0 to FindParts-1 do begin

        if SkipNext then begin

           SkipNext := False;

        end else begin

           if FindPart[fp].IsRE then begin
              try
                 if FindPart[fp].Hdr[0]=#0 then
                    OK := StrIFindRE( ArtText, fp, False )
                 else
                    OK := StrIFindRE( ArtText, fp, True );
              except
                 on E:Exception do begin
                    MessageDlg( 'Regex-error:' + #13#10 + E.Message, mtError, [mbOK], 0);
                    Result := False;
                    Stop := True;
                    exit;
                 end;
              end;
           end else begin
              if FindPart[fp].Hdr[0]=#0 then
                 OK := ( StrIFindQ( ArtText, fp ) <> nil )
              else
                 OK := ( StrIFindHdr( ArtText,FindPart[fp].Txt,FindPart[fp].Hdr ) <> nil );
           end;

           case FindPart[fp].How of
              FindHow_YES: {muﬂ enthalten sein}
                 if not OK then begin
                    if FindPart[fp].PseudoMime<>1 then begin // ignore 1st, 2nd decides
                       FoundParts:=False;
                       exit;
                    end;
                 end else begin
                    // +pseudomime => one of it
                    if FindPart[fp].PseudoMime=1 then SkipNext:=True;
                 end;
              FindHow_NO: {darf nicht enthalten sein}
                 if OK then begin
                    FoundParts:=False;
                    exit;
                 end;
              FindHow_OneOf: {eines davon muﬂ enthalten sein}
                 begin
                    NeedOneOf := True;
                    if OK then HasOneOf:=True;
                 end;
           end;

        end;
     end;

     if NeedOneOf and not(HasOneOf) then FoundParts:=False;
end;

procedure TForm1.FormArtText( FHdr, FBody, FSig: Boolean );
{Ver‰ndert Art_Text und seinen Inalt so, daﬂ nur noch die ausgew‰hlten Teile
enthalten sind.}
var  BAB, SAB: PChar;
begin
     {Soll etwas entfernt werden?}
     if FHdr and FBody and FSig then exit; {Nein}

     {BAB auf Bodystart}
     BAB := StrIQuickSearch( ArtText, #13#10#13#10 );
     if BAB<>nil then BAB:=(BAB+4);

     {Wenn kein Body vorhanden ist, dann ist allenfalls Header relevant}
     if BAB=nil then begin
        if not FHdr then ArtText^:=#0; {auch Header nicht relevant}
        exit;
     end;

     {ggf. Header entfernen}
     if not FHdr then begin {Header entfernen}
        ArtText := BAB; {auf Bodybeginn positionieren}
     end;

     {SAB auf Sigstart}
     SAB := StrIQuickSearch( BAB, #13#10'-- '#13#10 ); {Sigstart}
     if SAB<>nil then SAB:=(SAB+2);

     {ggf. Sig entfernen}
     if not FSig then begin {Sig. entfernen}
        if SAB<>nil then begin SAB^:=#0; SAB:=nil; end; {Textende auf Sigstart}
     end;

     {ggf. Body entfernen}
     if not FBody then begin
        {wenn keine Sig (mehr), dann Textende auf Bodystart}
        if SAB=nil then begin BAB^:=#0; exit; end;

        {Sig. nach BAB verschieben}
        StrMove( BAB, SAB, StrLen(SAB) );
        (BAB+StrLen(SAB))^ := #0;
     end;
end;

function TForm1.FindBegin : Boolean;
var  TG: TAgtGroupMem;
     i : Integer;
begin
     FindBegin := False;

     if lstGroups.SelCount=0 then begin
        Application.MessageBox('No groups selected!',PChar(Version),MB_ICONEXCLAMATION);
        exit;
     end;

     AllCount := 0;
     for i:=0 to lstGroups.Items.Count-1 do begin
        if not Stop then begin
           if lstGroups.Selected[i] then begin
              TG := TAgtGroupMem( lstGroups.Items.Objects[i] );
              if TG.ArtCnt<0 then TG.ArtCnt := LoadArticleCount( TG.PathIdx, TG.GrpID, True );
              AllCount := AllCount + TG.ArtCnt;
           end;
        end;
     end;

     if not StatIsActive then begin
        ClearArticles;
        ParseFindParts;
     end;

     FindCount := 0;
     BalkenCount := 0;
     BalkenG.MinValue := 0;
     BalkenG.MaxValue := AllCount;
     ProgressRateB := AllCount div 200;
     if ProgressRateB<1 then ProgressRateB:=1;
     BalkenG.Progress := 0;
     lblStatGrp.Caption := '';
     lblCount.Caption := '';

//     if not StatIsActive then TabbedNotebook1.PageIndex := 1;
     pnlStop.Visible := True;
     btnStop.SetFocus;
     TabbedNotebook1.Enabled := False;
     Stop := False;

     Cursor := crHourGlass;
     Application.ProcessMessages;
     Zeit := GetTickCount;

     FindBegin := True;
end;

procedure TForm1.FindStatus( TG: TAgtGroupMem; LfdArt: LongInt );
begin
     lblStatGrp.Caption := TG.GrpNam+' ('+IntToStr(LfdArt)+'/'+IntToStr(AgtArtCount(HArt))+')';
     if AllCount>0 then begin
        if BalkenCount>AllCount then AllCount:=BalkenCount; // ggf. wg. neuem Download
        Caption := 'F: '+IntToStr(FindCount)+' ('+IntToStr(BalkenCount*100 div AllCount)+'%)';
        Application.Title := Caption;
     end;
     Application.ProcessMessages;
end;

procedure TForm1.FindEnd;
begin
     Zeit := LongInt(GetTickCount) - Zeit;
     if Debug then Application.MessageBox( PChar(IntToStr(Zeit)+' ms'), '', 0 );

     Caption := 'Found: '+IntToStr(FindCount);
     Application.Title := Caption;

     pnlStop.Visible := False;
     TabbedNotebook1.Enabled := True;
     Stop := False;
     Cursor := crDefault;
end;

(*
function StatDayOK( UnixTime: LongInt ): Boolean;
var  DT  : TDateTime;
     Days: LongInt;
begin
     Days := UnixTime div 86400;
     DT   := GroundDate + Days;

     if StatDayDates then begin
        if (DT>=StatDayFrom) and (DT<=StatDayTil) then Result:=True
                                                  else Result:=False;
     end else begin
        DT   := int(Now) - DT;
        Days := trunc(DT);
        if (Days>=0) and (Days<=StatDays) then Result:=True
                                          else Result:=False;
     end;
end;

*)

function DayOK( UnixTime: LongInt ): Boolean;
var  DT  : TDateTime;
     Days: LongInt;
begin
     Days := UnixTime div 86400;
     DT   := GroundDate + Days;

     if DayDates then begin
        if (DT>=DayFrom) and (DT<=DayTil) then Result:=True
                                          else Result:=False;
     end else begin
        DT   := int(Now) - DT;
        Days := trunc(DT);
        if (Days>=0) and (Days<=forDays) then Result:=True
                                         else Result:=False;
     end;
end;

procedure TForm1.FindArticles( TG: TAgtGroupMem );
var  l      : LongInt;
     s      : String;
     TA     : TAgtArticle;
begin
       OpenMyArt( Opt.Database.Names[TG.PathIdx], TG.GrpID );
       if AgtArtCount(HArt)=0 then begin CloseMyArt; exit; end;

       TG.ArtCnt := AgtArtCount(HArt); // ggf. wg. neuem Download
       //ToDo: ggf. lˆschen
       lblStatGrp.Caption := TG.GrpNam;

       for l:=0 to AgtArtCount(HArt)-1 do begin
          if (BalkenCount mod Opt.Misc.Find_Progressrate )=0 then FindStatus(TG,l);
          if (BalkenCount mod ProgressRateB)=0 then BalkenG.Progress := BalkenCount;
          inc( BalkenCount );

          AgtArtLoadBody( HArt, l );

          if DayOk(AgtArtUnixTime(HArt,0)) then begin
             ArtTextSize := AgtArtTextLen(HArt);
             ArtText     := AgtArtTextPtr(HArt);

             FormArtText( chkHeader.Checked, chkBody.Checked, chkSig.Checked );

             if FoundParts then begin

                {ggf. Artikel neu laden, wenn Header entfernt worden ist}
                //ToDo: ????
                if not chkHeader.Checked then begin
                   AgtArtLoad( HArt, l );
                   ArtTextSize := AgtArtTextLen(HArt);
                   ArtText     := AgtArtTextPtr(HArt);
                end;

                s := ArtListTitle( TG.PathIdx, TG.GrpNam, l );
                TA := TAgtArticle.Create;
                TA.GrpID    := TG.GrpID;
                TA.ArtNo    := l;
                TA.PathIdx  := TG.PathIdx;
                lstArticles.items.AddObject( s, TA );

                inc(FindCount);
                if FindCount>=Opt.Misc.Find_MaxArticles then Stop:=True;
                lblCount.Caption := 'Found: '+IntToStr(FindCount);
                lblCount.Refresh;
             end;

          end;

          if Stop then begin
             CloseMyArt;
             exit;
          end;
       end;

       BalkenG.Progress := BalkenCount;
       FindStatus( TG, AgtArtCount(HArt) );

       CloseMyArt;
     Application.ProcessMessages;
end;

{----------------------------------------------------------- Control-Events ---}

procedure TForm1.LoadSections( IniKey: String; hdr: THeader );
var  i : Integer;
     s : String;
begin
     for i:=0 to hdr.Sections.Count-1 do begin
        s := AgtIni.ReadString( 'Display', IniKey + IntToStr(i), '' );
        if s<>'' then hdr.SectionWidth[i]:=StrToInt(s);
     end;
end;

procedure TForm1.SaveSections( IniKey: String; hdr: THeader );
var  i : Integer;
begin
     for i:=0 to hdr.Sections.Count-1 do begin
        AgtIni.WriteInteger( 'Display', IniKey + IntToStr(i), hdr.SectionWidth[i] );
     end;
end;

procedure TForm1.DrawSections( hdr, lst: TWinControl; Index: Integer; Rect: TRect; Line: String );
var  s, p : String;
     i, j, l : Integer;
     R : TRect;
begin
     with (lst as TListBox).Canvas do begin
        FillRect(Rect);

        if Line='' then s := (lst as TListBox).Items[Index]
                   else s := Line;
        l := Rect.Left;
        R := Rect;

        for i:=0 to (hdr as THeader).Sections.Count-1 do begin
           j := Pos(#9,s);
           if j=0 then begin
              p := s;  s := '';
           end else begin
              p := copy(s,1,j-1); s := copy(s,j+1,255);
           end;

           if copy(p,1,1)=#7 then begin {^Gruppenname}
              p := copy(p,2,255);
              if ShortGrpNam then p:=ShortGroupname(p);
           end;

           Pen.Color:=clGray; MoveTo(l-1,Rect.Top); LineTo(l-1,Rect.Bottom);
           R.Left := l + 1;
           R.Right := l + (hdr as THeader).SectionWidth[i] - 2;
           TextRect( R, l+1, Rect.Top, p );
           l := l + (hdr as THeader).SectionWidth[i];
        end;
     end;
end;

procedure TForm1.lstGroupsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var  TG: TAgtGroupMem;
     s : String;
begin
     // Anzeigestring wg. ggf. ge‰nderter Art.-Anzahl neu aufbauen
     TG := TAgtGroupMem( (Control as TListBox).Items.Objects[Index] );
     s := TG.GrpNam;
     if TG.ArtCnt>=0 then s := s + #9 + IntToStr(TG.ArtCnt)
                     else s := s + #9 + '?';
//     s := s + #9 + IntToHex(TG.GrpID,8);
     s := s + #9 + TG.GrpType;
     s := s + #9 + IntToStr(TG.PathIdx) + ' [' + Opt.Database.Names[TG.PathIdx] + ']';

     DrawSections( hdrGrp, Control, Index, Rect, s );
end;

procedure TForm1.lstArticlesDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
     DrawSections( hdrArt, Control, Index, Rect, '' );
end;

procedure TForm1.hdrArtSized(Sender: TObject; ASection, AWidth: Integer);
begin
     lstArticles.Refresh;
     if Startup then exit;
     SaveSections( 'HdrArt', hdrArt );
end;

procedure TForm1.RelocateCountButton;
begin
     btnCountArticles.Top    := hdrGrp.Top    + 3;
     btnCountArticles.Height := hdrGrp.Height - 6;
     btnCountArticles.Left := hdrGrp.Left
                            + hdrGrp.SectionWidth[0]
                            + hdrGrp.SectionWidth[1]
                            - btnCountArticles.Width - 1;
end;

procedure TForm1.hdrGrpSized(Sender: TObject; ASection, AWidth: Integer);
begin
     lstGroups.Refresh;
     RelocateCountButton;
     if Startup then exit;
     SaveSections( 'HdrGrp', hdrGrp );
end;

{procedure TForm1.txtPath1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var  PathIndex : Byte;
     s: String;
begin
     PathIndex := 0;
     if Sender=txtPath1 then PathIndex:=1;
     if Sender=txtPath2 then PathIndex:=2;
     if Sender=txtPath3 then PathIndex:=3;
     if Sender=txtPath4 then PathIndex:=4;
     if Sender=txtPath5 then PathIndex:=5;
     if Sender=txtPath6 then PathIndex:=6;
     if Sender=txtPath7 then PathIndex:=7;

     if (Key=VK_DELETE) or (Key=VK_BACK) then begin

        TEdit(Sender).Text := '';
        if DataPathName[PathIndex] = '' then exit;

        DataPathName[PathIndex] := '';
        if PathIndex=0 then AgtIni.WriteString( iniOptions, 'AgtPath', '' )
                       else AgtIni.WriteString( iniOptions, 'AgtPath'+IntToStr(PathIndex), '' );
        FillGroups;
     end else begin
        if Shift=[ssCtrl] then begin
           try
              if Key=VK_A then (Sender as TEdit).SelectAll
              else if Key=VK_C then (Sender as TEdit).CopyToClipboard
              else if Key=VK_X then (Sender as TEdit).CutToClipboard
              else if Key=VK_V then begin
                 s := Clipboard.AsText;
                 s := IncludeTrailingBackslash( s );
                 if s<>'' then (Sender as TEdit).Text := s;
                 SelectNewPath( PathIndex, s + 'groups.dat' );
              end;
           except
              // on e:exception do caption:=e.message;
           end;
        end;
     end;
end;
}

procedure TForm1.btnStopClick(Sender: TObject);
begin
     Stop := True;
     MessageBeep(0);
end;

procedure TForm1.ShowStatSelection;
begin
     if DayDates then begin
        optStatRange.Checked := True;
     end else begin
        optStatDays.Checked := True;
     end;

     txtStatDays.Text    := inttostr( ForDays );
     txtStatDays.Enabled := not DayDates;

     if DayFrom=0 then DayFrom:=int(Now);
     txtStatFrom.Text    := DateToStr( DayFrom );
     txtStatFrom.Enabled := DayDates;

     if DayTil=0 then DayTil:=int(Now);
     txtStatTil.Text     := DateToStr( DayTil );
     txtStatTil.Enabled  := DayDates;
end;

procedure TForm1.txtStatDaysExit(Sender: TObject);
var  s : String;
     DT: TDateTime;
begin
     s := (Sender as TEdit).Text;

     if Sender=txtStatDays then begin
        if s='' then s:='21';
        try ForDays:=StrToInt(s) except ForDays:=21 end;
        if ForDays<1 then ForDays:=1;
        if ForDays>9999 then ForDays:=9999;
        AgtIni.WriteInteger( iniOptions, 'ForDays', ForDays );
     end;

     if (Sender=txtStatFrom) or (Sender=txtStatTil) then begin
        if s='' then s:=DateToStr(Now);

        StringReplace(s,'.', DateSeparator, [rfReplaceAll]);
        StringReplace(s,',', DateSeparator, [rfReplaceAll]);
        StringReplace(s,'/', DateSeparator, [rfReplaceAll]);
        StringReplace(s,'\', DateSeparator, [rfReplaceAll]);
        StringReplace(s,'-', DateSeparator, [rfReplaceAll]);

        try DT:=StrToDate(s) except DT:=0 end;
        if Sender=txtStatFrom then begin
           DayFrom := DT;
           AgtIni.WriteInteger( iniOptions, 'DayFrom', trunc(DayFrom) );
        end else begin
           DayTil := DT;
           AgtIni.WriteInteger( iniOptions, 'DayTil', trunc(DayTil) );
        end;
     end;

     ShowStatSelection;
end;

procedure TForm1.optStatDaysClick(Sender: TObject);
begin
     DayDates := not optStatDays.Checked;
     AgtIni.WriteBool( iniOptions, 'DayDates', DayDates );
     ShowStatSelection;
end;

procedure TForm1.mnuExportAllClick(Sender: TObject);
var  TA: TAgtArticle;
     Curr, OverwriteResult: Integer;
     ExpFile: String;
     FileStrm: TFileStream;
begin
   if lstArticles.Items.Count = 0 then exit;

   ExpFile := '';
   with TSaveDialog.Create( Self ) do begin
      Title := 'Export found messages ...';
      DefaultExt := 'txt';
      Filter := 'Text Files (*.txt)|*.txt|All Files (*.*)|*.*';
      Options := [ ofHideReadOnly, ofNoReadOnlyReturn, ofPathMustExist];
      FileName := LastExport;
      if Execute then ExpFile := Filename;
      Free;
   end;
   if ExpFile='' then exit;

   OverwriteResult := mrNo;
   if FileExists( ExpFile ) then begin
      OverwriteResult := MessageDlg(
         'File ' + ExpFile + ' already exists!'#13#10#13#10
         + 'Answering "Yes" will append found messages to existing file, '
         + '"No" will overwrite the existing file.'#13#10#13#10
         + 'Append to existing file?',
         mtConfirmation, [mbYes, mbNo, mbCancel], 0 );
      if OverwriteResult=mrCancel then exit;
   end;

   Screen.Cursor := crHourGlass;
   Application.ProcessMessages;

   if OverwriteResult=mrNo then begin
      FileStrm := TFileStream.Create( ExpFile, fmCreate )
   end else begin
      FileStrm := TFileStream.Create( ExpFile, fmOpenWrite );
      FileStrm.Seek( 0, soFromEnd );
   end;

   try
      for Curr:=0 to lstArticles.Items.Count-1 do begin
         TA := TAgtArticle( lstArticles.Items.Objects[ Curr ] );

         OpenMyArt( Opt.Database.Names[TA.PathIdx], TA.GrpID );
         AgtArtLoadBody( HArt, TA.ArtNo );
         AgtArtConvertToExportFormat( HArt );
         ArtTextSize := AgtArtTextLen(HArt);
         ArtText     := AgtArtTextPtr(HArt);
         if ArtTextSize > 0 then FileStrm.Write( ArtText^, ArtTextSize );

         CloseMyArt;
      end;

      LastExport := ExpFile;

   finally
      FileStrm.Free;
   end;

   Screen.Cursor := crDefault;
end;

procedure TForm1.PopupMenuTextPopup(Sender: TObject);
begin
   mnuExportAll.Enabled :=  ( lstArticles.Items.Count > 0 )
                        and ( TabbedNotebook1.PageIndex = 0 );
   mnuLaunchAgent.Enabled := mnuExportAll.Enabled;
end;

procedure TForm1.lstArticlesClick(Sender: TObject);
var  TA: TAgtArticle;
begin
     if (lstArticles.ItemIndex>=0) and (lstArticles.ItemIndex<lstArticles.Items.Count) then begin
        TA := TAgtArticle( lstArticles.Items.Objects[lstArticles.ItemIndex] );
        Cursor := crHourGlass;
        ShowArticle( TA.PathIdx, TA.GrpID, TA.ArtNo );
        Cursor := crDefault;
     end else begin
        ShowArticle( 0, -1, -1 );
     end;
end;

procedure TForm1.lstArticlesDblClick(Sender: TObject);
var  TA: TAgtArticle;
begin
     if lstArticles.Items.Count<=0 then exit;
     TA := TAgtArticle( lstArticles.Items.Objects[lstArticles.ItemIndex] );
     AgentLaunchByDDE( TA );
end;

procedure TForm1.btnFindClick(Sender: TObject);
var  TG : TAgtGroupMem;
     i  : Integer;
     s  : String;
begin
     if not(chkHeader.Checked or chkBody.Checked or chkSig.Checked) then begin
        Application.MessageBox('No "Find In:" selected!',PChar(Version),MB_ICONEXCLAMATION);
        exit;
     end;

     if not FindBegin then exit;

     for i:=0 to lstGroups.Items.Count-1 do begin
        if not Stop then begin
           if lstGroups.Selected[i] then begin
              lblCount.Caption := 'Found: '+IntToStr(FindCount);
              lblCount.Refresh;

              TG := TAgtGroupMem( lstGroups.Items.Objects[i] );
              FindArticles( TG );
           end;
        end;
     end;

     FindEnd;

     s := 'Found: '+IntToStr(FindCount);
     if Stop then s:=s+'!';
     lblCount.Caption := s;

//     lstArticles.SetFocus;
     if lstArticles.Items.Count>0 then begin
        lstArticles.ItemIndex:=0;
        lstArticlesClick(Self);
     end;

     {cboFind-Eintr‰ge aktualisieren}
     s := cboFind.Text;
     if s<>'' then begin
        i := cboFind.Items.IndexOf(s);
        if i>=0 then cboFind.Items.Delete(i);
        cboFind.Items.Insert(0,s);
        cboFind.Text := s;
     end;
end;

procedure TForm1.mnuTxtSelectAllClick(Sender: TObject);
begin
     if TabbedNotebook1.PageIndex=0 then txtArticle.SelectAll;
     if TabbedNotebook1.PageIndex=1 then rtfStat.SelectAll;
end;

procedure TForm1.mnuTxtCopyClick(Sender: TObject);
begin
     if TabbedNotebook1.PageIndex=0 then txtArticle.CopyToClipboard;
     if TabbedNotebook1.PageIndex=1 then rtfStat.CopyToClipboard;
end;

procedure TForm1.VSplitterMoved(Sender: TObject);
begin
     AgtIni.WriteInteger( 'Display', 'SplitHeight', lstArticles.Height );
end;

procedure TForm1.txtArticleKeyPress(Sender: TObject; var Key: Char);
begin
     Key := #0;
end;

{-------------------------------------------------------------- Form-Events ---}

procedure TForm1.FormCreate(Sender: TObject);
var  s : String;
     i : Integer;
begin
     Startup := True;
     StatIsActive := False;

     Version := 'GoldFind ' + GetMyVersionInfo;
     Caption := Version;

     FindParts := -1;
     FindPosCount := 0;
     ShowPosition := -1;
     LastExport := 'GoldFind.txt';

     s := AgtIni.ReadString( iniOptions, 'Debug', '' );
     if s='0'+IntToStr(815) then Debug:=True else Debug:=False;

     TabbedNotebook1.PageIndex := 0;

     Opt.Misc.find_Ignore_Mailfolders := AgtIni.ReadBool( iniOptions, 'IgnoreFolders', true );

     s := AgtIni.ReadString( iniOptions, 'REIgnoreCase', '' );
     if s<>'0' then begin
        Opt.Misc.Find_RegexCase := PCRE_CASELESS;
     end else begin
        Opt.Misc.Find_RegexCase := 0;
     end;

     for i:=0 to AgtDataPathMax do begin
        s := 'AgtPath';
        if i>0 then s:=s+IntToStr(i);
        Opt.Database.Names[i] := AgtIni.ReadString( iniOptions, s, '' );
        Opt.Database.Activated[i] := AgtIni.ReadBool  ( iniOptions, 'AgtPathEnabled'+inttostr(i), True );
     end;

     Opt.Visual.shortGroups     := AgtIni.ReadBool( iniOptions, 'ShortGrpNam', false );
     Opt.Misc.Find_MaxArticles  := AgtIni.ReadInteger( iniOptions, 'StopAfter', 500 );
     Opt.Misc.Find_Progressrate := AgtIni.ReadInteger( iniOptions, 'ProgressRate', 25 );
     Opt.Misc.TimeZone          := AgtIni.ReadInteger( iniOptions, 'GMTDelta', 0 );

     s := AgtIni.ReadString(iniOptions,'FontName' ,''); if s<>'' then Opt.Visual.ResultFont.Name := s;
     s := AgtIni.ReadString(iniOptions,'FontSize' ,''); if s<>'' then Opt.Visual.ResultFont.Size := StrToInt(s);
     s := AgtIni.ReadString(iniOptions,'FontColor',''); if s<>'' then Opt.Visual.ResultFont.Color:= StrToInt(s);

     s := AgtIni.ReadString(iniOptions,'FontStyle','');
     Opt.Visual.ResultFont.Style := [];
     if s<>'' then begin
        if Pos('B',s)>0 then Opt.Visual.ResultFont.Style:=Opt.Visual.ResultFont.Style+[fsBold];
        if Pos('I',s)>0 then Opt.Visual.ResultFont.Style:=Opt.Visual.ResultFont.Style+[fsItalic];
        if Pos('U',s)>0 then Opt.Visual.ResultFont.Style:=Opt.Visual.ResultFont.Style+[fsUnderline];
        if Pos('S',s)>0 then Opt.Visual.ResultFont.Style:=Opt.Visual.ResultFont.Style+[fsStrikeOut];
     end;

     cboStatType.Clear;
     cboStatType.Items.AddObject( 'Messages per month',                                   Pointer(StatMPM) );
     cboStatType.Items.AddObject( 'Messages per day',                                     Pointer(StatMPD) );
     cboStatType.Items.AddObject( 'Messages per weekday',                                 Pointer(StatMPWD) );
     cboStatType.Items.AddObject( 'Messages per hour',                                    Pointer(StatMPH) );
     cboStatType.Items.AddObject( '-',                                                    Pointer(0) );
     cboStatType.Items.AddObject( 'Header: From',                                         Pointer(StatHFR) );
     cboStatType.Items.AddObject( 'Header: From (grouped, name)',                         Pointer(StatHFgn) );
     cboStatType.Items.AddObject( 'Header: From (grouped, domain)',                       Pointer(StatHFgd) );
     cboStatType.Items.AddObject( '-',                                                    Pointer(0) );
     cboStatType.Items.AddObject( 'Header: Subject (Re:/was: skipped)',                   Pointer(StatHSU) );
     cboStatType.Items.AddObject( '-',                                                    Pointer(0) );
     cboStatType.Items.AddObject( 'Message-ID (grouped)',                                 Pointer(StatHMg) );
     cboStatType.Items.AddObject( '-',                                                    Pointer(0) );
     cboStatType.Items.AddObject( 'Header: Newsreader',                                   Pointer(StatHXN) );
     cboStatType.Items.AddObject( 'Header: Newsreader (grouped, per msg.)',               Pointer(StatHXNga) );
     cboStatType.Items.AddObject( 'Header: Newsreader (grouped, per user)',               Pointer(StatHXNgu) );
     cboStatType.Items.AddObject( '-',                                                    Pointer(0) );
     cboStatType.Items.AddObject( 'Header: (others)',                                     Pointer(StatH) );
     cboStatType.Items.AddObject( 'Header: (regex)',                                      Pointer(StatHRE) );
     cboStatType.Items.AddObject( '-',                                                    Pointer(0) );
     cboStatType.Items.AddObject( 'Path: Relayers (Top 100)',                             Pointer(StatPR) );
     cboStatType.Items.AddObject( 'Path: My Feeds',                                       Pointer(StatMF) );
     cboStatType.Items.AddObject( 'Path: Feeds of ...',                                   Pointer(StatFO) );
     cboStatType.Items.AddObject( '-',                                                    Pointer(0) );
     cboStatType.Items.AddObject( 'Fun: DAU Jones ;-)',                                   Pointer(StatDAU) );
     cboStatType.Items.AddObject( 'Fun: DAU Jones ;-) (grouped, name)',                   Pointer(StatDAUn) );

     DayDates := AgtIni.ReadBool   ( iniOptions, 'DayDates', False );
     ForDays  := AgtIni.ReadInteger( iniOptions, 'ForDays',     21    );
     DayFrom  := AgtIni.ReadInteger( iniOptions, 'DayFrom',  0     );
     DayTil   := AgtIni.ReadInteger( iniOptions, 'DayTil',   0     );
     ShowStatSelection;

     PseudoMime := AgtIni.ReadBool( iniOptions, 'PseudoMime', True );

     i := AgtIni.ReadInteger( iniOptions, 'FindIn', 7 );
     if (i and 1)=0 then chkHeader.Checked:=False;
     if (i and 2)=0 then chkBody.Checked  :=False;
     if (i and 4)=0 then chkSig.Checked   :=False;

     ArtShowDiv := 4;
     ArtShowMul := 3;
     lstArticles.Height := AgtIni.ReadInteger( 'Display', 'SplitHeight', lstArticles.Height );

     s:=AgtIni.ReadString('Display','Left'  ,''); if s<>'' then Left   := StrToInt(s);
     s:=AgtIni.ReadString('Display','Top'   ,''); if s<>'' then Top    := StrToInt(s);
     s:=AgtIni.ReadString('Display','Width' ,''); if s<>'' then Width  := StrToInt(s);
     s:=AgtIni.ReadString('Display','Height',''); if s<>'' then Height := StrToInt(s);

     s := AgtIni.ReadString('Display','State','' );
     if s='1' then WindowState:=wsMinimized;
     if s='2' then WindowState:=wsMaximized;

     LoadSections( 'HdrGrp', hdrGrp );
     RelocateCountButton;
     LoadSections( 'HdrArt', hdrArt );

     with txtArticle.DefAttributes do begin
       Name  := Opt.Visual.ResultFont.Name;
       Size  := Opt.Visual.ResultFont.Size;
       Color := Opt.Visual.ResultFont.Color;
       Style := Opt.Visual.ResultFont.Style;
     end;

     with rtfStat.font do begin
       Name  := Opt.Visual.ResultFont.Name;
       Size  := Opt.Visual.ResultFont.Size;
       Color := Opt.Visual.ResultFont.Color;
       Style := Opt.Visual.ResultFont.Style;
     end;

     {cboFind-Eintr‰ge laden}
     for i:=0 to FindHistoryMax-1 do begin
        s := AgtIni.ReadString('FindHistory','What'+IntToStr(i),'');
        if s<>'' then cboFind.Items.Add(s);
     end;

     UpdateAutoSel;

     acShowViewer.ShortCut := ShortCut( VK_RETURN, [ssCtrl] );

     FillGroups;
//     lstQuickGroups.ItemIndex := 1; {Startup-Auswahl}
//     lstQuickGroupsDblClick( Self );
     txtStopAfter.Text := IntToStr(Opt.Misc.Find_MaxArticles);
     ShowHeader1.Checked := Opt.Visual.ShowHeader;
     ShowBody1.Checked := Opt.Visual.ShowBody;
     ShowSignature1.Checked := Opt.Visual.ShowSig;
end;

procedure TForm1.FormActivate(Sender: TObject);
var i : Integer;
    s : String;
    bHeader, bBody, bSig : Boolean;
begin
   if Startup then begin
     cboFind.SetFocus;
     Startup:=False;

     bBody   := chkBody.checked;
     bHeader := chkHeader.Checked;
     bSig    := chkSig.checked;

     chkBody.checked   := false;
     chkHeader.Checked := true;
     chkSig.checked    := false;
     //ToDo: Period

     //Kommandozeilen-Parameter
     for i:=1 to ParamCount do begin
       s := ParamStr(i);
       if length(s)>1 then
         if (s[1] = '-') or (s[1] = '/') then
           case s[2] of
             'n':  ;//if not ChooseShowNG.LoadNG(copy(s,3,length(s))) then
                     //Load given group
             'i':  begin
                     if pos('@',s) <> 0 then begin
                       MarkAllGroups( true );
                       if (lowercase(copy(s,3,5))='news:') or (lowercase(copy(s,3,5))='nntp:') then
                         cboFind.Text := '+@message-id:' + copy(s,8,length(s))
                       else
                         cboFind.Text := '+@message-id:' + copy(s,3,length(s));
                       btnFind.Click;
                     end else

//                       if (lowercase(copy(s,3,5))='news:') or (lowercase(copy(s,3,5))='nntp:') then begin
//                         if not (ChooseShowNG.LoadNG(copy(s,8,length(s)))) then
//                       end else
//                         if not ChooseShowNG.LoadNG(copy(s,3,length(s))) then
                   end;
             'm':  if s<>'' then begin
                     MarkAllGroups( true );
                     if (lowercase(copy(s,3,5))='news:') or (lowercase(copy(s,3,5))='nntp:') then
                       cboFind.Text := '+@message-id:' + copy(s,8,length(s))
                     else
                       cboFind.Text := '+@message-id:' + copy(s,3,length(s));
                     btnFind.Click;
                   end;
           end
     end;
     
     chkBody.checked   := bBody;
     chkHeader.Checked := bHeader;
     chkSig.checked    := bSig;
  end;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var  i  : Integer;
     buf: PChar;
begin
     if Key = VK_CONTROL then WasCtrl  := True;
     if Key = VK_SHIFT   then WasShift := True;

     {Ctrl+Shift+A}
     if ((ssCtrl in Shift) and (ssShift in Shift)) and (Key = VK_A) then begin
       AllGroups1.Click;
       Key := 0;
       exit;
     end;


     case TabbedNotebook1.PageIndex of
        0 : begin
               {CR}
               if ((Shift = []) and (Key = VK_RETURN)) then begin
                  if Sender=lstArticles then lstArticlesDblClick(Self);
                  if Sender=txtArticle  then lstArticlesDblClick(Self);
                  exit;
               end;

               {F3}
               if ((Shift = []) and (Key = VK_F3)) then begin
                  if Sender=TabbedNotebook1 then txtArticle.SetFocus
                  else if Sender=lstArticles     then txtArticle.SetFocus
                  else if Sender=txtArticle      then ShowPositions(+1)
                  else begin
                    btnFindClick(Sender);
                    Key := 0;
                  end;
                  exit;
               end;

               {Shift+F3}
               if ((Shift = [ssShift]) and (Key = VK_F3)) then begin
                  if Sender=TabbedNotebook1 then txtArticle.SetFocus;
                  if Sender=lstArticles     then txtArticle.SetFocus;
                  if Sender=txtArticle      then ShowPositions(-1);
                  exit;
               end;

               {*+F4: N‰chster Artikel}
               if ((Sender=lstArticles) or (sender=txtArticle)) and
                  ((Key = VK_F4) or (Key=VK_SPACE) or (Key=VK_N) or
                   (Key=VK_U) or (Key=VK_D)) then begin

                  txtArticle.SetFocus;
                  i := 0;
                  if ((Shift = [       ]) and (Key = VK_SPACE)) then i:=+1;
                  if ((Shift = [       ]) and (Key = VK_N)) then i:=+1;
                  if ((Shift = [       ]) and (Key = VK_U)) then i:=-1;
                  if ((Shift = [       ]) and (Key = VK_D)) then i:=+1;
                  if ((Shift = [       ]) and (Key = VK_F4)) then i:=+1;
                  if ((Shift = [ssShift]) and (Key = VK_F4)) then i:=-1;

                  if (Sender=lstArticles) or (Sender=txtArticle) then begin
                     if i<>0 then begin
                        i := lstArticles.ItemIndex + i;
                        if (i>=0) and (i<lstArticles.Items.Count) then begin
                           lstArticles.ItemIndex := i;
                           lstArticlesClick(Self);
                        end else begin
                           MessageBeep(0);
                        end;
                     end;
                  end;
               end;

               {*+F5, Z: Anzeigehˆhe umschalten}
               if ((Sender=lstArticles) or (sender=txtArticle)) and
                  ((Key = VK_F5) or (Key=VK_Z)) then begin
                  i := 2;
                  if ArtShowMul=1 then i:=2;
                  if ArtShowMul=2 then i:=3;
                  if ArtShowMul=3 then i:=1;
                  ArtShowMul := i;
                  case ArtShowMul of
                      1 : lstArticles.Height := ((lstArticles.Height+txtArticle.Height) div 6)*1;
                      3 : lstArticles.Height := ((lstArticles.Height+txtArticle.Height) div 6)*5;
                     else lstArticles.Height := ((lstArticles.Height+txtArticle.Height) div 6)*3;
                  end;
                  FormResize(Self);
                  i := lstArticles.ItemIndex;
                  if (lstArticles.Items.Count>0) and (i>0) then begin
                     lstArticles.ItemIndex := i-1;
                     lstArticles.ItemIndex := i;
                  end;
                  Key := 0;
               end;

               {Ctrl+A: alles ausw‰hlen}
               if (sender=txtArticle) and ((Shift = [ssCtrl]) and (Key = VK_A)) then begin
                  txtArticle.SelectAll;
                  Key := 0;
               end;

               {Ctrl+C: copy}
               if (sender=txtArticle) and ((Shift = [ssCtrl]) and (Key = VK_C)) then begin
                  i := txtArticle.GetTextLen + 1;
                  GetMem( Buf, i );
                  txtArticle.GetSelTextBuf( buf, i );
                  Clipboard.SetTextBuf( buf );
                  FreeMem( Buf, i );
                  Key := 0;
               end;

               {Ctrl+L: Launch in Viewer}
               if (Shift = [ssCtrl]) and (Key = VK_L) and (Sender=lstArticles) then begin
                  mnuLaunchViewerClick( Sender );
               end;

               {Ctrl+G: Launch in Agent}
               if (Shift = [ssCtrl]) and (Key = VK_G) and (Sender=lstArticles) then begin
                  mnuLaunchAgentClick( Sender );
               end;

               {H: Headeranzeige umschalten}
               if ((Sender=lstArticles) or (sender=txtArticle)) and ((Shift = []) and (Key = VK_H)) then begin
                  PressedKey('h');
                  lstArticlesClick(Self);
                  Key := 0;
               end;

            end;

        1 : begin {Statistics}
               {F3}
               if ((Shift = []) and (Key = VK_F3)) then begin
                   btnStatClick(Sender);
                   Key := 0;
               end;

               {Ctrl+A: alles ausw‰hlen}
               if ((Shift = [ssCtrl]) and (Key = VK_A)) then begin
                  rtfStat.SelectAll;
                  Key := 0;
               end;

               {Ctrl+C: copy}
               if ((Shift = [ssCtrl]) and (Key = VK_C)) then begin
                  i := rtfStat.GetTextLen + 1;
                  GetMem( Buf, i );
                  rtfStat.GetSelTextBuf( buf, i );
                  Clipboard.SetTextBuf( buf );
                  FreeMem( Buf, i );
                  Key := 0;
               end;
            end;
     end;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_CONTROL then WasCtrl  := False;
   if Key = VK_SHIFT   then WasShift := False;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var  i : Integer;
begin
     i := 0;
     if WindowState=wsMinimized then i:=1;
     if WindowState=wsMaximized then i:=2;
     AgtIni.WriteString( 'Display', 'State',  IntToStr(i) );

     if WindowState=wsNormal then begin
        AgtIni.WriteString( 'Display', 'Left',   IntToStr(Left)   );
        AgtIni.WriteString( 'Display', 'Top',    IntToStr(Top)    );
        AgtIni.WriteString( 'Display', 'Width',  IntToStr(Width)  );
        AgtIni.WriteString( 'Display', 'Height', IntToStr(Height) );
     end;

     AgtIni.WriteString( iniOptions, 'StopAfter',    IntToStr(Opt.Misc.Find_MaxArticles)    );
     AgtIni.WriteString( iniOptions, 'ProgressRate', IntToStr(Opt.Misc.Find_Progressrate) );

     {cboFind-Eintr‰ge sichern}
     for i:=0 to FindHistoryMax-1 do begin
        if i<cboFind.Items.Count then begin
           AgtIni.WriteString('FindHistory','What'+IntToStr(i),cboFind.Items[i] );
        end;
     end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
     pnlSearch.Width := TabbedNotebook1.ClientWidth - 15;
     btnFind.Left   := pnlSearch.ClientWidth - btnFind.Width - 10;
     chkHeader.Left := btnFind.Left - chkHeader.width - 5;
     chkBody.Left   := chkHeader.Left;
     chkSig.Left    := chkHeader.Left;
     lblFindIn.Left := chkHeader.Left - lblFindIn.width - 5;

     cboFind.Width  := lblFindIn.Left - cboFind.Left - 7;

     pnlStop.Left := (ClientWidth -pnlStop.Width ) div 2;
     pnlStop.Top  := (ClientHeight-pnlStop.Height) div 2;

     txtArticle.Repaint;

     grpStatSel.Width := TabbedNotebook1.ClientWidth - grpStatSel.Left - 15;
//     btnStat.Left     := grpStatSel.Width - btnStat.Width - grpStatSel.Left - 10;
end;

{--------------------------------------------------------------------- Ende ---}

procedure TForm1.btnCountArticlesClick(Sender: TObject);
var  i : Integer;
     TG: TAgtGroupMem;
begin
     Screen.Cursor := crHourGlass;
     Application.ProcessMessages;

     for i:=0 to lstGroups.Items.Count-1 do begin
        TG := TAgtGroupMem( lstGroups.Items.Objects[i] );
        if TG.ArtCnt<0 then TG.ArtCnt := LoadArticleCount( TG.PathIdx, TG.GrpID, True );
     end;
     lstGroups.Refresh;

     Screen.Cursor := crDefault;
     Application.ProcessMessages;
end;

procedure TForm1.cboStatTypeClick(Sender: TObject);
var  StatSel : Integer;
     Txt, Par: String;
     Enab    : Boolean;
begin
     StatSel := LongInt( cboStatType.Items.Objects[cboStatType.ItemIndex] );
     Enab    := True;
     chkSortByRatio.Visible := False;

     case StatSel of
        StatMPD  : begin Txt:=''; Par:=''; end;
        StatMPWD : begin Txt:=''; Par:=''; end;
        StatMPH  : begin Txt:=''; Par:=''; end;
        StatMPM  : begin Txt:=''; Par:=''; end;
        StatHFR  : begin Txt:=''; Par:='From:'; end;
        StatHFgn : begin Txt:=''; Par:='4From:'; end;
        StatHFgd : begin Txt:=''; Par:='3From:'; end;
        StatHSU  : begin Txt:=''; Par:='5Subject:'; end;
        StatHMg  : begin Txt:=''; Par:='3Message-ID:'; end;
        StatHXN  : begin Txt:=''; Par:='1X-Newsreader:'; end;
        StatHXNga: begin Txt:=''; Par:='2X-Newsreader:'; end;
        StatHXNgu: begin Txt:=''; Par:='6X-Newsreader:'; end;
        StatH    : begin Txt:='Header-field'; Par:=''; end;
        StatHRE  : begin Txt:='Regular expression (PCRE-style)'; Par:=''; end;
        StatPR   : begin Txt:=''; Par:=''; end;
        StatMF   : begin Txt:='Max. Relayers (1-10)'; Par:='1'; end;
        StatFO   : begin Txt:='Newsserver'; Par:=AgtIni.ReadString('Temp','FeedsOfSrv',''); end;
        StatDAU  : begin Txt:='From:-part (@ for all posters; leave empty for ranking)';
                         Par:=''; chkSortByRatio.Visible:=True; end;
        StatDAUn : begin Txt:='From:-part (@ for all posters; leave empty for ranking)';
                         Par:=''; chkSortByRatio.Visible:=True; end;
        else       begin Txt:=''; Par:=''; Enab:=False; end;
     end;

     lblStatPar.Caption := Txt;
     txtStatPar.Text    := Par;
     btnStat.Enabled    := Enab;

     if Txt='' then begin
        //lblStatPar.Visible := False;
        lblStatPar.Caption := '(none)';
        txtStatPar.Visible := False;
     end else begin
        //lblStatPar.Visible := True;
        txtStatPar.Visible := True;
     end;
end;

procedure TForm1.btnStatClick(Sender: TObject);
var  StatSel: Integer;
     Par    : String;
     i      : Integer;
begin
     if not btnStat.Enabled then exit;

     StatSel := LongInt( cboStatType.Items.Objects[cboStatType.ItemIndex] );
     if StatSel=0 then exit;

     if Form1.lstGroups.SelCount=0 then begin
        Application.MessageBox('No groups selected!',PChar(Version),MB_ICONEXCLAMATION);
        exit;
     end;

     Par     := txtStatPar.Text;

     StatIsActive := True;

     for i:=chart.SeriesList.Count-1 downto 1 do
       chart.SeriesList[i].free;

     case StatSel of
        StatMPD  : AgtStat_PerDay;
        StatMPWD : AgtStat_PerWeekDay;
        StatMPH  : AgtStat_PerHour;
        StatMPM  : AgtStat_PerMonth;
        StatHFR  : AgtStat_Header(Par);
        StatHFgn : AgtStat_Header(Par);
        StatHFgd : AgtStat_Header(Par);
        StatHSU  : AgtStat_Header(Par);
        StatHMg  : AgtStat_Header(Par);
        StatHXN  : AgtStat_Header(Par);
        StatHXNga: AgtStat_Header(Par);
        StatHXNgu: AgtStat_Header(Par);
        StatH    : AgtStat_Header(Par);
        StatHRE  : AgtStat_Header('{'+Par+'}');
        StatPR   : AgtStat_Path_Relayers;
        StatMF   : AgtStat_Path_Feeds(Par);
        StatFO   : AgtStat_Path_FeedsOf(Par);
        StatDAU  : AgtStat_DauJones(Par,chkSortByRatio.Checked,False);
        StatDAUn : AgtStat_DauJones(Par,chkSortByRatio.Checked,True );
     end;
     StatIsActive := False;

     Caption := Version;
end;

procedure TForm1.txtStatParKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
(*
     if not (Shift = [ssCtrl]) then exit;
     if Key = VK_A then begin txtStatPar.SelectAll; Key:=0; end;
     if Key = VK_C then begin txtStatPar.CopyToClipboard; Key:=0; end;
     if Key = VK_V then begin txtStatPar.PasteFromClipboard; Key:=0; end;
*)
end;

procedure TForm1.cboFindKeyPress(Sender: TObject; var Key: Char);
begin
   if TabbedNotebook1.PageIndex = 0 then begin
      if (Key in [^A..^Z]) and WasCtrl and WasShift then Key := #0;
      if (Key = #13) then btnFind.Click;
   end;
end;

procedure TForm1.acShowViewerExecute(Sender: TObject);
begin
   if not Assigned( frmViewer ) then begin
      Application.CreateForm( TfrmViewer, frmViewer );
      frmViewer.Show;
   end else begin
      frmViewer.BringToFront;
   end;
end;

procedure TForm1.mnuLaunchViewerClick(Sender: TObject);
var  TA: TAgtArticle;
     c, s: String;
begin
   acShowViewerExecute( Sender );

   if TabbedNotebook1.PageIndex=0 then begin
      if (lstArticles.ItemIndex>=0) and (lstArticles.ItemIndex<lstArticles.Items.Count) then begin
        TA := TAgtArticle( lstArticles.Items.Objects[lstArticles.ItemIndex] );
        if (TA.GrpID>=0) and (TA.ArtNo>=0) then begin
           c := lstArticles.Items[lstArticles.ItemIndex];
           c := StringReplace( c, #7, '',   [rfReplaceAll] );
           c := StringReplace( c, #9, ', ', [rfReplaceAll] );
           OpenMyArt( Opt.Database.Names[TA.PathIdx], TA.GrpID );
           AgtArtLoad( HArt, TA.ArtNo );
           AgtArtConvertToExportFormat( HArt );
           s := AgtArtTextPtr( HArt );
           CloseMyArt;
           if (c<>'') and (length(s)>2) then frmViewer.AddArticle( c, s, TA.Clone );
        end;
      end;
   end else if TabbedNotebook1.PageIndex=1 then begin
      c := cboStatType.Text;
      s := rtfStat.Text;
      if (c<>'') and (length(s)>2) then frmViewer.AddStatistic( c, s );
   end;
end;

procedure TForm1.mnuLaunchAgentClick(Sender: TObject);
var  TA: TAgtArticle;
begin
   if lstArticles.Items.Count<=0 then exit;
   TA := TAgtArticle( lstArticles.Items.Objects[lstArticles.ItemIndex] );
   AgentLaunchByDDE( TA );
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i : integer;
begin
  for i:=form1.chart.SeriesList.Count-1 downto 0 do
     chart.SeriesList[i].free;
end;

procedure TForm1.ROT131Click(Sender: TObject);
var  s : string;
     i : integer;

      function rot(c : char) : char;
      begin
        Result := c;
        if c in ['a'..'m', 'A'..'M'] then
          Result := chr(ord(c)+13)
        else if c in ['n'..'z','N'..'Z'] then
          Result := chr(ord(c)-13);
      end;

begin
    s := txtArticle.SelText;
    for i := 1 to length(s) do
       s[i] := ROT(s[i]);
    txtarticle.SelText := s;
end;

procedure TForm1.MARK1Click(Sender: TObject);
begin
  txtArticle.SelAttributes.Color := clRed;  //ToDo: Background-Color
end;

procedure TForm1.COPY1Click(Sender: TObject);
begin
  txtArticle.CopyToClipboard; 
end;

procedure TForm1.btnExportClick(Sender: TObject);
var s : string;
begin
  case rgExp.ItemIndex of
    0: Chart.CopyToClipboardBitmap;
    1: Chart.CopyToClipboardMetafile(false);
    2: //begin
//         SavePictureDialog.FilterIndex := 1;
         if SavePictureDialog.Execute then begin
           s := SavePictureDialog.FileName;
           case SavePictureDialog.FilterIndex of
             1: begin
                  if not (lowercase(ExtractFileExt(s))='.bmp') then
                    s := s + '.bmp';
                  Chart.SaveToBitmapFile(s);
                end;
             2: begin
                  if not (lowercase(ExtractFileExt(s))='.emf') then
                    s := s + '.emf';
                  Chart.SaveToMetafileEnh(s);
                end;
             3: begin
                  if not (lowercase(ExtractFileExt(s))='.wmf') then
                    s := s + '.wmf';
                  Chart.SaveToMetafile(s);
                end;
           end;
         end;
  end;
end;

procedure TForm1.AgentLaunchByDDE( TA: TAgtArticle );
var  s : String;
     BAB: PChar;
begin
     if (TA.GrpID<0) or (TA.ArtNo<0) then exit;

     OpenMyArt( Opt.Database.Names[TA.PathIdx], TA.GrpID );
     AgtArtLoad( HArt, TA.ArtNo );
     ArtTextSize := AgtArtTextLen(HArt);
     ArtText     := AgtArtTextPtr(HArt);

     {Message-ID ermitteln}
     s := '';
     BAB := StrIQuickSearch( ArtText, 'Message-ID: ' );
     if BAB<>nil then begin {im Body}
        BAB := (BAB+12);
     end else begin         {im Header}
        BAB := StrIFind( ArtText, #9 );
        if BAB<>nil then BAB := (BAB+1);
        if BAB<>nil then BAB := StrIFind( BAB, #9 );
        if BAB<>nil then BAB := (BAB+1);
     end;

     if BAB<>nil then begin {bis zum Ende ¸bernehmen}
        while not (BAB^ IN [#0,#9,#10,#13]) and (length(s)<256) do begin
           s := s + BAB^;
           BAB := (BAB+1);
        end;
        s := Trim(s);
        if copy(s,1,1)='<' then s:=copy(s,2,255);
        if copy(s,length(s),1)='>' then s:=copy(s,1,length(s)-1);
     end;
     CloseMyArt;

     {Konnte Msg-ID ermittelt werden?}
     if s='' then exit; {Nein :-(}
     if Debug then Application.MessageBox( PChar('Message-ID: '+s),'',0 );

     s := 'news:'+s;  //ToDo: andere Form der MID?
     ShellExecute(Form1.Handle, 'open', PChar(s), nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Konfiguration1Click(Sender: TObject);
begin
  Form2.ShowModal;
  ShowHeader1.Checked := Opt.Visual.ShowHeader;
  ShowBody1.Checked := Opt.Visual.ShowBody;
  ShowSignature1.Checked := Opt.Visual.ShowSig;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Options.Init;
end;

procedure TForm1.chkHeaderClick(Sender: TObject);
var  i : Integer;
     x : Integer;
begin
     if form1.Startup then exit;

     i := AgtIni.ReadInteger( iniOptions, 'FindIn', 0 );
     x := 1; if chkHeader.Checked then i:=i or x else i:=i and not(x);
     x := 2; if chkBody.Checked   then i:=i or x else i:=i and not(x);
     x := 4; if chkSig.Checked    then i:=i or x else i:=i and not(x);
     AgtIni.WriteInteger( iniOptions, 'FindIn', i );
end;

function IsLink (Wort : String) : Boolean;
begin
   wort := uppercase(wort);
   result :=
             (wort[1]='<') and (wort[length(wort)]='>') and (pos('@',wort)>0)
          OR (copy(wort,1,7)='HTTP://')
          OR (copy(wort,1,4)='WWW.')
          OR (copy(wort,1,4)='FTP:')
          OR (copy(wort,1,5)='NEWS:')
          OR (copy(wort,1,7)='MAILTO:');
end;

procedure TForm1.txtArticleMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);         //THX for helping to Nineberry and Thomas Stutz
var
  Point: TPoint;
  Wert: LongInt;
  LineNumber: Integer;
  LinePos: Integer;
  Line: String;
  Wort: String;
begin
 // Get absolute position of character beneath mouse
 Point.x:= X;
 Point.y:= Y;
 Wert:= txtArticle.Perform(EM_CHARFROMPOS, 0, LParam(@Point));

 if Wert >= 0 then
 begin
   // Get line number
   LineNumber:= TxtArticle.Perform(EM_LINEFROMCHAR, Wert, 0);

   // Get line position
   LinePos:= Wert - TxtArticle.Perform(EM_LINEINDEX,
   LineNumber, 0);

   // Get line
   Line:= txtArticle.Lines[LineNumber];

   Line := copy(Line, LastDelimiter(' ',copy(Line,1,LinePos))+1,length(Line));
   if pos(' ', Line)>0 then
     Wort := copy(Line,1,pos(' ',Line)-1)
   else
     Wort := Line;

   if (length(wort)>2) and (Linepos<>length(txtArticle.Lines[LineNumber])) and IsLink(Wort) then begin
       StatusBar1.Simpletext := Wort;
       txtArticle.Cursor := crHandPoint;
   end else begin
     StatusBar1.SimpleText:= EmptyStr;
     txtArticle.Cursor := crDefault;
   end;
 end
 else
 begin
   StatusBar1.SimpleText:= EmptyStr;
   txtArticle.Cursor := crDefault;
 end;
end;

procedure TForm1.txtArticleMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

  function OpenLink(Link : String) : Boolean;
  var s : string;
  begin
    s := uppercase(link);
    Result := true;
    if  (copy(s,1,7)='HTTP://')
     OR (copy(s,1,4)='WWW.')
     OR (copy(s,1,4)='FTP:')
     OR (copy(s,1,5)='NEWS:')
     OR (copy(s,1,7)='MAILTO:') then begin
       ShellExecute(Form1.Handle, 'open', PChar(Link), nil, nil, SW_SHOWNORMAL); //Execute with IE (or registered programm for this linktype)
    end else
    if (link[1]='<') and (link[length(link)]='>') and (pos('@',link)>0) then begin
      s := 'MAILTO:' + Link;
      ShellExecute(Form1.Handle, 'open', PChar(s), nil, nil, SW_SHOWNORMAL);  //Execute Mail
    end else
      Result := false;
  end;

var
  Point: TPoint;
  Wert: LongInt;
  LineNumber: Integer;
  LinePos: Integer;
  Line: String;
  Wort: String;
  xy  : tPoint;
begin
 if (Button=mbLeft) or (Button=mbRight) then begin
   // Get absolute position of character beneath mouse
   Point.x:= X;
   Point.y:= Y;
   Wert:= txtArticle.Perform(EM_CHARFROMPOS, 0, LParam(@Point));

   if Wert >= 0 then
   begin
     // Get line number
     LineNumber:= TxtArticle.Perform(EM_LINEFROMCHAR, Wert, 0);

     // Get line position
     LinePos:= Wert - TxtArticle.Perform(EM_LINEINDEX,
     LineNumber, 0);

     // Get line
     Line:= txtArticle.Lines[LineNumber];

     Line := copy(Line, LastDelimiter(' ',copy(Line,1,LinePos))+1,length(Line));
     if pos(' ', Line)>0 then
       Wort := copy(Line,1,pos(' ',Line)-1)
     else
       Wort := Line;

     if (length(wort)>2) and (Linepos<>length(txtArticle.Lines[LineNumber])) and IsLink(Wort) then begin
         StatusBar1.Simpletext := Wort;
         txtArticle.Cursor := crHandPoint;
         if button=mbLeft then
           OpenLink(Wort)
         else begin
           xy := txtArticle.ClientToScreen(Classes.Point(x,y));
           PopupMenuMessageMail.Popup(xy.x,xy.y);
         end;
     end else begin
       StatusBar1.SimpleText:= EmptyStr;
       txtArticle.Cursor := crDefault;
       if (Button=mbRight) then begin
         xy := txtArticle.ClientToScreen(Classes.Point(x,y));
         PopupMenuArticleShow.Popup(xy.x,xy.y);
       end;
     end;
   end
   else
   begin
     StatusBar1.SimpleText:= EmptyStr;
     txtArticle.Cursor := crDefault;
     if (Button=mbRight) then
       PopupMenuArticleShow.Popup(x,y);
   end;
 end;
end;

procedure TForm1.Info1Click(Sender: TObject);
begin
  if not Assigned(AboutBox) then Application.CreateForm(TAboutBox, AboutBox);
  AboutBox.ShowModal;
end;

procedure TForm1.New1Click(Sender: TObject);
var  SelNr, Cnt, i : Integer;
     TG            : TAgtGroupMem;
     s             : String;
begin
  UpdateAutoSel;
  SelNr := AutoSelection1.Count-3; //'4' is the number of other submenus in this menus.
  s := InputBox('Name of this selection', 'Name', '');
  if s='' then begin MessageBeep(0); exit; end;
  if MessageDlg('Save currently selected groups as group-collection "'+s+'"?', mtConfirmation, mbOkCancel, 0)<>mrOK then exit;
  AgtIni.WriteString( 'GrpSelect '+IntToStr(SelNr),
                      'Name', s);
  Cnt := 0;
  for i:=0 to lstGroups.Items.Count-1 do begin
    if lstGroups.Selected[i] then begin
      TG := TAgtGroupMem( lstGroups.Items.Objects[i] );
      AgtIni.WriteString( 'GrpSelect '+IntToStr(SelNr),
                          'Group'+IntToStr(Cnt),
                          IntToStr(TG.PathIdx) + ':' + IntToStr(TG.GrpID) );
      inc(Cnt);
    end;
  end;
  AgtIni.WriteString( 'GrpSelect '+IntToStr(SelNr), 'Count', IntToStr(Cnt) );
  UpdateAutoSel;
end;

procedure TForm1.MenuItemAutoSelClick(Sender: TObject);
var  SelNr, NGCount, i, k : Integer;
     PathNo, NGNo         : LongInt;
     s                    : String;
     TG                   : TAgtGroupMem;
begin
     s := (Sender as tMenuItem).name;

     {Alle Gruppen ausw‰hlen}
     if s='AllGroups1' then begin
        MarkAllGroups( True );
        exit;
     end;

     s := copy(s,4,length(s));
     if s='' then begin MessageBeep(0); exit; end;
     SelNr := StrToInt(s);

     MarkAllGroups( False );
     s := AgtIni.ReadString( 'GrpSelect '+IntToStr(SelNr), 'Count', '' );
     if s='' then begin MessageBeep(0); exit; end;
     NGCount := StrToInt(s);
     if NGCount<=0 then begin MessageBeep(0); exit; end;

     lstGroups.Items.BeginUpdate;

     for i:=0 to NGCount-1 do begin
        s := AgtIni.ReadString( 'GrpSelect '+IntToStr(SelNr), 'Group'+IntToStr(i), '' );
        if s='' then s:='0';
        k := Pos(':',s);
        if k=0 then begin
           PathNo := -1;
           NGNo   := StrToInt(s);
        end else begin
           PathNo := StrToInt(copy(s,1,k-1));
           NGNo   := StrToInt(copy(s,k+1,255));
        end;

        for k:=0 to lstGroups.Items.Count-1 do begin
           TG := TAgtGroupMem( lstGroups.Items.Objects[k] );
           if PathNo>=0 then begin
              if (TG.PathIdx=PathNo) and (TG.GrpID=NGNo) then lstGroups.Selected[k] := True;
           end else begin
              if TG.GrpID=NGNo then lstGroups.Selected[k] := True;
           end;
        end;
     end;

     lstGroups.Items.EndUpdate;
end;

procedure tForm1.UpdateAutoSel;  {Gruppen-Schnellauswahl}
var
  i : integer;
  s : string;
  MI : tMenuItem;
begin
  while autoselection1.Count>4 do
    autoselection1.Items[4].free;

  for i:=1 to 25 do begin
    s := AgtIni.ReadString( 'GrpSelect '+IntToStr(i), 'Name', '' );
    if s='' then continue;
    MI := tMenuItem.Create(self);
    MI.OnClick := MenuItemAutoSelClick;
    MI.Visible := true;

    MI.Name       := 'mnu'+IntToStr(i);
    MI.Caption    := s;
    MI.ShortCut   := ShortCut(Word($41+i), [ssCtrl]+[ssShift]);
    Autoselection1.Add(MI);
  end;
end;

procedure TForm1.Change1Click(Sender: TObject);
var  SelNr     : Integer;
     s         : String;
     DelRes    : Integer;
begin
  s := InputBox('Which item of auto-selection should be changed?','Change one of Selections','1');
  if (s='') or (StrToInt(s)<=0) then begin MessageBeep(0); exit; end;
  SelNr := StrToInt(s);
  s := InputBox('New name:', 'Rename group-collection', AgtIni.ReadString( 'GrpSelect '+IntToStr(SelNr), 'Name', '' ));
  if s='' then begin
    DelRes := Application.Messagebox('Should the item really be deleted?','Delete-Query',MB_YESNOCancel+MB_ICONQUESTION);
    if DelRes=IDYES then begin
      //ToDo: Delete GroupSelection
    end else if DelRes=IDNO then begin
      AgtIni.WriteString( 'GrpSelect '+IntToStr(SelNr), 'Name', '-' );
    end;
  end else
    AgtIni.WriteString( 'GrpSelect '+IntToStr(SelNr), 'Name', s );
//    lstQuickGroups.Items[SelNr] := chr($41+SelNr) + ': ' + s;
  UpdateAutoSel;
end;

procedure TForm1.lstGroupsClick(Sender: TObject);
begin
  if (TabbedNotebook1.PageIndex=0) and (chkBrowse.checked) and (lstGroups.SelCount=1) then begin
    if not (lstGroups.ItemIndex = OldBrowseIndex) then begin
      OldBrowseIndex := lstGroups.ItemIndex;
      btnFind.Click;
    end
  end else if (TabbedNotebook1.PageIndex=1) and (chkBrowse.checked) and (lstGroups.SelCount=1) then begin
//    if cboStat.
    if not (lstGroups.ItemIndex = OldBrowseIndex) then begin
      OldBrowseIndex := lstGroups.ItemIndex;
      btnStat.Click;
    end;

  end else
    OldBrowseIndex := -1;
end;

procedure TForm1.txtStopAfterChange(Sender: TObject);
var  s : String;
begin
     s := txtStopAfter.Text;
     if s='' then s:='0';
     try
        Opt.Misc.Find_MaxArticles := StrToInt(s);
     except
        Opt.Misc.Find_MaxArticles := 500;
     end;

     if Opt.Misc.Find_MaxArticles<1 then Opt.Misc.Find_MaxArticles:=1;
     s := IntToStr(Opt.Misc.Find_MaxArticles);
     AgtIni.WriteString( iniOptions, 'StopAfter', s );
     if txtStopAfter.Text<>s then txtStopAfter.Text:=s;
end;

procedure TForm1.ShowHeader1Click(Sender: TObject);
begin
  Opt.Visual.ShowHeader := not Opt.Visual.ShowHeader;
  ShowHeader1.Checked := Opt.Visual.ShowHeader;
  lstArticles.OnClick(self);
end;

procedure TForm1.ShowBody1Click(Sender: TObject);
begin
  Opt.Visual.ShowBody := not Opt.Visual.ShowBody;
  ShowBody1.Checked := Opt.Visual.ShowBody;
  lstArticles.OnClick(self);
end;

procedure TForm1.ShowSignature1Click(Sender: TObject);
begin
  Opt.Visual.ShowSig := not Opt.Visual.ShowSig;
  ShowSignature1.Checked := Opt.Visual.ShowSig;
  lstArticles.OnClick(self);
end;

procedure TForm1.TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  if NewTab=2 then begin
    AllowChange := (chart.SeriesList.countactive > 1);
    If not AllowChange then begin
      Application.MessageBox('There is no graph painted, so you need not this section, do you?' + #13#10
                            +'A graph will be painted using statistics ''Message per *''',
                             'Not possible', MB_OK); 
    end;
  end;
end;

end.

