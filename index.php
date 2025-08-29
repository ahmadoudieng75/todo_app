<?php
echo "Web api";
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diagnostic Erreur 403</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        body {
            background-color: #f5f7f9;
            color: #333;
            line-height: 1.6;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        header {
            background: linear-gradient(135deg, #2c3e50, #4a6580);
            color: white;
            padding: 2rem 0;
            text-align: center;
            border-radius: 8px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        h1 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
        }
        .subtitle {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        .card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }
        .card h2 {
            color: #2c3e50;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e8e8e8;
        }
        .solution-item {
            padding: 1rem;
            background: #f8f9fa;
            border-left: 4px solid #4a6580;
            margin-bottom: 1rem;
            border-radius: 0 4px 4px 0;
        }
        .solution-item h3 {
            margin-bottom: 0.5rem;
            color: #2c3e50;
        }
        .request-info {
            background: #2c3e50;
            color: white;
            padding: 1rem;
            border-radius: 4px;
            margin: 1rem 0;
            font-family: monospace;
            overflow-x: auto;
        }
        .error-details {
            background: #fff4f4;
            border: 1px solid #ffcdd2;
            color: #c62828;
            padding: 1rem;
            border-radius: 4px;
            margin: 1rem 0;
            font-family: monospace;
        }
        .btn {
            display: inline-block;
            background: #4a6580;
            color: white;
            padding: 0.7rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 500;
            transition: background 0.3s;
        }
        .btn:hover {
            background: #5b7a9a;
        }
        .status-badge {
            display: inline-block;
            padding: 0.3rem 0.7rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-left: 0.5rem;
        }
        .status-error {
            background: #ffebee;
            color: #c62828;
        }
        .footer {
            text-align: center;
            margin-top: 2rem;
            padding: 1rem;
            color: #7a7a7a;
            font-size: 0.9rem;
        }
        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            h1 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>Diagnostic d'Erreur 403 Forbidden</h1>
            <p class="subtitle">Résolvez les problèmes d'accès à votre serveur web</p>
        </header>

        <div class="card">
            <h2>Détails de l'Erreur</h2>
            <div class="error-details">
                <p><strong>URL:</strong> http://192.168.1.120/login.php</p>
                <p><strong>Status:</strong> 403 Forbidden <span class="status-badge status-error">Erreur</span></p>
                <p><strong>Serveur:</strong> Apache/2.4.58 (Win64) OpenSSL/3.1.3 PHP/8.2.12</p>
                <p><strong>Message:</strong> You don't have permission to access this resource.</p>
            </div>
        </div>

        <div class="card">
            <h2>Requête Effectuée</h2>
            <div class="request-info">
                POST /login.php HTTP/1.1<br>
                Host: 192.168.1.120<br>
                Content-Type: application/json<br>
                <br>
                {<br>
                &nbsp;&nbsp;"email": "ahmadou@gmail.com",<br>
                &nbsp;&nbsp;"password": "Ahmadou123"<br>
                }
            </div>
        </div>

        <div class="card">
            <h2>Solutions Possibles</h2>

            <div class="solution-item">
                <h3>1. Vérifier les permissions des fichiers</h3>
                <p>Assurez-vous que les fichiers sur le serveur ont les permissions appropriées. Les fichiers PHP doivent généralement avoir les permissions 644 et les dossiers 755.</p>
                <a href="#" class="btn">Voir comment modifier les permissions</a>
            </div>

            <div class="solution-item">
                <h3>2. Examiner la configuration Apache</h3>
                <p>Vérifiez la configuration d'Apache pour vous assurer qu'elle permet l'accès au répertoire contenant login.php.</p>
                <a href="#" class="btn">Guide de configuration Apache</a>
            </div>

            <div class="solution-item">
                <h3>3. Vérifier les restrictions .htaccess</h3>
                <p>Recherchez toute restriction dans le fichier .htaccess qui pourrait bloquer l'accès à votre script PHP.</p>
                <a href="#" class="btn">Documentation .htaccess</a>
            </div>

            <div class="solution-item">
                <h3>4. Tester avec un fichier simple</h3>
                <p>Créez un fichier test.php avec le contenu <code>&lt;?php echo "test"; ?&gt;</code> pour vérifier que PHP fonctionne correctement.</p>
                <a href="#" class="btn">Guide de test PHP</a>
            </div>
        </div>

        <div class="card">
            <h2>Outils de Diagnostic</h2>
            <p>Utilisez ces outils pour diagnostiquer le problème :</p>
            <div style="margin-top: 1rem;">
                <a href="#" class="btn">Tester la connexion au serveur</a>
                <a href="#" class="btn">Vérifier la configuration PHP</a>
                <a href="#" class="btn">Analyser les logs d'erreur</a>
            </div>
        </div>

        <div class="footer">
            <p>© 2023 Diagnostic Tool | Si le problème persiste, consultez la documentation officielle d'Apache ou contactez votre administrateur système.</p>
        </div>
    </div>

    <script>
        // Script simple pour interagir avec les boutons
        document.addEventListener('DOMContentLoaded', function() {
            const buttons = document.querySelectorAll('.btn');
            buttons.forEach(button => {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    alert('Cette fonctionnalité est illustrative. Dans une application réelle, cela déclencherait une action de diagnostic.');
                });
            });
        });
    </script>
</body>
</html>