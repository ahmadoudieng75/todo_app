<?php
try {
    $pdo = new PDO('mysql:host=192.168.1.120;dbname=todo_db', 'default-user', '');
    echo "Connexion BD réussie!";

    // Tester la table
    $stmt = $pdo->query("SELECT * FROM accounts_table");
    $users = $stmt->fetchAll();
    echo "<br>Utilisateurs trouvés: " . count($users);

} catch (PDOException $e) {
    echo "Erreur BD: " . $e->getMessage();
}
?>