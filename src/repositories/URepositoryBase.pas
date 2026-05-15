unit URepositoryBase;

interface

uses
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  UEntityBase;

type
  TRepositoryBase<T: TEntityBase, constructor> = class
  protected
    class function GetColumns: string; virtual; abstract;
    class function GetTableName: string; virtual; abstract;
    class function GetPrimaryKey: string; virtual; abstract;

    class function MapEntity(AQuery: TFDQuery): T; virtual; abstract;

  public
    class function ObterPorCodigo(const iCodigo: Integer): T;
    class function ValidarSeExiste(const iCodigo: Integer): Boolean;
  end;

implementation

uses
  System.SysUtils,
  UDM;

{ TRepositoryBase<T> }

class function TRepositoryBase<T>.ObterPorCodigo(const iCodigo: Integer): T;
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
      Format(
        'SELECT %s FROM %s WHERE %s = :CODIGO',
        [GetColumns, GetTableName, GetPrimaryKey]
      );

    aQuery.ParamByName('CODIGO').AsInteger :=
      iCodigo;

    aQuery.Open;

    if not aQuery.IsEmpty then
      Result := MapEntity(aQuery);
  finally
    aQuery.Free;
  end;
end;

class function TRepositoryBase<T>.ValidarSeExiste(const iCodigo: Integer): Boolean;
var
  aRegistro: T;
begin
  aRegistro := nil;
  try
    aRegistro := ObterPorCodigo(iCodigo);
    Result := aRegistro <> nil;
  finally
    aRegistro.Free;
  end;
end;

end.
