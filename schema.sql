-- Buat database
CREATE DATABASE paintings_db;
USE paintings_db;

-- Buat tabel artist
CREATE TABLE artist (
    artist_id INT PRIMARY KEY,
    full_name VARCHAR(255),
    first_name VARCHAR(100),
    middle_names VARCHAR(150),
    last_name VARCHAR(100),
    nationality VARCHAR(100),
    style VARCHAR(100),
    birth INT(4),
    death INT(4)
);

-- Import artist.csv ke tabel artist
LOAD DATA INFILE 'C:/xampp/mysql/data/dataset/artist.csv'
INTO TABLE artist
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(artist_id, full_name, first_name, middle_names, last_name, nationality, style, birth, death);

-- Buat tabel museum
CREATE TABLE museum (
    museum_id INT PRIMARY KEY,
    name VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    postal VARCHAR(20),
    country VARCHAR(100),
    phone VARCHAR(50),
    url VARCHAR(255)
);

-- Import museum.csv ke tabel museum
LOAD DATA INFILE 'C:/xampp/mysql/data/dataset/museum.csv'
INTO TABLE museum
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(museum_id, name, address, city, state, postal, country, phone, url);

-- Buat tabel museum_hours
CREATE TABLE museum_hours (
    museum_id INT,
    day VARCHAR(20),
    open TIME,
    close TIME,
    PRIMARY KEY (museum_id, day),
    FOREIGN KEY (museum_id) REFERENCES museum(museum_id)
);

-- Import museum_hours.csv ke tabel museum_hours
LOAD DATA INFILE 'C:/xampp/mysql/data/dataset/museum_hours.csv'
INTO TABLE museum_hours
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(museum_id, day, open, close);

-- Buat tabel work
CREATE TABLE work (
    work_id INT PRIMARY KEY,
    name VARCHAR(255),
    artist_id INT DEFAULT NULL,
    style VARCHAR(100),
    museum_id INT DEFAULT NULL,
    FOREIGN KEY (artist_id) REFERENCES artist(artist_id),
    FOREIGN KEY (museum_id) REFERENCES museum(museum_id)
);

SET FOREIGN_KEY_CHECKS = 0;

-- Import work.csv ke tabel work
LOAD DATA INFILE 'C:/xampp/mysql/data/dataset/work.csv'
INTO TABLE work
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(work_id, name, artist_id, style, museum_id);

SET FOREIGN_KEY_CHECKS = 1;

-- Buat tabel subject
CREATE TABLE subject (
    work_id INT,
    subject VARCHAR(100),
    PRIMARY KEY (work_id, subject),
    FOREIGN KEY (work_id) REFERENCES work(work_id)
);

-- Import subject.csv ke tabel subject
LOAD DATA INFILE 'C:/xampp/mysql/data/dataset/subject.csv'
INTO TABLE subject
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(work_id, subject);

-- Buat tabel canvas_size
CREATE TABLE canvas_size (
    size_id INT PRIMARY KEY,
    width INT,
    height FLOAT,
    label VARCHAR(100)
);

-- Import canvas_size.csv ke tabel canvas_size
LOAD DATA INFILE 'C:/xampp/mysql/data/dataset/canvas_size.csv'
INTO TABLE canvas_size
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(size_id, width, height, label);

-- Buat tabel product_size
CREATE TABLE product_size (
    work_id INT,
    size_id INT,
    sale_price DECIMAL(10,2),
    regular_price DECIMAL(10,2),
    PRIMARY KEY (work_id, size_id),
    FOREIGN KEY (work_id) REFERENCES work(work_id),
    FOREIGN KEY (size_id) REFERENCES canvas_size(size_id)
);

-- Import product_size.csv ke tabel product_size
LOAD DATA INFILE 'C:/xampp/mysql/data/dataset/product_size.csv'
INTO TABLE product_size
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(work_id, size_id, sale_price, regular_price);

-- Buat tabel image_link
CREATE TABLE image_link (
    work_id INT,
    url VARCHAR(500),
    thumbnail_small_url VARCHAR(500),
    thumbnail_large_url VARCHAR(500),
    PRIMARY KEY (work_id, url),
    FOREIGN KEY (work_id) REFERENCES work(work_id)
);

-- Import image_link.csv ke tabel amage_link
LOAD DATA INFILE 'C:/xampp/mysql/data/dataset/image_link.csv'
INTO TABLE image_link
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(work_id, url, thumbnail_small_url, thumbnail_large_url);
