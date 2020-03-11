#!/bin/sh
sudo apt install apache2 -y
sudo a2enmod rewrite
sudo service apache2 restart
sudo chown -R pi:www-data /var/www/html/
sudo chmod -R 770 /var/www/html/
sudo nano /etc/apache2/apache2.conf

sudo service apache2 restart
sudo apt install php libapache2-mod-php -y
sudo rm /var/www/html/index.html
echo "<?php phpinfo ();?>" > /var/www/html/index.php
sudo apt install mariadb-client mariadb-server php-mysql -y
sudo service apache2 restart
SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"root\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")
 
echo "$SECURE_MYSQL"

sudo apt install -y phpmyadmin
#Allow phpmyadmin to manage all databases
mysql -e "CREATE USER 'root'@'localhost' IDENTIFIED BY 'root';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"
mysql -e "FLUSH PRIVILEGES;"
sudo systemctl restart apache2


echo '********************************************************************'
