<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Inclure la connexion à la base de données
include_once 'config/database.php';

// Instancier la base de données
$database = new Database();
$db = $database->getConnection();

// Vérifier si la méthode est POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Récupérer les données POST
    $data = json_decode(file_get_contents("php://input"));
    
    // Vérifier si les données sont complètes
    if (!empty($data->email) && !empty($data->password)) {
        // Nettoyer les données
        $email = htmlspecialchars(strip_tags($data->email));
        $password = htmlspecialchars(strip_tags($data->password));
        
        // Vérifier si l'email est valide
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            http_response_code(400);
            echo json_encode(array(
                "success" => false,
                "message" => "Email invalide."
            ));
            exit;
        }
        
        // Vérifier la force du mot de passe
        if (strlen($password) < 6) {
            http_response_code(400);
            echo json_encode(array(
                "success" => false,
                "message" => "Le mot de passe doit contenir au moins 6 caractères."
            ));
            exit;
        }
        
        try {
            // Vérifier si l'email existe déjà
            $query = "SELECT account_id FROM accounts_table WHERE email = :email";
            $stmt = $db->prepare($query);
            $stmt->bindParam(':email', $email);
            $stmt->execute();
            
            if ($stmt->rowCount() > 0) {
                // Email déjà utilisé
                http_response_code(409);
                echo json_encode(array(
                    "success" => false,
                    "message" => "Cet email est déjà utilisé."
                ));
            } else {
                // Hasher le mot de passe
                $hashed_password = password_hash($password, PASSWORD_DEFAULT);
                
                // Insérer le nouvel utilisateur
                $query = "INSERT INTO accounts_table SET email = :email, password = :password";
                $stmt = $db->prepare($query);
                $stmt->bindParam(':email', $email);
                $stmt->bindParam(':password', $hashed_password);
                
                if ($stmt->execute()) {
                    // Récupérer l'ID du nouvel utilisateur
                    $account_id = $db->lastInsertId();
                    
                    http_response_code(201);
                    echo json_encode(array(
                        "success" => true,
                        "message" => "Utilisateur créé avec succès.",
                        "account_id" => (int)$account_id,
                        "email" => $email
                    ));
                } else {
                    http_response_code(500);
                    echo json_encode(array(
                        "success" => false,
                        "message" => "Impossible de créer l'utilisateur."
                    ));
                }
            }
        } catch (PDOException $exception) {
            // Erreur de base de données
            http_response_code(500);
            echo json_encode(array(
                "success" => false,
                "message" => "Erreur de base de données: " . $exception->getMessage()
            ));
        }
    } else {
        // Données manquantes
        http_response_code(400);
        echo json_encode(array(
            "success" => false,
            "message" => "Impossible de créer l'utilisateur. Données manquantes."
        ));
    }
} else {
    // Mauvaise méthode HTTP
    http_response_code(405);
    echo json_encode(array(
        "success" => false,
        "message" => "Méthode non autorisée."
    ));
}
?>