<?php
include 'config.php'; 

// Pobranie nazwy tabeli oraz identyfikatora rekordu z parametrów GET
$table = $_GET['table'] ?? ''; 
$id = $_GET['id'] ?? ''; 

// Sprawdzenie czy parametry nie są puste
if (empty($table) || empty($id)) {
    die("Brak tabeli lub identyfikatora rekordu.");
}

// Funkcja do pobrania nazwy klucza głównego danej tabeli
function getPrimaryKey($table) {
    global $pdo;
    
    // Zapytanie, aby znaleźć klucz główny tabeli
    $query = "
        SELECT column_name 
        FROM information_schema.key_column_usage 
        WHERE table_name = :table AND constraint_name = (
            SELECT constraint_name 
            FROM information_schema.table_constraints 
            WHERE table_name = :table AND constraint_type = 'PRIMARY KEY'
        )
    ";
    $stmt = $pdo->prepare($query); // Przygotowanie zapytania
    $stmt->execute(['table' => $table]); // Wykonanie zapytania z przekazaniem nazwy tabeli jako parametr
    
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    return $result['column_name'] ?? ''; // Zwrócenie nazwy klucza głównego, jeśli istnieje
}

$primaryKey = getPrimaryKey($table); // Pobranie klucza głównego dla tabeli

// Zapytanie do pobrania danych rekordu z bazy
$query = "SELECT * FROM $table WHERE $primaryKey = :id";
$stmt = $pdo->prepare($query);
$stmt->execute(['id' => $id]);
$row = $stmt->fetch(PDO::FETCH_ASSOC);

// Zakończenie działania skryptu gdy rekord o podanym id nie istnieje
if (!$row) {
    die("Rekord nie istnieje.");
}

// Funkcja do pobrania nazw wszystkich kolumn dla tabeli
function getColumns($table) {
    global $pdo;
    
    // Zapytanie pobierające nazwy wszystkich kolumn
    $query = "SELECT column_name FROM information_schema.columns WHERE table_name = :table";
    $stmt = $pdo->prepare($query);
    $stmt->execute(['table' => $table]);
    
    return $stmt->fetchAll(PDO::FETCH_COLUMN); // Zwraca wszystkie nazwy kolumn
}

// Funkcja, która sprawdza, czy kolumna może być edytowana (czy nie jest kluczem głównym)
function isEditable($column, $primaryKey, $table) {
    // Dla tabeli 'plac' kolumna 'nr_toru' powinna być edytowalna, mimo że jest kluczem głównym
    if ($table === 'plac' && $column === 'nr_toru') {
        return true; // Zezwolenie na edycję 'nr_toru' w tabeli 'plac'
    }
    return $column !== $primaryKey; // Kolumna nie jest edytowalna, jeśli jest kluczem głównym
}

// Obsługa formularza, jeśli został wysłany
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Zbieranie danych z formularza
    $updatedData = [];
    foreach (getColumns($table) as $column) {
        if ($column !== $primaryKey || $column == 'nr_toru') { // Umożliwienie edytowania nr_toru (gdy nie jest autoinkrementowane)
            $updatedData[$column] = $_POST[$column] ?? null; // Ustawienie wartości z formularza, lub null, jeśli pole jest puste
        }
    }

    // Przygotowanie zapytania SQL do aktualizacji rekordu
    $setFields = [];
    foreach ($updatedData as $column => $value) {
        $setFields[] = "$column = :$column"; // Przygotowanie części zapytania 'SET column1 = :column1'
    }

    // Łączenie fragmentów zapytania 'SET' w jedno
    $setString = implode(', ', $setFields);
    // Zapytanie SQL do aktualizacji rekordu w tabeli
    $updateQuery = "UPDATE $table SET $setString WHERE $primaryKey = :id";

    // Przygotowanie i wykonanie zapytania
    $stmt = $pdo->prepare($updateQuery);
    $updatedData['id'] = $id; // Dodanie ID do danych do wykonania
    $stmt->execute($updatedData);

    // Po zakończeniu edycji, przekierowanie do widoku tabeli
    header("Location: table.php?table=$table");
    exit;
}
?>

<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edytuj rekord w tabeli <?php echo htmlspecialchars($table); ?></title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Edytuj rekord w tabeli <?php echo htmlspecialchars($table); ?></h1>

    <!-- Formularz edycji rekordu -->
    <form action="edit.php?table=<?php echo $table; ?>&id=<?php echo $id; ?>" method="POST">
        <?php foreach (getColumns($table) as $column): ?>
            <?php if (isEditable($column, $primaryKey, $table)): ?>
                <div>
                    <label for="<?php echo $column; ?>"><?php echo $column; ?>:</label>
                    <input type="text" id="<?php echo $column; ?>" name="<?php echo $column; ?>" value="<?php echo htmlspecialchars($row[$column] ?? '', ENT_QUOTES); ?>">
                </div>
            <?php endif; ?>
        <?php endforeach; ?>

        <!-- Przycisk zatwierdzający edycję -->
        <button type="submit">Edytuj rekord</button>
    </form>

    <!-- Link powrotu do tabeli -->
    <div class="centered">
        <a href="table.php?table=<?php echo $table; ?>">Powrót do tabeli</a>
    </div>
</body>
</html>