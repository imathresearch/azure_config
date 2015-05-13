function aptget {

    for p in $(echo $1);
    do
        PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $p|grep "install ok installed")
        echo ""
        echo "________________________________"
        echo "Checking for $p"
        if [ "" == "$PKG_OK" ]; then
             echo "$p not found. Setting up $p"
             sudo apt-get --force-yes --yes install $p
        fi
    done

}


#################################################################################################

################################   GLOBAL PACKAGES    ###########################################

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Installing general required packages"
echo "------------------------------------------------------------------------------------------"
packages="libcurl4-openssl-dev openssh-server git-core postgresql libpq-dev libfreetype6-dev"
aptget "$packages"

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Installing python required packages"
echo "------------------------------------------------------------------------------------------"
packages="python-dev python-pycurl python-numpy python-scipy python-sklearn python-pymongo python-simplejson python-psycopg2 python-paramiko python-tornado python-psutil python-pip python-matplotlib"
aptget "$packages"

echo "------------------------------------------------------------------------------------------"
echo "Setting postgresql "
echo "------------------------------------------------------------------------------------------"
sudo export LANGUAGE="es_ES.UTF-8"
sudo export LC_ALL="es_ES.UTF-8"
sudo dpkg-reconfigure locales
sudo pg_createcluster 9.3 main --start

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Installing the common version of IPython Notebook"
echo "------------------------------------------------------------------------------------------"
packages="ipython ipython-notebook"
aptget "$packages"

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Upgrading matplotlib for video visualization"
echo "------------------------------------------------------------------------------------------"

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Installing R"
echo "------------------------------------------------------------------------------------------"
packages="r-base python-rpy2"
aptget "$packages"

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Installing Octave"
echo "------------------------------------------------------------------------------------------"
sudo apt-add-repository ppa:octave/stable
sudo apt-get update
packages="octave liboctave-dev"
aptget "$packages"

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Installing oct2py"
echo "------------------------------------------------------------------------------------------"
cd /tmp
wget https://pypi.python.org/packages/source/o/oct2py/oct2py-1.6.0.tar.gz#md5=5169f791c0a3ec6f99d91decbec86725
tar -zxf oct2py-1.6.0.tar.gz
cd oct2py-1.6.0
sudo python setup.py install

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Installing Java 7"
echo "------------------------------------------------------------------------------------------"
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
packages="oracle-java7-installer"
aptget "$packages"
sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/java-7-oracle/bin/java" 1
sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/java-7-oracle/bin/javac" 1
sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/java-7-oracle/bin/javaws" 1
sudo update-alternatives --config java

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Installing Maven"
echo "------------------------------------------------------------------------------------------"
packages="maven2"
aptget "$packages"
cd /tmp
wget http://apache.rediris.es/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz
tar -zxf apache-maven-3.1.1-bin.tar.gz
sudo mkdir /usr/local/apache-maven
sudo cp -R apache-maven-3.1.1 /usr/local/apache-maven/

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Installing JBOSS"
echo "------------------------------------------------------------------------------------------"
cd ~/
scp -r imath@158.109.125.112:/home/imath/jboss_production .
cd jboss_production
unzip jboss-eap-6.3.0.zip
cp -r postgresql/ jboss-eap-6.3/modules/system/layers/base/com/
cp standalone.xml jboss-eap-6.3/standalone/configuration/
## Pass to specify --> "changeit"
sudo /usr/lib/jvm/java-7-oracle/bin/keytool -genkey -alias tomcat -keyalg RSA

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Writing variables to bashrc"
echo "------------------------------------------------------------------------------------------"
echo "export JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> ~/.bashrc
echo "export JRE_HOME=\$JAVA_HOME/jre" >> ~/.bashrc
echo "export M2_HOME=/usr/local/apache-maven/apache-maven-3.1.1" >> ~/.bashrc
echo "export M2=\$M2_HOME/bin" >> ~/.bashrc
echo "export MAVEN_OPTS=\"-XX:PermSize=128m -XX:MaxPermSize=256m\"" >> ~/.bashrc 
echo "export PATH=\$JAVA_HOME/bin:\$M2:\$PATH" >> ~/.bashrc




