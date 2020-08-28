#!/bin/bash
#Installation for Ubuntu softwares .
d=DOMAIN.RAGE-INDIA.com

cra(){
    read -p 'Enter AD Username : ' user
    read -s -p "Enter AD Password: " passwd
    echo ""
    us=$user
    pass=$passwd
}

domainjoin(){
    cra
    echo -ne "Domain Joining ..."
    echo ""
    cd /tmp
    echo -ne '###                                              (10%)\r'
    wget https://github.com/Darkshadee/pbis-open/releases/download/9.1.0/pbis-open-9.1.0.551.linux.x86_64.deb.sh >/dev/null 2>&1
    echo -ne '#######                                          (20%)\r'
    sh pbis-open-9.1.0.551.linux.x86_64.deb.sh >/dev/null 2>&1
    echo -ne '###############                                  (30%)\r'
#    cd pbis-open-9.1.0.551.linux.x86_64.deb
    echo -ne '######################                           (50%)\r'
 #   chmod +x pbis-open-9.1.0.551.linux.x86_64.deb/install.sh
    echo -ne '##########################                       (60%)\r'
  #  sh pbis-open-9.1.0.551.linux.x86_64.deb/install.sh  >/dev/null 2>&1
    echo -ne '#################################                (75%)\r'
    domainjoin-cli join --disable ssh $d $us $pass 
    echo -ne '#####################################            (85%)\r'
    #echo $us
    cd /
    rm -rf /tmp/pbis-open-9.1.0.551.linux.x86_64.*
    echo -ne '##########################################       (90%)\r'
    apt-get install ssh -y >/dev/null 2>&1
    echo -ne '################################################ (100%)\r'
    echo -ne "Domain Joining ... \033[1;32mDONE \033[m"
    echo -ne "System will be reboot in few seconds "
    sleep 10
    /sbin/reboot
}

domainrm()
{
	echo -ne "Domain Removing"
    echo ""
    echo -ne '###                                              (10%)\r'
	pbis leave >/dev/null 2>&1
    echo -ne '#################################                (75%)\r'
	apt purge pbis -y >/dev/null 2>&1
    echo -ne '################################################ (100%)\r'
	echo -ne "Domain Removed ... \033[1;32mDONE \033[m"
    echo -ne "System will be reboot in few seconds "
    sleep 10
    /sbin/reboot
}

domain()
{
    opp='Please enter your choice: '
    opti=("Join" "Remove")
    select oppt in "${opti[@]}"
    do
        case $oppt in
            "Join")
                domainjoin
                break
                ;;
            "Remove")
                domainrm
                break
                ;;

            *) echo "invalid option"
                break
                ;;
        esac
    done
}

