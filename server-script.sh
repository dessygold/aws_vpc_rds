#!/bin/bash

sudo yum update -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd mariadb-server
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl is-enabled httpd
sudo usermod -a -G apache ec2-user
groups
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;

#Secure the database server
set timeout 10
sudo systemctl start mariadb

# SECURE_MYSQL=$(expect -c "
# set timeout 10
# spawn mysql_secure_installation

# expect \"Enter current password for root (enter for none):\"
# send \"\r\"

# expect \"Change the root password?\"
# send \"y\r\"
# expect \"New password:\"
# send \"password\r\"
# expect \"Re-enter new password:\"
# send \"password\r\"
# expect \"Remove anonymous users?\"
# send \"y\r\"

# expect \"Disallow root login remotely?\"
# send \"y\r\"

# expect \"Remove test database and access to it?\"
# send \"y\r\"

# expect \"Reload privilege tables now?\"
# send \"y\r\"

# expect eof
# ")

sudo systemctl stop mariadb
sudo systemctl enable mariadb

sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
cp wordpress/wp-config-sample.php wordpress/wp-config.php

sudo systemctl start mariadb

sudo mysql -u root << EOF
    CREATE USER 'wordpress-user'@'localhost' IDENTIFIED BY 'password';
    CREATE DATABASE \`wordpress-db\`;
    USE \`wordpress-db\`;
    GRANT ALL PRIVILEGES ON \`wordpress-db\`.* TO 'wordpress-user'@'localhost';
    FLUSH PRIVILEGES;
EOF

sudo sed -i 's/database_name_here/wordpress-db/g' wordpress/wp-config.php
sudo sed -i 's/username_here/wordpress-user/g' wordpress/wp-config.php
sudo sed -i 's/password_here/password/g' wordpress/wp-config.php

sudo cp -r wordpress/* /var/www/html/

sudo sed -i '151s/None/All/g' /etc/httpd/conf/httpd.conf

sudo yum install php-gd
sudo yum list installed | grep php
sudo yum list | grep php
sudo yum install php72-gd
sudo chown -R apache /var/www
sudo chgrp -R apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;

sudo systemctl restart httpd
sudo systemctl enable httpd && sudo systemctl enable mariadb
sudo systemctl status mariadb
sudo systemctl start mariadb
sudo systemctl start mariadb
sudo systemctl status httpd
sudo systemctl start httpd