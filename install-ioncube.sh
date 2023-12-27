#!/bin/bash

# Update the package list
sudo apt update

# Install the required packages
sudo apt install wget unzip

# Navigate to the /tmp directory
cd /tmp

# Download the IonCube Loader archive for PHP 7.4
wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz

# Extract the downloaded archive
tar xzf ioncube_loaders_lin_x86-64.tar.gz

# Determine the PHP extension directory
PHP_EXT_DIR=$(php7.4 -r "echo ini_get('extension_dir');")

# Copy the IonCube Loader to the PHP extension directory
sudo cp ioncube/ioncube_loader_lin_7.4.so $PHP_EXT_DIR

# Create a configuration file for IonCube Loader
echo "zend_extension=$PHP_EXT_DIR/ioncube_loader_lin_7.4.so" | sudo tee /etc/php/7.4/cli/conf.d/00-ioncube.ini

# Remove the downloaded files and directory
rm -rf /tmp/ioncube*

# Restart the PHP-FPM service (adjust this based on your PHP setup)
sudo service php7.4-fpm restart

# Verify IonCube Loader installation
php -m | grep ionCube

echo "IonCube Loader for PHP 7.4 has been successfully installed."

# Clean up
rm install-ioncube.sh

