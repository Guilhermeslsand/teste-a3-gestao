#!/bin/bash

set -euo pipefail

APP_DIR="/opt/vitalsenior"
BACK_DIR="/opt/vitalsenior/demo"
BRANCH="${1:-main}"

echo "===================================="
echo " Iniciando deploy do VitalSenior"
echo " Branch: $BRANCH"
echo "===================================="

# Validar nome da branch
if [[ ! "$BRANCH" =~ ^[a-zA-Z0-9._/-]+$ ]]; then
    echo "Nome de branch inválido"
    exit 1
fi

cd "$APP_DIR"

# Atualizar referências remotas
echo "[1/3] Atualizando repositório..."

git fetch origin "$BRANCH"

# Atualizar a branch local
git checkout -B "$BRANCH" "origin/$BRANCH"

cd "$BACK_DIR"

# Subir ou atualizar containers
echo "[2/3] Atualizando Docker Compose..."

docker compose up -d --build --remove-orphans

# Verificar containers
echo "[3/3] Verificando serviços..."

docker compose ps

echo "===================================="
echo " Deploy finalizado!"
echo "===================================="