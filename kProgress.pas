unit kProgress;

{
Copyright: Heiko Studt <Heiko.Studt@Goldpool.org>
Download: http://www.goldpool.org
Name: Progress-Form
Version: 1.1


Diese Komponente stellt eine Progressbar und einen "Cancel"-Button dar.

Diese Komponente ist aus einem Posting bzW die Anregung in ebendiesem
von Marian Aldenhövel entstanden, bezieht sich aber nur noch in geringen Teilen
auf dieses. Den größten Teil des Codes stammt von mir.


Beispiel:

procedure TForm1.Button1Click(Sender: TObject);
var i : integer;
begin
  with tProgressForm1 do begin
    try
      Min := 1;
      Max := 10;
      show('Progress-Test');
        for i := 1 to 10 do begin
          if not Progress('',i) then
            break;
          sleep(100);
        end;
    finally
      hide;
    end;
  end;
end;

Version 1.2: 31.03.2002
  Chg: "Progress" invertiert.
  Add: Label

Version 1.1: 10.02.2002
  Add: ShowModal

Version 1.0: Offizielles Release

}

interface

uses Forms, stdctrls, comctrls, classes, Controls, sysutils;

type
  ENotShown = class(Exception);
  EAllreadyShown = class(Exception);
  TProgressEvent = procedure(Sender:TObject;ProgressMessage:String; Pos : Integer; var Abort:boolean) of object;

  tProgressForm = class (tComponent)
  private
    FOnProgress:TProgressEvent;
    Form : tForm;
    fAbort: Boolean;
    fPos, fMin, fMax : Integer;
    fCursor : tCursor;
    IsShow : Boolean;
    btnAbort: TButton;
    ProgressBar: TProgressBar;
    lProgress: tLabel;
    procedure btnAbortClick(Sender: TObject);
    procedure SetCursor(cur : tCursor);
    procedure setMin( sMin : integer );
    procedure setMax( sMax : integer );
  published
    property OnProgress:TProgressEvent read FOnProgress write FOnProgress;
    property Min : Integer read fMin write SetMin default 1;
    property Max : Integer read fMax write SetMax default 10;
//    property Cursor : tCursor read fCursor write SetCursor default crAppStart;
  public
    procedure Show(sCaption : String);
    procedure ShowModal(sCaption : String);
    procedure Hide;
    function  Progress(aMessage:string; sPos : integer) : Boolean; //Ist true, solange *nicht* abgebrochen wurde

    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
  end;

  procedure Register;



implementation

uses Graphics;

Constructor tProgressForm.Create(AOwner: TComponent);
begin
  inherited;

  fMin   := 1;
  fMax   := 10;
  fPos   := 0;
  IsShow := false;

  if not (csDesigning in ComponentState) then begin
    Form := tForm.CreateNew(AOwner);
    try
      btnAbort    := tButton.Create(form);
      ProgressBar := tProgressbar.Create(form);
      lProgress   := tLabel.Create(form);
      with Form do begin
        AutoScroll   := false;
        BorderIcons  := [];
        BorderStyle  := bsSingle;
        ClientHeight := 97;
        ClientWidth  := 242;
  //      Color        := clLime; //Color: Change?
                                  //Könnte auch als Property deklariert werden...
        Height       := 130;
        KeyPreview   := true;
        HorzScrollBar.Visible := false;
        VertScrollBar.Visible := false;
        Position     := poMainFormCenter;
        Width        := 250;
      end;

      with btnAbort do begin
        Caption     := 'Cancel';
        Cancel      := true;
        ModalResult := mrCancel;
        Left        := 88;
        Height      := 25;
        Width       := 75;
        Top         := 72;
        OnClick     := BtnAbortClick;
        Visible     := true;
        Parent      := form;
      end;
      with Progressbar do begin
        Visible  := true;
        Step     := 1;
        Left     := 8;
        Height   := 21;
        Width    := 225;
        Top      := 30;
        Parent   := form;
      end;
      with lProgress do begin
        Visible := true;
        AutoSize := false;
        Caption := '';
//        Color := clBlack;
        Left        := 8;
        Height      := 25;
        Width       := 225;
        Top         := 12;
        parent := form;

        WordWrap := false;
      end;
      SetCursor(crAppStart);
      //Cursor   := crAppStart;// crHourGlass
    except
      raise;
        //ToDo: Freigaben?
  //    form.Destroy;
  //    self.destroy;
    end;
  end;
end;

procedure tProgressForm.Show(sCaption : String);
begin
  if not IsShow then begin
    with Progressbar do begin
      Position := 0;
      Min      := fMin;
      Max      := fMax;
    end;
    lProgress.Caption := '';
    form.Caption := sCaption;
    form.show;
    IsShow := true;
  end else
   Raise EAllreadyShown.Create('Dieses ProgressForm wird bereits angezeigt');
end;

procedure tProgressForm.ShowModal(sCaption : String);
begin
  if not IsShow then begin
    with Progressbar do begin
      Position := 0;
      Min      := fMin;
      Max      := fMax;
    end;
    lProgress.Caption := '';
    form.Caption := sCaption;
    (Owner as tForm).enabled := false;
    form.show;
    IsShow := true;
  end else
   Raise EAllreadyShown.Create('Dieses ProgressForm wird bereits angezeigt');
end;

procedure tProgressForm.SetCursor(cur: tCursor);
begin
  form.Cursor        := cur;
  progressbar.cursor := cur;
  btnAbort.Cursor    := cur;
  fCursor            := cur;
end;

procedure tProgressForm.setMax(sMax: integer);
begin
  fMax            := sMax;
  ProgressBar.Max := sMax;
end;

procedure tProgressForm.setMin(sMin: integer);
begin
  fMin            := sMin;
  Progressbar.Min := sMin;
end;

function TProgressForm.Progress(aMessage:string; sPos : Integer) : Boolean;
begin
   if IsShow then begin
     fPos := sPos;
     ProgressBar.Position := sPos;
     lProgress.Caption := aMessage;
     Result := not fAbort;

     Application.ProcessMessages;
     if Assigned(FOnProgress) then
       begin
          FOnProgress(Self,aMessage,fPos,fAbort);
//          if fAbort then Raise EProgressAborted.Create('Abbruch durch den Benutzer');

          //Falls denn eine _Exception_ gewünscht ist.
          //Bisher kann man durch den Funktionswert erkennen, ob abgebrochen wurde.
       end;
  end else
    Raise ENotShown.Create('Das ProgressForm wurde nicht mit "show" angezeigt! Im Sourcecode ist ein Fehler!');
end;

procedure tProgressForm.btnAbortClick(Sender: TObject);
begin
  fAbort := true;
end;

procedure tProgressForm.Hide;
begin
  if IsShow then begin
    IsShow := false;
//    if form.HasParent then
//      form.Parent.Enabled := true;
    (Owner as tForm).enabled := true;
    form.close;
  end else
    Raise ENotShown.Create('Das ProgressForm wurde noch nicht angezeigt. Daher kann es nicht ge''hide''ed werden!');
end;

{
ToDo: Destroy, "free"s erzeugen leider bisher Accessviolation
}
Destructor tProgressForm.Destroy;
begin
  inherited;
end;



procedure Register;
begin
  RegisterComponents('Eigene', [tProgressForm]);
end;

end.
