program PedidoVenda;

uses
  System.SysUtils,
  Vcl.Forms,
  UMain in 'app\UMain.pas' {fMain},
  UConfigINI in 'connection\UConfigINI.pas',
  UDM in 'connection\UDM.pas' {fDM: TDataModule};

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
