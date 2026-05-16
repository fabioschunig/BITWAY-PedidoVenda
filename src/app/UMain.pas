unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Mask, Vcl.Grids,
  UPedido,
  UPedidoService;

type
  TfMain = class(TForm)
    pnPedido: TPanel;
    pnItem: TPanel;
    pnGrid: TPanel;
    pnTotal: TPanel;
    Label1: TLabel;
    edNumeroPedido: TEdit;
    bCarregarPedido: TButton;
    Label2: TLabel;
    edDataEmissao: TDateTimePicker;
    Label3: TLabel;
    edCodigoCliente: TEdit;
    edNomeCliente: TEdit;
    edCidade: TEdit;
    edUF: TEdit;
    Label4: TLabel;
    edCodigoProduto: TEdit;
    edDescricaoProduto: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    bInserirAtualizarItem: TButton;
    grdItens: TStringGrid;
    Label8: TLabel;
    bGravarPedido: TButton;
    bCancelarPedido: TButton;
    bNovoPedido: TButton;
    edQuantidade: TEdit;
    edValorUnitario: TEdit;
    edValorTotalItem: TEdit;
    edTotalPedido: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edCodigoClienteExit(Sender: TObject);
    procedure edCodigoProdutoExit(Sender: TObject);
    procedure ValidaTeclasNumerico(Sender: TObject; var Key: Char);
    procedure ValidaCamposItem(Sender: TObject);
    procedure bCarregarPedidoClick(Sender: TObject);
    procedure bNovoPedidoClick(Sender: TObject);
    procedure bCancelarPedidoClick(Sender: TObject);
    procedure bGravarPedidoClick(Sender: TObject);
    procedure bInserirAtualizarItemClick(Sender: TObject);
    procedure grdItensKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FPedido: TPedido;
    FEditingItemID: Integer;

    procedure ConfigurarGrid;

    procedure BuscarCliente(const sCodigo: string);
    procedure BuscarProduto(const sCodigo: string);

    procedure CarregarPedido(const sCodigo: string);
    procedure NovoPedido;
    procedure CancelarPedido(const sCodigo: string);
    procedure GravarPedido;
    procedure InserirGravarItem;
    procedure CalcularTotalItem;
    procedure CarregarItemParaEdicao(const iIndex: Integer);
    procedure ExcluirItem(const iIndex: Integer);

    procedure LimparCliente;
    procedure LimparProduto;
    procedure LimparTela;
    procedure LimparCamposItem;

    procedure AtualizarGrid;
    procedure AtualizarTotal;
  end;

var
  fMain: TfMain;

implementation

uses
  System.UITypes,
  UCliente,
  UClienteRepository,
  UProduto,
  UProdutoRepository,
  UPedidoItem;

{$R *.dfm}

procedure TfMain.FormCreate(Sender: TObject);
begin
  FPedido := TPedido.Create;
  FEditingItemID := -1;

  ConfigurarGrid;
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FPedido);
end;

procedure TfMain.ConfigurarGrid;
var
  i: Integer;
begin
  grdItens.ColCount := 5;
  grdItens.RowCount := 1;

  grdItens.Cells[0, 0] := 'Cód. Produto';
  grdItens.ColWidths[0] := 100;
  grdItens.Cells[1, 0] := 'Descrição Produto';
  grdItens.ColWidths[1] := 300;
  grdItens.Cells[2, 0] := 'Quantidade';
  grdItens.ColWidths[2] := 100;
  grdItens.Cells[3, 0] := 'Valor Unitário';
  grdItens.ColWidths[3] := 100;
  grdItens.Cells[4, 0] := 'Valor Total';
  grdItens.ColWidths[4] := 100;

  grdItens.ColAlignments[2] := taRightJustify;
  grdItens.ColAlignments[3] := taRightJustify;
  grdItens.ColAlignments[4] := taRightJustify;

  grdItens.RowCount := 2;
  grdItens.FixedRows := 1;
  grdItens.FixedCols := 0;

  // limpa primeira linha após os títulos
  for i := 0 to Pred(grdItens.ColCount) do
    grdItens.Cells[i, 1] := '';
end;

procedure TfMain.edCodigoClienteExit(Sender: TObject);
begin
  BuscarCliente(edCodigoCliente.Text);
end;

procedure TfMain.BuscarCliente(const sCodigo: string);
var
  iCodigoCliente: Integer;
  aCliente: TCliente;
begin
  iCodigoCliente := StrToIntDef(sCodigo.Trim, 0);
  if iCodigoCliente <= 0 then
    Exit;

  aCliente := TClienteRepository.ObterPorCodigo(iCodigoCliente);

  if aCliente = nil then
  begin
    ShowMessage('Cliente não encontrado');
    Exit;
  end;

  try
    edNomeCliente.Text := aCliente.Nome;
    edCidade.Text := aCliente.Cidade;
    edUF.Text := aCliente.UF;

    FPedido.CodigoCliente := aCliente.Codigo;
  finally
    aCliente.Free;
  end;
