#!/bin/bash

# Verificamos que el usuario este NO rooteado

if [[ "${UID}" -eq 0 ]] 
then
    echo ""
    echo "Se debe ejecutar como usurario NO root."
    echo "Ejecute nuevamente este script"
    exit 1
fi

response="true"

while [[ $response -eq "true" ]]; do
    echo ""
    OPCIONES=$(ls | grep rsync_)
    echo "Escriba nombre(s) de store(s) para su(s) entornor :"
    echo ""
    read STORE
    echo ""
   
    if [ chrlen=${#STORE} \> 0 ]; then

        EXIST=$(grep -i ${STORE,,} stores_done.txt)

        if [ chrlen=${#EXIST} == 0 ]; then

            echo "El entorno que intenta montar, ya esta agregado " $STORE 

        else
           echo $STORE >> stores_done.txt
           cat templates/nginx_template >> etc/nginx/sites-available/$STORE.com.conf
           cat templates/service_site_template >> docker-compose.yml
           sed -i 's/_CONTAINER_STORE_1_/'"$STORE"'/g' etc/nginx/sites-available/$STORE.com.conf
           sed -i 's/_CONTAINER_STORE_1_/'"$STORE"'/g' docker-compose.yml
           mkdir www_$STORE
           cat templates/index_template >> www_$STORE/index.php
           sed -i 's/_CONTAINER_STORE_1_/'"$STORE"'/g' www_$STORE/index.php
           ln -s etc/nginx/sites-available/$STORE.com.conf etc/nginx/sites-enabled/
        fi
        
    fi
    echo "¿Desea agregar otro store?"
done
