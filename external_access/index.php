<?php
include 'config.php';
?>

<!-- Menu wyboru tabel -->
<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Baza danych OSK</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Wybierz tabelę którą chcesz wyświetlić</h1>
    <nav>
        <ul>
            <!-- Linki do wczytania tabel -->
            <li><a href="table.php?table=instruktorzy">Instruktorzy</a></li>
            <li><a href="table.php?table=kursanci">Kursanci</a></li>
            <li><a href="table.php?table=szkolenia">Szkolenia</a></li>
            <li><a href="table.php?table=pojazdy">Pojazdy</a></li>
            <li><a href="table.php?table=plac">Plac</a></li>
            <li><a href="table.php?table=uprawnienia">Uprawnienia</a></li>
            <li><a href="table.php?table=kursanci_szkolenia">Kursanci Szkolenia</a></li>
            <li><a href="table.php?table=rezerwacje_plac">Rezerwacje Plac</a></li>
            <li><a href="table.php?table=jazdy">Jazdy</a></li>
        </ul>
    </nav>
</body>
</html>