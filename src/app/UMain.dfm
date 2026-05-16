object fMain: TfMain
  Left = 0
  Top = 0
  Caption = 'BITWAY - Pedido de Venda'
  ClientHeight = 561
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object pnPedido: TPanel
    Left = 0
    Top = 0
    Width = 784
    Height = 99
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 17
      Top = 25
      Width = 57
      Height = 15
      Alignment = taRightJustify
      Caption = 'N'#186' Pedido:'
    end
    object Label2: TLabel
      Left = 613
      Top = 28
      Width = 27
      Height = 15
      Alignment = taRightJustify
      Caption = 'Data:'
    end
    object Label3: TLabel
      Left = 34
      Top = 57
      Width = 40
      Height = 15
      Alignment = taRightJustify
      Caption = 'Cliente:'
    end
    object edNumeroPedido: TEdit
      Left = 80
      Top = 22
      Width = 121
      Height = 23
      TabOrder = 0
    end
    object bCarregarPedido: TButton
      Left = 224
      Top = 21
      Width = 121
      Height = 25
      Caption = 'Carregar Pedido'
      TabOrder = 1
      OnClick = bCarregarPedidoClick
    end
    object edDataEmissao: TDateTimePicker
      Left = 646
      Top = 25
      Width = 123
      Height = 23
      Date = 46157.000000000000000000
      Time = 0.881701770835206800
      TabOrder = 2
    end
    object edCodigoCliente: TEdit
      Left = 80
      Top = 54
      Width = 121
      Height = 23
      TabOrder = 3
      OnExit = edCodigoClienteExit
    end
    object edNomeCliente: TEdit
      Left = 224
      Top = 54
      Width = 281
      Height = 23
      TabStop = False
      Enabled = False
      TabOrder = 4
    end
    object edCidade: TEdit
      Left = 511
      Top = 54
      Width = 195
      Height = 23
      TabStop = False
      Enabled = False
      TabOrder = 5
    end
    object edUF: TEdit
      Left = 712
      Top = 54
      Width = 57
      Height = 23
      TabStop = False
      Enabled = False
      TabOrder = 6
    end
  end
  object pnItem: TPanel
    Left = 0
    Top = 99
    Width = 784
    Height = 94
    Align = alTop
    TabOrder = 1
    object Label4: TLabel
      Left = 28
      Top = 17
      Width = 46
      Height = 15
      Alignment = taRightJustify
      Caption = 'Produto:'
    end
    object Label5: TLabel
      Left = 45
      Top = 49
      Width = 29
      Height = 15
      Alignment = taRightJustify
      Caption = 'Qtde:'
    end
    object Label6: TLabel
      Left = 228
      Top = 49
      Width = 54
      Height = 15
      Alignment = taRightJustify
      Caption = 'Valor Unit:'
    end
    object Label7: TLabel
      Left = 440
      Top = 49
      Width = 58
      Height = 15
      Alignment = taRightJustify
      Caption = 'Valor Total:'
    end
    object edCodigoProduto: TEdit
      Left = 80
      Top = 14
      Width = 121
      Height = 23
      TabOrder = 0
      OnExit = edCodigoProdutoExit
    end
    object edDescricaoProduto: TEdit
      Left = 224
      Top = 14
      Width = 401
      Height = 23
      TabStop = False
      Enabled = False
      TabOrder = 1
    end
    object bInserirAtualizarItem: TButton
      Left = 640
      Top = 29
      Width = 129
      Height = 25
      Caption = 'Inserir Item'
      TabOrder = 5
      OnClick = bInserirAtualizarItemClick
    end
    object edQuantidade: TEdit
      Left = 80
      Top = 46
      Width = 118
      Height = 23
      Alignment = taRightJustify
      MaxLength = 12
      TabOrder = 2
      Text = '0,00'
      StyleElements = [seBorder]
      OnExit = ValidaCamposItem
      OnKeyPress = ValidaTeclasNumerico
    end
    object edValorUnitario: TEdit
      Left = 288
      Top = 46
      Width = 120
      Height = 23
      Alignment = taRightJustify
      MaxLength = 12
      TabOrder = 3
      Text = '0,00'
      StyleElements = [seBorder]
      OnExit = ValidaCamposItem
      OnKeyPress = ValidaTeclasNumerico
    end
    object edValorTotalItem: TEdit
      Left = 504
      Top = 46
      Width = 121
      Height = 23
      TabStop = False
      Alignment = taRightJustify
      Enabled = False
      TabOrder = 4
      Text = '0,00'
      StyleElements = [seBorder]
    end
  end
  object pnGrid: TPanel
    Left = 0
    Top = 193
    Width = 784
    Height = 311
    Align = alClient
    TabOrder = 2
    object grdItens: TStringGrid
      Left = 1
      Top = 1
      Width = 782
      Height = 309
      Align = alClient
      TabOrder = 0
      OnKeyDown = grdItensKeyDown
    end
  end
  object pnTotal: TPanel
    Left = 0
    Top = 504
    Width = 784
    Height = 57
    Align = alBottom
    TabOrder = 3
    object Label8: TLabel
      Left = 13
      Top = 17
      Width = 69
      Height = 15
      Alignment = taRightJustify
      Caption = 'Total Pedido:'
    end
    object bGravarPedido: TButton
      Left = 260
      Top = 13
      Width = 125
      Height = 25
      Caption = 'Gravar Pedido'
      TabOrder = 1
      OnClick = bGravarPedidoClick
    end
    object bCancelarPedido: TButton
      Left = 452
      Top = 13
      Width = 117
      Height = 25
      Caption = 'Cancelar Pedido'
      TabOrder = 2
      OnClick = bCancelarPedidoClick
    end
    object bNovoPedido: TButton
      Left = 640
      Top = 13
      Width = 129
      Height = 25
      Caption = 'Novo Pedido'
      TabOrder = 3
      OnClick = bNovoPedidoClick
    end
    object edTotalPedido: TEdit
      Left = 88
      Top = 14
      Width = 121
      Height = 23
      TabStop = False
      Alignment = taRightJustify
      Enabled = False
      TabOrder = 0
      Text = '0,00'
      StyleElements = [seBorder]
    end
  end
end
