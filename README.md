### CamGuard 📸

Este script está diseñado para Linux con el objetivo de vigilar tu portátil mientras te encuentras "Away From Keyboard" (AFK). La función principal del script es:

- **Envío de Correos Periódicos:**
  - Cada 30 segundos, el script capturará una foto y un vídeo utilizando la cámara integrada del portátil.
  - Los archivos multimedia (foto y vídeo) serán adjuntados en correos electrónicos enviados a la dirección especificada.

- **Detección del Cierre de la Tapa del Portátil:**
  - El script también monitorea el estado de la tapa del portátil.
  - Si la tapa se cierra, el script enviará una notificación para informarte.

#### Requisitos
Asegúrate de tener instalados los siguientes programas en tu sistema:

1. **ffmpeg:**
     ```bash
     sudo apt install ffmpeg
     ```

2. **mutt:**
     ```bash
     sudo apt install mutt
     ```

#### Configuración del Script
- **Gmail al cuál se enviarán los correos :** `tugmail@gmail.com`
  - *Ubicación del Archivo de Configuración:* `~/.muttrc` en la carpeta `/root`
  - *Descripción:* Configura el archivo `.muttrc` para el envío de correos utilizando Gmail con las credenciales y ajustes necesarios.
```bash
set smtp_url = "smtps://tugmail@gmail.com@smtp.gmail.com/"
set smtp_pass = "Tu contraseña de aplicación de google"
set from = "tugmail@gmail.com"
set realname = "tu nombre asociado a tu correo"
```

#### Ejecución

- **Dar permisos de ejecución :**
```bash
chmod +x camGuard.sh
```

- **Ejecutar el script :**
```bash
sudo ./camGuard.sh
```

---

*Este README fue creado por ChatGPT*
