CREATE TABLE Book (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    author VARCHAR(100) NOT NULL,
    publication_house VARCHAR(100),
    category VARCHAR(50),
    book_count INT,
    status ENUM('IN STOCK', 'OUT_OF_STOCK')
);

$$

INSERT INTO Book (title, price, author, publication_house, category, book_count, status) VALUES
('The War Code', 399.99, 'James Hunt', 'Mcgraw Hill', 'WAR', 12, 'IN STOCK'),
('Fiction Fever', 299.50, 'Samantha Ray', 'DreamFolks', 'FICTION', 5, 'IN STOCK'),
('Laugh Out Loud', 199.99, 'Tom Hardy', 'Warner Bros', 'COMEDY', 8, 'OUT_OF_STOCK'),
('Champions of Sport', 349.00, 'Alex Morgan', 'Mcgraw Hill', 'SPORTS', 10, 'IN STOCK'),
('Dream Fiction', 420.75, 'Nina Fox', 'DreamFolks', 'FICTION', 7, 'OUT_OF_STOCK');
$$

DELIMITER $$
Create Procedure fetch_in_stock_values(IN value int)
BEGIN
	Select * from Book WHERE status = 'IN STOCK' AND price <= value;
END
$$

CALL fetch_in_stock_values(400);

DELIMITER $$

Create Procedure delete_specific_publications(IN publicationHouse varchar(255))
BEGIN 
	Declare i int default 0;
    Declare total_rows int default 0;
    Declare ids int;
    
	Select Count(id) into total_rows from Book WHERE publication_house = publicationHouse;
    
    WHILE i<=total_rows DO
		Select id into ids from Book WHERE publication_house = publicationHouse LIMIT i,1;
        DELETE From Book Where id = ids;
        SET i = i+1;
	END WHILE;
END;
$$

CALL delete_specific_publications('Mcgraw Hill');

Select * from Book;
$$

Create Procedure update_price(IN categ varchar(255), IN percent double)
BEGIN 
	Declare i int default 0;
    Declare total_rows int default 0;
    Declare ids int;
    
    Select count(id) into total_rows from Book WHERE category = categ;
    
	WHILE i<=total_rows DO
		Select id into ids from Book WHERE category = categ LIMIT i,1;
        UPDATE Book SET price = price + (price * (percent / 100)) WHERE id = ids;
        SET i = i+1;
	END WHILE;
END;

$$

CALL update_price('FICTION', 5);
$$