symantec(){
    echo -ne "Installing Symantec ..."
    echo ""
 	cd /tmp/
    echo -ne '###                                              (10%)\r'
    apt-get install smbclient -y >/dev/null 2>&1
    echo -ne '#######                                          (20%)\r'
    smbclient //172.16.1.17/softwares -W domain.rage-india.com -U $us --pass $pass -c 'prompt OFF; recurse ON; cd Symantec_2019/ubuntu/SymantecEndpointProtection; lcd /tmp/; mget *' >/dev/null 2>&1
    echo -ne '###############                                  (30%)\r'
    chmod +x /tmp/install.sh
    dpkg --add-architecture i386 -y >/dev/null 2>&1
    echo -ne '######################                           (50%)\r'
    apt-get update -y >/dev/null 2>&1
    echo -ne '##########################                       (60%)\r'
    apt-get install libc6:i386 libx11-6:i386 libncurses5:i386 libstdc++6:i386 -y >/dev/null 2>&1
    echo -ne '#################################                (75%)\r'
    apt-get install lib32ncurses5 lib32z1 -y >/dev/null 2>&1
    echo -ne '#####################################            (85%)\r'
    ./install.sh -i >/dev/null 2>&1
    echo -ne '##########################################       (90%)\r'
    cd /
    rm -rf /tmp/*
    echo -ne '################################################ (100%)\r'
    echo ""
    echo -ne "\rInstalling Symantec ... \033[1;32mDONE \033[m"    
}

symunins()
{
    echo -ne "Uninstalling Symantec ..."
    echo ""
    echo -ne '###                                              (10%)\r'
 	cd /tmp/
     echo -ne '###############                                  (30%)\r'
    apt-get install smbclient -y >/dev/null 2>&1
    echo -ne '######################                           (50%)\r'
    smbclient //172.16.1.17/softwares -W domain.rage-india.com -U $us --pass $pass -c 'prompt OFF; recurse ON; cd Symantec_2019/ubuntu/SymantecEndpointProtection; lcd /tmp/; mget *' >/dev/null 2>&1
    echo -ne '#################################                (75%)\r'
    chmod +x /tmp/install.sh
    echo -ne '#####################################            (85%)\r'
    ./install.sh -u >/dev/null 2>&1
    echo -ne '##########################################       (90%)\r'
    cd /
    rm -rf /tmp/*
    echo -ne '################################################ (100%)\r'
    echo ""
    echo -ne "\rUninstalling Symantec ... \033[1;32mDONE \033[m"
}

sym()
{
    opp='Please enter your choice: '
    opti=("Install" "Uninstall")
    select oppt in "${opti[@]}"
    do
    case $oppt in
        "Install")
            symantec
            break
            ;;
        "Uninstall")
            symunins
            break
            ;;

        *) echo "invalid option"
            break
            ;;
    esac
    done

}

mariadb(){
pkgs='mariadb-server'
if ! dpkg -s $pkgs >/dev/null 2>&1; then
	echo -ne "Installing Mariadb ..."
        apt-get install -y $pkgs >/dev/null
	echo -ne "\rInstalling Mariadb ... \033[1;32mDONE \033[m"
else
	echo -ne "\rMariadb Installed ... \033[1;32mDONE \033[m"
fi
}

php5_6(){

	pkgs='software-properties-common'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
		apt install software-properties-common -y >/dev/null
 		add-apt-repository ppa:ondrej/php -y >/dev/null
		apt-get update -y >/dev/null
	else
		sudo apt-get install php5.6-fpm php5.6-bcmath php5.6-cli php5.6-common php5.6-curl php5.6-gd php5.6-intl php5.6-imap php5.6-json php5.6-ldap php5.6-mbstring php5.6-mysql php5.6-sqlite3 php5.6-mcrypt php5.6-pspell php5.6-soap php5.6-tidy php5.6-xml php5.6-xsl php5.6-zip -y >/dev/null
		sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9002/g' /etc/php/5.6/fpm/pool.d/www.conf
		sudo update-rc.d php5.6-fpm defaults >/dev/null
	fi
}

php7_0(){

	pkgs='software-properties-common'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
		apt install software-properties-common -y >/dev/null
		add-apt-repository ppa:ondrej/php -y >/dev/null
		apt-get update -y >/dev/null
	else
		sudo apt-get install php7.0-fpm php7.0-bcmath php7.0-cli php7.0-common php7.0-curl php7.0-gd php7.0-intl php7.0-imap php7.0-json php7.0-ldap php7.0-mbstring php7.0-mysql php7.0-sqlite3 php7.0-mcrypt php7.0-pspell php7.0-soap php7.0-tidy php7.0-xml php7.0-xsl php7.0-zip -y >/dev/null
		sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9001/g' /etc/php/7.0/fpm/pool.d/www.conf
		sudo update-rc.d php7.0-fpm defaults >/dev/null
	fi
}

php7_1(){

	pkgs='software-properties-common'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
		apt install software-properties-common -y >/dev/null
		add-apt-repository ppa:ondrej/php >/dev/null
		apt-get update -y >/dev/null
	else
		sudo apt-get install php7.1-fpm php7.1-bcmath php7.1-cli php7.1-common php7.1-curl php7.1-gd php7.1-intl php7.1-imap php7.1-json php7.1-ldap php7.1-mbstring php7.1-mysql php7.1-sqlite3 php7.1-mcrypt php7.1-pspell php7.1-soap php7.1-tidy php7.1-xml php7.1-xsl php7.1-zip -y >/dev/null
		sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9000/g' /etc/php/7.1/fpm/pool.d/www.conf
		sudo update-rc.d php7.1-fpm defaults >/dev/null
	fi
}

php7_2(){

	pkgs='software-properties-common'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
		apt install software-properties-common -y >/dev/null
		add-apt-repository ppa:ondrej/php >/dev/null
		apt-get update -y >/dev/null
	else
		apt-get install php7.2-fpm php7.2-bcmath php7.2-cli php7.2-common php7.2-curl php7.2-gd php7.2-intl php7.2-imap php7.2-json php7.2-ldap php7.2-mbstring php7.2-mysql php7.2-sqlite3  php7.2-pspell php7.2-soap php7.2-tidy php7.2-xml php7.2-xsl php7.2-zip -y >/dev/null
		sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9003/g' /etc/php/7.2/fpm/pool.d/www.conf
		sudo update-rc.d php7.2-fpm defaults >/dev/null
	fi
}

php_install(){

if ! [ -x "$(command -v php5.6)"  ]; then
	echo -ne "Php5.6 is installing ..."
	php5_6
	echo -ne "\rPhp5.6 is installing ... \033[1;32mDONE \033[m"
	php_install
elif ! [ -x "$(command -v php7.0)"  ]; then
        echo -ne "Php7.0 is installing ..."
	php7_0
	echo -ne "\rPhp7.0 is installing ... \033[1;32mDONE \033[m"
	php_install
elif ! [ -x "$(command -v php7.1)"  ]; then
        echo -ne "Php7.1 is installing ..."
	php7_1
	echo -ne "\rPhp7.1 is installing ... \033[1;32mDONE \033[m"
	php_install
elif ! [ -x "$(command -v php7.2)"  ]; then
        echo -ne "Php7.2 is installeing ..."
	php7_2
	echo -ne "\rPhp7.2 is installing ... \033[1;32mDONE \033[m"
	php_install
      echo "Php is installed"

fi
}

nginx(){
pkgs='nginx'
if ! dpkg -s $pkgs >/dev/null 2>&1; then
	echo -ne "Installing Nginx "
        apt-get install -y $pkgs >/dev/null
	echo -ne "\rInstalling Nginx ... \033[1;32mDONE \033[m"
fi
}

nodejs(){
        
        clear
           read -p "Past URL to Install : " url
            u=`echo $url | grep -o '\b\w*linux-x64\w*\b'`


            if  curl --output /dev/null --silent --head --fail "$url"; then
                    
                if [ "$u" = linux-x64 ]
                then

                    i=`echo $url | sed 's|.*/||'` 
                    z=`echo $url | sed 's|.*tar.||'`
                    # echo $i

                    if [ "$z" = xz ]
                    then

                        curl -o $i $url
                        tar -C /usr/local --strip-components 1 -xf $i
                        npm install -g npm@latest

                        NODE_VER=$(node -v)
                        NPM_VER=$(npm -v)

                        echo -ne " Nodejs" "\033[0;32m$NODE_VER\033[0m" "Installed Sucessfully"
                        echo -ne " Npm" "\033[0;32m$NPM_VER\033[0m" "Installed Sucessfully"

                    elif [ "$z" = gz ] 
                    then

                        curl -o $i $url
                        tar -C /usr/local --strip-components 1 -xzf $i 
                        npm install -g npm@latest
                        NODE_VER=$(node -v)
                        NPM_VER=$(npm -v)

                        echo -ne " Nodejs" "\033[0;32m$NODE_VER\033[0m" "Installed Sucessfully"
                        echo -ne " Npm" "\033[0;32m$NPM_VER\033[0m" "Installed Sucessfully"

                    else
                        echo "Invalid Extantion"

                    fi

                else
                echo ""
                echo -ne "\033[0;31mPlease Select Linux-x64 Package URL\033[0m " 
                echo ""
                exit;

                fi

            else
                echo ""
                printf '%s\n' "Invalid URL, Retry Again"
                echo ""
            fi  
}



