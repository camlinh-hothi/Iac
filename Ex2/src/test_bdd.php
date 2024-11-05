<?php
$mysqli = new mysqli("mariadb", "root", "password", "testdb");

if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

// Créer la table `visites` si elle n'existe pas
$createTableQuery = "CREATE TABLE IF NOT EXISTS visites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    visit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";

if (!$mysqli->query($createTableQuery)) {
    die("Error creating table: " . $mysqli->error);
}

// Insérer une nouvelle entrée
$mysqli->query("INSERT INTO visites (name) VALUES ('Visiteur_" . rand(1, 1000) . "')");

// Sélectionner les entrées pour les afficher
$result = $mysqli->query("SELECT * FROM visites");

while ($row = $result->fetch_assoc()) {
    echo "ID: " . $row["id"] . " - Name: " . $row["name"] . " - Visit Time: " . $row["visit_time"] . "<br>";
}
