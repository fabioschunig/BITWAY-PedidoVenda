program PedidoVenda;

uses
  System.SysUtils,
  Vcl.Forms,
  UMain in 'app\UMain.pas' {fMain},
  UConfigINI in 'connection\UConfigINI.pas',
  UDM in 'connection\UDM.pas' {fDM: TDataModule},
  UCliente in 'entities\UCliente.pas',
  UProduto in 'entities\UProduto.pas',
  UPedidoItem in 'entities\UPedidoItem.pas',
  UPedido in 'entities\UPedido.pas',
  UClienteRepository in 'repositories\UClienteRepository.pas',
  UProdutoRepository in 'repositories\UProdutoRepository.pas',
  UPedidoRepository in 'repositories\UPedidoRepository.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfDM, fDM);

  // conexão com o banco de dados
  try
    fDM.Connect;
  except
    on E: Exception do
    begin
      Application.ShowException(E);
      Application.Terminate;
    end;
  end;

  Application.Run;
end.
