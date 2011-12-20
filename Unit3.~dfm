object MainForm: TMainForm
  Left = 333
  Top = 342
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Capture The Flag'
  ClientHeight = 569
  ClientWidth = 775
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClick = FormClick
  OnClose = FormClose
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
    Width = 219
    Height = 37
    Caption = 'RedLifeCaption'
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object BlueLifeCaption: TLabel
    Left = 8
    Top = 516
    Width = 225
    Height = 37
    Caption = 'BlueLifeCaption'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object EnemyPlayerLabel: TLabel
    Left = 448
    Top = 208
    Width = 196
    Height = 37
    Caption = 'Red Player is:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
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
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object eventLabel: TLabel
    Left = 448
    Top = 16
    Width = 313
    Height = 113
    AutoSize = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
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
  object BluePlayerName: TEdit
    Left = 448
    Top = 320
    Width = 121
    Height = 21
    MaxLength = 10
    TabOrder = 0
    Text = 'Blue Player'
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
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object ServerChoice1: TMenuItem
      Caption = 'Server Choice'
      object Server1: TMenuItem
        Caption = 'Server'
        OnClick = Server1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object Instructions1: TMenuItem
        Caption = 'Instructions'
        OnClick = Instructions1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Caption = 'About...'
        OnClick = About1Click
      end
    end
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnRead = ClientSocket1Read
    OnError = ClientSocket1Error
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
  object blueAITimer: TTimer
    Enabled = False
    Interval = 250
    OnTimer = blueAITimerTimer
    Left = 128
  end
  object PositionTimer: TTimer
    Interval = 50
    OnTimer = PositionTimerTimer
    Left = 160
  end
  object eventTimer: TTimer
    Interval = 3000
    OnTimer = eventTimerTimer
    Left = 192
  end
end
