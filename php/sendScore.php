<?php
require 'Connector.php'; //https://www.w3schools.com/php/php_includes.asp

//User info
$UserID = $_POST["UserID"];
$Question = $_POST["Question"];
$Points = $_POST["Points"];

// Check connection
if ($conn->connect_error) {
	die("Błąd połączenia: " . $conn->connect_error);
}
echo "Połączono z bazą. ";

$sql = "SELECT fInsertResult($UserID, $Question, $Points)"; //https://www.w3schools.com/php/php_mysql_select.asp
$result = $conn -> query($sql);

if ($result->num_rows > 0) {
	echo "Działa";
} else
	echo "Nie działa";

$conn->close();
?>