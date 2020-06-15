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
           cat templates/template_nginx >> etc/nginx/nginx.dev.conf
           cat templates/store_container_template >> docker-compose.yml
           sed -i 's/_CONTAINER_STORE_1_/'"$STORE"'/g' etc/nginx/nginx.dev.conf
           sed -i 's/_CONTAINER_STORE_1_/'"$STORE"'/g' docker-compose.yml
           mkdir www_$STORE
           cat templates/index_template >> www_$STORE/index.php
           sed -i 's/_CONTAINER_STORE_1_/'"$STORE"'/g' www_$STORE/index.php
        fi
        
    fi
    echo "¿Desea agregar otro store?"
done