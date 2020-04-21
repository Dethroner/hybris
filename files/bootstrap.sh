#!/usr/bin/env bash

HYBRISDIR="/opt/hybris" 

apt update -y

echo "Installing wget.."
apt install wget -y

echo "Installing Java 8.."
cd /opt/
wget http://enos.itcollege.ee/~jpoial/allalaadimised/jdk8/jdk-8u241-linux-x64.tar.gz
tar xzf jdk-8u241-linux-x64.tar.gz
cd /opt/jdk1.8.0_241/
update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_241/bin/java 2
update-alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_241/bin/jar 2
update-alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_241/bin/javac 2
update-alternatives --set jar /opt/jdk1.8.0_241/bin/jar
update-alternatives --set javac /opt/jdk1.8.0_241/bin/javac
echo "Java Version: "
java -version
echo "Setting JAVA_HOME Variable.."
export JAVA_HOME=/opt/jdk1.8.0_241
echo "Settting JRE_HOME Variable..."
export JRE_HOME=/opt/jdk1.8.0_241/jre
echo "Setting PATH Variable"..
export PATH=$PATH:/opt/jdk1.8.0_241/bin:/opt/jdk1.8.0_241/jre/bin

echo "Copying the Hybris installatiion from from host to guest machine.."
echo "Creating Hybris home directory..."
mkdir $HYBRISDIR
cd $HYBRISDIR
cp /vagrant/HYBRISCOMM6600P_25-70003031.ZIP $HYBRISDIR/
echo "Installing Unzip..."
apt -y install unzip

echo "Unzipping the Hybris Installation.."
unzip HYBRISCOMM6600P_25-70003031.ZIP

echo "Removing the Hybris Installation zip file.."
rm HYBRISCOMM6600P_25-70003031.ZIP


cat <<EOF | sudo tee /opt/hybrisstart.sh
cd $HYBRISDIR/hybris/bin/platform
. ./setantenv.sh
ant clean all -Dinput.template=develop
./hybrisserver.sh
EOF
chmod +x /opt/hybrisstart.sh

cat <<EOF | sudo tee /etc/systemd/system/hybris.service
[Unit]
Description=Hybris

[Service]
ExecStart=/opt/hybrisstart.sh

[Install]
WantedBy=multi-user.target
EOF
chmod +x /etc/systemd/system/hybris.service

systemctl start hybris