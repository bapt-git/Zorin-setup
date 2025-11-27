#!/bin/bash

# > Installation Firefox
sudo snap remove firefox
sudo add-apt-repository ppa:mozillateam/ppa -y
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox

sudo apt update
sudo apt install -y firefox

# > Configuration clavier

# Insérer à la ligne 5
sed -i '5i include "mswindows-capslock"' /usr/share/X11/xkb/symbols/fr

# Génération du fichier
echo "// Replicate a \"feature\" of MS Windows on AZERTY keyboards
// where Caps Lock also acts as a Shift Lock on number keys.
// Include keys <AE01> to <AE10> in the FOUR_LEVEL_ALPHABETIC key type.

partial alphanumeric_keys
xkb_symbols \"basic\" {
    key <AE01>	{ type= \"FOUR_LEVEL_ALPHABETIC\", [ ampersand,          1,          bar,   exclamdown ]	};
    key <AE02>	{ type= \"FOUR_LEVEL_ALPHABETIC\", [    eacute,          2,           at,    oneeighth ]	};
    key <AE03>	{ type= \"FOUR_LEVEL_ALPHABETIC\", [  quotedbl,          3,   numbersign,     sterling ]	};
    key <AE04>	{ type= \"FOUR_LEVEL_ALPHABETIC\", [apostrophe,          4,   onequarter,       dollar ]	};
    key <AE05>	{ type= \"FOUR_LEVEL_ALPHABETIC\", [ parenleft,          5,      onehalf, threeeighths ]	};
    key <AE06>	{ type= \"FOUR_LEVEL_ALPHABETIC\", [   section,          6,  asciicircum,  fiveeighths ]	};
    key <AE07>	{ type= \"FOUR_LEVEL_ALPHABETIC\", [    egrave,          7,    braceleft, seveneighths ]	};
    key <AE08>	{ type= \"FOUR_LEVEL_ALPHABETIC\", [    exclam,          8,  bracketleft,    trademark ]	};
    key <AE09>	{ type= \"FOUR_LEVEL_ALPHABETIC\", [  ccedilla,          9,    braceleft,    plusminus ]	};
    key <AE10>	{ type= \"FOUR_LEVEL_ALPHABETIC\", [    agrave,          0,   braceright,       degree ]	};
};"  >  /usr/share/X11/xkb/symbols/mswindows-capslock;


# Installation de Bitwarden
flatpak install -y flathub com.bitwarden.desktop
