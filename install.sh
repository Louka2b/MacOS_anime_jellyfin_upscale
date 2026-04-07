#!/bin/bash

echo "========================================="
echo "🎬 Jellyfin Anime4K MacOS Installer"
echo "========================================="
echo ""
echo "🌍 Choose your language / Choisissez votre langue :"
echo "1) English (EN)"
echo "2) Français (FR)"
read -p "> " lang_choice < /dev/tty

LANG_PREF="en"
if [ "$lang_choice" = "2" ]; then
    LANG_PREF="fr"
fi

INSTALL_DIR="$HOME/.config/jellyfin-anime4k"
mkdir -p "$INSTALL_DIR"
SCRIPT_PATH="$INSTALL_DIR/anime4k.sh"

cat << EOF > "$SCRIPT_PATH"
#!/bin/bash
JMP_DIR="\$HOME/Library/Application Support/Jellyfin Media Player"
SHADER_DIR="\$JMP_DIR/shaders"
CONF="\$JMP_DIR/mpv.conf"
LANGUAGE="$LANG_PREF"

if [ "\$LANGUAGE" = "fr" ]; then
    TXT_MAX="🌌 Mode MAX (Singularité) activé ! 🔥"
    TXT_ULTRA="🚀 Mode ULTRA (Performance) activé ! ✨"
    TXT_MID="❄️ Mode MID (Équilibré) activé ! 🌬️"
    TXT_LOW="🔋 Mode LOW (Désactivé) activé ! ⚡"
    TXT_WIPE="✅ Nettoyage terminé ! Ouverture de Jellyfin..."
    TXT_DOWN="⏳ Téléchargement des shaders en cours..."
    TXT_ERR="❌ Usage: up --max | up --ultra | up --mid | up --low | up --wipe"
    TXT_CUR="ℹ️ Mode actuel :"
    TXT_CLOSE="🛑 Application des réglages..."
else
    TXT_MAX="🌌 MAX Mode (Singularity) activated ! 🔥"
    TXT_ULTRA="🚀 ULTRA Mode (High Performance) activated ! ✨"
    TXT_MID="❄️ MID Mode (Balanced) activated ! 🌬️"
    TXT_LOW="🔋 LOW Mode (Disabled) activated ! ⚡"
    TXT_WIPE="✅ WIPE complete ! Opening Jellyfin..."
    TXT_DOWN="⏳ Downloading shaders..."
    TXT_ERR="❌ Usage: up --max | up --ultra | up --mid | up --low | up --wipe"
    TXT_CUR="ℹ️ Current mode :"
    TXT_CLOSE="🛑 Applying settings..."
fi

if [ -z "\$1" ]; then
    if grep -q "Restore_CNN_VL" "\$CONF" 2>/dev/null; then echo "\$TXT_CUR 🌌 MAX"
    elif grep -q "Restore_CNN_L" "\$CONF" 2>/dev/null; then echo "\$TXT_CUR 🚀 ULTRA"
    elif grep -q "Restore_CNN_M" "\$CONF" 2>/dev/null; then echo "\$TXT_CUR ❄️ MID"
    elif grep -q "glsl-shaders=\"\"" "\$CONF" 2>/dev/null; then echo "\$TXT_CUR 🔋 LOW"
    else echo "\$TXT_CUR ❓ None"
    fi
    exit 0
fi

if [ "\$1" != "--max" ] && [ "\$1" != "--ultra" ] && [ "\$1" != "--mid" ] && [ "\$1" != "--low" ] && [ "\$1" != "--wipe" ]; then
    echo "\$TXT_ERR"
    exit 1
fi

echo "\$TXT_CLOSE"
killall "Jellyfin Media Player" 2>/dev/null
sleep 1

if [ "\$1" = "--wipe" ]; then
    rm -rf "\$JMP_DIR"
    rm -rf "\$HOME/Library/Caches/Jellyfin Media Player"
    rm -rf "\$HOME/Library/Saved Application State/tv.jellyfin.player.savedState"
    echo "\$TXT_WIPE"
    open -a "Jellyfin Media Player" 2>/dev/null
    exit 0
fi

