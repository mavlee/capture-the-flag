object MainForm: TMainForm
  Left = 378
  Top = 272
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Capture the Flag'
  ClientHeight = 569
  ClientWidth = 775
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClick = FormClick
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    Left = 0
    Top = 0
    Width = 360
    Height = 360
  end
  object Label1: TLabel
    Left = 148
    Top = 112
    Width = 48
    Height = 109
    Alignment = taCenter
    AutoSize = False
    Caption = '5'
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -96
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
    Visible = False
  end
  object RedLifeCaption: TLabel
    Left = 8
    Top = 460
    Width = 240
    Height = 37
    Caption = 'Remaining Flags'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object BlueLifeCaption: TLabel
    Left = 8
    Top = 516
    Width = 240
    Height = 37
    Caption = 'Remaining Flags'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object EnemyPlayerLabel: TLabel
    Left = 448
    Top = 208
    Width = 193
    Height = 37
    Caption = 'Blue Player is'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Bearing: TLabel
    Left = 448
    Top = 264
    Width = 110
    Height = 37
    Caption = 'Bearing'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object eventLabel: TLabel
    Left = 451
    Top = 16
    Width = 310
    Height = 129
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object mapNameLabel: TLabel
    Left = 448
    Top = 160
    Width = 267
    Height = 29
    Caption = 'Map: Strategic Battlefield'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object RedPlayerName: TEdit
    Left = 448
    Top = 320
    Width = 121
    Height = 21
    MaxLength = 10
    TabOrder = 0
    Text = 'Red Player'
  end
  object ChatMessage: TEdit
    Left = 448
    Top = 352
    Width = 225
    Height = 21
    TabOrder = 1
    OnKeyDown = ChatMessageKeyDown
  end
  object Send: TButton
    Left = 685
    Top = 352
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 2
    OnClick = SendClick
  end
  object ChatMemo: TMemo
    Left = 448
    Top = 384
    Width = 313
    Height = 177
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object MainMenu1: TMainMenu
    object File1: TMenuItem
      Caption = 'File'
      object New1: TMenuItem
        Caption = 'New'
        OnClick = New1Click
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Settings1: TMenuItem
      Caption = 'Settings'
      object NumberofLives1: TMenuItem
        Caption = 'Number of Flags'
        object N12: TMenuItem
          AutoCheck = True
          Caption = '1'
          RadioItem = True
          OnClick = N12Click
        end
        object N22: TMenuItem
          AutoCheck = True
          Caption = '2'
          RadioItem = True
          OnClick = N22Click
        end
        object N32: TMenuItem
          AutoCheck = True
          Caption = '3'
          Checked = True
          RadioItem = True
          OnClick = N32Click
        end
        object N42: TMenuItem
          AutoCheck = True
          Caption = '4'
          RadioItem = True
          OnClick = N42Click
        end
        object N52: TMenuItem
          AutoCheck = True
          Caption = '5'
          RadioItem = True
          OnClick = N52Click
        end
        object N61: TMenuItem
          AutoCheck = True
          Caption = '6'
          RadioItem = True
          OnClick = N61Click
        end
      end
      object MapChoice1: TMenuItem
        Caption = 'Small Maps'
        object StrategicBattlefield1: TMenuItem
          Caption = 'Strategic Battlefield'
          OnClick = StrategicBattlefield1Click
        end
        object Vortex1: TMenuItem
          Caption = 'Vortex'
          OnClick = Vortex1Click
        end
        object Deathmatch1: TMenuItem
          Caption = 'Deathmatch'
          OnClick = Deathmatch1Click
        end
        object OpenPlains1: TMenuItem
          Caption = 'Open Plains'
          OnClick = OpenPlains1Click
        end
        object Confusion1: TMenuItem
          Caption = 'Confusion'
          OnClick = Confusion1Click
        end
        object Labyrinth1: TMenuItem
          Caption = 'Labyrinth'
          OnClick = Labyrinth1Click
        end
      end
      object MediumMaps1: TMenuItem
        Caption = 'Medium Maps'
        object Disaster1: TMenuItem
          Caption = 'Disaster'
          OnClick = Disaster1Click
        end
        object Torrential1: TMenuItem
          Caption = 'Torrential'
          OnClick = Torrential1Click
        end
        object Stadium1: TMenuItem
          Caption = 'Stadium'
          OnClick = Stadium1Click
        end
      end
      object LargeMaps1: TMenuItem
        Caption = 'Large Maps'
        object Spiral1: TMenuItem
          Caption = 'Spiral'
          OnClick = Spiral1Click
        end
        object Monoworld1: TMenuItem
          Caption = 'Monoworld'
          OnClick = Monoworld1Click
        end
        object Haxed1: TMenuItem
          Caption = 'Haxed'
          OnClick = Haxed1Click
        end
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'Instructions'
        OnClick = About1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object About2: TMenuItem
        Caption = 'About...'
        OnClick = About2Click
      end
    end
  end
  object ServerSocket1: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    ThreadCacheSize = 100
    OnClientConnect = ServerSocket1ClientConnect
    OnClientRead = ServerSocket1ClientRead
    Left = 32
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 64
  end
  object redAITimer: TTimer
    Enabled = False
    Interval = 250
    OnTimer = redAITimerTimer
    Left = 96
  end
  object blueAItimer: TTimer
    Enabled = False
    Interval = 250
    OnTimer = blueAItimerTimer
    Left = 128
  end
  object PositionTimer: TTimer
    Interval = 50
    OnTimer = PositionTimerTimer
    Left = 160
  end
  object EventTimer: TTimer
    Interval = 3000
    OnTimer = EventTimerTimer
    Left = 192
  end
end
