#!/bin/bash

# autor:  Gregory Sánchez 2020

# Verificamos que el usuario este NO rooteado
if [[ "${UID}" -ne 0 ]] 
then
  echo ""
  echo "Se debe ejecutar como root (sudo)."
  exit 1
fi

VERSIONUSED="_VERSION_USED_"
EXT="com"
COMPLEMENTO="-local"

echo ""
echo " ****** LEA BIEN LAS INDICACIONES, NO HAGA TODO A LAS APURADAS, SON MUY POCOS PASOS ****** "
echo ""
echo ""
echo "[1] Recuerde que el puerto para entornos con PS 1.6 es 8071 y para PS 1.7.5.2 es 8073"
echo "[2] Cada vez que cree un entorno con un determinado nombre, a éste se le agrega el sufijo -local.com"
echo "[3] Ejemplo: Si ha creado el entorno con el nombre itau, en la url deberá escribir: http://itau-local.com:8073"
echo ""
echo "PASO 1 .- Escriba nombre del store para el entorno, ej [icbc, tclic, spv, bbva, itau, galicia, etc] "
echo ""
read STORE
echo ""
echo "PASO 2 .- Escriba su nombre de usuario del sistema (necesario para ejecutar sudo) "
echo ""
read USUARIO
echo ""

if [ chrlen=${#STORE} \> 0 ]; then

    if [[ $VERSIONUSED = "_VERSION_USED_" ]]; then

        echo "PASO 3 .- Este paso sólo se ejecuta la primera vez dependiendo del tipo de entorno"
        echo "PRESIONE 1 para entornos con Prestahop 1.6"
        echo "PRESIONE 2 para entornos con Prestahop 1.7"
        echo ""
        read VERSION
        echo ""

        mkdir etc/nginx/sites-available
        cat templates/nginx_template >> etc/nginx/sites-available/$STORE$COMPLEMENTO.$EXT
        cat templates/service_site_template >> docker-compose.yml
        sed -i 's/_PROYECT_NAME_COMPLETE_/'"$STORE$COMPLEMENTO"'/g' etc/nginx/sites-available/$STORE$COMPLEMENTO.$EXT
        sed -i 's/_CONTAINER_STORE_/'"$STORE"'/g' etc/nginx/sites-available/$STORE$COMPLEMENTO.$EXT
        sed -i 's/_EXT_/'"$EXT"'/g' etc/nginx/sites-available/$STORE$COMPLEMENTO.$EXT
        sed -i 's/_CONTAINER_STORE_/'"$STORE"'/g' docker-compose.yml
        mkdir www_$STORE
        cat templates/index_template >> www_$STORE/index.php
        sed -i 's/_CONTAINER_STORE_/'"$STORE"'/g' www_$STORE/index.php
        sed -i 's/#new_services/- store_'"$STORE"'\n      #new_services/g' docker-compose.yml
        sed -i 's/#new_volumens/- .\/www_'"$STORE"':\/var\/www\/html\/www_'"$STORE"'\n      #new_volumens/g' docker-compose.yml

        if [[ $VERSION = "1" ]]; then
         cat templates/Dockerfile_php71 >> etc/php/Dockerfile
         sed -i 's/_NGINX_/nginx71/g' docker-compose.yml
         sed -i 's/_PHPFPM_/php-fpm71/g' docker-compose.yml
         sed -i 's/_PORT_/8071/g' docker-compose.yml
         sed -i 's/_PHPFPM_/php-fpm71/g' etc/nginx/sites-available/$STORE$COMPLEMENTO.$EXT
         sed -i 's/VERSIONUSED="_VERSION_USED_"/VERSIONUSED="php-fpm71"/g' build_docker.sh

        fi
        if [[ $VERSION = "2" ]]; then
         cat templates/Dockerfile_php73 >> etc/php/Dockerfile
         sed -i 's/_NGINX_/nginx73/g' docker-compose.yml
         sed -i 's/_PHPFPM_/php-fpm73/g' docker-compose.yml
         sed -i 's/_PORT_/8073/g' docker-compose.yml
         sed -i 's/_PHPFPM_/php-fpm73/g' etc/nginx/sites-available/$STORE$COMPLEMENTO.$EXT
         sed -i 's/VERSIONUSED="_VERSION_USED_"/VERSIONUSED="php-fpm73"/g' build_docker.sh

        fi
         
        chown www-data. etc/nginx/sites-available/*
        chown -R $USUARIO.www-data www_$STORE
        chmod -R 775 www_$STORE
        echo "127.0.0.1   ${STORE}${COMPLEMENTO}.$EXT" >> /etc/hosts

    else

        if [[ $VERSIONUSED = "php-fpm71" ]]; then
          echo "*** Hemos verificado que este es un entorno para PRESTASHOP 1.6 (php 7.1.26) *** "
        fi
        if [[ $VERSIONUSED = "php-fpm73" ]]; then
          echo "*** Hemos verificado que este es un entorno para PRESTASHOP 1.7 (php 7.3.22) *** "
        fi

        cat templates/nginx_template >> etc/nginx/sites-available/$STORE$COMPLEMENTO.$EXT
        cat templates/service_site_template >> docker-compose.yml
        sed -i 's/_PROYECT_NAME_COMPLETE_/'"$STORE$COMPLEMENTO"'/g' etc/nginx/sites-available/$STORE$COMPLEMENTO.$EXT
        sed -i 's/_CONTAINER_STORE_/'"$STORE"'/g' etc/nginx/sites-available/$STORE$COMPLEMENTO.$EXT
        sed -i 's/_EXT_/'"$EXT"'/g' etc/nginx/sites-available/$STORE$COMPLEMENTO.$EXT
        sed -i 's/_CONTAINER_STORE_/'"$STORE"'/g' docker-compose.yml
        mkdir www_$STORE
        cat templates/index_template >> www_$STORE/index.php
        sed -i 's/_CONTAINER_STORE_/'"$STORE"'/g' www_$STORE/index.php
        sed -i 's/#new_services/- store_'"$STORE"'\n      #new_services/g' docker-compose.yml
        sed -i 's/#new_volumens/- .\/www_'"$STORE"':\/var\/www\/html\/www_'"$STORE"'\n      #new_volumens/g' docker-compose.yml
         
        chown www-data. etc/nginx/sites-available/*
        chown -R $USUARIO.www-data www_$STORE
        chmod -R 775 www_$STORE
        echo "127.0.0.1   ${STORE}${COMPLEMENTO}.$EXT" >> /etc/hosts
        sed -i 's/_PHPFPM_/'"$VERSIONUSED"'/g' etc/nginx/sites-available/$STORE$COMPLEMENTO.$EXT
    fi

  echo "************************************************************************"
  echo "************************************************************************"
  echo "Desea construir su entorno ya? Escriba 1 para SI || Escriba 2 para NO)"
  read CONSTR
  echo "************************************************************************"
  echo "************************************************************************"

  if [[ $CONSTR = "1" ]]; then
    
    docker-compose up --build -d

    echo "************************************************************************"
    echo "************************************************************************"
    echo ""

    if [ $VERSIONUSED == "php-fpm71" ] || [ $VERSION == "1" ]
    then
      echo "Al terminar la construcción abra en el explorador la url: http://$STORE$COMPLEMENTO.$EXT:8071"
    fi
    if [ $VERSIONUSED == "php-fpm73" ] || [ $VERSION == "2" ]
    then
      echo "Al terminar la construcción abra en el explorador la url: http://$STORE$COMPLEMENTO.$EXT:8073"
    fi
    
    echo ""
    echo "Si ve: Connected successfully - OK, presione 1"
    echo ""
    read ISFINE
    echo ""
    echo "************************************************************************"
    echo "************************************************************************"
    if [[ $ISFINE = "1" ]]; then

      rm www_$STORE/index.php
      docker-compose down

      echo "************************************************************************"
      echo "************************************************************************"

      if [[ $VERSIONUSED = "php-fpm71" ]]; then
        echo "Muy bien, ahora empiece a migrar sus archivos al directorio: www_$STORE, y edite el archivo www_$STORE/config/settings.inc.php"
      fi
      if [[ $VERSIONUSED = "php-fpm73" ]]; then
        echo "Muy bien, ahora empiece a migrar sus archivos al directorio: www_$STORE, y edite el archivo www_$STORE/app/parameters.php"
      fi

      echo "DB_SERVER debe ser = define('_DB_SERVER_', 'mysqldb')"
      echo "DB_USER debe ser = define('_DB_USER_', 'root')"
      echo "DB_PASSWD debe ser = define('_DB_PASSWD_', 'root')"
      echo "DB_NAME debe ser = define('_DB_NAME_', '"$STORE"-local') * el nombre de la DB pepende del nombre que ud haya creado"
      
      echo " ---- Finalmente, levante el docker usando docker-compose up ---- "
      
      echo "************************************************************************"
      echo "************************************************************************"
    fi
  fi  
fi