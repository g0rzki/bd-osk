<?php
include 'config.php';

// Sprawdzenie, czy formularz został wysłany metodą POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Zbieranie danych z formularza
    $imie_kursanta = $_POST['imie_kursanta'] ?? '';
    $nazwisko_kursanta = $_POST['nazwisko_kursanta'] ?? '';
    $data_urodzenia = $_POST['data_urodzenia'] ?? '';
    $telefon = $_POST['telefon'] ?? '';
    $email = $_POST['email'] ?? '';
    $kategoria = $_POST['kategoria'] ?? '';
    $imie_instruktora = $_POST['imie_instruktora'] ?? '';
    $nazwisko_instruktora = $_POST['nazwisko_instruktora'] ?? '';
    $oplacony = isset($_POST['oplacony']) ? 1 : 0; // Przekazanie wartości true/false

    // Wywołanie funkcji zapisującej kursanta na kurs
    $stmt = $pdo->prepare("SELECT zarzadzanie_osoby.zapisz_na_kurs(
        :imie_kursanta, :nazwisko_kursanta, :data_urodzenia, :telefon, :email, 
        :kategoria, :imie_instruktora, :nazwisko_instruktora, :oplacony
    )");

    // Powiązanie zmiennyhc PHP z zapytaniem SQL
    $stmt->bindParam(':imie_kursanta', $imie_kursanta);
    $stmt->bindParam(':nazwisko_kursanta', $nazwisko_kursanta);
    $stmt->bindParam(':data_urodzenia', $data_urodzenia);
    $stmt->bindParam(':telefon', $telefon);
    $stmt->bindParam(':email', $email);
    $stmt->bindParam(':kategoria', $kategoria);
    $stmt->bindParam(':imie_instruktora', $imie_instruktora);
    $stmt->bindParam(':nazwisko_instruktora', $nazwisko_instruktora);
    $stmt->bindParam(':oplacony', $oplacony, PDO::PARAM_BOOL);

    // Wykonanie zapytania
    try {
        $stmt->execute();
        // Po udanym zapisie przekierowanie do strony potwierdzenia lub tabeli
        header("Location: table.php?table=kursanci");
        exit;
    } catch (Exception $e) {
        // Obsługa błędów (np. brak uprawnień instruktora, nieistniejący kurs)
        $error_message = $e->getMessage();
    }
}
?>

<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Zapisywanie kursanta na kurs</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Zapisywanie kursanta na kurs</h1>

    <!-- Wyświetlanie błędów, jeśli wystąpiły podczas zapisu -->
    <?php if (isset($error_message)): ?>
        <div class="error">
            <p>Błąd: <?php echo htmlspecialchars($error_message); ?></p>
        </div>
    <?php endif; ?>

    <!-- Formularz do zapisu kursanta na kurs -->
    <form action="sign_for_course.php" method="POST">
        <div>
            <label for="imie_kursanta">Imię kursanta:</label>
            <input type="text" id="imie_kursanta" name="imie_kursanta" required>
        </div>
        <div>
            <label for="nazwisko_kursanta">Nazwisko kursanta:</label>
            <input type="text" id="nazwisko_kursanta" name="nazwisko_kursanta" required>
        </div>
        <div>
            <label for="data_urodzenia">Data urodzenia:</label>
            <input type="date" id="data_urodzenia" name="data_urodzenia" required>
        </div>
        <div>
            <label for="telefon">Telefon:</label>
            <input type="text" id="telefon" name="telefon" required>
        </div>
        <div>
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div>
            <label for="kategoria">Kategoria kursu:</label>
            <input type="text" id="kategoria" name="kategoria" required>
        </div>
        <div>
            <label for="imie_instruktora">Imię instruktora:</label>
            <input type="text" id="imie_instruktora" name="imie_instruktora" required>
        </div>
        <div>
            <label for="nazwisko_instruktora">Nazwisko instruktora:</label>
            <input type="text" id="nazwisko_instruktora" name="nazwisko_instruktora" required>
        </div>
        <div>
            <label for="oplacony">Opłacony:</label>
            <input type="checkbox" id="oplacony" name="oplacony">
        </div>
        <div>
            <button type="submit">Zapisz kursanta</button>
        </div>
    </form>

    <!-- Link powrotu do strony kursantów -->
    <div class="centered">
        <a href="table.php?table=kursanci">Powrót do listy kursantów</a>
    </div>
</body>
</html>
