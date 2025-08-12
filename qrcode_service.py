from flask import Flask, request, send_file
import qrcode
import io

app = Flask(__name__)

@app.route('/qrcode=<text>')
def generate_qrcode(text):
    # Cria o objeto QR code
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(text)
    qr.make(fit=True)

    # Cria a imagem do QR code
    img = qr.make_image(fill_color="black", back_color="white")

    # Salva a imagem em um buffer de bytes na memória
    img_io = io.BytesIO()
    img.save(img_io, 'PNG')
    img_io.seek(0)

    # Retorna a imagem como um arquivo PNG
    return send_file(img_io, mimetype='image/png')

if __name__ == '__main__':
    # Roda o servidor na porta 3000, acessível de qualquer IP
    # Use 0.0.0.0 para permitir acesso externo se necessário (para teste)
    app.run(host='0.0.0.0', port=3000)

