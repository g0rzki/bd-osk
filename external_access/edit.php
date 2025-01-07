<?php
include 'config.php'; 

// Pobranie nazwy tabeli oraz identyfikatora rekordu z parametrów GET
$table = $_GET['table'] ?? ''; 
$id = $_GET['id'] ?? ''; 

// Sprawdzenie, czy tabela jest poprawna
if (!in_array($table, ['instruktorzy', 'kursanci', 'szkolenia', 'pojazdy', 'plac', 'uprawnienia', 'kursanci_szkolenia', 'rezerwacje_plac', 'jazdy'])) {
    die("Nieprawidłowa tabela.");
}

// Mapowanie tabel i ich kluczy głównych
$primaryKeyMap = [
    'instruktorzy' => 'id_instruktora',
    'kursanci' => 'id_kursanta',
    'szkolenia' => 'id_kursu',
    'pojazdy' => 'id_pojazdu',
    'plac' => 'nr_toru',
    'uprawnienia' => 'id_uprawnienia',
    'kursanci_szkolenia' => 'id_postepu',
    'rezerwacje_plac' => 'id_rezerwacji',
    'jazdy' => 'id_jazdy'
];

// Sprawdzenie, czy tabela istnieje w mapowaniu
if (!array_key_exists($table, $primaryKeyMap)) {
    die("Nieznana tabela.");
}

// Pobranie nazwy klucza głównego dla danej tabeli
$primaryKey = $primaryKeyMap[$table];

// Zapytanie do pobrania danych rekordu z bazy
$query = "SELECT * FROM $table WHERE $primaryKey = :id";
$stmt = $pdo->prepare($query);
$stmt->execute(['id' => $id]);
$row = $stmt->fetch(PDO::FETCH_ASSOC);

// Zakończenie działania skryptu gdy rekord o podanym id nie istnieje
if (!$row) {
    die("Rekord nie istnieje.");
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

$columns = array_column(getColumns($table), 'column_name');

// Funkcja, która sprawdza, czy kolumna może być edytowana (czy nie jest kluczem głównym)
function isEditable($column, $primaryKey) {
    return $column !== $primaryKey; // Kolumna nie jest edytowalna, jeśli jest kluczem głównym
}

// Procedury dla tabel
$procedures = [
    'instruktorzy' => 'zarzadzanie_osoby.update_instruktory',
    'kursanci' => 'zarzadzanie_osoby.update_kursanci',
    'szkolenia' => 'zarzadzanie_szkolenia.update_szkolenia',
    'pojazdy' => 'zarzadzanie_pojazdy.update_pojazdy',
    'plac' => 'zarzadzanie_plac.update_plac',
    'uprawnienia' => 'zarzadzanie_osoby.update_uprawnienia',
    'kursanci_szkolenia' => 'zarzadzanie_szkolenia.update_kursanci_szkolenia',
    'rezerwacje_plac' => 'zarzadzanie_plac.update_rezerwacje_plac',
    'jazdy' => 'zarzadzanie_jazdy.update_jazdy'
];

// Obsługa formularza
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $updatedData = [];

    // Zbieranie danych z formularza, uwzględniając klucz główny
    foreach ($columns as $column) {
        if (isEditable($column, $primaryKey)) {
            $updatedData[$column] = $_POST[$column] ?? null;
        }
    }

    // Klucz główny zawsze jest uwzględniany w zapytaniu mimo braku możliwości jego edycji
    if (isset($procedures[$table])) {
        $procedure = $procedures[$table];

        // Przygotowanie zapytania do wykonania procedury
        $params = $updatedData;
        $params[$primaryKey] = $id; // Zawsze przekazujemy klucz główny do zapytania

        // Przygotowanie zapytania do wykonania procedury
        $procedureParams = [];
        foreach ($updatedData as $key => $value) {
            $procedureParams[":$key"] = $value;
        }

        $procedureParams[':id'] = $id; // Przekazywanie klucza głównego

        // Przygotowanie zapytania z odpowiednią liczbą parametrów
        $columnsList = implode(', ', array_map(fn($col) => ":$col", array_keys($updatedData)));
        $stmt = $pdo->prepare("SELECT $procedure(:id::int, $columnsList)");

        // Wykonanie zapytania
        $stmt->execute($procedureParams);
    } else {
        die("Brak procedury do aktualizacji tej tabeli.");
    }

    // Po zakończeniu aktualizacji, przekierowanie do tabeli
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
     <!-- Formularz do edycji rekordu -->
    <form action="edit.php?table=<?php echo $table; ?>&id=<?php echo $id; ?>" method="POST">
        <?php foreach ($columns as $column): ?>
            <div>
                <label for="<?php echo $column; ?>"><?php echo $column; ?>:</label>
                <input type="text" id="<?php echo $column; ?>" name="<?php echo $column; ?>" 
                    value="<?php echo htmlspecialchars($row[$column] ?? '', ENT_QUOTES); ?>" 
                    <?php echo isEditable($column, $primaryKey) ? '' : 'disabled'; ?>>
            </div>
        <?php endforeach; ?>

        <!-- Przycisk do wysłania formularza -->
        <button type="submit">Zapisz zmiany</button>
    </form>

    <!-- Link powrotu do tabeli -->
    <div class="centered">
        <a href="table.php?table=<?php echo $table; ?>">Powrót do tabeli</a>
    </div>
</body>
</html>
