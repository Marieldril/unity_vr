<?php
//Server info
//https://www.w3schools.com/php/php_mysql_select.asp
$servername = "localhost";
$db_username = "root";
$db_password = "";
$db_name = "unity_vr_sql";

//User info
$UserID = $_POST["UserID"];
$Question = $_POST["Question"];
$Points = $_POST["Points"];

// Create connection
$conn = new mysqli($servername, $db_username, $db_password, $db_name);

// Check connection
if ($conn->connect_error) {
	die("Błąd połączenia: " . $conn->connect_error);
}
echo "Połączono z bazą. ";

// SendScore
//https://www.hacksplaining.com/exercises/sql-injection#/start
//https://www.w3schools.com/sql/sql_injection.asp

// $sql = "SELECT (?, ?, ?)"; //https://www.w3schools.com/php/php_mysql_select.asp

$sql = "SELECT fInsertResult($UserID, $Question, $Points)";
$result = $conn -> query($sql);

if ($result->num_rows > 0) {
	echo "Działa";
} else
	echo "Nie działa";

$conn->close();

?>