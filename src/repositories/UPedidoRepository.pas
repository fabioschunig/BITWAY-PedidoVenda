unit UPedidoRepository;

interface

uses
  uPedido, uPedidoItem;

type
  TPedidoRepository = class
  private
    class procedure SalvarPedido(APedido: TPedido);
    class procedure SalvarItem(const iNumeroPedido: Integer;
      APedidoItem: TPedidoItem);
  public
    class function GerarNumeroPedido: Integer;
    class procedure Salvar(APedido: TPedido);
    class function Carregar(const iNumeroPedido: Integer): TPedido;
    class procedure Excluir(const iNumeroPedido: Integer);
  end;

implementation

uses
  System.SysUtils,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  FireDAC.DApt,
  uDM;

{ TPedidoRepository }

class function TPedidoRepository.GerarNumeroPedido: Integer;
var
  aQuery: TFDQuery;
begin
  aQuery := TFDQuery.Create(nil);
  try
    aQuery.Connection := fDM.FDConnection;

    aQuery.SQL.Text :=
      'SELECT NEXT VALUE FOR SEQ_PEDIDO AS NUMERO ' +
      'FROM RDB$DATABASE';

    aQuery.Open;

    Result := aQuery.FieldByName('NUMERO').AsInteger;
  finally
    aQuery.Free;
  end;
end;

class procedure TPedidoRepository.SalvarPedido(APedido: TPedido);
var
  aQuery: TFDQuery;
begin
  aQuery := TFDQuery.Create(nil);
  try
    aQuery.Connection := fDM.FDConnection;

    aQuery.SQL.Text :=
      'INSERT INTO PEDIDO (' +
      '  NUMERO_PEDIDO, ' +
      '  DATA_EMISSAO, ' +
      '  CODIGO_CLIENTE, ' +
      '  VALOR_TOTAL ' +
      ') VALUES (' +
      '  :NUMERO_PEDIDO, ' +
      '  :DATA_EMISSAO, ' +
      '  :CODIGO_CLIENTE, ' +
      '  :VALOR_TOTAL ' +
      ')';

    aQuery.ParamByName('NUMERO_PEDIDO').AsInteger :=
      APedido.NumeroPedido;

    aQuery.ParamByName('DATA_EMISSAO').AsDateTime :=
      APedido.DataEmissao;

    aQuery.ParamByName('CODIGO_CLIENTE').AsInteger :=
      APedido.CodigoCliente;

    aQuery.ParamByName('VALOR_TOTAL').AsCurrency :=
      APedido.ValorTotal;

    aQuery.ExecSQL;
  finally
    aQuery.Free;
  end;
end;

class procedure TPedidoRepository.SalvarItem(const iNumeroPedido: Integer;
    APedidoItem: TPedidoItem);
var
  aQuery: TFDQuery;
begin
  aQuery := TFDQuery.Create(nil);
  try
    aQuery.Connection := fDM.FDConnection;

    aQuery.SQL.Text :=
      'INSERT INTO PEDIDO_ITEM (' +
      '  NUMERO_PEDIDO, ' +
      '  CODIGO_PRODUTO, ' +
      '  QUANTIDADE, ' +
      '  VLR_UNITARIO, ' +
      '  VLR_TOTAL ' +
      ') VALUES (' +
      '  :NUMERO_PEDIDO, ' +
      '  :CODIGO_PRODUTO, ' +
      '  :QUANTIDADE, ' +
      '  :VLR_UNITARIO, ' +
      '  :VLR_TOTAL ' +
      ')';

    aQuery.ParamByName('NUMERO_PEDIDO').AsInteger := iNumeroPedido;

    aQuery.ParamByName('CODIGO_PRODUTO').AsInteger :=
      APedidoItem.CodigoProduto;

    aQuery.ParamByName('QUANTIDADE').AsFloat :=
      APedidoItem.Quantidade;

    aQuery.ParamByName('VLR_UNITARIO').AsCurrency :=
      APedidoItem.VlrUnitario;

    aQuery.ParamByName('VLR_TOTAL').AsCurrency :=
      APedidoItem.VlrTotal;

    aQuery.ExecSQL;
  finally
    aQuery.Free;
  end;
end;

class procedure TPedidoRepository.Salvar(APedido: TPedido);
var
  aItem: TPedidoItem;
