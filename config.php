<?php
// ==============================
// Configuration de la base de données
// ==============================

// Nom du serveur MySQL
$servername = "192.168.1.120";

// Nom d'utilisateur MySQL (par défaut sur XAMPP)
$username = "root";

// Mot de passe MySQL (par défaut vide sur XAMPP)
$password = "";

// Nom de la base de données
$database = "todo_db";

// ==============================
// Connexion à la base de données
// ==============================
try {
    $conn = new mysqli($servername, $username, $password, $database);

    // Vérifier la connexion
    if ($conn->connect_error) {
        die("Connexion échouée: " . $conn->connect_error);
    }

    // Optionnel : définir l'encodage
    $conn->set_charset("utf8");

} catch (Exception $e) {
    die("Erreur de connexion : " . $e->getMessage());
}
?>
