unit UPedidoVendaTests;

interface

uses
  DUnitX.TestFramework,
  UPedido,
  UPedidoItem;

type
  [TestFixture]
  TPedidoVendaTests = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;


    // =================================================
    // ITEM
    // =================================================

    [Test]
    procedure Deve_Calcular_Total_Do_Item;

    [Test]
    procedure Deve_Recalcular_Total_Do_Item_Ao_Alterar_Quantidade;

    [Test]
    procedure Deve_Recalcular_Total_Do_Item_Ao_Alterar_Valor_Unitario;

    [Test]
    procedure Deve_Permitir_Item_Com_Valor_Zero;

    // =================================================
    // PEDIDO
    // =================================================

    [Test]
    procedure Deve_Calcular_Total_Do_Pedido;

    [Test]
    procedure Deve_Recalcular_Total_Ao_Excluir_Item;

    [Test]
    procedure Deve_Permitir_Produtos_Repetidos;

    [Test]
    procedure Deve_Manter_Total_Zero_Sem_Itens;

    [Test]
    procedure Deve_Calcular_Total_Com_Multiplos_Itens;

    [Test]
    procedure Deve_Calcular_Total_Corretamente_Com_Valores_Fracionados;
  end;

implementation

procedure TPedidoVendaTests.Setup;
begin
end;

procedure TPedidoVendaTests.TearDown;
begin
end;


// =====================================================
// ITEM
// =====================================================

procedure TPedidoVendaTests.Deve_Calcular_Total_Do_Item;
var
  aItem: TPedidoItem;
begin
  aItem := TPedidoItem.Create;
  try
    aItem.Quantidade := 2;
    aItem.VlrUnitario := 10;

    Assert.AreEqual(
      Currency(20),
      aItem.VlrTotal,
      'Total do item calculado incorretamente'
    );
  finally
    aItem.Free;
  end;
end;

procedure TPedidoVendaTests.Deve_Recalcular_Total_Do_Item_Ao_Alterar_Quantidade;
var
  aItem: TPedidoItem;
begin
  aItem := TPedidoItem.Create;
  try
    aItem.Quantidade := 1;
    aItem.VlrUnitario := 50;

    Assert.AreEqual(
      Currency(50),
      aItem.VlrTotal
    );

    aItem.Quantidade := 3;

    Assert.AreEqual(
      Currency(150),
      aItem.VlrTotal,
      'Total não foi recalculado após alterar quantidade'
    );
  finally
    aItem.Free;
  end;
end;

procedure TPedidoVendaTests.Deve_Recalcular_Total_Do_Item_Ao_Alterar_Valor_Unitario;
var
  aItem: TPedidoItem;
begin
  aItem := TPedidoItem.Create;
  try
    aItem.Quantidade := 2;
    aItem.VlrUnitario := 10;

    Assert.AreEqual(
      Currency(20),
      aItem.VlrTotal
    );

    aItem.VlrUnitario := 25;

    Assert.AreEqual(
      Currency(50),
      aItem.VlrTotal,
      'Total não foi recalculado após alterar valor unitário'
    );
  finally
    aItem.Free;
  end;
end;

procedure TPedidoVendaTests.Deve_Permitir_Item_Com_Valor_Zero;
var
  aItem: TPedidoItem;
begin
  aItem := TPedidoItem.Create;
  try
    aItem.Quantidade := 2;
    aItem.VlrUnitario := 0;

    Assert.AreEqual(
      Currency(0),
      aItem.VlrTotal
    );
  finally
    aItem.Free;
  end;
end;

// =====================================================
// PEDIDO
// =====================================================

procedure TPedidoVendaTests.Deve_Calcular_Total_Do_Pedido;
var
  aPedido: TPedido;

  aItem1: TPedidoItem;
  aItem2: TPedidoItem;
