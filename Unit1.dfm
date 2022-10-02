object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Merlin32 source file to Merlin 8/16 source file'
  ClientHeight = 262
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 72
    Width = 50
    Height = 13
    Caption = 'Input file :'
  end
  object Label2: TLabel
    Left = 16
    Top = 99
    Width = 58
    Height = 13
    Caption = 'Output file :'
  end
  object Label3: TLabel
    Left = 192
    Top = 32
    Width = 211
    Height = 13
    Caption = 'Drag a Merlin32 source file over this window'
  end
  object Edit1: TEdit
    Left = 87
    Top = 69
    Width = 482
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 192
    Top = 144
    Width = 217
    Height = 41
    Caption = 'Convert'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 87
    Top = 96
    Width = 482
    Height = 21
    TabOrder = 2
  end
  object ProgressBar1: TProgressBar
    Left = 87
    Top = 215
    Width = 482
    Height = 17
    TabOrder = 3
    Visible = False
  end
end
