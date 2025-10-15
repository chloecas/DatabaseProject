DB Project Tables

CREATE TABLE Student (
    studentID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    name CHAR(20),
    email VARCHAR(50),
    year INT(4)
);

INSERT INTO Student (name, email, year) 
VALUES('Chloe', 'chloec@outlook.com', 2024),
('Connor', 'conw@hotmail.com', 2020),
('Jane', 'jsmith@gmail.com', 2022),
('Nancy', 'nande@outlook.com', 2019);

CREATE TABLE Organizer (
    organizerID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(20),
    contactInfo VARCHAR(30)
);
CREATE TABLE Event (
    eventID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    organizerID INT NOT NULL FOREIGN KEY REFERENCES Organizer(organizerID),
    title VARCHAR(30),
    eventDate DATE,
    location VARCHAR(25),
    capacity INT
);

CREATE TABLE Registration (
    registrationID INT UNIQUE NOT NULL IDENTITY(1,1) PRIMARY KEY,
    studentID INT NOT NULL FOREIGN KEY REFERENCES Student(studentID),
    eventID INT NOT NULL FOREIGN KEY REFERENCES Event(eventID), 
    status BOOLEAN,
    time TIMESTAMP,
);

