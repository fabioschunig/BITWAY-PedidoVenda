unit UClienteRepository;

interface

uses
  Data.DB,
  FireDAC.Comp.Client,
  URepositoryBase,
  UCliente;

type
  TClienteRepository = class(TRepositoryBase<TCliente>)
  protected
    class function GetColumns: string; override;
    class function GetTableName: string; override;
    class function GetPrimaryKey: string; override;

    class function MapEntity(aQuery: TFDQuery): TCliente; override;
  end;

implementation

uses
  System.SysUtils,
  FireDAC.Stan.Param,
  UDM;

{ TClienteRepository }

class function TClienteRepository.GetColumns: string;
begin
  Result := 'CODIGO, NOME, CIDADE, UF';
end;

class function TClienteRepository.GetTableName: string;
begin
  Result := 'CLIENTE';
end;

class function TClienteRepository.GetPrimaryKey: string;
begin
  Result := 'CODIGO';
end;

class function TClienteRepository.MapEntity(aQuery: TFDQuery): TCliente;
begin
  Result := TCliente.Create;

  Result.Codigo := aQuery.FieldByName('CODIGO').AsInteger;
  Result.Nome := aQuery.FieldByName('NOME').AsString;
  Result.Cidade := aQuery.FieldByName('CIDADE').AsString;
  Result.UF := aQuery.FieldByName('UF').AsString;
end;

end.
