#!/bin/bash
NGINX_INSTALL=0
test -x /usr/sbin/nginx && NGINX_INSTALL=1
if [ $NGINX_INSTALL -eq 0 ]; then
	sudo apt install -y nginx
	OUT=$?
		if [ $OUT -eq 0 ];then
   			echo "Nginx Installation successfull! Version [ `nginx -v` ]"
		else
   			echo "There is some problem installing Nginx on Provisioned VM!"
		fi 
	else
		echo "Nginx is already Installed! Skipping installation"
fi

NODE_INSTALLED=0
test -x /usr/sbin/nginx && NODE_INSTALLED=1
if [ $NODE_INSTALLED -eq 0 ]; then
	sudo apt install -y nodejs
	OUT=$?
		if [ $OUT -eq 0 ];then
   			echo "Nodejs installation successfull with nodejs version [`nodejs -v`]"
		else
   			echo "There is some problem installing nodejs on Provisioned VM!"
		fi
	else
		echo "Nodejs with Version [`nodejs -v`] already Installed! Skipping installation "
fi

NPM_INSTALLED=0
test -x /usr/sbin/npm && NPM_INSTALLED=1
if [ $NPM_INSTALLED -eq 0 ]; then
	sudo apt install -y npm
	OUT=$?
		if [ $OUT -eq 0 ];then
   			echo "NPM installation successfull with npm version [`npm -v`]"
		else
   			echo "There is some problem installing NPM on Provisioned VM!"
		fi
	else
		echo "npm with Version [`npm -v`] already Installed! Skipping installation "
fi

if [ ! -d "/usr/share/nginx/iotlabs" ]; then
  mkdir /usr/share/nginx/iotlabs
fi



#cp -Rf /vagrant_data/index_files /usr/share/nginx/iotlabs
cp /vagrant_data/index.html /usr/share/nginx/iotlabs
cp /vagrant_data/iot.dev /etc/nginx/sites-available/
cp /vagrant_data/app.js /usr/share/nginx/iotlabs
sudo ln -fs "/etc/nginx/sites-available/iot.dev" "/etc/nginx/sites-enabled/iot.dev"
if [ -L "/etc/nginx/sites-enabled/default" ]; then
  sudo unlink "/etc/nginx/sites-enabled/default"
fi

sudo service nginx restart
echo " `pwd` "
cd /usr/share/nginx/iotlabs
npm install express --save
nodejs app.js