dockercompose(){
pkgs='docker-compose'
if ! dpkg -s $pkgs >/dev/null 2>&1; then
        echo -ne "Installing Missing Docker-compose ..."
	curl -s -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose > /dev/null
	chmod +x /usr/local/bin/docker-compose
       apt-get install -y $pkgs >/dev/null
        echo -ne "\rInstalling Missing Docker-compose ...\033[1;32mDONE \033[m"
fi
}

lando(){

read -p "If you want to install Lando Press Y/n : " lan

if [ "$lan" = "y" ] || [ "$lan" = "Y" ] || [ "$lan" = "" ]; then
	#echo "[Enter] Pressed"
	echo -ne "Lando Installing ..."
    echo ""
    echo -ne '###                                              (10%)\r'
    cd /tmp
    echo -ne '#######                                          (20%)\r'
    sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y >/dev/null 2>&1
    echo -ne '###############                                  (30%)\r'
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - >/dev/null 2>&1
    sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" >/dev/null 2>&1
    echo -ne '######################                           (50%)\r'
    sudo apt-get update -y >/dev/null 2>&1
    echo -ne '##########################                       (60%)\r'
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y >/dev/null 2>&1
	echo -ne '#################################                (75%)\r'
    wget https://github.com/lando/lando/releases/download/v3.0.0-rc.22/lando-v3.0.0-rc.22.deb >/dev/null 2>&1
	echo -ne '#####################################            (85%)\r'
    dpkg -i lando-v3.0.0-rc.22.deb  >/dev/null 2>&1
    echo -ne '##########################################       (90%)\r'
    rm -rf lando-v3.0.0-rc.22.deb
    echo -ne '################################################ (100%)\r'
    echo ""
	echo -ne "\rLando Installing ...\033[1;32mDONE \033[m"
else 
	echo "\033[0;31mLando Installation Exit\033[0m"
fi
}

