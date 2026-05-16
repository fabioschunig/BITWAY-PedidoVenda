unit UProdutoService;

interface

uses
  UProduto;

type
  TProdutoService = class
  public
    class function Carregar(const iCodigo: Integer): TProduto;
  end;

implementation

uses
  System.SysUtils,
  UProdutoRepository;

{ TProdutoService }

class function TProdutoService.Carregar(const iCodigo: Integer): TProduto;
begin
  Result := TProdutoRepository.ObterPorCodigo(iCodigo);

  if Result = nil then
    raise Exception.Create('Produto não encontrado');
end;

end.
