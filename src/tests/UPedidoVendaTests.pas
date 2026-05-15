unit UPedidoVendaTests;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TPedidoVendaTests = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  end;

implementation

procedure TPedidoVendaTests.Setup;
begin
end;

procedure TPedidoVendaTests.TearDown;
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TPedidoVendaTests);

end.
