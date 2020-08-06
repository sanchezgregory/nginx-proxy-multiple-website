<?php
$servername = "mysqldb";
$username = "root";
$password = "root";
$dbname = "stores";

try {
  $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
  // set the PDO error mode to exception
  $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  
   echo "Connected successfully - OK";

  echo " <H2>Entorno listo para continuar, agrege los archivos del proyecto</H2> ";


} catch(PDOException $e) {
  echo "Connection failed - Error " . $e->getMessage();

  echo "<H2>No hay acceso a la BD, verifique usuario y password</H2>";
};
?>
<!DOCTYPE html>
<html>
<head>
	<title>
		ENTORNO DE _CONTAINER_STORE_1_
	</title>
</head>
<body>
	<H2>_CONTAINER_STORE_1_ listo solo si la conexión a la DB está OK.</H2>
</body>
</html>

<?php
echo phpinfo();
