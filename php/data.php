<?php
//Server
$servername = "sql7.freemysqlhosting.net";
$db_username = "sql7353088";
$db_password = "KRtXDWhBFU";
$db_name = "sql7353088";

//User
$loginUser = $_POST["loginUser"];
$loginPass = $_POST["loginPass"];

// Create connection
$conn = new mysqli($servername, $db_username, $db_password, $db_name);

// Check connection
if ($conn->connect_error) {
	die("Błąd połączenia: " . $conn->connect_error);
}
echo "Połączono z bazą. ";

// Login
$sql = "SELECT Haslo FROM Logowanie WHERE Nazwa = '" . $loginUser . "'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
	// output data of each row
	while($row = $result->fetch_assoc()) {
		if($row["Haslo"] == $loginPass){
			echo "Zalogowano pomyślnie! ";
		} else {
			echo "Niepoprawny Login lub Hasło. ";
		}
	}
} else {
	echo "Użytkownik nie istnieje. ";
}
$conn->close();

?>