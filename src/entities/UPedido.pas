unit UPedido;

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  UEntityBase,
  UPedidoItem;

type
  TPedido = class(TEntityBase)
  private
    FNumeroPedido: Integer;
    FDataEmissao: TDateTime;
    FCodigoCliente: Integer;
    FNomeCliente: string;
    FCidade: string;
    FUF: string;
    FObservacao: string;
    FValorTotal: Currency;

    FItens: TObjectList<TPedidoItem>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AtualizarTotal;

    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;
    property NomeCliente: string read FNomeCliente write FNomeCliente;
    property Cidade: string read FCidade write FCidade;
    property UF: string read FUF write FUF;
    property Observacao: string read FObservacao write FObservacao;
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

procedure TPedido.AtualizarTotal;
var
  aItem: TPedidoItem;
begin
  FValorTotal := 0;

  for aItem in FItens do
    FValorTotal := FValorTotal + aItem.VlrTotal;
end;

end.
