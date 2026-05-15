unit UPedidoItem;

interface

type
  TPedidoItem = class
  private
    FID: Integer;
    FCodigoProduto: Integer;
    FDescricaoProduto: string;
    FQuantidade: Double;
    FVlrUnitario: Currency;
    FVlrTotal: Currency;

    procedure SetQuantidade(const Value: Double);
    procedure SetVlrUnitario(const Value: Currency);

    procedure RecalcularTotal;
  public
    property ID: Integer read FID write FID;
    property CodigoProduto: Integer read FCodigoProduto write FCodigoProduto;
    property DescricaoProduto: string read FDescricaoProduto write FDescricaoProduto;
    property Quantidade: Double read FQuantidade write SetQuantidade;
    property VlrUnitario: Currency read FVlrUnitario write SetVlrUnitario;
    property VlrTotal: Currency read FVlrTotal;
  end;

implementation

{ TPedidoItem }

procedure TPedidoItem.RecalcularTotal;
begin
  FVlrTotal := FQuantidade * FVlrUnitario;
end;

procedure TPedidoItem.SetQuantidade(const Value: Double);
begin
  FQuantidade := Value;
  RecalcularTotal;
end;

procedure TPedidoItem.SetVlrUnitario(const Value: Currency);
begin
  FVlrUnitario := Value;
  RecalcularTotal;
end;

end.