begin
  fDM.FDConnection.StartTransaction;

  try
    if APedido.NumeroPedido = 0 then
      APedido.NumeroPedido := GerarNumeroPedido;

    // PEDIDO
    aPedido.AtualizarTotal;
    SalvarPedido(APedido);

    // ITENS
    for aItem in APedido.Itens do
      SalvarItem(APedido.NumeroPedido, aItem);

    fDM.FDConnection.Commit;
  except
    fDM.FDConnection.Rollback;
    raise;
  end;
end;

class function TPedidoRepository.Carregar(const iNumeroPedido: Integer): TPedido;
var
  aPedidoQuery: TFDQuery;
  aItemQuery: TFDQuery;
  aItem: TPedidoItem;
begin
  Result := nil;

  if iNumeroPedido <= 0 then
    Exit;

  aPedidoQuery := TFDQuery.Create(nil);
  aItemQuery := TFDQuery.Create(nil);
  try
    aPedidoQuery.Connection := fDM.FDConnection;
    aItemQuery.Connection := fDM.FDConnection;

    // PEDIDO
    aPedidoQuery.SQL.Text :=
      'SELECT ' +
      '  NUMERO_PEDIDO, DATA_EMISSAO, CODIGO_CLIENTE, VALOR_TOTAL ' +
      'FROM PEDIDO ' +
      'WHERE NUMERO_PEDIDO = :NUMERO';

    aPedidoQuery.ParamByName('NUMERO').AsInteger := iNumeroPedido;

    aPedidoQuery.Open;

    if aPedidoQuery.IsEmpty then
      Exit;

    Result := TPedido.Create;

    Result.NumeroPedido := aPedidoQuery.FieldByName('NUMERO_PEDIDO').AsInteger;
    Result.DataEmissao := aPedidoQuery.FieldByName('DATA_EMISSAO').AsDateTime;
    Result.CodigoCliente := aPedidoQuery.FieldByName('CODIGO_CLIENTE').AsInteger;

    // ITENS
    aItemQuery.SQL.Text :=
      'SELECT ' +
      '  PI.ID, PI.NUMERO_PEDIDO, ' +
      '  PI.CODIGO_PRODUTO, P.DESCRICAO, ' +
      '  PI.QUANTIDADE, PI.VLR_UNITARIO ' +
      'FROM PEDIDO_ITEM PI ' +
      'INNER JOIN PRODUTO P ' +
      '  ON P.CODIGO = PI.CODIGO_PRODUTO ' +
      'WHERE PI.NUMERO_PEDIDO = :NUMERO';

    aItemQuery.ParamByName('NUMERO').AsInteger := iNumeroPedido;

    aItemQuery.Open;

    while not aItemQuery.Eof do
    begin
      aItem := TPedidoItem.Create;

      aItem.ID := aItemQuery.FieldByName('ID').AsInteger;
      aItem.CodigoProduto := aItemQuery.FieldByName('CODIGO_PRODUTO').AsInteger;
      aItem.DescricaoProduto := aItemQuery.FieldByName('DESCRICAO').AsString;
      aItem.Quantidade := aItemQuery.FieldByName('QUANTIDADE').AsFloat;
      aItem.VlrUnitario := aItemQuery.FieldByName('VLR_UNITARIO').AsCurrency;

      Result.Itens.Add(aItem);

      aItemQuery.Next;
    end;

    Result.AtualizarTotal;
  finally
    aPedidoQuery.Free;
    aItemQuery.Free;
  end;
end;

class procedure TPedidoRepository.Excluir(const iNumeroPedido: Integer);
var
  aQuery: TFDQuery;
begin
  if iNumeroPedido <= 0 then
    Exit;

  fDM.FDConnection.StartTransaction;

  try
    aQuery := TFDQuery.Create(nil);
    try
      aQuery.Connection := fDM.FDConnection;

      aQuery.SQL.Text :=
        'DELETE FROM PEDIDO_ITEM ' +
        'WHERE NUMERO_PEDIDO = :NUMERO';
      aQuery.ParamByName('NUMERO').AsInteger := iNumeroPedido;
      aQuery.ExecSQL;

      aQuery.SQL.Text :=
        'DELETE FROM PEDIDO ' +
        'WHERE NUMERO_PEDIDO = :NUMERO';
      aQuery.ParamByName('NUMERO').AsInteger := iNumeroPedido;
      aQuery.ExecSQL;

      fDM.FDConnection.Commit;
    finally
      aQuery.Free;
    end;
  except
    fDM.FDConnection.Rollback;
    raise;
  end;
end;

end.
