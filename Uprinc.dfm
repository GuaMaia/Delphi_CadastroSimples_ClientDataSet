object Fprinc: TFprinc
  Left = 0
  Top = 0
  Caption = 'Principal'
  ClientHeight = 222
  ClientWidth = 445
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 24
    Top = 16
    object Cadastrodeunidademedida1: TMenuItem
      Caption = 'Cadastro'
      object UnidadeMedida1: TMenuItem
        Caption = 'Unidade Medida'
        OnClick = UnidadeMedida1Click
      end
      object CadastrodeProduto1: TMenuItem
        Caption = 'Cadastro de Produto'
        OnClick = CadastrodeProduto1Click
      end
    end
    object Sair1: TMenuItem
      Caption = 'Sair'
      OnClick = Sair1Click
    end
  end
end
