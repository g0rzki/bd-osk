<?php
include 'config.php';

// Zmienna przechowująca raport
$raport = null;
$error_message = null;

// Sprawdzenie, czy formularz został wysłany metodą POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Pobranie ID kursanta z formularza
    $id_kursanta = $_POST['id_kursanta'] ?? ''; 

    // Walidacja ID kursanta
    if (empty($id_kursanta) || !is_numeric($id_kursanta)) {
        $error_message = "Proszę podać prawidłowe ID kursanta."; // Jeśli ID jest puste lub nie jest liczbą
    } else {
        try {
            // Wywołanie funkcji raportu kursanta
            $stmt = $pdo->prepare("SELECT * FROM zarzadzanie_osoby.raport_kursanta(:id_kursanta)");
            $stmt->bindParam(':id_kursanta', $id_kursanta, PDO::PARAM_INT); // Powiązanie parametru z zapytaniem
            $stmt->execute(); // Wykonanie zapytania

            // Pobranie wyników w postaci tablicy
            $raport = $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            // Obsługa błędów
            $error_message = "Wystąpił błąd podczas pobierania raportu: " . $e->getMessage();
        }
    }
}
?>

<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Raport o kursancie</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Raport o kursancie</h1>

     <!-- Wyświetlanie komunikatu o błędzie, jeśli taki wystąpił -->
    <?php if (isset($error_message)): ?>
        <div class="error">
            <p><?php echo htmlspecialchars($error_message); ?></p>
        </div>
    <?php endif; ?>

    <!-- Formularz do wprowadzenia ID kursanta -->
    <form action="student_report.php" method="POST">
        <div>
            <label for="id_kursanta">ID kursanta:</label>
            <input type="text" id="id_kursanta" name="id_kursanta" required>
        </div>
        <button type="submit">Pobierz raport</button>
    </form>

    <?php if ($raport): ?>
        <!-- Wyświetlanie raportu -->
        <table>
            <thead>
                <tr>
                    <th>Imię</th>
                    <th>Nazwisko</th>
                    <th>Telefon</th>
                    <th>Email</th>
                    <th>Godziny pozostałe</th>
                    <th>Data jazdy</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($raport as $row): ?>
                    <!-- Iteracja po każdym rekordzie w raporcie i wyświetlanie danych w tabeli -->
                    <tr>
                        <td><?php echo htmlspecialchars($row['kursant_imie']); ?></td>
                        <td><?php echo htmlspecialchars($row['kursant_nazwisko']); ?></td>
                        <td><?php echo htmlspecialchars($row['kursant_telefon']); ?></td>
                        <td><?php echo htmlspecialchars($row['kursant_email']); ?></td>
                        <td><?php echo htmlspecialchars($row['godziny_pozostale']); ?></td>
                        <td><?php echo htmlspecialchars($row['jazda_data']); ?></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    <?php endif; ?>

    <!-- Link powrotu do strony z kursantami -->
    <div class="centered">
        <a href="table.php?table=kursanci">Powrót do listy kursantów</a>
    </div>
</body>
</html>
