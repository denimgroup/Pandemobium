CREATE TABLE IF NOT EXISTS users (
	userID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	firstName CHAR(20) NOT NULL,
	lastName CHAR(20) NOT NULL,
	email VARCHAR(30),
	phone VARCHAR(12),
	userName VARCHAR(20) NOT NULL,
	password VARCHAR(20) NOT NULL);

INSERT INTO users (firstName, lastName, email, phone, userName, password) 
	VALUES ('first', 'last', NULL, NULL, 'user', 'password');

