# -*- coding: utf-8 -*-
from flask import Flask, request, send_file
import qrcode
import io
import argparse
from waitress import serve # Importa o servidor 'waitress'

# --- Lógica de Argumentos ---
# Movemos a leitura da porta para cá, para que seja sempre executada
parser = argparse.ArgumentParser(description='QR Code Service')
parser.add_argument('--port', type=int, default=3000, help='Porta para rodar o servidor')
args = parser.parse_args()
# -----------------------------

app = Flask(__name__)

@app.route('/generate')
def generate_qrcode():
    # Obtém o valor do parâmetro 'qrcode' da URL.
    # Se for vazio ou não existir, usa o link do GitHub como padrão.
    text = request.args.get('qrcode') or 'https://github.com/fagnerlouis/servico-qrcode'

    # Obtém o valor do parâmetro 'border' da URL.
    try:
        border_size = int(request.args.get('border', 1))
    except (ValueError, TypeError):
        border_size = 1

    # Cria o objeto QR code
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=border_size,
    )
    qr.add_data(text)
    qr.make(fit=True)

    # Cria a imagem do QR code
    img = qr.make_image(fill_color="black", back_color="white")

    # Salva a imagem em um buffer de bytes na memória
    img_io = io.BytesIO()
    img.save(img_io, 'PNG')
    img_io.seek(0)

    # Retorna a imagem
    return send_file(img_io, mimetype='image/png')

# --- Inicia o Servidor ---
# Usamos o 'serve' do waitress em vez do 'app.run'
if __name__ == '__main__':
    print(f"Iniciando servidor na porta {args.port}...")
    serve(app, host='0.0.0.0', port=args.port)