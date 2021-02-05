
hash_password
enter password
sudo psql synapse

UPDATE users SET password_hash='hash' 
  WHERE name='@user:server';
  
 ctrl + D
 sudo service synapse-matrix restart
