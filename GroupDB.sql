CREATE TABLE Student (
    studentID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    name CHAR(20),
    email VARCHAR(50),
    year INT
);

CREATE TABLE Organizer (
    organizerID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(20),
    orgEmail VARCHAR(30)
);

INSERT INTO Organizer (name, orgEmail)
VALUES ('Omar', 'omulligan@outlook.com'),
('Brenda', 'brenbren@hotmail.com'),
('Synthia', 'scharles@gmail.com'),
('Taylor', 'taylorj@outlook.com'),
('Xavier', 'xprunier@gmail.com');

SELECT * FROM Organizer;


CREATE TABLE Event (
    eventID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    organizerID INT NOT NULL FOREIGN KEY REFERENCES Organizer(organizerID),
    title VARCHAR(30),
    eventDate DATE DEFAULT GETDATE(),
    location VARCHAR(25),
    capacity INT CHECK (capacity <= 350)
);

INSERT INTO Event (organizerID, title, eventDate, location, capacity)
VALUES(1, 'Cooking Workshop', '2025-11-05', 'Cafeteria', 300),
(2, 'Financial Literacy Workshop', '2025-10-27', 'Room D-210', 150),
(3, 'Music Showcase', '2025-12-11', 'Auditorium', 350),
(4, 'Writing Workshop', '2025-11-20', 'Library', 100),
(5, 'Coding Workshop', '2025-10-31', 'Room D-242', 125);

SELECT * FROM Event;

CREATE TABLE Registration (
    registrationID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    studentID INT NOT NULL FOREIGN KEY REFERENCES Student(studentID),
    eventID INT NOT NULL FOREIGN KEY REFERENCES Event(eventID), 
    status VARCHAR (10) UNIQUE,
    time TIMESTAMP,
);

