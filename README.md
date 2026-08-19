# Primeiro Uso — Termux Fun (sergio)

Este repositório contém scripts e instruções práticos para deixar o Termux mais simples, divertido e com um monitor de rede.

Arquivos incluídos:
- clicaSergio.sh — instalador rápido (move rish, cria launcher e inicia rede.sh)
- rede.sh — monitor simples de rede (tenta reconectar e abre configurações se necessário)
- rede.txt — comandos úteis de diagnóstico e reconexão (curto e direto)
- termux-fun-rede.txt — comandos e dicas para se divertir no Termux

Como usar (rápido):
1. No Termux permita acesso ao storage:
   termux-setup-storage
2. Clone o repo (opcional):
   pkg install git
   git clone https://github.com/sergiomelorepositorio/sergio.git
   cd sergio
3. Tornar o instalador executável e rodar (ou baixe pelo app GitHub e execute no Termux):
   chmod +x clicaSergio.sh
   bash ./clicaSergio.sh

Notas:
- O instalador não precisa de root e não modifica /system.
- Se o rish estiver no Download, o instalador moverá para um local estável e criará o comando global `rish`.
- Se o Android bloquear reconexão automática, o script abre as configurações para você reconectar manualmente.
