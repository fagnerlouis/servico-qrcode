; Inno Setup Script para o instalador do QR Code Service

; --- Definições Globais ---
; Usar #define torna o script mais fácil de manter.
#define MyAppName "Serviço Gerador de QR Code"
#define MyAppVersion "1.0"
#define MyServiceName "qrcode_service_1.0"
#define MyDirName "qrcode_service_print"

[Setup]
; Informações básicas do instalador usando as definições acima
AppName={#MyAppName}
AppVersion={#MyAppVersion}
DefaultDirName={autopf}\{#MyDirName}
; 'admin' é o valor correto para versões modernas do Inno Setup.
PrivilegesRequired=admin
OutputBaseFilename=setup_qrcode_service
OutputDir=.\Output
UninstallDisplayIcon={app}\qrcode_service.exe


[Files]
; Adiciona o executável do serviço ao instalador
Source: "qrcode_service.exe"; DestDir: "{app}"; Flags: ignoreversion

[UninstallRun]
; Comando para parar e desinstalar o serviço do Windows
Filename: "{sys}\cmd.exe"; Parameters: "/C sc stop ""{#MyServiceName}"" & sc delete ""{#MyServiceName}"""; Flags: runhidden


[Code]
var
  PortPage: TInputDirWizardPage;
  PortNumberEdit: TNewEdit;

// Função para validar a entrada do usuário na página de porta
function ValidatePortInput(Sender: TWizardPage): Boolean;
var
  PortValue: Integer;
begin
  try
    PortValue := StrToInt(PortNumberEdit.Text);
    if (PortValue < 1024) or (PortValue > 65535) then
    begin
      MsgBox('A porta deve ser um número entre 1024 e 65535.', mbError, MB_OK);
      Result := False;
    end
    else
    begin
      Result := True;
    end;
  except
    MsgBox('Por favor, insira um número válido para a porta.', mbError, MB_OK);
    Result := False;
  end;
end;


// Função para criar uma página personalizada no instalador
procedure CreatePortPage();
begin
  PortPage := CreateInputDirPage(
    wpSelectDir,
    'Configurar Porta do Serviço',
    'Escolha a porta para o serviço de QR Code',
    'Insira o número da porta que você deseja usar para o serviço (ex: 3000):',
    False,
    ''
  );

  PortNumberEdit := TNewEdit.Create(PortPage);
  PortNumberEdit.Parent := PortPage.Surface;
  PortNumberEdit.Text := '3000'; // Valor padrão
  PortNumberEdit.Left := ScaleX(10);
  PortNumberEdit.Top := ScaleY(100);
  PortNumberEdit.Width := ScaleX(200);
  
  PortPage.OnNextButtonClick := @ValidatePortInput;
end;

// Evento que cria a página personalizada antes da instalação
procedure InitializeWizard();
begin
  CreatePortPage();
end;

// Evento que executa após a instalação dos arquivos
procedure CurStepChanged(CurStep: TSetupStep);
var
  CreateServiceCmd: string;
  StartServiceCmd: string;
  ResultCode: Integer;
  FullBinPath: string;
  ServiceName: string;
  AppDisplayName: string;

begin
  if CurStep = ssPostInstall then
  begin
    // Prepara as variáveis
    FullBinPath := ExpandConstant('{app}\qrcode_service.exe') + ' --port=' + PortNumberEdit.Text;
    FullBinPath := AddQuotes(FullBinPath);
    ServiceName := '{#MyServiceName}';
    AppDisplayName := '{#MyAppName}';

    // CORREÇÃO: Separar a criação e o início em dois comandos distintos

    // 1. Comando para CRIAR o serviço
    CreateServiceCmd := Format('/C sc create "%s" binPath=%s start=auto DisplayName="%s"', [ServiceName, FullBinPath, AppDisplayName]);
    Exec(ExpandConstant('{sys}\cmd.exe'), CreateServiceCmd, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);

    // 2. Comando para INICIAR o serviço
    StartServiceCmd := Format('/C sc start "%s"', [ServiceName]);
    Exec(ExpandConstant('{sys}\cmd.exe'), StartServiceCmd, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  end;
end;