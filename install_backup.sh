
############################### INPUT PARAMETER: USERNAME MACHINE  #############################################
echo ""
echo "--------------------"
echo ""
while true; do
    read -p "Insert the username of the current machine (required for periodic backup of DBs): " username
    #Checkear si esta vacia
    if [ -z "$username" ];
    then
	echo "Please enter a non empty username"
    else
    	break	
    fi
done

cd ~/

echo ""
echo "--------------------"
echo "Copying the backup script from server"
echo "--------------------"
scp -r imath@158.109.125.112:/home/imath/backup_production .

#This file contains the password required to access to the DBs to be dumped.
echo "localhost:5432:PRODIMATHCONNECT:postgres:postgres " >> .pgpass
echo "localhost:5432:PRODIMATHCLOUD:postgres:postgres" >> .pgpass
echo "localhost:5432:mydb:postgres:postgres" >> .pgpass
echo "127.0.01:5432:*:postgres:postgres" >> .pgpass

#Adding the line required for the service cron for automatic dump of the DBs
echo ""
echo "--------------------"
echo "Using cron for periodic backup of the DB"
echo "--------------------"
echo $username
sudo sh -c "echo \"00 22   * * *   $username   ~/backup_production/pg_backup.sh\" >> /etc/crontab"

