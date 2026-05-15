unit UProdutoRepository;

interface

uses
  Data.DB,
  FireDAC.Comp.Client,
  URepositoryBase,
  UProduto;

type
  TProdutoRepository = class(TRepositoryBase<TProduto>)
  protected
    class function GetColumns: string; override;
    class function GetTableName: string; override;
    class function GetPrimaryKey: string; override;

    class function MapEntity(aQuery: TFDQuery): TProduto; override;
  end;

implementation

uses
  System.SysUtils,
  FireDAC.Stan.Param,
  UDM;

{ TProdutoRepository }

class function TProdutoRepository.GetColumns: string;
begin
  Result := 'CODIGO, DESCRICAO, PRECO_VENDA';
end;

class function TProdutoRepository.GetTableName: string;
begin
  Result := 'PRODUTO';
end;

class function TProdutoRepository.GetPrimaryKey: string;
begin
  Result := 'CODIGO';
end;

class function TProdutoRepository.MapEntity(aQuery: TFDQuery): TProduto;
begin
  Result := TProduto.Create;

  Result.Codigo := aQuery.FieldByName('CODIGO').AsInteger;
  Result.Descricao := aQuery.FieldByName('DESCRICAO').AsString;
  Result.PrecoVenda := aQuery.FieldByName('PRECO_VENDA').AsCurrency;
end;

end.