docker(){

    echo -ne "\033[1;32mFor Docker Installtion !!!\033[0m "
    echo ""
#search_dir='ls  /home/local/RAGE/  | awk -F'\n' '{print NR, $1}''
per='RAGE\'
domain='RAGE\domain^users'

read -p 'Press Enter to continue or ctrl+c to Abort' key
if [ "$key" = "" ]; then
ls  /home/local/RAGE/  | awk -F'\n' '{print NR, $1}'
echo " "  
echo -ne "\033[0;31mEnter Username :\033[0m "
read optr
#echo "$opt"
if [ -z "$optr" ]
then
    echo "user did not exist"
	echo " "
else
	user=' /home/local/RAGE/'"$optr"
    cd $user
	echo -ne "Permission Changing"
	# chmod -R 777 projects/php/data/
	# chmod -R 777 projects/php/docker/vhosts
	chown -R $per''$optr:$domain projects/
	echo -ne "\rPermission changing ... \033[1;32mDONE \033[m"
	sleep 1;
	echo -ne "Php is installing ..."
	php_install
	echo -ne "\rPhp is installing ... \033[1;32mDONE \033[m"
	mariadb
	sleep 1;
	echo -ne "Mariadb Stop and Disable \033[1;32mDONE \033[m"
	systemctl stop mysql --quiet
	systemctl disable mysql --quiet
	echo -ne "\rMariadb Stop and Disable ... \033[1;32mDONE \033[m"
	sleep 1;
	nginx
	echo -ne 'Nginx stop and disable '
	systemctl stop nginx --quiet
	systemctl disable nginx --quiet
	echo -ne '\rNginx stop and disable ... \033[1;32mDONE \033[m'
	sleep 1;
	echo -ne 'PHP stopping and disable '
	systemctl stop php5.6-fpm --quiet
	systemctl disable php5.6-fpm --quiet
	systemctl stop php7.0-fpm --quiet
	systemctl disable php7.0-fpm --quiet
	systemctl stop php7.1-fpm  --quiet
	systemctl disable php7.1-fpm --quiet
	systemctl stop php7.2-fpm --quiet
	systemctl disable php7.2-fpm --quiet
	echo -ne '\rPHP stopping and disable ... \033[1;32mDONE \033[m'
	sleep 1;
	dockercompose
	sleep 1;
	cd $user/projects/php/docker/
#	./bin/start
	echo -ne '\033[1;32mDocker Installed Sucessfully \033[m'
	
fi
fi
}

ins(){
    clear
if [ `whoami` != root ]; then
        echo -ne "\033[0;31mPlease run this scripts as root or using sudo\033[0m "
		echo ""
        exit
else
    op='Please enter your choice: '
    options=("Domain join" "Symantec" "Mariadb" "Php" "Nginx" "Nodejs" "Lando" "Docker" "All" "Quit")
    select opt in "${options[@]}"
    do
    case $opt in
        "Domain join")
            domain
            break
            ;;
        "Symantec")
            sym
            break
            ;;
        "Mariadb")    
            mariadb
            break
            ;;
        "Php")
            php_install
            break
            ;;
        "Nginx")
            nginx
            break
            ;;
        "Nodejs")
            nodejs
            break
            ;;    
        "Lando")
            lando
            break
            ;;
        "Docker")
            docker
            break
            ;;
        "All")
            domain
            symantec
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
    #cra
    #domainjoin
    #symantec
fi
}
ins
