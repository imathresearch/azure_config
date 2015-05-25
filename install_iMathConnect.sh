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
echo "Cloning iMathConnect"
echo "------------------------------------------------------------------------------------------"
git clone https://github.com/imathresearch/iMathConnect_BBVA.git iMathConnect

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Cloning iMathCloud_API"
echo "------------------------------------------------------------------------------------------"
git clone https://github.com/imathresearch/iMathCloud_api_BBVA.git iMathCloud_api


#################################################################################################

###################################   DATABASES   ###############################################

echo ""
echo "------------------------------------------------------------------------------------------"
echo "Creating database for iMathConnect"
echo "------------------------------------------------------------------------------------------"
sudo -u postgres createdb PRODIMATHCONNECT
sudo -u postgres psql -d PRODIMATHCONNECT -f ~/GIT/iMathConnect/src/main/resources/prod/create_productionDB.sql

