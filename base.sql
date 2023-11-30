CREATE DATABASE testdb;

DROP DATABASE testdb;

SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'testdb'
	AND pid <> pg_backend_pid()

--Отношение один ко многим
CREATE TABLE publisher
(
	publisher_id integer PRIMARY KEY,
	org_name varchar(128) NOT NULL,
	address text NOT NULL
);

CREATE TABLE book
(
	book_id integer PRIMARY KEY,
	title text NOT NULL,
	isbn varchar(32) NOT NULL
);

INSERT INTO book
VALUES
(1, 'The Diary of a Young Girl', '0199535566'),
(2, 'Pride and Prejudice', '9780307594006'),
(3, 'To Kill a Mockingbird', '0446310786'),
(4, 'The Book of Gutsy Women: Favorite Stories of Courage and Resilience', '1501178415'),
(5, 'War and Peace', '1788886526');

INSERT INTO publisher
VALUES
(1, 'Everyman''s Library', 'NY'),
(2, 'Oxford University Press', 'NY'),
(3, 'Grand Central Publishing', 'Washington'),
(4, 'Simon & Schuster', 'Chicago');

SELECT * FROM publisher;

----
ALTER TABLE book
ADD COLUMN fk_publisher_id;

ALTER TABLE book
ADD CONSTRAINT fk_book_publisher
FOREIGN KEY(fk_publisher_id) REFERENCES publisher(publisher_id);
----
DROP TABLE book;

CREATE TABLE book
(
	book_id integer PRIMARY KEY,
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	fk_publisher_id integer REFERENCES publisher(publisher_id) NOT NULL
);

INSERT INTO book
VALUES
(1, 'The Diary of a Young Girl', '0199535566', 1),
(2, 'Pride and Prejudice', '9780307594006', 1),
(3, 'To Kill a Mockingbird', '0446310786', 2),
(4, 'The Book of Gutsy Women: Favorite Stories of Courage and Resilience', '1501178415', 2),
(5, 'War and Peace', '1788886526', 2);

--Отношение один к одному
CREATE TABLE person
(
	person_id int PRIMARY KEY,
	first_name varchar(64) NOT NULL,
	last_name varchar(64) NOT NULL
);

CREATE TABLE passport
(
	passport_id int PRIMARY KEY,
	serial_number int NOT NULL,
	fk_passport_person int UNIQUE REFERENCES person(person_id)
);

INSERT INTO person VALUES (1, 'John', 'Snow');
INSERT INTO person VALUES (2, 'Ned', 'Stark');
INSERT INTO person VALUES (3, 'Rob', 'Baratheon');

ALTER TABLE passport
ADD COLUMN registration text NOT NULL;

INSERT INTO passport VALUES (1, 123456, 1, 'Winterfell');
INSERT INTO passport VALUES (2, 789012, 2, 'Winterfell');
INSERT INTO passport VALUES (3, 345678, 3, 'King''s Landing');

--Отношение многие ко многим
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS author;

CREATE TABLE book
(
	id int PRIMARY KEY,
	title text NOT NULL,
	isbn text NOT NULL
);

CREATE TABLE author
(
	id int PRIMARY KEY,
	name text NOT NULL,
	rating real
);

CREATE TABLE book_author
(
	book_id int REFERENCES book(id),
	author_id int REFERENCES author(id),
	
  CONSTRAINT book_author_pkey PRIMARY KEY (book_id, author_id) --composite key ключ состоит более чем из 1 колонки
);

INSERT INTO book
VALUES
(1, 'The Diary of a Young Girl', '6'),
(2, 'Pride and Prejudice', '6'),
(3, 'To Kill a Mockingbird', '86'),
(4, 'The Book of Gutsy Women: Favorite Stories of Courage and Resilience', '15'),
(5, 'War and Peace', '178');

INSERT INTO author
VALUES
(1, 'Alice', 4.92),
(2, 'Vincent', 4.98),
(3, 'Sara', 4.63);

INSERT INTO book_author
VALUES
(1, 1),
(2, 1),
(3, 1),
(3, 2),
(3, 3),
(4, 2),
(4, 3),
(5, 1);

SELECT * FROM book;
SELECT * FROM author;
SELECT * FROM book_author;