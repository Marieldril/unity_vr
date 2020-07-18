<?php
//Server info
//https://www.w3schools.com/php/php_mysql_select.asp
$servername = "localhost";
$db_username = "root";
$db_password = "";
$db_name = "unity_vr_sql";

//User info
$loginUser = $_POST["loginUser"];
$loginPass = $_POST["loginPass"];

// Create connection
$conn = new mysqli($servername, $db_username, $db_password, $db_name);

// Check connection
if ($conn->connect_error) {
	die("Błąd połączenia: " . $conn->connect_error);
}
// Login -- protected
//https://www.hacksplaining.com/exercises/sql-injection#/start
//https://www.w3schools.com/sql/sql_injection.asp

$sql = "SELECT UserID, UserPassword FROM users_login WHERE UserEmail = ?"; //https://www.w3schools.com/php/php_mysql_select.asp

$statement = $conn -> prepare($sql);
$statement -> bind_param("s", $loginUser);
$statement -> execute();

$result = $statement -> get_result();

if ($result->num_rows > 0) {
	// output data of each row
	while($row = $result->fetch_assoc()) {
		if($row["UserPassword"] == $loginPass){
			echo $row['UserID'];
		} else {
			echo "Niepoprawny Login lub Hasło. ";
		}
	}
} else {
	echo "Użytkownik nie istnieje. ";
}
$conn->close();

?>