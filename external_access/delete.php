<?php
include 'config.php';

// Pobranie nazwy tabeli oraz identyfikatora rekordu z parametrów GET
$table = $_GET['table'] ?? '';
$id = $_GET['id'] ?? '';

// Sprawdzenie, czy ID jest liczbą całkowitą większą od 0
if (!is_numeric($id) || (int)$id <= 0) {
    die("Nieprawidłowy identyfikator rekordu.");
}

// Sprawdzenie, czy tabela jest poprawna
if (!in_array($table, ['instruktorzy', 'kursanci', 'szkolenia', 'pojazdy', 'plac', 'uprawnienia', 'kursanci_szkolenia', 'rezerwacje_plac', 'jazdy'])) {
    die("Nieprawidłowa tabela.");
}

// Funkcja wykonująca odpowiednią procedurę składowaną do usunięcia rekordu z wybranej tabeli
function deleteRecord($table, $id) {
    global $pdo; // Globalne połączenie z bazą danych

    // Mapowanie tabel na procedury składowane w bazie danych
    $procedures = [
        'plac' => 'delete_from_plac',
        'instruktorzy' => 'delete_from_instruktorzy',
        'kursanci' => 'delete_from_kursanci',
        'szkolenia' => 'delete_from_szkolenia',
        'pojazdy' => 'delete_from_pojazdy',
        'uprawnienia' => 'delete_from_uprawnienia',
        'kursanci_szkolenia' => 'delete_from_kursanci_szkolenia',
        'rezerwacje_plac' => 'delete_from_rezerwacje_plac',
        'jazdy' => 'delete_from_jazdy'
    ];

    // Sprawdzenie, czy procedura dla danej tabeli istnieje
    if (!isset($procedures[$table])) {
        die("Brak procedury usuwania dla tej tabeli.");
    }

    // Wywołanie odpowiedniej procedury składowanej
    $procedure = $procedures[$table]; // Pobranie nazwy procedury składowanej
    $stmt = $pdo->prepare("SELECT $procedure(:id)"); // Przygotowanie zapytania SQL wywołującego procedurę
    $stmt->execute(['id' => (int)$id]); // Rzutowanie ID na typ całkowity i przekazanie go do zapytania
}

try {
    // Uruchomienie funkcji usuwania rekordu z tabeli
    deleteRecord($table, $id);

    // Po udanym usunięciu przekierowanie użytkownika z powrotem na stronę tabeli
    header("Location: table.php?table=$table");
    exit; // Zakończenie skryptu, zapobiegając dalszemu wykonywaniu kodu
} catch (PDOException $e) {
    // Obsługa błędów, jeśli wystąpi problem z połączeniem lub wykonaniem zapytania
    die("Błąd podczas usuwania rekordu: " . $e->getMessage());
}
?>