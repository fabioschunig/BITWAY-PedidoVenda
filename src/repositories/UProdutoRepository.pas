unit UProdutoRepository;

interface

uses
  uProduto;

type
  TProdutoRepository = class
  public
    class function ObterPorCodigo(const iCodigo: Integer): TProduto;
    class function ValidarSeExiste(const iCodigo: Integer): Boolean;
  end;

implementation

uses
  System.SysUtils,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  uDM;

{ TProdutoRepository }

class function TProdutoRepository.ObterPorCodigo(const iCodigo: Integer): TProduto;
var
  aQuery: TFDQuery;
begin
  Result := nil;

  if iCodigo <= 0 then
    Exit;

  aQuery := TFDQuery.Create(nil);
  try
    aQuery.Connection := fDM.FDConnection;

    aQuery.SQL.Text :=
      'SELECT ' +
      '  CODIGO, DESCRICAO, PRECO_VENDA ' +
      'FROM PRODUTO ' +
      'WHERE CODIGO = :CODIGO';

    aQuery.ParamByName('CODIGO').AsInteger := iCodigo;

    aQuery.Open;

    if aQuery.IsEmpty then
      Exit;

    Result := TProduto.Create;
    Result.Codigo := aQuery.FieldByName('CODIGO').AsInteger;
    Result.Descricao := aQuery.FieldByName('DESCRICAO').AsString;
    Result.PrecoVenda := aQuery.FieldByName('PRECO_VENDA').AsCurrency;
  finally
    aQuery.Free;
  end;
end;

class function TProdutoRepository.ValidarSeExiste(const iCodigo: Integer): Boolean;
var
  aProduto: TProduto;
begin
  aProduto := nil;
  try
    aProduto := ObterPorCodigo(iCodigo);
    Result := aProduto <> nil;
  finally
    aProduto.Free;
  end;
end;

end.
