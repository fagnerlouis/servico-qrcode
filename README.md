# Microsserviço Gerador de QR Code para Windows

Este pacote contém um microsserviço desenvolvido em Python (usando Flask) que gera imagens de QR Code sob demanda via URL.

## Conteúdo do Pacote

- `qrcode_service.py`: O script Python principal do microsserviço.
- `requirements.txt`: Lista das dependências Python necessárias.
- `README.md`: Este arquivo com instruções.

## Limitação

Devido a limitações do ambiente de desenvolvimento atual (Linux), não foi possível gerar diretamente um executável `.exe` ou um instalador para Windows. No entanto, você pode facilmente executar o serviço ou criar o executável em seu próprio ambiente Windows seguindo as instruções abaixo.

## Opção 1: Executar Diretamente com Python (Recomendado para Simplicidade)

Esta é a forma mais simples de rodar o serviço se você já tem Python instalado no Windows.

1.  **Instalar Python:** Se ainda não tiver, baixe e instale a versão mais recente do Python para Windows em [python.org](https://www.python.org/downloads/windows/). **Importante:** Durante a instalação, marque a opção "Add Python to PATH".

2.  **Abrir o Prompt de Comando (CMD) ou PowerShell:**
    - Pressione `Win + R`, digite `cmd` e pressione Enter.
    - Ou procure por "PowerShell" no menu Iniciar.

3.  **Navegar até a Pasta do Serviço:** Use o comando `cd` para navegar até a pasta onde você extraiu os arquivos deste pacote.
    ```bash
    cd caminho\para\a\pasta\do\servico
    ```

4.  **Instalar Dependências:** Execute o comando abaixo para instalar as bibliotecas necessárias:
    ```bash
    pip install -r requirements.txt
    ```

5.  **Executar o Serviço:** Inicie o microsserviço com o comando:
    ```bash
    python qrcode_service.py
    ```

6.  **Acessar o Serviço:** O serviço estará rodando em `http://localhost:3000`. Para gerar um QR code, acesse no seu navegador uma URL como:
    `http://localhost:3000/qrcode=SeuTextoAqui`
    Substitua `SeuTextoAqui` pelo texto que você deseja codificar.

7.  **Parar o Serviço:** Volte ao Prompt de Comando/PowerShell e pressione `Ctrl + C`.

## Opção 2: Criar um Executável `.exe` com PyInstaller

Se você preferir ter um arquivo `.exe` independente, pode usar o PyInstaller no seu ambiente Windows.

1.  **Instalar Python:** Siga o passo 1 da Opção 1.

2.  **Abrir o Prompt de Comando (CMD) ou PowerShell:** Siga o passo 2 da Opção 1.

3.  **Navegar até a Pasta do Serviço:** Siga o passo 3 da Opção 1.

4.  **Instalar Dependências e PyInstaller:**
    ```bash
    pip install -r requirements.txt
    pip install pyinstaller
    ```

5.  **Gerar o Executável:** Execute o comando PyInstaller:
    ```bash
    pyinstaller --onefile --windowed qrcode_service.py
    ```
    - `--onefile`: Cria um único arquivo `.exe`.
    - `--windowed`: Evita que uma janela de console apareça ao executar o `.exe` (o serviço rodará em segundo plano).

6.  **Encontrar o Executável:** Após a conclusão, o arquivo `qrcode_service.exe` estará dentro de uma pasta chamada `dist`.

7.  **Executar o Serviço:** Dê um duplo clique no arquivo `qrcode_service.exe` na pasta `dist`. O serviço começará a rodar em segundo plano na porta 3000.

8.  **Acessar o Serviço:** Use a URL `http://localhost:3000/qrcode=SeuTextoAqui` no navegador.

9.  **Parar o Serviço:** Como ele roda em segundo plano, você precisará usar o Gerenciador de Tarefas do Windows (`Ctrl + Shift + Esc`) para encontrar e finalizar o processo `qrcode_service.exe`.

## Próximos Passos (Instalador)

Com o arquivo `qrcode_service.exe` gerado (Opção 2), você pode usar ferramentas como [Inno Setup](https://jrsoftware.org/isinfo.php) ou [NSIS](https://nsis.sourceforge.io/Main_Page) para criar um instalador `.msi` ou `.exe` mais tradicional, que pode adicionar atalhos, configurar o serviço para iniciar com o Windows, etc. A criação desses scripts de instalação está fora do escopo atual, mas pode ser feita com base no `.exe` gerado.

Se precisar de ajuda com alguma dessas etapas, me informe!