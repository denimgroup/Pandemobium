CREATE TABLE IF NOT EXISTS users (
	userID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	firstName CHAR(20) NOT NULL,
	lastName CHAR(20) NOT NULL,
	email VARCHAR(30),
	phone VARCHAR(12),
	userName VARCHAR(20) NOT NULL,
	password VARCHAR(20) NOT NULL
) ENGINE=INNODB;

INSERT INTO users (firstName, lastName, email, phone, userName, password) 
	VALUES ('first', 'last', NULL, NULL, 'user', 'password');


CREATE TABLE IF NOT EXISTS account (
	accountID INT NOT NULL AUTO_INCREMENT,
	userID INT NOT NULL,
	totalShares INT NOT NULL, 
	balance FLOAT NOT NULL,
	INDEX accID (accountID),
	FOREIGN KEY (userID) REFERENCES users(userID)
	ON DELETE CASCADE
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS tips (
	tipID INT NOT NULL AUTO_INCREMENT,
	userID INT NOT NULL,
	symbol CHAR(10),
	reason VARCHAR(100),
	INDEX tipIdx (tipID),
	FOREIGN KEY (userID) REFERENCES users(userID)
	ON DELETE CASCADE
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS stock (
	stockID INT NOT NULL AUTO_INCREMENT,
	accountID INT NOT NULL,
	symbol VARCHAR(10) NOT NULL,
	shares int NOT NULL,
	INDEX stockIdx (stockID),
	FOREIGN KEY(accountID) REFERENCES account(accountID)
	ON DELETE CASCADE
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS history (
	historyID INT NOT NULL AUTO_INCREMENT,
	userID INT NOT NULL,
	log VARCHAR(100) NOT NULL,
	time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	INDEX historyIdx (historyID),
	FOREIGN KEY(userID) REFERENCES users(userID)
	ON DELETE CASCADE
) ENGINE=INNODB;

INSERT INTO users (firstName, lastName, email, phone, userName, password)
        VALUES ('first', 'last', NULL, NULL, 'user', 'password');

SELECT @last := LAST_INSERT_ID();

INSERT INTO account (userID, totalShares, balance) VALUES (@last, 0, 0);



