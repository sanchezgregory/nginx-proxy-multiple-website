#!/bin/bash

# Verificamos que el usuario este NO rooteado

if [[ "${UID}" -ne 0 ]] 
then
  echo ""
  echo "Se debe ejecutar como root (sudo)."
  exit 1
fi

response="true"
EXT="com"
COMPLEMENTO="-local"

echo ""
echo " ****** LEA BIEN LAS INDICACIONES, NO HAGA TODO A LAS APURADAS ****** "
echo ""
echo ""
echo "Si es la primera vez que levantará este docker presione 1, si ya lo tiene creado pero instalará otro proyecto presione 2"
echo ""
read MOMENTO
echo ""
echo "Escriba nombre del store para el entorno, ej [icbc, tclic, spv, bbva, itau, galicia, etc] "
echo ""
read STORE
echo ""
echo "Escriba su nombre de usuario del sistema: "
echo ""
read USUARIO
echo ""

if [ chrlen=${#STORE} \> 0 ]; then

    EXIST=$(grep -i ${STORE,,} stores_done.txt)

    if [ chrlen=${#EXIST} == 0 ]; then

        echo "El entorno que intenta montar, ya esta agregado " $STORE 

    else

      if [[ $MOMENTO = "1"  ]]; then

        echo "Entornos con Prestahop1.6 presione 1 ::: Prestahop1.7 presion 2"
        echo ""
        read VERSION
        echo ""

        mkdir etc/nginx/sites-available
        echo $STORE >> stores_done.txt
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
         sed -i 's/_PHPFPM_/php-fpm71/g' etc/nginx/sites-available/$STORE$COMPLEMENTO.$EXT
        fi
        if [[ $VERSION = "2" ]]; then
         cat templates/Dockerfile_php73 >> etc/php/Dockerfile
         sed -i 's/_NGINX_/nginx73/g' docker-compose.yml
         sed -i 's/_PHPFPM_/php-fpm73/g' docker-compose.yml
         sed -i 's/_PHPFPM_/php-fpm73/g' etc/nginx/sites-available/$STORE$COMPLEMENTO.$EXT
        fi
         
        chown www-data. etc/nginx/sites-available/*
        chown -R $USUARIO.www-data www_$STORE
        chmod -R 775 www_$STORE
        echo "127.0.0.1   ${STORE}${COMPLEMENTO}.$EXT" >> /etc/hosts
      else
        echo $STORE >> stores_done.txt
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
      fi
    fi
fi