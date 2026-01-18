#!/bin/bash

# --- Culori ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color (Reset)

# --- Configurare ---
NOUL_PORT=2222
CHEIE_PUBLICA="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK..." # Pune cheia ta aici

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   SSH SETUP & SECURITY AUTOMATION      ${NC}"
echo -e "${BLUE}========================================${NC}"

# 1. Modificare Port
echo -ne "${YELLOW}[...] Configurare port $NOUL_PORT... ${NC}"
if grep -q "^#\?Port 22" /etc/ssh/sshd_config; then
    sed -i "s/^#\?Port 22/Port $NOUL_PORT/" /etc/ssh/sshd_config
    echo -e "${GREEN}DONE!${NC}"
else
    echo -e "${BLUE}PORT DEJA MODIFICAT${NC}"
fi

# 2. Configurare Chei
echo -ne "${YELLOW}[...] Adăugare cheie autorizată... ${NC}"
mkdir -p /root/.ssh
chmod 700 /root/.ssh
echo "$CHEIE_PUBLICA" >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
echo -e "${GREEN}DONE!${NC}"

# 3. Restart Serviciu
echo -ne "${YELLOW}[...] Restartare serviciu SSH... ${NC}"
if systemctl restart ssh; then
    echo -e "${GREEN}SUCCESS!${NC}"
else
    echo -e "${RED}FAILED!${NC}"
    exit 1
fi

echo -e "${BLUE}----------------------------------------${NC}"
echo -e "${GREEN}✔ CONFIGURARE FINALIZATĂ CU SUCCES!${NC}"
echo -e "${YELLOW}➜ Conectează-te cu:${NC} ssh -p $NOUL_PORT root@$(curl -s https://ipinfo.io/ip)"
echo -e "${BLUE}========================================${NC}"
