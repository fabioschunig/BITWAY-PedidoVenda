unit UClienteRepository;

interface

uses
  uCliente;

type
  TClienteRepository = class
  public
    class function ObterPorCodigo(const iCodigo: Integer): TCliente;
  end;

implementation

uses
  System.SysUtils,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  uDM;

{ TClienteRepository }

class function TClienteRepository.ObterPorCodigo(const iCodigo: Integer): TCliente;
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
      '  CODIGO, NOME, CIDADE, UF ' +
      'FROM CLIENTE ' +
      'WHERE CODIGO = :CODIGO';

    aQuery.ParamByName('CODIGO').AsInteger := iCodigo;

    aQuery.Open;

    if aQuery.IsEmpty then
      Exit;

    Result := TCliente.Create;
    Result.Codigo := aQuery.FieldByName('CODIGO').AsInteger;
    Result.Nome := aQuery.FieldByName('NOME').AsString;
    Result.Cidade := aQuery.FieldByName('CIDADE').AsString;
    Result.UF := aQuery.FieldByName('UF').AsString;
  finally
    aQuery.Free;
  end;
end;

end.
