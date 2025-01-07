<?php
include 'config.php';

// Pobranie nazwy tabeli z parametrów GET
$table = $_GET['table'] ?? '';

// Sprawdzenie, czy tabela jest poprawna
if (!in_array($table, ['instruktorzy', 'kursanci', 'szkolenia', 'pojazdy', 'plac', 'uprawnienia', 'kursanci_szkolenia', 'rezerwacje_plac', 'jazdy'])) {
    die("Nieprawidłowa tabela.");
}

// Funkcja wykonująca odpowiednią procedurę składowaną do wydobycia nazw kolumn z tabeli
function getColumns($table) {
    global $pdo; // Globalne połączenie z bazą danych

    // Przygotowanie wywołania procedury
    $stmt = $pdo->prepare("SELECT * FROM ogolne_operacje.get_table_columns(:table_name)");
    $stmt->bindParam(':table_name', $table, PDO::PARAM_STR);

    // Wykonanie procedury
    $stmt->execute();

    // Pobranie wyników w postaci tablicy
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

// Pobranie kolumny danej tabeli
$columns = getColumns($table);

// Filtrowanie kluczy głównych (kolumny z wartością 'nextval' są ignorowane)
$columns = array_filter($columns, function($column) {
    return !$column['is_serial']; // Ignorowanie kolumn autoinkrementowanych
});

// Sprawdzenie, czy formularz został wysłany metodą POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Zbieranie danych z formularza
    $values = [];
    $columnNames = [];

    // Iterowanie po wszystkich kolumnach i zbiór danych z formularza
    foreach ($columns as $column) {
        $columnName = $column['column_name']; // Pobranie nazwy kolumny
        // Jeśli pole istnieje w formularzu
        if (isset($_POST[$columnName])) { 
            $value = trim($_POST[$columnName]);
            // Jeśli pole jest puste i może być NULL, ustawienie NULL
            if ($value === '' && $column['is_nullable'] === 'YES') {
                $values[":$columnName"] = null;
            } else {
                $values[":$columnName"] = $value;
            }
            $columnNames[] = $columnName; // Dodanie nazwy kolumny do listy nazw
        }
    }

    // Mapowanie tabel na procedury składowane w bazie danych
    $procedures = [
        'instruktorzy' => 'zarzadzanie_osoby.insert_into_instruktorzy',
        'kursanci' => 'zarzadzanie_osoby.insert_into_kursanci',
        'szkolenia' => 'zarzadzanie_szkolenia.insert_into_szkolenia',
        'pojazdy' => 'zarzadzanie_pojazdy.insert_into_pojazdy',
        'plac' => 'zarzadzanie_plac.insert_into_plac',
        'uprawnienia' => 'zarzadzanie_osoby.insert_into_uprawnienia',
        'kursanci_szkolenia' => 'zarzadzanie_szkolenia.insert_into_kursanci_szkolenia',
        'rezerwacje_plac' => 'zarzadzanie_plac.insert_into_rezerwacje_plac',
        'jazdy' => 'zarzadzanie_jazdy.insert_into_jazdy'
    ];

    // Sprawdzenie, czy dla danej tabeli istnieje procedura do dodania rekordu
    if (isset($procedures[$table])) {
        $procedure = $procedures[$table]; // Pobranie nazwy procedury składowanej dla danej tabeli

        // Przygotowanie zapytania SQL, które wywoła odpowiednią procedurę składowaną z dynamicznymi parametrami
        $placeholders = implode(", ", array_keys($values)); // Tworzenie ciągu parametrów
        $stmt = $pdo->prepare("SELECT $procedure($placeholders)"); // Przygotowanie zapytania do wywołania procedury

        // Wykonanie zapytania z parametrami z formularza
        $stmt->execute($values);

        // Po udanym dodaniu rekordu przekierowanie użytkownika na stronę tabeli
        header("Location: table.php?table=$table");
        exit;
    } else {
        die("Brak procedury do dodania rekordu dla tej tabeli."); // Jeśli nie ma procedury, wyświetlenie błędu
    }
}
?>

<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dodaj rekord do tabeli <?php echo htmlspecialchars($table); ?></title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Dodaj rekord do tabeli: <?php echo htmlspecialchars($table); ?></h1>

    <!-- Formularz do dodania rekordu -->
    <form action="add.php?table=<?php echo $table; ?>" method="POST">
        <?php foreach ($columns as $column): ?>
            <div>
                <label for="<?php echo $column['column_name']; ?>"><?php echo $column['column_name']; ?>:</label>
                <input type="text" id="<?php echo $column['column_name']; ?>" name="<?php echo $column['column_name']; ?>" <?php echo $column['is_nullable'] === 'NO' ? 'required' : ''; ?>>
            </div>
        <?php endforeach; ?>
        
        <!-- Przycisk do wysłania formularza -->
        <button type="submit">Dodaj rekord</button>
    </form>

    <!-- Link powrotu do tabeli -->
    <div class="centered">
        <a href="table.php?table=<?php echo $table; ?>">Powrót do tabeli</a>
    </div>
</body>
</html>