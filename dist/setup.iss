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
; O caminho foi corrigido para apontar para o executável na mesma pasta do script.
Source: "qrcode_service.exe"; DestDir: "{app}"; Flags: ignoreversion

[UninstallRun]
; Comando para parar e desinstalar o serviço do Windows
; O parâmetro "/C" é crucial para que o cmd execute e feche a janela
; Usando a definição MyServiceName para consistência
Filename: "{sys}\cmd.exe"; Parameters: "/C sc stop ""{#MyServiceName}"" & sc delete ""{#MyServiceName}"""; Flags: runhidden


[Code]
var
  PortPage: TInputDirWizardPage;
  PortNumberEdit: TNewEdit;

// Função para validar a entrada do usuário na página de porta
// Retorna True se a entrada for válida, False caso contrário.
function ValidatePortInput(Sender: TWizardPage): Boolean;
var
  PortValue: Integer;
begin
  try
    // Tenta converter o texto para um inteiro. Se falhar, vai para o bloco 'except'.
    PortValue := StrToInt(PortNumberEdit.Text);

    // Se a conversão for bem-sucedida, verifica se a porta está no intervalo permitido
    if (PortValue < 1024) or (PortValue > 65535) then
    begin
      MsgBox('A porta deve ser um número entre 1024 e 65535.', mbError, MB_OK);
      Result := False;
    end
    else
    begin
      // Se estiver tudo correto, o resultado é verdadeiro
      Result := True;
    end;
  except
    // Este bloco é executado se StrToInt falhar (ex: texto não é um número)
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
  
  // Conecta a função de validação ao botão "Avançar" da página
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
  ServiceCommand: string;
  ResultCode: Integer;
  AppPath: string;
  ServiceName: string;
  AppDisplayName: string;

begin
  if CurStep = ssPostInstall then
  begin
    AppPath := AddQuotes(ExpandConstant('{app}\qrcode_service.exe'));
    ServiceName := '{#MyServiceName}';
    AppDisplayName := '{#MyAppName}';

    ServiceCommand := Format('/C sc create "%s" binPath= "%s --port=%s" start=auto DisplayName="%s" & sc start "%s"', [ServiceName, AppPath, PortNumberEdit.Text, AppDisplayName, ServiceName]);


    Exec(ExpandConstant('{sys}\cmd.exe'), ServiceCommand, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  end;
end;