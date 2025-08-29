<?php
// Désactiver la mise en cache
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Pragma: no-cache");

// Headers CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Réponse immédiate aux pré-requêtes OPTIONS
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Vérifier que c'est bien un POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["error" => "Method not allowed"]);
    exit();
}

// Récupérer le JSON envoyé
$input = json_decode(file_get_contents("php://input"), true);

$email = $input['email'] ?? null;
$password = $input['password'] ?? null;

// Vérifier les identifiants
if ($email === "ahmadou@gmail.com" && $password === "Ahmadou123") {
    $response = [
        "success" => true,
        "message" => "Login successful",
        "account_id" => 1,
        "email" => $email
    ];
} else {
    $response = [
        "success" => false,
        "message" => "Invalid credentials"
    ];
}

http_response_code(200);
echo json_encode($response);
exit();
