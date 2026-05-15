unit UPedido;

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  uPedidoItem;

type
  TPedido = class
  private
    FNumeroPedido: Integer;
    FDataEmissao: TDateTime;
    FCodigoCliente: Integer;
    FValorTotal: Currency;

    FItens: TObjectList<TPedidoItem>;

    procedure RecalcularTotal;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AtualizarTotal;

    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;
    property ValorTotal: Currency read FValorTotal;
    property Itens: TObjectList<TPedidoItem> read FItens;
  end;

implementation

{ TPedido }

constructor TPedido.Create;
begin
  FItens := TObjectList<TPedidoItem>.Create(True);
  FValorTotal := 0;
  FDataEmissao := Now;
end;

destructor TPedido.Destroy;
begin
  FItens.Free;

  inherited;
end;

procedure TPedido.RecalcularTotal;
var
  aItem: TPedidoItem;
begin
  FValorTotal := 0;

  for aItem in FItens do
    FValorTotal := FValorTotal + aItem.VlrTotal;
end;

procedure TPedido.AtualizarTotal;
begin
  RecalcularTotal;
end;

end.
