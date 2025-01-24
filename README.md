<p align="center">
      <img src="https://i.ibb.co/qmqv7ZY/2024-04-13-17-42-50.png" width="726">
</p>

<p align="center">
   <img src="https://img.shields.io/badge/Engine-XCode v15.3-blueviolet">
   <img src="https://img.shields.io/badge/Version-v1.0-blue">
   <img src="https://img.shields.io/badge/License-MIT-green">
</p>

## About

Приложение-читалка для сайта https://english-e-reader.net/.
Приложение загружает книги по сети с помощью парсинга HTML.
Книги разделяются по категориям. 
Также могут быть пролистаны и догружены по категориям.
Приложение подразумевает:
 - режим скачивания книги на iPhone пользователя
 - режим чтения книги с запоминанием текущей страницы
 - возможность поделиться книгой через соцсети


**В проекте используются:**

* URLSessions
* GCD
* SPM
* SwiftSoup
* UITableViewController
* UICollectionViewController

### Техническое задание к проекту:

Сделать приложение по сайту https://english-e-reader.net/.
Задача загрузки озвучки книги пока не стоит.
Предусмотреть режим чтения книги, добавления в избранное и 
возможность поделиться ссылкой на книгу через соцсети.


![screenshot of sample](https://i.ibb.co/vXJbgDp/2025-01-23-11-38-11.png)

## Documentation

### Model:

      Book - основная модель данных

### Managers:

      FavoritesManager - отвечает за добавление/удаление/изменение и загрузку избранных книг пользователя
      BookLoader - отвечает за загрузку книг с сайта и парсинг этих данных
      ImageCache - отвечает за кэщ обложек книг

### Cells:

      TableViewCell - отвечает за отображение секции каталога
      CollectionViewCell - содержит все аттрибуты книги 
  
## Developers

- [Irina Muravyova](https://github.com/IrinaMuravyova)

## License
Project eReader is distributed under the MIT license.
