#!/bin/bash
set -e

FALLBACK="Themes/_fallback";         MODULES="Modules";         MINDBOX="mind\$box";

if [ -d "Appearance" ]; then

    FALLBACK="Appearance/$FALLBACK";        MODULES="$FALLBACK/$MODULES"

fi

SCRIPTS="$FALLBACK/Scripts";        BGANIMATIONS="$FALLBACK/BGAnimations"


# Clone repository.

REPOSITORY="https://github.com/EngineMachiner/mindbox.git"

git clone "$REPOSITORY" "$MODULES/$MINDBOX"


# Add to init script.

echo "Checking initialization script...";           TAPLUA="$SCRIPTS/tapLua.lua"

echo "LoadModule(\"$MINDBOX/$MINDBOX.lua\")" | { grep -xFv -f "$TAPLUA" >> "$TAPLUA" || true; }

echo "Done."


# Open editor to add actors.

cat << EOF

Add the console persistent actor in ScreenSystemLayer aux:

mindbox.console()

EOF

read -p "Nano will open. Press any key to continue."

sudo nano "$BGANIMATIONS/ScreenSystemLayer aux.lua"
