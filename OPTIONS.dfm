object Form2: TForm2
  Left = 226
  Top = 251
  BorderStyle = bsDialog
  Caption = 'Configuration'
  ClientHeight = 417
  ClientWidth = 579
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 579
    Height = 376
    ActivePage = tsMisc
    Align = alClient
    TabOrder = 0
    object tsDatabase: TTabSheet
      Caption = 'Database'
      object grpSetup: TGroupBox
        Left = 0
        Top = 4
        Width = 277
        Height = 269
        Caption = 'Setup'
        TabOrder = 0
        object txtPath: TEdit
          Left = 72
          Top = 16
          Width = 177
          Height = 21
          CharCase = ecLowerCase
          MaxLength = 256
          TabOrder = 1
          Text = 'hamster.app'
          OnExit = txtPathExit
        end
        object txtPath1: TEdit
          Left = 72
          Top = 40
          Width = 177
          Height = 21
          CharCase = ecLowerCase
          MaxLength = 256
          TabOrder = 3
        end
        object txtPath2: TEdit
          Left = 72
          Top = 64
          Width = 177
          Height = 21
          CharCase = ecLowerCase
          MaxLength = 256
          TabOrder = 5
        end
        object txtPath3: TEdit
          Left = 72
          Top = 88
          Width = 177
          Height = 21
          CharCase = ecLowerCase
          MaxLength = 256
          TabOrder = 7
        end
        object txtPath4: TEdit
          Left = 72
          Top = 112
          Width = 177
          Height = 21
          CharCase = ecLowerCase
          MaxLength = 256
          TabOrder = 9
        end
        object txtPath5: TEdit
          Left = 72
          Top = 136
          Width = 177
          Height = 21
          CharCase = ecLowerCase
          MaxLength = 256
          TabOrder = 11
        end
        object txtPath6: TEdit
          Left = 72
          Top = 160
          Width = 177
          Height = 21
          CharCase = ecLowerCase
          MaxLength = 256
          TabOrder = 13
        end
        object txtPath7: TEdit
          Left = 72
          Top = 184
          Width = 177
          Height = 21
          CharCase = ecLowerCase
          MaxLength = 256
          TabOrder = 15
        end
        object chkPath0: TCheckBox
          Left = 12
          Top = 20
          Width = 59
          Height = 17
          Caption = 'OLE &0:'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = chkPath0Click
        end
        object chkPath1: TCheckBox
          Left = 12
          Top = 44
          Width = 59
          Height = 17
          Caption = 'OLE &1:'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object chkPath2: TCheckBox
          Left = 12
          Top = 68
          Width = 59
          Height = 17
          Caption = 'OLE &2:'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object chkPath3: TCheckBox
          Left = 12
          Top = 92
          Width = 59
          Height = 17
          Caption = 'OLE &3:'
          Checked = True
          State = cbChecked
          TabOrder = 6
        end
        object chkPath4: TCheckBox
          Left = 12
          Top = 116
          Width = 59
          Height = 17
          Caption = 'OLE &4:'
          Checked = True
          State = cbChecked
          TabOrder = 8
        end
        object chkPath5: TCheckBox
          Left = 12
          Top = 140
          Width = 59
          Height = 17
          Caption = 'OLE &5:'
          Checked = True
          State = cbChecked
          TabOrder = 10
        end
        object chkPath6: TCheckBox
          Left = 12
          Top = 164
          Width = 59
          Height = 17
          Caption = 'OLE &6:'
          Checked = True
          State = cbChecked
          TabOrder = 12
        end
        object chkPath7: TCheckBox
          Left = 12
          Top = 188
          Width = 59
          Height = 17
          Caption = 'OLE &7:'
          Checked = True
          State = cbChecked
          TabOrder = 14
        end
      end
    end
    object tsVis: TTabSheet
      Caption = 'Visualisation'
      ImageIndex = 1
      object grpDisplay: TGroupBox
        Left = 28
        Top = 4
        Width = 277
        Height = 112
        Caption = 'Display-preferences'
        TabOrder = 0
        object Label2: TLabel
          Left = 11
          Top = 35
          Width = 52
          Height = 13
          Caption = 'Article text:'
          FocusControl = chkShowHdr
        end
        object Label5: TLabel
          Left = 11
          Top = 15
          Width = 48
          Height = 13
          Caption = 'Result list:'
          FocusControl = chkShowGrpNam
        end
        object Label6: TLabel
          Left = 12
          Top = 84
          Width = 53
          Height = 13
          Caption = 'Article font:'
          FocusControl = txtFont
        end
        object chkShowHdr: TCheckBox
          Left = 88
          Top = 36
          Width = 69
          Height = 13
          Caption = 'Header'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = chkShowHdrClick
        end
        object chkShowBody: TCheckBox
          Left = 88
          Top = 49
          Width = 69
          Height = 13
          Caption = 'Body'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = chkShowHdrClick
        end
        object chkShowSig: TCheckBox
          Left = 88
          Top = 62
          Width = 69
          Height = 13
          Caption = 'Signature'
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = chkShowHdrClick
        end
        object chkShowGrpNam: TCheckBox
          Left = 88
          Top = 16
          Width = 114
          Height = 14
          Caption = 'Short group names'
          TabOrder = 0
          OnClick = chkShowGrpNamClick
        end
        object txtFont: TEdit
          Left = 88
          Top = 81
          Width = 161
          Height = 21
          MaxLength = 256
          ReadOnly = True
          TabOrder = 4
        end
        object cmdFont: TButton
          Left = 256
          Top = 81
          Width = 13
          Height = 21
          Caption = '...'
          TabOrder = 5
          OnClick = cmdFontClick
        end
      end
      object chk3DChart: TCheckBox
        Left = 360
        Top = 16
        Width = 113
        Height = 24
        Caption = 'Show Chart in 3D'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = chk3DChartClick
      end
    end
    object tsMisc: TTabSheet
      Caption = 'Misc'
      ImageIndex = 2
      object Label3: TLabel
        Left = 12
        Top = 218
        Width = 49
        Height = 13
        Caption = 'Timezone:'
        FocusControl = txtGMT
      end
      object Label1: TLabel
        Left = 156
        Top = 218
        Width = 67
        Height = 13
        Caption = '(GMT +/- hrs.)'
      end
      object grpFind: TGroupBox
        Left = 4
        Top = 16
        Width = 277
        Height = 153
        Caption = 'Find-preferences'
        TabOrder = 0
        object Label7: TLabel
          Left = 12
          Top = 44
          Width = 33
          Height = 13
          Caption = 'Ignore:'
        end
        object Label15: TLabel
          Left = 12
          Top = 128
          Width = 65
          Height = 13
          Caption = 'Progress-rate:'
          FocusControl = txtProgressRate
        end
        object Label10: TLabel
          Left = 12
          Top = 100
          Width = 69
          Height = 13
          Caption = 'Regex-default:'
          FocusControl = chkREIgnoreCase
        end
        object chkIgnoreFolders: TCheckBox
          Left = 88
          Top = 76
          Width = 181
          Height = 14
          Caption = 'Mail-Folders'
          Enabled = False
          TabOrder = 0
          OnClick = chkIgnoreFoldersClick
        end
        object txtProgressRate: TEdit
          Left = 88
          Top = 124
          Width = 61
          Height = 21
          TabOrder = 2
          OnChange = txtProgressRateChange
        end
        object chkREIgnoreCase: TCheckBox
          Left = 88
          Top = 100
          Width = 181
          Height = 14
          Caption = 'Ignore case'
          TabOrder = 1
          OnClick = chkREIgnoreCaseClick
        end
      end
      object txtGMT: TEdit
        Left = 72
        Top = 214
        Width = 77
        Height = 21
        TabOrder = 1
        OnChange = txtGMTChange
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 376
    Width = 579
    Height = 41
    Align = alBottom
    TabOrder = 1
    object btnOK: TButton
      Left = 176
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Options = [fdEffects, fdForceFontExist]
    Left = 348
    Top = 4
  end
end