if [ ! -f "\$SHADER_DIR/Anime4K_Clamp_Highlights.glsl" ] && [ "\$1" != "--low" ]; then
    echo "\$TXT_DOWN"
    mkdir -p "\$SHADER_DIR"
    curl -sL -o /tmp/Anime4K.zip "https://github.com/bloc97/Anime4K/releases/download/v4.0.1/Anime4K_v4.0.zip"
    unzip -qo /tmp/Anime4K.zip -d "\$SHADER_DIR"
    rm -f /tmp/Anime4K.zip
fi

mkdir -p "\$JMP_DIR"

if [ "\$1" = "--max" ]; then
    cat << IN_EOF > "\$CONF"
profile=gpu-hq
vo=gpu-next
deband=yes
deband-iterations=4
deband-threshold=48
deband-range=24
deband-grain=16
scale=ewa_lanczossharp
cscale=ewa_lanczossharp
dscale=mitchell
glsl-shaders="\$SHADER_DIR/Anime4K_Clamp_Highlights.glsl:\$SHADER_DIR/Anime4K_Restore_CNN_VL.glsl:\$SHADER_DIR/Anime4K_Upscale_CNN_x2_VL.glsl:\$SHADER_DIR/Anime4K_AutoDownscalePre_x2.glsl:\$SHADER_DIR/Anime4K_AutoDownscalePre_x4.glsl:\$SHADER_DIR/Anime4K_Restore_CNN_M.glsl:\$SHADER_DIR/Anime4K_Upscale_CNN_x2_M.glsl"
IN_EOF
    echo "\$TXT_MAX"

elif [ "\$1" = "--ultra" ]; then
    cat << IN_EOF > "\$CONF"
profile=gpu-hq
vo=gpu-next
deband=yes
scale=ewa_lanczossharp
cscale=bilinear
dscale=mitchell
glsl-shaders="\$SHADER_DIR/Anime4K_Clamp_Highlights.glsl:\$SHADER_DIR/Anime4K_Restore_CNN_L.glsl:\$SHADER_DIR/Anime4K_Upscale_CNN_x2_L.glsl:\$SHADER_DIR/Anime4K_AutoDownscalePre_x2.glsl:\$SHADER_DIR/Anime4K_Restore_CNN_S.glsl"
IN_EOF
    echo "\$TXT_ULTRA"

elif [ "\$1" = "--mid" ]; then
    cat << IN_EOF > "\$CONF"
profile=gpu-hq
vo=gpu-next
deband=yes
scale=spline36
cscale=bilinear
dscale=mitchell
glsl-shaders="\$SHADER_DIR/Anime4K_Clamp_Highlights.glsl:\$SHADER_DIR/Anime4K_Restore_CNN_M.glsl:\$SHADER_DIR/Anime4K_Upscale_CNN_x2_M.glsl:\$SHADER_DIR/Anime4K_AutoDownscalePre_x2.glsl:\$SHADER_DIR/Anime4K_AutoDownscalePre_x4.glsl:\$SHADER_DIR/Anime4K_Upscale_CNN_x2_S.glsl"
IN_EOF
    echo "\$TXT_MID"

elif [ "\$1" = "--low" ]; then
    cat << IN_EOF > "\$CONF"
profile=gpu-hq
vo=gpu-next
deband=no
glsl-shaders=""
IN_EOF
    echo "\$TXT_LOW"
fi

open -a "Jellyfin Media Player" 2>/dev/null
EOF

chmod +x "$SCRIPT_PATH"

if [ -d "$HOME/.config/fish/functions" ]; then
    echo "function up; bash $SCRIPT_PATH \$argv; end" > "$HOME/.config/fish/functions/up.fish"
    echo "function upscale; bash $SCRIPT_PATH \$argv; end" > "$HOME/.config/fish/functions/upscale.fish"
fi

if [ -f "$HOME/.zshrc" ]; then
    sed -i '' '/alias up=/d' "$HOME/.zshrc"
    sed -i '' '/alias upscale=/d' "$HOME/.zshrc"
    echo "alias up=\"bash $SCRIPT_PATH\"" >> "$HOME/.zshrc"
    echo "alias upscale=\"bash $SCRIPT_PATH\"" >> "$HOME/.zshrc"
fi

echo ""
if [ "$LANG_PREF" = "fr" ]; then
    echo "✅ Installation terminée !"
    echo "Utilisez : up --max | up --ultra | up --mid | up --low"
else
    echo "✅ Installation complete !"
    echo "Use: up --max | up --ultra | up --mid | up --low"
fi