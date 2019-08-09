#!/bin/bash
sudo yum -y update
sudo yum -y install httpd


myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<h2>Build by Power of Terraform <font color="red"> v0.12</font></h2><br>
<font color="green"> Server with IP: <font color="red">$myip<br>
<font color="black">Version 2<br>
</html>
EOF

sudo service httpd start
sudo chkconfig httpd on