end;

procedure TfMain.edCodigoProdutoExit(Sender: TObject);
begin
  BuscarProduto(edCodigoProduto.Text);
end;

procedure TfMain.BuscarProduto(const sCodigo: string);
var
  iCodigoProduto: Integer;
  aProduto: TProduto;
begin
  iCodigoProduto := StrToIntDef(sCodigo.Trim, 0);
  if iCodigoProduto <= 0 then
    Exit;

  aProduto := TProdutoRepository.ObterPorCodigo(iCodigoProduto);

  if aProduto = nil then
  begin
    ShowMessage('Produto não encontrado');
    Exit;
  end;

  try
    edDescricaoProduto.Text := aProduto.Descricao;
    edValorUnitario.Text := FormatFloat('0.00', aProduto.PrecoVenda);
  finally
    aProduto.Free;
  end;
end;

procedure TfMain.ValidaTeclasNumerico(Sender: TObject; var Key: Char);
var
  Sep: Char;
begin
  Sep := FormatSettings.DecimalSeparator;

  if not CharInSet(Key,  ['0'..'9', Sep, #8]) then
    Key := #0;

  if (Key = Sep) and (Pos(Sep, (Sender as TEdit).Text) > 0) then
    Key := #0;
end;

procedure TfMain.ValidaCamposItem(Sender: TObject);
var
  sNumero: string;
begin
  sNumero := (Sender as TEdit).Text;
  (Sender as TEdit).Text := FormatFloat('0.00', StrToFloatDef(sNumero, 0));

  CalcularTotalItem;
end;

procedure TfMain.AtualizarGrid;
var
  i: Integer;
  aItem: TPedidoItem;
begin
  grdItens.RowCount := FPedido.Itens.Count + 1;

  for i := 0 to FPedido.Itens.Count - 1 do
  begin
    aItem := FPedido.Itens[i];

    grdItens.Cells[0, i + 1] := aItem.CodigoProduto.ToString;
    grdItens.Cells[1, i + 1] := aItem.DescricaoProduto;
    grdItens.Cells[2, i + 1] := FloatToStr(aItem.Quantidade);
    grdItens.Cells[3, i + 1] := CurrToStr(aItem.VlrUnitario);
    grdItens.Cells[4, i + 1] := CurrToStr(aItem.VlrTotal);
  end;
end;

procedure TfMain.AtualizarTotal;
begin
  edTotalPedido.Text := FormatFloat('0.00', FPedido.ValorTotal);
end;

procedure TfMain.bCarregarPedidoClick(Sender: TObject);
begin
  CarregarPedido(edNumeroPedido.Text);
end;

procedure TfMain.CarregarPedido(const sCodigo: string);
var
  iNumeroPedido: Integer;
  aPedidoService: TPedidoService;
begin
  iNumeroPedido := StrToIntDef(sCodigo.Trim, 0);
  if iNumeroPedido <= 0 then
    Exit;

  LimparTela;

  // libera objeto do pedido atual
  FreeAndNil(FPedido);

  aPedidoService := TPedidoService.Create;
  try
    FPedido := aPedidoService.Carregar(iNumeroPedido);
  finally
    aPedidoService.Free;
  end;

  if FPedido = nil then
    Exit;

  edNumeroPedido.Text := FPedido.NumeroPedido.ToString;
  edDataEmissao.DateTime := FPedido.DataEmissao;
  edCodigoCliente.Text := FPedido.CodigoCliente.ToString;
  edNomeCliente.Text := FPedido.NomeCliente;
  edCidade.Text := FPedido.Cidade;
  edUF.Text := FPedido.UF;

  AtualizarGrid;
  AtualizarTotal;
end;

procedure TfMain.bNovoPedidoClick(Sender: TObject);
begin
  NovoPedido;
end;

procedure TfMain.NovoPedido;
begin
  LimparTela;

  // libera Pedido atual e cria novo
  FreeAndNil(FPedido);
  FPedido := TPedido.Create;
end;

procedure TfMain.bCancelarPedidoClick(Sender: TObject);
begin
  CancelarPedido(edNumeroPedido.Text);
end;

procedure TfMain.CancelarPedido(const sCodigo: string);
var
  aPedidoService: TPedidoService;
begin
  if MessageDlg('Confirma cancelamento?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  aPedidoService := TPedidoService.Create;
  try
    try
      aPedidoService.Cancelar(FPedido.NumeroPedido);
      ShowMessage('Pedido cancelado com sucesso');
      NovoPedido;
    except
      on E: Exception do
        ShowMessage('Erro ao cancelar pedido: ' + E.Message);
    end;
  finally
    aPedidoService.Free;
  end;
end;

procedure TfMain.bGravarPedidoClick(Sender: TObject);
begin
  GravarPedido;
end;

procedure TfMain.GravarPedido;
var
  aPedidoService: TPedidoService;
begin
  aPedidoService := TPedidoService.Create;
  try
    try
      aPedidoService.Gravar(FPedido);
      ShowMessage('Pedido gravado com sucesso: ' + FPedido.NumeroPedido.ToString);
      edNumeroPedido.Text := FPedido.NumeroPedido.ToString;
    except
      on E: Exception do
        ShowMessage('Erro ao gravar pedido: ' + E.Message);
    end;
  finally
    aPedidoService.Free;
  end;
end;

procedure TfMain.bInserirAtualizarItemClick(Sender: TObject);
begin
  InserirGravarItem;
end;

procedure TfMain.InserirGravarItem;
var
  aItem: TPedidoItem;
begin
  if FPedido = nil then
    raise Exception.Create('Pedido inválido');

  if Trim(edCodigoProduto.Text) = '' then
    raise Exception.Create('Produto é requerido');

  if FEditingItemID >= 0 then
    aItem := FPedido.Itens[FEditingItemID]
  else
    aItem := TPedidoItem.Create;

  aItem.CodigoProduto := StrToIntDef(edCodigoProduto.Text, 0);
  aItem.DescricaoProduto := edDescricaoProduto.Text;
  aItem.Quantidade := StrToFloatDef(edQuantidade.Text, 0);
  aItem.VlrUnitario := StrToCurrDef(edValorUnitario.Text, 0);

  if FEditingItemID < 0 then
    FPedido.Itens.Add(aItem);

  FPedido.AtualizarTotal;

  AtualizarGrid;
  AtualizarTotal;

  LimparCamposItem;

  FEditingItemID := -1;
end;

procedure TfMain.LimparCliente;
begin
  edCodigoCliente.Clear;
  edNomeCliente.Clear;
  edCidade.Clear;
  edUF.Clear;
end;

procedure TfMain.LimparProduto;
begin
  edCodigoProduto.Clear;
  edDescricaoProduto.Clear;
end;

procedure TfMain.LimparTela;
begin
  edNumeroPedido.Clear;
  edDataEmissao.DateTime := Now;
  LimparCliente;
  LimparCamposItem;
  ConfigurarGrid;

  if edNumeroPedido.CanFocus then
    edNumeroPedido.SetFocus;
end;

procedure TfMain.LimparCamposItem;
begin
  LimparProduto;
  edQuantidade.Text := '0,00';
  edValorUnitario.Text := '0,00';
  edValorTotalItem.Text := '0,00';

  if edCodigoProduto.CanFocus then
    edCodigoProduto.SetFocus;
end;

procedure TfMain.grdItensKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  iIndex: Integer;
begin
  iIndex := grdItens.Row - 1;

  // ENTER = EDITAR
  if Key = VK_RETURN then
    CarregarItemParaEdicao(iIndex);

  // DEL = EXCLUIR
  if Key = VK_DELETE then
    ExcluirItem(iIndex);
end;

procedure TfMain.CalcularTotalItem;
var
  nTotal: Double;
begin
  nTotal := StrToFloatDef(edQuantidade.Text, 0) * StrToFloatDef(edValorUnitario.Text, 0);
  edValorTotalItem.Text := FormatFloat('0.00', nTotal);
end;

procedure TfMain.CarregarItemParaEdicao(const iIndex: Integer);
var
  aItem: TPedidoItem;
begin
  if (iIndex < 0) or (iIndex >= FPedido.Itens.Count) then
    Exit;

  aItem := FPedido.Itens[iIndex];

  edCodigoProduto.Text := aItem.CodigoProduto.ToString;
  edDescricaoProduto.Text := aItem.DescricaoProduto;
  edQuantidade.Text := FloatToStr(aItem.Quantidade);
  edValorUnitario.Text := CurrToStr(aItem.VlrUnitario);
  CalcularTotalItem;

  FEditingItemID := iIndex;
end;

procedure TfMain.ExcluirItem(const iIndex: Integer);
begin
  if (iIndex < 0) or (iIndex >= FPedido.Itens.Count) then
    Exit;

  if MessageDlg('Excluir item?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  FPedido.Itens.Delete(iIndex);

  // simulando bug de não atualizar o total - requisito do desafio no item 4.2
  // FPedido.AtualizarTotal;

  AtualizarGrid;
  AtualizarTotal;
end;

end.
