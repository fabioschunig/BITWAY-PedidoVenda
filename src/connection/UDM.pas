unit UDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FBDef, FireDAC.Phys.IBBase,
  FireDAC.Phys.FB;

type
  TfDM = class(TDataModule)
    FDConnection: TFDConnection;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
  private
    procedure ConfigureConnection;
  public
    procedure Connect;
  end;

var
  fDM: TfDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  UConfigINI;

{$R *.dfm}

{ TfDM }

procedure TfDM.ConfigureConnection;
var
  aConfig: TDatabaseConfig;
begin
  aConfig := TConfigINI.LoadDatabaseConfig;

  FDConnection.LoginPrompt := False;

  FDConnection.Params.Clear;
  FDConnection.Params.DriverID := 'FB';
  FDConnection.Params.Add('Server=' + aConfig.Server);
  FDConnection.Params.Add('Port=' + aConfig.Port.ToString);
  FDConnection.Params.Add('Database=' + aConfig.Database);
  FDConnection.Params.Add('User_Name=' + aConfig.Username);
  FDConnection.Params.Add('Password=' + aConfig.Password);
  FDConnection.Params.Add('Protocol=TCPIP');
  FDPhysFBDriverLink.VendorLib := aConfig.ClientLibrary;
end;

procedure TfDM.Connect;
begin
  ConfigureConnection;
  FDConnection.Connected := True;
end;

end.
