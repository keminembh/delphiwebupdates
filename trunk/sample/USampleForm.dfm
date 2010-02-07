object SampleForm: TSampleForm
  Left = 0
  Top = 0
  Caption = 'SampleForm'
  ClientHeight = 84
  ClientWidth = 267
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblVersao: TLabel
    Left = 8
    Top = 8
    Width = 53
    Height = 13
    Color = clBlue
    ParentColor = False
  end
  object lblCurrentVersion: TLabel
    Left = 8
    Top = 63
    Width = 82
    Height = 13
    Caption = 'lblCurrentVersion'
  end
  object btnVersao: TButton
    Left = 8
    Top = 27
    Width = 75
    Height = 25
    Caption = 'Download'
    Enabled = False
    TabOrder = 0
    OnClick = btnVersaoClick
  end
end
