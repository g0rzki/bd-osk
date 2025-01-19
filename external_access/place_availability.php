<?php
include 'config.php'; 

// Sprawdzenie, czy formularz został wysłany
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Pobranie danych z formularza
    $kategoria = $_POST['kategoria'] ?? null;
    $data = $_POST['data'] ?? null;
    $godzina = $_POST['godzina'] ?? null;

    // Sprawdzenie, czy wszystkie dane zostały podane
    if ($kategoria && $data && $godzina) {
        try {
            // Przygotowanie zapytania do funkcji PostgreSQL
            $stmt = $pdo->prepare("
                SELECT * 
                FROM zarzadzanie_plac.sprawdz_dostepnosc_torow(:kategoria, :data, :godzina)
            ");
            // Powiązanie parametrów zapytania z danymi wejściowymi
            $stmt->bindParam(':kategoria', $kategoria, PDO::PARAM_STR);
            $stmt->bindParam(':data', $data, PDO::PARAM_STR);
            $stmt->bindParam(':godzina', $godzina, PDO::PARAM_STR);

            // Wykonanie zapytania
            $stmt->execute();

            // Pobranie wyników funkcji
            $dostepneTory = $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            // Obsługa błędu w przypadku problemów z bazą danych
            $error = "Błąd bazy danych: " . $e->getMessage();
        }
    } else {
        // Wyświetlenie błędu, jeśli dane wejściowe są niepełne
        $error = "Proszę podać wszystkie wymagane dane.";
    }
}
?>

<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sprawdź dostępność placu manewrowego</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Panel dostępności placu manewrowego</h1>

    <!-- Formularz do sprawdzenia dostępności -->
    <form method="POST" action="">
        <!-- Wybór kategorii pojazdu -->
        <label for="kategoria">Kategoria pojazdu:</label>
        <select name="kategoria" id="kategoria" required>
            <option value="">-- Wybierz kategorię --</option>
            <option value="A">Kategoria A</option>
            <option value="B">Kategoria B</option>
            <option value="C">Kategoria C</option>
            <option value="D">Kategoria D</option>
        </select>
        <br><br>

        <!-- Wybór daty -->
        <label for="data">Data:</label>
        <input type="date" name="data" id="data" required>
        <br><br>

        <!-- Wybór godziny -->
        <label for="godzina">Godzina:</label>
        <input type="time" name="godzina" id="godzina" required>
        <br><br>

        <!-- Przycisk do wysłania formularza -->
        <button type="submit">Sprawdź dostępność</button>
    </form>

    <!-- Sekcja wyników -->
    <?php if (isset($dostepneTory)): ?>
        <?php if (count($dostepneTory) > 0): ?>
            <!-- Wyświetlanie tabeli z dostępnością torów -->
            <table border="1">
                <thead>
                    <tr>
                        <th>Numer toru</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Iteracja po dostępnych torach i wyświetlanie ich danych -->
                    <?php foreach ($dostepneTory as $tor): ?>
                        <tr>
                            <td><?php echo htmlspecialchars($tor['nr_toru']); ?></td>
                            <td><?php echo htmlspecialchars($tor['status']); ?></td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        <?php else: ?>
            <!-- Komunikat o braku dostępnych torów w wybranym terminie -->
            <p style="color: red;">Brak dostępnych torów w wybranym terminie i godzinie.</p>
        <?php endif; ?>
    <?php elseif (isset($error)): ?>
        <!-- Wyświetlenie błędu, jeśli dane zostały wprowadzone niepoprawnie -->
        <p style="color: red;"><?php echo htmlspecialchars($error); ?></p>
    <?php endif; ?>

    <!-- Formularz powrotu do wyboru tabeli -->
    <div class="centered">
        <a href="index.php">Wróć do wyboru tabeli</a>
    </div>
</body>
</html>