ALTER TABLE Book.Book_Author ADD CONSTRAINT FK_Author FOREIGN KEY (Author_ID) REFERENCES Book.Author (Author_ID)
ON UPDATE NO ACTION -- update i�lemlerinde herhangi bir de�i�iklik yapma
ON DELETE NO ACTION -- delete i�lemlerinde ayn� de�i�ikli�i uygula

ALTER TABLE Book.Book_Author ADD CONSTRAINT FK_Author FOREIGN KEY (Author_ID) REFERENCES Book.Author (Author_ID)
ON UPDATE NO ACTION -- update i�lemlerinde herhangi bir de�i�iklik yapma
ON DELETE NO ACTION -- delete i�lemlerinde ayn� de�i�ikli�i uygula


ALTER TABLE Book.Book_Author ADD CONSTRAINT FK_Book2 FOREIGN KEY (Book_ID) REFERENCES Book.Book (Book_ID)
ON UPDATE NO ACTION
ON DELETE CASCADE
