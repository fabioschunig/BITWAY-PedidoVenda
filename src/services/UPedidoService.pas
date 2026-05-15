unit UPedidoService;

interface

uses
  UPedido, UPedidoItem;

type
  TPedidoService = class
  public
    procedure Validar(APedido: TPedido);
    procedure Gravar(APedido: TPedido);
    function Carregar(const iNumeroPedido: Integer): TPedido;
    procedure Cancelar(const iNumeroPedido: Integer);
  end;

implementation

uses
  System.SysUtils,
  UClienteRepository,
  UProdutoRepository,
  UPedidoRepository;

{ TPedidoService }

procedure TPedidoService.Validar(APedido: TPedido);
var
  aItem: TPedidoItem;
begin
  if APedido = nil then
    raise Exception.Create('Pedido não informado');

  if APedido.CodigoCliente <= 0 then
    raise Exception.Create('Informe o cliente');

  if not TClienteRepository.ValidarSeExiste(APedido.CodigoCliente) then
    raise Exception.CreateFmt('Cliente %d não encontrado', [APedido.CodigoCliente]);

  if APedido.Itens.Count = 0 then
    raise Exception.Create('Pedido sem itens');

  for aItem in APedido.Itens do
  begin
    if not TProdutoRepository.ValidarSeExiste(aItem.CodigoProduto) then
      raise Exception.CreateFmt('Produto %d não encontrado', [aItem.CodigoProduto]);
  end;

  APedido.AtualizarTotal;

  if APedido.ValorTotal <= 0 then
    raise Exception.Create('Valor total inválido');
end;

procedure TPedidoService.Gravar(APedido: TPedido);
begin
  Validar(APedido);

  TPedidoRepository.Salvar(APedido);
end;

function TPedidoService.Carregar(const iNumeroPedido: Integer): TPedido;
begin
  Result := TPedidoRepository.Carregar(iNumeroPedido);

  if Result = nil then
    raise Exception.Create('Pedido não encontrado');
end;

procedure TPedidoService.Cancelar(const iNumeroPedido: Integer);
begin
  if iNumeroPedido <= 0 then
    raise Exception.Create('Número do pedido inválido');

  TPedidoRepository.Excluir(iNumeroPedido);
end;

end.
