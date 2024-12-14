<?php
include 'config.php';

// Pobranie nazwy tabeli z parametrów GET
$table = $_GET['table'] ?? '';

// Mapowanie tabel na ich klucze główne
$primaryKeys = [
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

// Warunek sprawdzający poprawność tabeli w zapytaniu
if (!in_array($table, array_keys($primaryKeys))) {
    die("Nieprawidłowa tabela.");
}

// Stronowanie rekordów 
$recordsPerPage = 20; // Liczba rekordów na stronę
$page = isset($_GET['page']) ? (int)$_GET['page'] : 1; // Pobranie numeru strony z parametru GET
$offset = ($page - 1) * $recordsPerPage; // Określenie pozycji od której zaczynamy pobierać dane

// Kwerenda SQL do pobrania danych z tabeli z uwzględnieniem stronowania
$query = "SELECT * FROM $table LIMIT $recordsPerPage OFFSET $offset";
$stmt = $pdo->query($query);

// Pobranie nazw kolumn z pierwszego rekordu
$columns = array_keys($stmt->fetch(PDO::FETCH_ASSOC));

// Pobranie danych z tabel
$stmt->execute();

// Zliczanie wszystkich rekordów w tabeli
$totalQuery = "SELECT COUNT(*) FROM $table";
$totalRecords = $pdo->query($totalQuery)->fetchColumn();
$totalPages = ceil($totalRecords / $recordsPerPage);

$primaryKey = $primaryKeys[$table]; // Ustalenie klucza głównego dla danej tabeli
?>

<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tabela: <?php echo $table; ?></title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <!-- Nagłówek strony z nazwą tabeli -->
    <h1>Tabela: <?php echo $table; ?></h1>

    <!-- Formularz powrotu do wyboru tabeli -->
    <div class="centered">
        <a href="index.php">Wróć do wyboru tabeli</a>
    </div>

    <!-- Tabela z danymi -->
    <table>
        <thead>
            <tr>
                <!-- Wyświetlenie nazwy kolumn -->
                <?php foreach ($columns as $column): ?>
                    <th><?php echo $column; ?></th>
                <?php endforeach; ?>
                <!-- Dodanie kolumny z akcjami -->
                <th>akcje</th>
            </tr>
        </thead>
        <tbody>
            <!-- Wyświetlenie danych w tabeli -->
            <?php while ($row = $stmt->fetch(PDO::FETCH_ASSOC)): ?>
                <tr>
                    <!-- Wyświetlenie wartości z każdego rekordu w odpowiednich kolumnach -->
                    <?php foreach ($row as $value): ?>
                        <td><?php echo $value; ?></td>
                    <?php endforeach; ?>
                    <!-- Akcje dla każdego rekordu: edycja i usuwanie -->
                    <td>
                        <!-- Link do edycji rekordu -->
                        <a href="edit.php?table=<?php echo $table; ?>&id=<?php echo $row[$primaryKey]; ?>" onclick="return confirm('Czy na pewno chcesz edytować ten rekord?');">edytuj</a>
                        <br>
                        <!-- Link do usuwania rekordu -->
                        <a href="delete.php?table=<?php echo $table; ?>&id=<?php echo $row[$primaryKey]; ?>" onclick="return confirm('Czy na pewno chcesz usunąć ten rekord?');">usuń</a>
                    </td>
                </tr>
            <?php endwhile; ?>
        </tbody>
    </table>

    <!-- Formularz do dodawania rekordu -->
    <div class="centered">
        <a href="add.php?table=<?php echo $table; ?>">Dodaj nowy rekord</a>
    </div>

    <!-- Nawigacja między stronami (paginacja) -->
    <div class="centered">
        <p>Strona: <?php echo $page; ?> z <?php echo $totalPages; ?></p>
        <div>
            <!-- Link do poprzedniej strony (jeśli nie jesteśmy na pierwszej) -->
            <?php if ($page > 1): ?>
                <a href="?table=<?php echo $table; ?>&page=<?php echo $page - 1; ?>">Poprzednia</a>
            <?php endif; ?>
            <!-- Link do następnej strony (jeśli nie jesteśmy na ostatniej) -->
            <?php if ($page < $totalPages): ?>
                <a href="?table=<?php echo $table; ?>&page=<?php echo $page + 1; ?>">Następna</a>
            <?php endif; ?>
        </div>
    </div>
</body>
</html>