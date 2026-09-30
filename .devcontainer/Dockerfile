# Use the latest official Node.js image
FROM node:latest

# Set environment variables
ENV TZ=Asia/Kolkata
ENV DEBIAN_FRONTEND=noninteractive
ENV USERNAME=saranya

# Install useful system utilities and zsh
RUN apt-get update \
    && apt-get install --yes \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        locales \
        postgresql-client \
        sudo \
        tzdata \
        wget \
        zsh \
    && rm -rf /var/lib/apt/lists/*

# Create the user and give sudo permissions
RUN useradd -ms /bin/zsh $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create workspace directory and grant ownership to the user
RUN mkdir -p /workspace && chown -R $USERNAME:$USERNAME /workspace

WORKDIR /workspace

# Copy project files
COPY --chown=$USERNAME:$USERNAME . .

# Expose port
EXPOSE 3000

# Switch to the non-root user
USER $USERNAME
ENV HOME=/home/$USERNAME

# Install Oh-My-Zsh
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh -s -- --unattended \
    && sed -i 's/robbyrussell/kennethreitz/g' ~/.zshrc \
    && echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.zshrc