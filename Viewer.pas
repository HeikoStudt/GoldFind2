unit Viewer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, Menus, StdCtrls, ComCtrls, AgtBase, ExtCtrls;

type
  TfrmViewer = class(TForm)
    rtfText: TRichEdit;
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    acExit: TAction;
    acSaveAs: TAction;
    acCut: TAction;
    acCopy: TAction;
    acPaste: TAction;
    acDelete: TAction;
    acSelectAll: TAction;
    File1: TMenuItem;
    Edit1: TMenuItem;
    Saveas1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    Selectall1: TMenuItem;
    StatusBar1: TStatusBar;
    acAgentDDE: TAction;
    N2: TMenuItem;
    LaunchinAgent1: TMenuItem;
    lstList: TListBox;
    Splitter1: TSplitter;
    acRemoveItem: TAction;
    N3: TMenuItem;
    Removeselecteditem1: TMenuItem;
    acMainForm: TAction;
    LaunchinAgent2: TMenuItem;
    procedure acExitExecute(Sender: TObject);
    procedure acSaveAsExecute(Sender: TObject);
    procedure acCutExecute(Sender: TObject);
    procedure acPasteExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acSelectAllExecute(Sender: TObject);
    procedure acCopyExecute(Sender: TObject);
    procedure acAgentDDEExecute(Sender: TObject);
    procedure lstListClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acRemoveItemExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure acMainFormExecute(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure ScrollToBody;
    procedure SelectText( Index: Integer );
    function IndexOf( const Caption, Text: String ): Integer;
  public
    { Public-Deklarationen }
    procedure AddArticle  ( const Caption, Text: String; const TA: TAgtArticle );
    procedure AddStatistic( const Caption, Text: String );
  end;

var
   frmViewer: TfrmViewer = nil;

implementation

uses Main;

{$R *.DFM}

var
   LastSaveAs: String;

type
   TViewerInfo = class
      Caption, Text: String;
      TA: TAgtArticle;
      constructor Create( const ACaption, AText: String; ATA: TAgtArticle );
   end;

constructor TViewerInfo.Create(const ACaption, AText: String; ATA: TAgtArticle);
begin
   inherited Create;
   Caption := ACaption;
   Text := AText;
   TA := ATA;
end;

procedure TfrmViewer.acExitExecute(Sender: TObject);
begin
   Close;
end;

procedure TfrmViewer.acSaveAsExecute(Sender: TObject);
var  ExpFile: String;
begin
   ExpFile := '';
   with TSaveDialog.Create( Self ) do begin
      Title := 'Save as ...';
      DefaultExt := 'txt';
      Filter := 'Text Files (*.txt)|*.txt|All Files (*.*)|*.*';
      Options := [ ofHideReadOnly, ofNoReadOnlyReturn, ofPathMustExist];
      FileName := LastSaveAs;
      if Execute then ExpFile := Filename;
      Free;
   end;
   if ExpFile='' then exit;

   try
      rtfText.Lines.SaveToFile( ExpFile );
      LastSaveAs := ExpFile;
   except
      on E: Exception do ShowMessage( E.Message );
   end;
end;

procedure TfrmViewer.acCutExecute(Sender: TObject);
begin
   rtfText.CutToClipboard;
end;

procedure TfrmViewer.acCopyExecute(Sender: TObject);
begin
   rtfText.CopyToClipboard;
end;

procedure TfrmViewer.acPasteExecute(Sender: TObject);
begin
   rtfText.PasteFromClipboard;
end;

procedure TfrmViewer.acDeleteExecute(Sender: TObject);
begin
   rtfText.SetSelTextBuf( nil );
end;

procedure TfrmViewer.acSelectAllExecute(Sender: TObject);
begin
   rtfText.SelectAll;
end;

procedure TfrmViewer.ScrollToBody;
var  HdrSep: Integer;
begin
   HdrSep := Pos( #13#10#13#10, rtfText.Text );
   if HdrSep = 0 then exit;

   rtfText.SelLength := 0;
   rtfText.SelStart := length(rtfText.Text);
   SendMessage( rtfText.Handle, EM_SCROLLCARET, 0, 0 );
   rtfText.SelStart := HdrSep + 4;
   SendMessage( rtfText.Handle, EM_SCROLLCARET, 0, 0 );
end;

procedure TfrmViewer.acAgentDDEExecute(Sender: TObject);
var  VI: TViewerInfo;
begin
   if lstList.ItemIndex < 0 then exit;
   if lstList.ItemIndex >= lstList.Items.Count then exit;

   VI := TViewerInfo( lstList.Items.Objects[ lstList.ItemIndex ] );
   if Assigned( VI.TA ) then Form1.AgentLaunchByDDE( VI.TA );
end;

procedure TfrmViewer.lstListClick(Sender: TObject);
begin
   SelectText( lstList.ItemIndex );
end;

procedure TfrmViewer.SelectText( Index: Integer );
var  VI: TViewerInfo;
begin
   if Index < 0 then exit;
   if Index >= lstList.Items.Count then exit;

   VI := TViewerInfo( lstList.Items.Objects[ Index ] );

   Statusbar1.SimpleText := VI.Caption;
   rtfText.Text := VI.Text;
   acAgentDDE.Enabled := Assigned( VI.TA );
   if Assigned( VI.TA ) then ScrollToBody;
end;

function TfrmViewer.IndexOf( const Caption, Text: String ): Integer;
var  i: Integer;
     VI: TViewerInfo;
begin
   Result := -1;

   for i:=0 to lstList.Items.Count-1 do begin
      VI := TViewerInfo( lstList.Items.Objects[i] );
      if VI.Caption = Caption then begin
         if VI.Text = Text then begin
            Result := i;
            break;
         end;
      end;
   end;
end;

procedure TfrmViewer.AddArticle(const Caption, Text: String; const TA: TAgtArticle);
var  i: Integer;
begin
   i := IndexOf( Caption, Text );
   if i < 0 then begin
      i := lstList.Items.AddObject( Caption, TViewerInfo.Create(Caption,Text,TA) );
   end;
   lstList.ItemIndex := i;
   SelectText( i );
end;

procedure TfrmViewer.AddStatistic(const Caption, Text: String);
var  i: Integer;
begin
   i := IndexOf( Caption, Text );
   if i < 0 then begin
      i := lstList.Items.AddObject( Caption, TViewerInfo.Create(Caption,Text,nil) );
   end;
   lstList.ItemIndex := i;
   SelectText( i );
end;

procedure TfrmViewer.FormClose(Sender: TObject; var Action: TCloseAction);
var  VI: TViewerInfo;
begin
   while lstList.Items.Count > 0 do begin
      VI := TViewerInfo( lstList.Items.Objects[ 0 ] );
      lstList.Items.Delete( 0 );
      if Assigned( VI ) then VI.Free;
   end;
   frmViewer := nil;
end;

procedure TfrmViewer.acRemoveItemExecute(Sender: TObject);
var  VI: TViewerInfo;
     Index: Integer;
begin
   Index := lstList.ItemIndex;
   if Index < 0 then exit;
   if Index >= lstList.Items.Count then exit;

   VI := TViewerInfo( lstList.Items.Objects[ Index ] );
   lstList.Items.Delete( Index );
   if Assigned( VI ) then VI.Free;

   if Index >= lstList.Items.Count then dec( Index );
   lstList.ItemIndex := Index;
   SelectText( Index );
end;

procedure TfrmViewer.FormCreate(Sender: TObject);
begin
   acMainForm.ShortCut := ShortCut( VK_RETURN, [ssCtrl] );
end;

procedure TfrmViewer.acMainFormExecute(Sender: TObject);
begin
   Application.MainForm.BringToFront;
end;

end.
