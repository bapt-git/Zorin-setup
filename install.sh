#!/bin/bash
set -e  # Arrêter en cas d'erreur

# =============================================================================
# Installation Firefox (via PPA au lieu de Snap)
# =============================================================================

sudo snap remove firefox || true  # Ignorer si déjà supprimé
sudo add-apt-repository ppa:mozillateam/ppa -y

echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox > /dev/null

sudo apt update
sudo apt install -y firefox

# =============================================================================
# Configuration clavier AZERTY - Caps Lock agit comme Shift Lock sur chiffres
# =============================================================================

XKB_SYMBOLS_DIR="/usr/share/X11/xkb/symbols"
CAPSLOCK_FILE="$XKB_SYMBOLS_DIR/mswindows-capslock"
FR_FILE="$XKB_SYMBOLS_DIR/fr"

# Création du fichier mswindows-capslock
sudo tee "$CAPSLOCK_FILE" > /dev/null << 'EOF'
// Replicate a "feature" of MS Windows on AZERTY keyboards
// where Caps Lock also acts as a Shift Lock on number keys.
// Include keys <AE01> to <AE10> in the FOUR_LEVEL_ALPHABETIC key type.

partial alphanumeric_keys
xkb_symbols "basic" {
    key <AE01>	{ type= "FOUR_LEVEL_ALPHABETIC", [ ampersand,          1,          bar,   exclamdown ]	};
    key <AE02>	{ type= "FOUR_LEVEL_ALPHABETIC", [    eacute,          2,           at,    oneeighth ]	};
    key <AE03>	{ type= "FOUR_LEVEL_ALPHABETIC", [  quotedbl,          3,   numbersign,     sterling ]	};
    key <AE04>	{ type= "FOUR_LEVEL_ALPHABETIC", [apostrophe,          4,   onequarter,       dollar ]	};
    key <AE05>	{ type= "FOUR_LEVEL_ALPHABETIC", [ parenleft,          5,      onehalf, threeeighths ]	};
    key <AE06>	{ type= "FOUR_LEVEL_ALPHABETIC", [   section,          6,  asciicircum,  fiveeighths ]	};
    key <AE07>	{ type= "FOUR_LEVEL_ALPHABETIC", [    egrave,          7,    braceleft, seveneighths ]	};
    key <AE08>	{ type= "FOUR_LEVEL_ALPHABETIC", [    exclam,          8,  bracketleft,    trademark ]	};
    key <AE09>	{ type= "FOUR_LEVEL_ALPHABETIC", [  ccedilla,          9, bracketright,    plusminus ]	};
    key <AE10>	{ type= "FOUR_LEVEL_ALPHABETIC", [    agrave,          0,   braceright,       degree ]	};
};
EOF

# Ajout de l'include dans le fichier fr (seulement si pas déjà présent)
if ! grep -q 'include "mswindows-capslock"' "$FR_FILE"; then
    # Insertion après la ligne 'include "latin"' avec indentation
    sudo sed -i '/include "latin"/a\    include "mswindows-capslock"' "$FR_FILE"
    echo "Include ajouté dans $FR_FILE"
else
    echo "Include déjà présent dans $FR_FILE, rien à faire"
fi

# =============================================================================
# Installation de Bitwarden
# =============================================================================

flatpak install -y --noninteractive flathub com.bitwarden.desktop 2>&1 | cat || true

echo "Installation terminée !"

# =============================================================================
# Forcer Xorg (désactiver Wayland) pour compatibilité AnyDesk
# =============================================================================

GDM_CONF="/etc/gdm3/custom.conf"

# Créer le fichier si absent
touch "$GDM_CONF"

# Si WaylandEnable existe (commenté ou non), le forcer à false
if grep -q '^#\?WaylandEnable=' "$GDM_CONF"; then
    sed -i 's/^#\?WaylandEnable=.*/WaylandEnable=false/' "$GDM_CONF"
else
    echo 'WaylandEnable=false' >> "$GDM_CONF"
fi

echo "Wayland désactivé (Xorg activé). Un redémarrage est nécessaire."
