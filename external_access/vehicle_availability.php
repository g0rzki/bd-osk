<?php
include 'config.php';

// Sprawdzenie, czy formularz został wysłany
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Pobranie danych z formularza
    $kategoria = $_POST['kategoria'] ?? null;
    $start_time = $_POST['start_time'] ?? null;
    $end_time = $_POST['end_time'] ?? null;

    // Sprawdzenie, czy wszystkie dane zostały podane
    if ($kategoria && $start_time && $end_time) {
        // Wywołanie funkcji sprawdzającej dostępność pojazdów
        $stmt = $pdo->prepare("
            SELECT * 
            FROM zarzadzanie_pojazdy.dostepnosc_pojazdu(:kategoria, :start_time, :end_time)
        ");

        // Przypisanie parametrów do zapytania
        $stmt->bindParam(':kategoria', $kategoria, PDO::PARAM_STR);
        $stmt->bindParam(':start_time', $start_time, PDO::PARAM_STR);
        $stmt->bindParam(':end_time', $end_time, PDO::PARAM_STR);

        // Wykonanie zapytania
        $stmt->execute();

        // Pobranie wyników zapytania, które zawierają dostępne pojazdy
        $dostepnePojazdy = $stmt->fetchAll(PDO::FETCH_ASSOC);
    } else {
        // Wyświetlenie błędu, jeśli nie podano wszystkich wymaganych danych
        $error = "Proszę podać wszystkie wymagane dane.";
    }
}
?>

<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sprawdź dostępność pojazdów</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Panel dostępności pojazdów</h1>

    <!-- Formularz do wprowadzenia danych do sprawdzenia dostępności pojazdów -->
    <form method="POST" action="">
        <label for="kategoria">Kategoria pojazdu:</label>
        <select name="kategoria" id="kategoria" required>
            <option value="">-- Wybierz kategorię --</option>
            <option value="A">Kategoria A</option>
            <option value="B">Kategoria B</option>
            <option value="C">Kategoria C</option>
            <option value="D">Kategoria D</option>
        </select>
        <br><br>

        <!-- Wybór daty i godziny rozpoczęcia -->
        <label for="start_time">Początek (data i godzina):</label>
        <input type="datetime-local" name="start_time" id="start_time" required>
        <br><br>

        <!-- Wybór daty i godziny zakończenia -->
        <label for="end_time">Koniec (data i godzina):</label>
        <input type="datetime-local" name="end_time" id="end_time" required>
        <br><br>

        <!-- Przycisk do wysłania formularza -->
        <button type="submit">Sprawdź dostępność</button>
    </form>

    <!-- Sprawdzenie, czy dostępne pojazdy zostały znalezione -->
    <?php if (isset($dostepnePojazdy)): ?>
        <?php if (count($dostepnePojazdy) > 0): ?>
            <!-- Wyświetlanie tabeli z dostępnymi pojazdami -->
            <table border="1">
                <thead>
                    <tr>
                        <th>ID Pojazdu</th>
                        <th>Numer rejestracyjny</th>
                        <th>Marka</th>
                        <th>Model</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Iteracja po dostępnych pojazdach i wyświetlanie ich danych -->
                    <?php foreach ($dostepnePojazdy as $pojazd): ?>
                        <tr>
                            <td><?php echo htmlspecialchars($pojazd['id_pojazdu']); ?></td>
                            <td><?php echo htmlspecialchars($pojazd['nr_rejestracyjny']); ?></td>
                            <td><?php echo htmlspecialchars($pojazd['marka']); ?></td>
                            <td><?php echo htmlspecialchars($pojazd['model']); ?></td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        <?php else: ?>
            <!-- Komunikat, gdy nie ma dostępnych pojazdów w wybranym czasie i kategorii -->
            <p style="color: red;">Brak dostępnych pojazdów w wybranym czasie i kategorii.</p>
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