#!/bin/bash

identificador_usuari=`id -u`
nom_script=$0
nom_usuari=$1
compte_usuari="$2 $3 $4"

# Make sure the script is being executed with superuser privileges
if [ $identificador_usuari -ne 0 ];then
   echo Has de ser root per afegir un usuari
   exit 1

else
 #If the user doesn't supply at least one argument, then give them help
  if [ -z $nom_usuari ];then
	#The first parameter is the user name
	#The rest of the parameters are for the account comment
	echo -e Utilitzacio: ./$nom_script NOM_USUARI [NOM_COMPTE]... '\n'
	echo "Has de ficar almenys el nom de l'usuari"
	exit 1
    else
	#Generate a password (text pla)
	contrasenya_aleatoria=`cat /dev/urandom | tr -dc 'az09' | fold -w 8 | head -n1`

	#Create the user with password
       	    useradd -c "${compte_usuari}" -m ${nom_usuari} -p $(openssl passwd $contrasenya_aleatoria) > /dev/null 2>&1
	#Check to see if the useradd command succeeded
	   if [ $? -gt 0 ]; then
             echo "L'usuari $nom_usuari ja existeix"
	     exit 1
           else
	     #Set the password
		echo -e "${contrasenya_aleatoria}\n${contrasenya_aleatoria}" | passwd ${nom_usuari} > /dev/null 2>&1

	      #Check to see if the passwd command succeded
		if [ $? -eq 0 ]; then
		#Force password change on first login
		passwd -e ${nom_usuari}
		echo -e '\n'

		#Display the username, password, and the host where the user was created
		echo "L'usuari $nom_usuari s'ha creat correctament"
		
		echo username:
		echo $nom_usuari
		echo -e '\n'
		echo password:
		echo $contrasenya_aleatoria
		echo -e '\n'
		echo host:
		echo `hostname`
		echo -e '\n'
	     else
		echo "Contrasenya no especificada"
		exit 1
	    fi
	  fi
       fi
fi

