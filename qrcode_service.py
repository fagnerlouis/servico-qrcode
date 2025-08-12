from flask import Flask, request, send_file
import qrcode
import io

app = Flask(__name__)

@app.route('/generate')
def generate_qrcode():
    text = request.args.get('qrcode', 'https://github.com/fagnerlouis/servico-qrcode')

    try:
        border_size = int(request.args.get('border', 1))
    except (ValueError, TypeError):
        border_size = 1
    
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=border_size,
    )
    qr.add_data(text)
    qr.make(fit=True)

    img = qr.make_image(fill_color="black", back_color="white")

    img_io = io.BytesIO()
    img.save(img_io, 'PNG')
    img_io.seek(0)

    return send_file(img_io, mimetype='image/png')

if __name__ == '__main__':
    # Roda o servidor na porta 3000, acessível de qualquer IP.
    # host='0.0.0.0' permite acesso externo para testes.
    app.run(host='0.0.0.0', port=3000)
