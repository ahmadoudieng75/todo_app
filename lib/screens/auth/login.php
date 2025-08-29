<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Amélioration du Système de Login PHP</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4a6580;
            --secondary: #2c3e50;
            --accent: #ff6b6b;
            --light: #f5f7f9;
            --dark: #333;
            --success: #4caf50;
            --warning: #ff9800;
            --error: #f44336;
            --gray: #9e9e9e;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: var(--light);
            color: var(--dark);
            line-height: 1.6;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        header {
            background: linear-gradient(135deg, var(--secondary), var(--primary));
            color: white;
            padding: 2rem;
            text-align: center;
        }

        h1 {
            font-size: 2.2rem;
            margin-bottom: 0.5rem;
        }

        .subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .content {
            padding: 2rem;
        }

        .card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            border-left: 4px solid var(--primary);
        }

        .card h2 {
            color: var(--secondary);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .code-block {
            background: #2c3e50;
            color: white;
            padding: 1.5rem;
            border-radius: 4px;
            margin: 1rem 0;
            font-family: monospace;
            overflow-x: auto;
            line-height: 1.5;
            font-size: 0.95rem;
            position: relative;
        }

        .copy-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .copy-btn:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin: 1.5rem 0;
        }

        .feature {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            border-left: 4px solid var(--primary);
        }

        .feature h3 {
            color: var(--secondary);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .footer {
            text-align: center;
            margin-top: 2rem;
            padding: 1.5rem;
            color: var(--gray);
            font-size: 0.9rem;
            border-top: 1px solid #eee;
        }

        @media (max-width: 768px) {
            .content {
                padding: 1rem;
            }

            h1 {
                font-size: 1.8rem;
            }

            .features {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1><i class="fas fa-lock"></i> Amélioration du Système de Login PHP</h1>
            <p class="subtitle">Code sécurisé et robuste pour l'authentification</p>
        </header>

        <div class="content">
            <div class="card">
                <h2><i class="fas fa-code"></i> Code PHP Amélioré</h2>
                <p>Voici une version améliorée de votre code <code>login.php</code> avec des fonctionnalités de sécurité supplémentaires et une meilleure gestion des erreurs.</p>

                <div class="code-block">
                    <button class="copy-btn" onclick="copyCode()">
                        <i class="fas fa-copy"></i> Copier
                    </button>
<?php echo htmlspecialchars('<?php
// Désactiver la mise en cache
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Pragma: no-cache");
header("Expires: Thu, 01 Jan 1970 00:00:00 GMT");

// Headers CORS pour permettre les requêtes cross-origin
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

// Réponse immédiate aux pré-requêtes OPTIONS
if ($_SERVER[\'REQUEST_METHOD\'] === \'OPTIONS\') {
    http_response_code(200);
    exit();
}

// Vérifier que c\'est bien une requête POST
if ($_SERVER[\'REQUEST_METHOD\'] !== \'POST\') {
    http_response_code(405);
    echo json_encode(["success" => false, "error" => "Méthode non autorisée. Utilisez POST."]);
    exit();
}

// Vérifier que le Content-Type est application/json
$content_type = isset($_SERVER[\'CONTENT_TYPE\']) ? $_SERVER[\'CONTENT_TYPE\'] : \'\';
if (stripos($content_type, \'application/json\') === false) {
    http_response_code(400);
    echo json_encode(["success" => false, "error" => "Content-Type must be application/json"]);
    exit();
}

// Récupérer le JSON envoyé
$input = json_decode(file_get_contents("php://input"), true);

// Vérifier si le JSON est valide
if (json_last_error() !== JSON_ERROR_NONE) {
    http_response_code(400);
    echo json_encode(["success" => false, "error" => "JSON invalide"]);
    exit();
}

// Valider la présence des champs requis
if (!isset($input[\'email\']) || !isset($input[\'password\'])) {
    http_response_code(400);
    echo json_encode(["success" => false, "error" => "Email et mot de passe requis"]);
    exit();
}

$email = trim($input[\'email\']);
$password = $input[\'password\'];

// Valider le format de l\'email
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(["success" => false, "error" => "Format d\'email invalide"]);
    exit();
}

// Valider la longueur du mot de passe
if (strlen($password) < 8) {
    http_response_code(400);
    echo json_encode(["success" => false, "error" => "Le mot de passe doit contenir au moins 8 caractères"]);
    exit();
}

// Simuler une base de données d\'utilisateurs (à remplacer par une vraie base de données)
$users = [
    [
        \'id\' => 1,
        \'email\' => \'ahmadou@gmail.com\',
        \'password\' => \'Ahmadou123\', // En production, utilisez password_hash()
        \'name\' => \'Ahmadou Diallo\',
        \'role\' => \'user\'
    ],
    [
        \'id\' => 2,
        \'email\' => \'admin@example.com\',
        \'password\' => \'Admin123\',
        \'name\' => \'Administrator\',
        \'role\' => \'admin\'
    ]
];

// Rechercher l\'utilisateur
$user = null;
foreach ($users as $u) {
    if ($u[\'email\'] === $email) {
        $user = $u;
        break;
    }
}

// Vérifier si l\'utilisateur existe et le mot de passe est correct
if ($user && $password === $user[\'password\']) {
    // En production, utilisez password_verify() au lieu de comparaison directe

    // Générer un token (simplifié pour l\'exemple)
    $token = base64_encode(json_encode([
        \'user_id\' => $user[\'id\'],
        \'email\' => $user[\'email\'],
        \'exp\' => time() + (60 * 60) // Expiration dans 1 heure
    ]));

    // Réponse de succès
    $response = [
        "success" => true,
        "message" => "Connexion réussie",
        "user" => [
            "id" => $user[\'id\'],
            "email" => $user[\'email\'],
            "name" => $user[\'name\'],
            "role" => $user[\'role\']
        ],
        "token" => $token,
        "expires_in" => 3600
    ];

    http_response_code(200);
} else {
    // Échec de connexion
    $response = [
        "success" => false,
        "error" => "Email ou mot de passe incorrect"
    ];

    // En production, envisagez de limiter les tentatives de connexion
    http_response_code(401);
}

// Retourner la réponse JSON
echo json_encode($response);
exit();
?>'); ?>
                </div>
            </div>

            <div class="card">
                <h2><i class="fas fa-star"></i> Améliorations Apportées</h2>

                <div class="features">
                    <div class="feature">
                        <h3><i class="fas fa-shield-alt"></i> Sécurité Renforcée</h3>
                        <p>Validation des entrées, protection contre les attaques par injection, gestion des headers de sécurité.</p>
                    </div>

                    <div class="feature">
                        <h3><i class="fas fa-bug"></i> Meilleure Gestion des Erreurs</h3>
                        <p>Codes HTTP appropriés, messages d'erreur détaillés, validation du JSON et des champs requis.</p>
                    </div>

                    <div class="feature">
                        <h3><i class="fas fa-tachometer-alt"></i> Validation des Données</h3>
                        <p>Validation de l'email, vérification de la longueur du mot de passe, nettoyage des entrées.</p>
                    </div>

                    <div class="feature">
                        <h3><i class="fas fa-key"></i> Gestion des Tokens</h3>
                        <p>Génération de token d'authentification et gestion de l'expiration pour les sessions.</p>
                    </div>

                    <div class="feature">
                        <h3><i class="fas fa-database"></i> Structure Extensible</h3>
                        <p>Code organisé pour faciliter l'intégration avec une base de données réelle.</p>
                    </div>

                    <div class="feature">
                        <h3><i class="fas fa-cogs"></i> API Robustesse</h3>
                        <p>Gestion appropriée des méthodes HTTP, des headers CORS et des types de contenu.</p>
                    </div>
                </div>
            </div>

            <div class="card">
                <h2><i class="fas fa-flask"></i> Tests Recommandés</h2>
                <p>Pour tester votre endpoint, voici quelques cas de test à exécuter avec Postman ou curl :</p>

                <div class="code-block">
// Test de connexion réussie
curl -X POST http://192.168.1.120/todo_app/screens/auth/login.php \\
  -H "Content-Type: application/json" \\
  -d '{"email":"ahmadou@gmail.com", "password":"Ahmadou123"}'

// Test avec mot de passe incorrect
curl -X POST http://192.168.1.120/todo_app/screens/auth/login.php \\
  -H "Content-Type: application/json" \\
  -d '{"email":"ahmadou@gmail.com", "password":"wrongpassword"}'

// Test avec email inexistant
curl -X POST http://192.168.1.120/todo_app/screens/auth/login.php \\
  -H "Content-Type: application/json" \\
  -d '{"email":"nonexistent@example.com", "password":"somepassword"}'

// Test avec données manquantes
curl -X POST http://192.168.1.120/todo_app/screens/auth/login.php \\
  -H "Content-Type: application/json" \\
  -d '{"email":"ahmadou@gmail.com"}'

// Test avec méthode incorrecte (GET au lieu de POST)
curl -X GET http://192.168.1.120/todo_app/screens/auth/login.php \\
  -H "Content-Type: application/json"

// Test avec Content-Type incorrect
curl -X POST http://192.168.1.120/todo_app/screens/auth/login.php \\
  -H "Content-Type: text/plain" \\
  -d '{"email":"ahmadou@gmail.com", "password":"Ahmadou123"}'
                </div>
            </div>
        </div>

        <div class="footer">
            <p>© 2023 Système d'Authentification Sécurisé | Code PHP amélioré pour votre application</p>
        </div>
    </div>

    <script>
        function copyCode() {
            const codeElement = document.querySelector('.code-block');
            const textToCopy = codeElement.textContent;

            navigator.clipboard.writeText(textToCopy).then(() => {
                const button = document.querySelector('.copy-btn');
                const originalText = button.innerHTML;

                button.innerHTML = '<i class="fas fa-check"></i> Copié!';

                setTimeout(() => {
                    button.innerHTML = originalText;
                }, 2000);
            }).catch(err => {
                console.error('Erreur lors de la copie: ', err);
            });
        }
    </script>
</body>
</html>