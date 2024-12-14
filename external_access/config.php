<?php
$host = 'localhost';
$dbname = 'osk';
$username = 'postgres';
$password = '12345';

try {
    // Łączenie z bazą danych 
    $pdo = new PDO("pgsql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Nie można połączyć się z bazą danych: " . $e->getMessage());
}
?>