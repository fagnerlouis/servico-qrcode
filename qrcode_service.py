# -*- coding: utf-8 -*-
from flask import Flask, request, send_file
import qrcode
import io
import argparse # Importando a biblioteca para argumentos

app = Flask(__name__)

@app.route('/generate')
def generate_qrcode():
    # Obtém o valor do parâmetro 'qrcode' da URL.
    text = request.args.get('qrcode', 'https://github.com/fagnerlouis/servico-qrcode')

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

if __name__ == '__main__':
    # 1. Configura o parser de argumentos
    parser = argparse.ArgumentParser(description='QR Code Service')
    parser.add_argument('--port', type=int, default=3000, help='Porta para rodar o servidor Flask')
    args = parser.parse_args()

    # 2. Roda o servidor usando a porta do argumento
    app.run(host='0.0.0.0', port=args.port)