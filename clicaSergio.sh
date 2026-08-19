#!/data/data/com.termux/files/usr/bin/env bash
set -euo pipefail

PREFIX=${PREFIX:-/data/data/com.termux/files/usr}
DOWNLOADS="$HOME/storage/shared/Download"
OPT_DIR="$PREFIX/opt/rish"
LAUNCHER="$PREFIX/bin/rish"
REDE_SCRIPT="$HOME/rede.sh"

echo "== clicaSergio: iniciando =="

# pedir permissão ao storage (se necessário)
termux-setup-storage || true

# criar pasta estável para rish
mkdir -p "$OPT_DIR"

# mover rish do Downloads para o local estável (se existir)
if compgen -G "$DOWNLOADS/rish*" >/dev/null 2>&1; then
  echo "Movendo rish* de $DOWNLOADS para $OPT_DIR"
  mv "$DOWNLOADS"/rish* "$OPT_DIR"/ 2>/dev/null || true
else
  echo "Nenhum arquivo rish* em $DOWNLOADS — pule se não tiver"
fi

# ajustar permissões e shebang
if [ -f "$OPT_DIR/rish" ]; then
  chmod 755 "$OPT_DIR/rish" || true
  [ -f "$OPT_DIR/rish_shizuku.dex" ] && chmod 644 "$OPT_DIR/rish_shizuku.dex" || true
  if ! head -n1 "$OPT_DIR/rish" | grep -q '^#!'; then
    sed -i '1i#!/data/data/com.termux/files/usr/bin/env bash' "$OPT_DIR/rish" || true
  fi
  echo "rish pronto em $OPT_DIR/rish"
fi

# criar launcher simples no PATH
cat > "$LAUNCHER" <<'L'
#!/data/data/com.termux/files/usr/bin/env bash
exec "$PREFIX/opt/rish/rish" "$@"
L
chmod 755 "$LAUNCHER" 2>/dev/null || true

# criar rede.sh (se não existir) e iniciar em background
if [ ! -f "$REDE_SCRIPT" ]; then
  cat > "$REDE_SCRIPT" <<'S'
#!/data/data/com.termux/files/usr/bin/env bash
TARGET=8.8.8.8
SLEEP=10
LOG="$HOME/reconnect-wifi.log"
echo "$(date) - rede.sh iniciado" >> "$LOG"
command -v termux-wake-lock >/dev/null && termux-wake-lock
while true; do
  if ping -c1 -W1 "$TARGET" >/dev/null 2>&1; then
    sleep "$SLEEP"
    continue
  fi
  echo "$(date) - ping falhou, tentando..." >> "$LOG"
  termux-toast "Rede caiu — abrindo Wi‑Fi" 2>/dev/null || true
  if command -v termux-wifi-enable >/dev/null 2>&1; then
    termux-wifi-enable true 2>/dev/null || true
    sleep 4
    if ping -c1 -W1 "$TARGET" >/dev/null 2>&1; then
      echo "$(date) - reconectou via termux-wifi-enable" >> "$LOG"
      sleep "$SLEEP"
      continue
    fi
  fi
  am start -a android.settings.WIFI_SETTINGS >/dev/null 2>&1 || true
  sleep 15
done
S
  chmod 755 "$REDE_SCRIPT" 2>/dev/null || true
  nohup "$REDE_SCRIPT" >/dev/null 2>&1 &
fi

hash -r || true

echo "== pronto =="
echo "Verifique: which rish  || nano $HOME/rede.txt"
