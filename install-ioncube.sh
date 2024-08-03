#!/bin/bash
# Copyright (c) 2024 Ángel (Crujera27)
# Version: 1.3

echo "WARNING: This script is recommended to be run on a clean system. It may modify your PHP configuration or even break stuff."
read -p "Do you wish to proceed? (y/n): " proceed_choice

if [ "$proceed_choice" != "y" ]; then
    echo "Exiting script. No changes have been made."
    exit 1
fi

sudo apt update
sudo apt install -y wget tar
echo ".___                          ___.            .__                 __         .__  .__                
|   | ____   ____   ____  __ _\_ |__   ____   |__| ____   _______/  |______  |  | |  |   ___________ 
|   |/  _ \ /    \_/ ___\|  |  \ __ \_/ __ \  |  |/    \ /  ___/\   __\__  \ |  | |  | _/ __ \_  __ \
|   (  <_> )   |  \  \___|  |  / \_\ \  ___/  |  |   |  \\___ \  |  |  / __ \|  |_|  |_\  ___/|  | \/
|___|\____/|___|  /\___  >____/|___  /\___  > |__|___|  /____  > |__| (____  /____/____/\___  >__|   
                \/     \/          \/     \/          \/     \/            \/               \/       "
echo "By Crujera27 (github.com/Crujera27)"
echo "This is a completely unofficial installer; I'm not affiliated with or related to IonCube in any way"
echo "Choose IonCube Loader version:"
echo "1. PHP 7.4"
echo "2. PHP 7.3"
echo "3. PHP 7.2"
echo "4. PHP 8.0"
echo "5. PHP 8.1"
echo "6. PHP 8.2"
read -p "Enter your choice (1, 2, 3, 4, 5, or 6): " version_choice

case $version_choice in
    1) PHP_VERSION="7.4";;
    2) PHP_VERSION="7.3";;
    3) PHP_VERSION="7.2";;
    4) PHP_VERSION="8.0";;
    5) PHP_VERSION="8.1";;
    6) PHP_VERSION="8.2";;
    *) echo "Invalid choice. Exiting."; exit 1;;
esac

echo "Choose installation target:"
echo "1. FPM only"
echo "2. CLI only"
echo "3. Both FPM and CLI"
read -p "Enter your choice (1, 2, or 3): " target_choice

case $target_choice in
    1) TARGET="fpm";;
    2) TARGET="cli";;
    3) TARGET="both";;
    *) echo "Invalid choice. Exiting."; exit 1;;
esac

cd /tmp

wget "https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz"
tar xzf ioncube_loaders_lin_x86-64.tar.gz

PHP_EXT_DIR=$(php${PHP_VERSION} -r "echo ini_get('extension_dir');")
sudo cp "ioncube/ioncube_loader_lin_${PHP_VERSION}.so" $PHP_EXT_DIR

INI_DIR="/etc/php/${PHP_VERSION}/${TARGET}/conf.d"
if [ ! -d "$INI_DIR" ]; then
    sudo mkdir -p "$INI_DIR"
fi
echo "zend_extension=$PHP_EXT_DIR/ioncube_loader_lin_${PHP_VERSION}.so" | sudo tee "$INI_DIR/00-ioncube.ini"

rm -rf /tmp/ioncube*

if [ "$TARGET" == "fpm" ] || [ "$TARGET" == "both" ]; then
    sudo service "php${PHP_VERSION}-fpm" restart
fi

PHP_BINARY_PATH=$(which php${PHP_VERSION})
$PHP_BINARY_PATH -m | grep ionCube

echo "IonCube Loader for PHP $PHP_VERSION has been successfully installed on $TARGET."
