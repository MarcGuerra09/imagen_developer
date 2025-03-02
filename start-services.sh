#!/bin/bash

# Iniciar servidor SSH en segundo plano
sudo service ssh start

# Iniciar servidor VNC
vncserver :1 -geometry 1280x800 -depth 24

# Activar el entorno virtual
source /home/developer/venv/bin/activate

# Mantener el contenedor en ejecución
tail -f /dev/null