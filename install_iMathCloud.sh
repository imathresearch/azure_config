#################################################################################################

#######################################   CODE    ###############################################

if [ -d  ~/GIT ];
then
    cd ~/GIT
else
    mkdir ~/GIT
    cd ~/GIT
fi

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Cloning iMathCloud and setting up"
echo "------------------------------------------------------------------------------------------"
git clone https://github.com/imathresearch/iMathCloud_BBVA.git iMathCloud

cp ~/GIT/iMathCloud/scripts/* ~/jboss_production/jboss-eap-6.3/bin/
chmod +x ~/jboss_production/jboss-eap-6.3/bin/closeconsole.sh
chmod +x ~/jboss_production/jboss-eap-6.3/bin/console.sh
chmod +x ~/jboss_production/jboss-eap-6.3/bin/getpids.sh
chmod +x ~/jboss_production/jboss-eap-6.3/bin/remove-user.sh

sudo mkdir /iMathCloud
cd /iMathCloud
sudo mkdir -p exec_dir
sudo mkdir -p trash
sudo mkdir -p temp
sudo mkdir -p environments
sudo mkdir -p data

echo ""
echo "Installing virtualenv tool..."
sudo pip install virtualenv

echo ""
echo "Creating virtualenv virt1..."
cd /iMathCloud/environments
virtualenv virt1
cd virt1
source bin/activate
pip install -r ~/GIT/iMathCloud/environment/requirements.txt
deactivate


echo ""
echo "------------------------------------------------------------------------------------------"
echo "Cloning HPC2 and setting up"
echo "------------------------------------------------------------------------------------------"
git clone https://github.com/imathresearch/hpc2_BBVA.git hpc2
sudo mkdir /etc/hpc2/
sudo mkdir /etc/hpc2/hpc2.config
sudo cp ~/GIT/hpc2/HPC2/resources/prod/config.properties /etc/hpc2/hpc2.config
python ~/GIT/hpc2/setup.py install

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Cloning Colossus and setting up"
echo "------------------------------------------------------------------------------------------"
git clone https://github.com/imathresearch/colossus_BBVA.git colossus
sudo mkdir /etc/colossus
sudo mkdir /etc/colossus/colossus.config
sudo cp ~/GIT/colossus/Colossus/resources/prod/* /etc/colossus/colossus.config
cd /iMathCloud/environments/virt1
source bin/activate
python ~/GIT/colossus/setup.py install
deactivate

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Cloning IPython Notebook"
echo "------------------------------------------------------------------------------------------"
git clone https://github.com/imathresearch/iMathCloud_Console.git iMathCloud_Console



#################################################################################################

#################################   IPYTHON NOTEBOOK    #########################################

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Installing IPython Notebook and complements: JSAnimation, ffmpeg and mencoder" 
echo "------------------------------------------------------------------------------------------"

cd ~/GIT/iMathCloud_Console
tar -zxf ipython-rel-0.13.1.tar.gz

rm -r  ipython-rel-0.13.1/IPython/frontend/html/notebook/templates
rm -r ipython-rel-0.13.1/IPython/frontend/html/notebook/static

cp -r frontend/html/notebook/static/ ipython-rel-0.13.1/IPython/frontend/html/notebook/
cp -r frontend/html/notebook/templates/ ipython-rel-0.13.1/IPython/frontend/html/notebook/

cp frontend/html/notebook/handlers.py ipython-rel-0.13.1/IPython/frontend/html/notebook/
cp frontend/html/notebook/notebookapp.py ipython-rel-0.13.1/IPython/frontend/html/notebook/
cp frontend/html/notebook/notebookmanager.py ipython-rel-0.13.1/IPython/frontend/html/notebook/ 

cd ~/GIT/iMathCloud_Console/ipython-rel-0.13.1
sudo python setup.py install

cd ~/GIT/iMathCloud_Console/JSAnimation
sudo python setup.py installl

sudo apt-get remove x264 ffmpeg mplayer mencoder
sudo apt-get install libsdl1.2-dev zlib1g-dev libfaad-dev libfaac-dev libgsm1-dev libtheora-dev libvorbis-dev libspeex-dev libopencore-amrwb-dev libopencore-amrnb-dev libxvidcore-dev libxvidcore4 libmp3lame-dev libjpeg8 libjpeg8-dev yasm
cd /tmp
wget ftp://ftp.videolan.org/pub/videolan/x264/snapshots/last_stable_x264.tar.bz2
tar xvjf last_stable_x264.tar.bz2
cd x264-snapshot-20141218-2245-stable/
./configure --enable-shared --enable-pic
make
sudo make install
cd /tmp  
wget http://webm.googlecode.com/files/libvpx-v1.2.0.tar.bz2
tar xvjf libvpx-v1.2.0.tar.bz2
cd libvpx-v1.2.0/
./configure --enable-shared --enable-pic
make
sudo make install
cd /tmp
wget http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.1.tar.gz
tar xvzf MPlayer-1.1.tar.gz
cd MPlayer-1.1/
./configure 
make
sudo make install
cd /tmp
wget http://ffmpeg.org/releases/ffmpeg-2.2.1.tar.bz2
tar xvjf ffmpeg-2.2.1.tar.bz2 
cd ffmpeg-2.2.1/
./configure --enable-gpl --enable-version3 --enable-shared --enable-nonfree --enable-postproc --enable-libfaac --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libxvid
make
sudo make install
sudo ldconfig


#################################################################################################

###################################   DATABASE   ###############################################

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Creating database for iMathCloud"
echo "------------------------------------------------------------------------------------------"
sudo -u postgres createdb PRODIMATHCLOUD
sudo -u postgres psql -d PRODIMATHCLOUD -f ~/GIT/iMathCloud/src/main/resources/prod/create_productionDB.sql

