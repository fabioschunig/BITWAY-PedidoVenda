unit UClienteService;

interface

uses
  UCliente;

type
  TClienteService = class
  public
    class function Carregar(const iCodigo: Integer): TCliente;
  end;

implementation

uses
  System.SysUtils,
  UClienteRepository;

{ TClienteService }

class function TClienteService.Carregar(const iCodigo: Integer): TCliente;
begin
  Result := TClienteRepository.ObterPorCodigo(iCodigo);

  if Result = nil then
    raise Exception.Create('Cliente não encontrado');
end;

end.
