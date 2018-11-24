# Vigenere-cipher
# НАСТАНОВА КОРИСТУВАЧУ
щодо роботи з комп'ютерною програмою “Шифрування методом Віженера”

# ВСТУП
Комп'ютерна програма “Шифрування методом Віженера” дозволяє шифрувати і дешифрувати текст методом Віженера. Програма підтримує літери українського алфавіту, а також різноманітні символи та цифри. Текст який потрібно зашифрувати або розшифрувати та ключ вводяться у відповідні файли, а результати виконання у вихідний файл. Також програма вміє опрацьовувати різні помилки у вигляді некоректних символів і виводити відповідні повідомлення.

# ВИМОГИ ДО ПРОГРАМНОГО ЗАБЕЗПЕЧЕННЯ
- операційна система Linux, BSD, Microsoft Windows, Solaris, Mac OS X та будь-яка інша операційна система з підтримкою запуску DOS програм;
- DOS — емулятор або транслятор, якщо такий необхідно.

# ВСТАНОВЛЕННЯ КОМП’ЮТЕРНОЇ ПРОГРАМИ
Нижче буде наведено приклад встановлення та запуску програми на операційній системі Ubuntu 18.04 LTS. Ці кроки можуть несуттєво відрізнятися на інших операційних системах. Спочатку потрібно встановити DOS — емулятор або транслятор, якщо такий необхідно. На рисунку 1 показано встановлення DOS емулятора dosbox.
<br>
<a href="https://raw.githubusercontent.com/RomanButsiy/Vigenere-cipher/master/screens/Screen1.png"><img src="https://raw.githubusercontent.com/RomanButsiy/Vigenere-cipher/master/screens/Screen1.png"></a>
<br>
Рисунок 1 — Встановлення dosbox
<br>
Для використання програми потрібно запустити dosbox та змонтувати каталог у якому знаходиться розпакована програма “Шифрування методом Віженера”. Монтувати каталог можна на будь-яку букву диску (рисунок 2).
<br>
<a href="https://raw.githubusercontent.com/RomanButsiy/Vigenere-cipher/master/screens/Screen2.png"><img src="https://raw.githubusercontent.com/RomanButsiy/Vigenere-cipher/master/screens/Screen2.png"></a>
<br>
Рисунок 2 — Підготовка до запуску програми
<br>
# ЗАПУСК ТА ВИКОРИСТАННЯ ПРОГРАМИ
Для запуску програми потрібно запустити пакетний файл shell-програми командою KEY.BAT. Після цього автоматично запуститься сценарій, який вже запустить програму “Шифрування методом Віженера”. Текст який потрібно зашифрувати або розшифрувати вводиться у файл “text.txt”, а ключ — у файл “inkey.txt”. Результат виконання програми виводиться у вихідний файл “outkey.txt” (рисунок 3). 
<br>
<a href="https://raw.githubusercontent.com/RomanButsiy/Vigenere-cipher/master/screens/Screen3.png"><img src="https://raw.githubusercontent.com/RomanButsiy/Vigenere-cipher/master/screens/Screen3.png"></a>
<br>
Рисунок 3 — Вміст файлів після виконання програми
<br>
Після запуску програма вона запитує користувача, що потрібно зробити з текстом. Якщо натиснути клавішу “E” або “Ввід” то запуститься алгоритм шифрування тексту, а якщо натиснути клавішу “D” то запуститься алгоритм дешифрування тексту (рисунок 4).
<br>
<a href="https://raw.githubusercontent.com/RomanButsiy/Vigenere-cipher/master/screens/Screen4.png"><img src="https://raw.githubusercontent.com/RomanButsiy/Vigenere-cipher/master/screens/Screen4.png"></a>
<br>
Рисунок 4 — Інтерфейс користувача
<br>
У програмі передбачена обробка маси виняткових ситуацій. Наприклад якщо будуть відсутні файли “text.txt” або “inkey.txt” то програма виведе користувачу відповідні повідомлення і завершить свою роботу, також якщо вихідний файл за якихось причин не вдалося створити або він вже створений та захищений від запису, то програма також виведе відповідне повідомлення.
Програмою передбачено використання помилкових символів у ключі та у тексті. Вівши у файл “inkey.txt” символ “d” програма виведе відповідне повідомлення про помилку (рисунок 5). Слід зазначити, що кількість символів ключа і тексту може бути довільною і на виконання програми ніяк не впливає.
<br>
<a href="https://raw.githubusercontent.com/RomanButsiy/Vigenere-cipher/master/screens/Screen5.png"><img src="https://raw.githubusercontent.com/RomanButsiy/Vigenere-cipher/master/screens/Screen5.png"></a>
<br>
Рисунок 5 — Некоректний символ
<br>
# ЗАГАЛЬНИЙ ОПИС ПРОГРАМИ

Шифр Віженера складається з послідовності декількох шифрів Цезаря з різними значеннями зсуву. Для зашифровування може використовуватися таблиця алфавітів, так звана квадрат Віженера. Таблиця знаходиться у додатку А. Цю таблицю також можна використовувати для ручного шифрування або дешифрування тексту за неможливості використання програми. У програмі  використовується наступний алфавіт символів: “а б в г ґ д е є ж з и і ї й к л м н о п р с т у ф х ц ч ш щ ь ю я 0 1 2 3 4 5 6 7 8 9   ! № ; % : ? * ( ) - + = . , $”. Слід зазначити, що символ між дев'яткою і знаком оклику є пробіл.
Стосовно даного алфавіту таблиця Віженера складатиметься з рядків по 59 символів, причому кожний наступний рядок зсуватиметься на кілька позицій. Таким чином, в таблиці виходить 59 різних шифрів Цезаря. На кожному етапі шифрування використовуються різні алфавіти, які обираються в залежності від символу ключового слова.
Наприклад, припустимо, що вхідний текст має такий вигляд “роман”. Тоді ключове слово буде мати вигляд “буцій”. Якщо текст, який потрібно зашифрувати містить більше символів ніж ключ тоді ключове слово циклічно повторяється поки не буде досягнута необхідна кількість символів.
Перший символ вхідного тексту “р” зашифрований послідовністю “б”, яка є першим символом ключа. Перший символ “с” зашифрованого тексту знаходиться на перетині рядка “б” і стовпці “р” в таблиці Віженера (див. додаток А). Точно так шифрування проводиться для другого символу вхідного тексту, використовується другий символ ключа; тобто другий символ зашифрованого тексту “8” виходить на перетині рядка “у” і стовпця “о”. Інша частина вхідного тексту шифрується аналогічним способом.
Розшифрування проводиться таким чином: знаходимо в таблиці Віженера рядок, відповідно першому символу ключового слова; в цьому рядку знаходимо перший символ зашифрованого тексту. Стовпець, в якому знаходиться даний символ, відповідає першому символу вхідного тексту. Наступні символи зашифрованого тексту розшифровуються аналогічно.
# ДОДАТОК А ТАБЛИЦЯ АЛФАВІТІВ
<br>
<a href="https://raw.githubusercontent.com/RomanButsiy/Vigenere-cipher/master/screens/Screen6.png"><img src="https://raw.githubusercontent.com/RomanButsiy/Vigenere-cipher/master/screens/Screen6.png"></a>
<br>
# 2018 Roman
