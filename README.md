## Multi Sites Docker with nginx revere configuration

Configura multiples sites con una misma intancia de Docker

### Considerations

1. Usa una sola imagen de php-fpm sin importar la cantidad de proyectos ya que usa para cada uno de los proyecto de manera individual, una imagen de docker conocida como tianon, solo son 125 bytes para permitir levantar un servicio que permite montar volumenes.  También usa una sola imagane de mysql, y el servicio de php-fpm lo usa para todos sus proyectos individuales.

2. Es necesario ejecutar el script como superusuario, ya que necesita escribir en el archivo /etc/hosts para agregar la ip local y el nombre de dominio para el nombre de entorno

3. La ejecución del script solo pide el nombre del entorno a levantar y su nombre de usuario del sistema, se recomienda como nombre de entorno, los nombres de la tienda, (una sola palabra), ej icbc, bbva, spv, bsf, etc

4. El script, una vez insertado los valores anteriores, modificará automaticamente el archivo docker-compose.yml ajustando los nuevos valores, volumens y el nuevo servicio para el proyecto, igualmente creará un nuevo archivo para la configuración del virtual host dentro de etc/nginx/sites-availabe/entorno.com, finalmente se creará un directorio llamado www_entorno con un archivo index.php de ejemplo, que permitirá detectar que todo está andando al 100% una vez se levante el docker-compose up -d

5. Para cada nuevo entorno, de debe bajar el docker:  docker-compose down y luego ejecutar el script. Finalmente levantar el docker.


### Add More Sites

Port 9000 is used by `fastcgi_pass`. Do not set port to 9000 for visualizer.

## Installation

* Install Docker
* Install Docke-comoopose

#### Algunos archivos

El archivo `nginx.conf`, tiene la configuracion generica de nginx, y dentro de includes estan los demas archivos complementarios para nginx

Dentro de templates, están las plantillas que se necesitan para ir generando nuevos archivos y ser reemplazods por los valores introducidos en el script build_docker.sh

## License
A short snippet describing the license (MIT, Nginx, php etc)

MIT © [Yourname]()

#### Ports

Los puertos utilizados son el 3000 para el acceso de la BD desde afuera del docker, por ejemplo desde workbench usando el server name 127.0.0.1, el user y el password es root

Visualizer usa el puerto 9999 y `fastcgi_pass` el puerto 9000, de resto ninguno de los proyecto usan puertos. por defecto todo se redirige al 443

Use 8xxx port range for all wordpress apps, except 8080 which is used for `docker-visualizer`.
Port 9000 is used by .

## Access y Error Logs
Los logs de accesos y errores de Nginx se encuentran mapeados en logs, en el root de este proyecto.

## INICIO PASOS ENTORNO 1.6

6.- Clone el proyecto completo ya sea individualmente core, overrides, theme, modules, etc  o  simplemente ejecute el rsync.sh (elija la opcion 6.1 o 6.2) 

	6.1 (usando rsync.sh  "proyecto completo con imagenes")

		Editar el rsync.sh  y agregar la ubicacion del proyecto, este traerá todo el proyecto hacia la carpeta www. Por ejemplo
   			/home/$USER/prestaNginx/    "dentro de la carpeta donde se clonó el docker -> prestaNginx  se creará la carpeta www"

		- Imprescindible tener el .pem de icbcclub-dev
		- sudo chmod +x rsync.sh
		- sudo chmod 777 www/
		- ./rsync.sh
		
		Después de 5, 6 u 8 horas.... cuando termine el rsync

		cd www/  ----> core
			git status
			git reset --hard
			git flow init (enter a todo)
			git checkout develop
			git pull origin develop
		cd overrides/
			git status
			git reset --hard
			git flow init (enter a todo)
			git checkout develop
			git pull origin develop
		cd ..
		cd themes/icbcstore/
			git status
			git reset --hard
			git flow init (enter a todo)
			git checkout develop
			git pull origin develop
		cd modules/ (todos los modulos editables)
			git status
			git reset --hard
			git flow init (enter a todo)
			git checkout develop
			git pull origin develop

		git branch
		Si se observan branch diferentes a: "Master", "Develop" borrarlos con:
			git branch -D "NombreBranch"
			

	6.2 (Solo si no se usa el paso 6.1) baja modulo a modulo
		
		dentro de la carpeta del proyecto ("www/")
		1. git clone git@gitlab.com:apernet/icbcstore-core.git .
		2. git flow init  --> verificar que ya se encuentre en la rama develop
		3. git clone git@gitlab.com:apernet/icbcstore-override.git override
		4. git clone git@gitlab.com:apernet/icbcstore-theme.git themes/icbcstore
		5. git clone git@gitlab.com:apernet/presta-decidir2.0.git modules/decidir
		6. git clone git@gitlab.com:apernet/presta-vtex16.git modules/vtexmodule
		7. git clone git@gitlab.com:apernet/presta-productsmarks.git modules/productsmarks
		8. git clone git@gitlab.com:apernet/presta-productshippingcostcalculator.git modules/productshippingcostcalculator
		9. git clone git@gitlab.com:apernet/icbcstore-blocktopmenu.git modules/blocktopmenu
		10. git clone git@gitlab.com:apernet/presta-pointspayment.git modules/pointspayment

*nota: hacer los pasos siguientes desde /www
   7.- Eliminar el directorio cache/ (rm -rf cache) y crearlo (mkdir cache);  con todos (sin -r) los permisos (chmod 777 cache)
   8.- Eliminar el directorio themes/icbcstore/cache/ (rm -rf themes/icbcstore/cache/) y crearlo (mkdir themes/icbcstore/cache);  con todos (sin -r) los permisos (chmod 777 themes/icbcstore/cache)
   9.- Eliminar el directorio log/ y crearlo (mkdir log);  con todos (sin -r) los permisos (chmod 777 log)
   9.- Crear el archivo settings.inc.php en base al template (cp config/settings_template.inc.php config/settings.inc.php)
     9.1 - define('_DB_SERVER_', 'mysqldb');
           define('_DB_NAME_', '<db_name>');
           define('_DB_USER_', 'root');
           define('_DB_PASSWD_', 'root');
   10.- Crear el .htaccess  (touch .htaccess,  chmod 777 .htaccess)

## FIN PASOS ENTORNO 1.6

## Credits
Gregory Sánchez