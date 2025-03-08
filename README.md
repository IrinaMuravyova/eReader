<p align="center">
      <img src="https://i.ibb.co/qmqv7ZY/2024-04-13-17-42-50.png" width="200">
</p>

<p align="center">
   <img src="https://img.shields.io/badge/Engine-XCode v15.3-blueviolet">
   <img src="https://img.shields.io/badge/Version-v1.0-blue">
   <img src="https://img.shields.io/badge/License-MIT-green">
</p>

## About

Website reader application https://english-e-reader.net .
The application downloads books over the web using HTML parsing.
Books are divided into categories. 
They can also be scrolled through and loaded by category.
The application implies:

 - book download mode on the user's iPhone
 - book reading mode with memorization of the current page
 - the ability to share a book via social media


**The project uses:**

* URLSessions
* GCD
* SPM
* SwiftSoup
* UITableViewController
* UICollectionViewController

### Terms of reference for the project:

Create an application on the site https://english-e-reader.net.
The task of downloading the book's voiceover is not worth it yet.
Provide a mode for reading a book, adding to favorites, and
the ability to share a link to the book via social media.


![screenshot of sample](https://i.ibb.co/vXJbgDp/2025-01-23-11-38-11.png)

## Documentation

### Model:

      Book - the basic data model

### Managers:

      Favorites Manager - responsible for adding/deleting/modifying and uploading the user's favorite books
      Bootloader is responsible for downloading books from the website and parsing this data.
      ImageCache - responsible for the cache of book covers

### Cells:

      TableViewCell - responsible for displaying the catalog section
      Collection View Cell - contains all the attributes of the book
  
## Developers

- [Irina Muravyova](https://github.com/IrinaMuravyova)

## License
Project eReader is distributed under the MIT license.
