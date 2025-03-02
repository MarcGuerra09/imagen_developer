FROM ubuntu:24.04

# Evitar preguntas interactivas durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar dependencias
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    novnc \
    websockify \
    sudo \
    ssh \
    python3 \
    python3-pip \
    python3-venv \
    python3-full \
    wget \
    gnupg2 \
    lsb-release \
    postgresql-client \
    curl \
    git \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Configurar locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Instalar Visual Studio Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
    && install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list \
    && apt-get update && apt-get install -y code \
    && rm -rf /var/lib/apt/lists/*

# Crear un usuario no-root
RUN useradd -m developer \
    && echo "developer:password" | chpasswd \
    && usermod -aG sudo developer \
    && echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Cambiar al usuario developer
USER developer
WORKDIR /home/developer

# Crear y configurar un entorno virtual para Python
RUN python3 -m venv /home/developer/venv
ENV PATH="/home/developer/venv/bin:$PATH"

# Instalar Flask y dependencias Python en el entorno virtual
RUN /home/developer/venv/bin/pip install flask gunicorn psycopg2-binary

# Añadir el entorno virtual al PATH y configurarlo para activarse automáticamente
RUN echo 'export PATH="/home/developer/venv/bin:$PATH"' >> ~/.bashrc

# Configurar VNC
RUN mkdir -p ~/.vnc
RUN echo "password" | vncpasswd -f > ~/.vnc/passwd
RUN chmod 600 ~/.vnc/passwd

# Crear directorio de workspace
RUN mkdir -p /home/developer/workspace

# Configurar inicio de VNC
RUN echo '#!/bin/bash\nxrdb $HOME/.Xresources\nstartxfce4 &' > ~/.vnc/xstartup
RUN chmod +x ~/.vnc/xstartup

# Script de inicio
USER root
COPY start-services.sh /home/developer/
RUN chown developer:developer /home/developer/start-services.sh
RUN chmod +x /home/developer/start-services.sh

USER developer
EXPOSE 5901 22

CMD ["/home/developer/start-services.sh"]