object frmViewer: TfrmViewer
  Left = 231
  Top = 107
  Width = 504
  Height = 406
  Caption = 'GoldFind-Viewer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 97
    Width = 496
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object rtfText: TRichEdit
    Left = 0
    Top = 100
    Width = 496
    Height = 241
    Align = alClient
    Lines.Strings = (
      '')
    PlainText = True
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 341
    Width = 496
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object lstList: TListBox
    Left = 0
    Top = 0
    Width = 496
    Height = 97
    Align = alTop
    ItemHeight = 13
    TabOrder = 0
    OnClick = lstListClick
  end
  object MainMenu1: TMainMenu
    Left = 264
    Top = 108
    object File1: TMenuItem
      Caption = '&File'
      object Saveas1: TMenuItem
        Action = acSaveAs
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object LaunchinAgent1: TMenuItem
        Action = acAgentDDE
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object LaunchinAgent2: TMenuItem
        Action = acMainForm
      end
      object Exit1: TMenuItem
        Action = acExit
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object Cut1: TMenuItem
        Action = acCut
      end
      object Copy1: TMenuItem
        Action = acCopy
      end
      object Paste1: TMenuItem
        Action = acPaste
      end
      object Delete1: TMenuItem
        Action = acDelete
      end
      object Selectall1: TMenuItem
        Action = acSelectAll
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Removeselecteditem1: TMenuItem
        Action = acRemoveItem
      end
    end
  end
  object ActionList1: TActionList
    Left = 300
    Top = 108
    object acExit: TAction
      Category = 'File'
      Caption = 'E&xit'
      OnExecute = acExitExecute
    end
    object acSaveAs: TAction
      Category = 'File'
      Caption = '&Save as ...'
      ShortCut = 16467
      OnExecute = acSaveAsExecute
    end
    object acCut: TAction
      Category = 'Edit'
      Caption = 'Cut'
      ShortCut = 16472
      OnExecute = acCutExecute
    end
    object acCopy: TAction
      Category = 'Edit'
      Caption = '&Copy'
      ShortCut = 16451
      OnExecute = acCopyExecute
    end
    object acPaste: TAction
      Category = 'Edit'
      Caption = '&Paste'
      ShortCut = 16470
      OnExecute = acPasteExecute
    end
    object acDelete: TAction
      Category = 'Edit'
      Caption = 'Delete'
      ShortCut = 16430
      OnExecute = acDeleteExecute
    end
    object acSelectAll: TAction
      Category = 'Edit'
      Caption = 'Select &all'
      ShortCut = 16449
      OnExecute = acSelectAllExecute
    end
    object acAgentDDE: TAction
      Category = 'File'
      Caption = 'Launch in Agent ...'
      Enabled = False
      ShortCut = 16455
      OnExecute = acAgentDDEExecute
    end
    object acRemoveItem: TAction
      Category = 'Edit'
      Caption = 'Remove selected item'
      ShortCut = 16466
      OnExecute = acRemoveItemExecute
    end
    object acMainForm: TAction
      Caption = 'Return to main window'
      OnExecute = acMainFormExecute
    end
  end
end