begin
  aPedido := TPedido.Create;
  try
    aItem1 := TPedidoItem.Create;
    aItem1.Quantidade := 2;
    aItem1.VlrUnitario := 10;

    aItem2 := TPedidoItem.Create;
    aItem2.Quantidade := 3;
    aItem2.VlrUnitario := 5;

    aPedido.Itens.Add(aItem1);
    aPedido.Itens.Add(aItem2);

    aPedido.AtualizarTotal;

    Assert.AreEqual(
      Currency(35),
      aPedido.ValorTotal,
      'Total do pedido calculado incorretamente'
    );
  finally
    aPedido.Free;
  end;
end;

procedure TPedidoVendaTests.Deve_Recalcular_Total_Ao_Excluir_Item;
var
  aPedido: TPedido;

  aItem1: TPedidoItem;
  aItem2: TPedidoItem;
begin
  aPedido := TPedido.Create;
  try
    aItem1 := TPedidoItem.Create;
    aItem1.Quantidade := 1;
    aItem1.VlrUnitario := 100;

    aItem2 := TPedidoItem.Create;
    aItem2.Quantidade := 1;
    aItem2.VlrUnitario := 50;

    aPedido.Itens.Add(aItem1);
    aPedido.Itens.Add(aItem2);

    aPedido.AtualizarTotal;

    Assert.AreEqual(
      Currency(150),
      aPedido.ValorTotal
    );

    aPedido.Itens.Delete(0);

    aPedido.AtualizarTotal;

    Assert.AreEqual(
      Currency(50),
      aPedido.ValorTotal,
      'Total do pedido não foi recalculado após exclusão'
    );
  finally
    aPedido.Free;
  end;
end;

procedure TPedidoVendaTests.Deve_Permitir_Produtos_Repetidos;
var
  aPedido: TPedido;

  aItem1: TPedidoItem;
  aItem2: TPedidoItem;
begin
  aPedido := TPedido.Create;
  try

    aItem1 := TPedidoItem.Create;
    aItem1.CodigoProduto := 1;
    aItem1.Quantidade := 1;
    aItem1.VlrUnitario := 10;

    aItem2 := TPedidoItem.Create;
    aItem2.CodigoProduto := 1;
    aItem2.Quantidade := 2;
    aItem2.VlrUnitario := 10;

    aPedido.Itens.Add(aItem1);
    aPedido.Itens.Add(aItem2);

    Assert.AreEqual(
      2,
      aPedido.Itens.Count,
      'Produtos repetidos não deveriam ser bloqueados'
    );
  finally
    aPedido.Free;
  end;
end;

procedure TPedidoVendaTests.Deve_Manter_Total_Zero_Sem_Itens;
var
  aPedido: TPedido;
begin
  aPedido := TPedido.Create;
  try
    aPedido.AtualizarTotal;

    Assert.AreEqual(
      Currency(0),
      aPedido.ValorTotal,
      'Pedido sem itens deveria possuir total zero'
    );
  finally
    aPedido.Free;
  end;
end;

procedure TPedidoVendaTests.Deve_Calcular_Total_Com_Multiplos_Itens;
var
  aPedido: TPedido;
  i: Integer;

  aItem: TPedidoItem;
begin
  aPedido := TPedido.Create;
  try
    for i := 1 to 10 do
    begin
      aItem := TPedidoItem.Create;

      aItem.Quantidade := 1;
      aItem.VlrUnitario := 10;

      aPedido.Itens.Add(aItem);
    end;

    aPedido.AtualizarTotal;

    Assert.AreEqual(
      Currency(100),
      aPedido.ValorTotal,
      'Total incorreto para múltiplos itens'
    );
  finally
    aPedido.Free;
  end;
end;

procedure TPedidoVendaTests.Deve_Calcular_Total_Corretamente_Com_Valores_Fracionados;
var
  aPedido: TPedido;

  aItem: TPedidoItem;
begin
  aPedido := TPedido.Create;
  try

    aItem := TPedidoItem.Create;

    aItem.Quantidade := 1.5;
    aItem.VlrUnitario := 10.25;

    aPedido.Itens.Add(aItem);

    aPedido.AtualizarTotal;

    Assert.AreEqual(
      Currency(15.375),
      aPedido.ValorTotal,
      0.001,
      'Erro de cálculo com valores fracionados'
    );

  finally
    aPedido.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TPedidoVendaTests);

end.
