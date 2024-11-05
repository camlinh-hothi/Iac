<?php
$mysqli = new mysqli("db-server", "root", "password", "testdb");

if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

$mysqli->query("INSERT INTO visites (name) VALUES ('Visiteur_" . rand(1, 1000) . "')");
$result = $mysqli->query("SELECT * FROM visites");

while ($row = $result->fetch_assoc()) {
    echo "ID: " . $row["id"] . " - Name: " . $row["name"] . "<br>";
}
?>
