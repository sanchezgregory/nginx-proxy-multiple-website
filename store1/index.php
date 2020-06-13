<?php
$servername = "mysqldb";
$username = "root";
$password = "root";

try {
  $conn = new PDO("mysql:host=$servername;dbname=icbc", $username, $password);
  // set the PDO error mode to exception
  $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  echo "Connected successfully";
} catch(PDOException $e) {
  echo "Connection failed: " . $e->getMessage();
};
?>
<!DOCTYPE html>
<html>
<head>
	<title>
		ICBC STORE
	</title>
</head>
<body>
	<H2>ICBC working</H2>
</body>
</html>
