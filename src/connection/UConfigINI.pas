unit UConfigINI;

interface

type
  TDatabaseConfig = record
    Server: string;
    Port: Integer;
    Database: string;
    Username: string;
    Password: string;
    ClientLibrary: string;
  end;

  TConfigINI = class
  public
    class function LoadDatabaseConfig: TDatabaseConfig;
  end;

implementation

uses
  System.SysUtils,
  System.IniFiles;

{ TConfigINI }

class function TConfigINI.LoadDatabaseConfig: TDatabaseConfig;
var
  aIniFile: TIniFile;
  sPath: string;
begin
  sPath := ExtractFilePath(ParamStr(0)) + 'config.ini';

  if not FileExists(sPath) then
    raise Exception.CreateFmt('Arquivo config.ini não encontrado: %s', [sPath]);

  aIniFile := TIniFile.Create(sPath);
  try
    Result.Server := aIniFile.ReadString('DATABASE', 'Server', '127.0.0.1');
    Result.Port := aIniFile.ReadInteger('DATABASE', 'Port', 3050);
    Result.Database := aIniFile.ReadString('DATABASE', 'Database', '');
    Result.Username := aIniFile.ReadString('DATABASE', 'Username', 'SYSDBA');
    Result.Password := aIniFile.ReadString('DATABASE', 'Password', 'masterkey');
    Result.ClientLibrary := aIniFile.ReadString('DATABASE', 'ClientLibrary', '.\fbclient.dll');

    if Result.Database.Trim.IsEmpty then
      raise Exception.Create('Valor para "Database" não informado no config.ini');
  finally
    aIniFile.Free;
  end;
end;

end.
