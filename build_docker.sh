#!/bin/bash

# Verificamos que el usuario este NO rooteado

if [[ "${UID}" -ne 0 ]] 
then
  echo ""
  echo "Se debe ejecutar como root."
  exit 1
fi

response="true"

echo ""
OPCIONES=$(ls | grep rsync_)
echo "Escriba nombre del store para su entorno: "
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
       echo $STORE >> stores_done.txt
       cat templates/nginx_template >> etc/nginx/sites-available/$STORE.com
       cat templates/service_site_template >> docker-compose.yml
       sed -i 's/_CONTAINER_STORE_1_/'"$STORE"'/g' etc/nginx/sites-available/$STORE.com
       sed -i 's/_CONTAINER_STORE_1_/'"$STORE"'/g' docker-compose.yml
       mkdir www_$STORE
       cat templates/index_template >> www_$STORE/index.php
       sed -i 's/_CONTAINER_STORE_1_/'"$STORE"'/g' www_$STORE/index.php
       sed -i 's/#new_services/- store_'"$STORE"'\n      #new_services/g' docker-compose.yml
       sed -i 's|#new_volumens|- ./www_'"$STORE"':/var/www/html/www_'"$STORE"'\n      #new_volumens|g' docker-compose.yml
       chown www-data. etc/nginx/sites-available/*
       chown -R $USUARIO.www-data www_$STORE
       chmod -R 775 www_$STORE
       echo "127.0.0.1   ${STORE}.com" >> /etc/hosts
    fi
  
fi
