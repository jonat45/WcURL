object ViewPrincipal: TViewPrincipal
  Left = 0
  Top = 0
  Caption = 'Teste WcURL'
  ClientHeight = 392
  ClientWidth = 806
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object btnTesteBasico: TButton
    Left = 16
    Top = 16
    Width = 100
    Height = 25
    Caption = 'Teste b'#225'sico'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnTesteBasicoClick
  end
  object pgctrlRespostas: TPageControl
    Left = 0
    Top = 216
    Width = 806
    Height = 176
    ActivePage = tbshRespostas
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object tbshRespostas: TTabSheet
      Caption = 'Respostas'
      object memResposta: TMemo
        Left = 0
        Top = 0
        Width = 798
        Height = 145
        Align = alClient
        TabOrder = 0
      end
    end
  end
end
