CREATE TABLE Student (
    studentID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	fName CHAR(20),
    lName CHAR(20),
    email VARCHAR(50),
    year INT
);

INSERT INTO Student VALUES('Megumi','Fushiguro','fushigurom@gmail.com',1),
('Nobara','Kugisaki','kugisakin@gmail.com',1),
('Yuji','Itadori','itadoriy@gmail.com',1),
('Maki','Zenin','zeninm@gmail.com',2),
('Toge','Inumaki','inumakit@gmail.com',2),
('Yuta','Okkotsu','okkotsuy@gmail.com',4),
('Aoi','Todo','todoa@gmail.com',3),
('Riko','Amanai','amanair@gmail.com',1),
('Kinji','Hakari','hakarik@gmail.com',3),
('Kirara','Hoshi','hoshik@gmail.com',3),
('Momo','Nishimiya','nishimiyam@gmail.com',4),
('Akari','Nitta','nittaa@gmail.com',4),
('Kiyotaka','Ijichi','ijichik@gmail.com',2),
('Masamichi', 'Yaga', 'masamichiy@outlook.com', 3),
('Yu', 'Haibara', 'yuh@outlook.com', 2),
('Arata', 'Nitta', 'aratan@outlook.com', 1),
('Mai', 'Zenin', 'maiz@outlook.com', 2),
('Kokichi', 'Muta', 'kokichim@outlook.com', 2),
('Kasumi', 'Miwa', 'kasumim@outlook.com', 2),
('Noritoshi', 'Kamo', 'noritoshik@outlook.com', 3),
('Takuma', 'Ino', 'takumai@outlook.com', 4),
('Yuki', 'Tsukumo', 'yukit@outlook.com', 4),
('Hana', 'Kurusu', 'hanak@outlook.com', 4),
('Hiromi', 'Higuruma', 'hiromih@outlook.com', 4),
('Rin', 'Amai', 'rina@outlook.com', 4),
('Chizuru', 'Hari', 'chizuruh@outlook.com', 2);

SELECT * FROM Student;

CREATE TABLE Organizer (
    organizerID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    fName CHAR(20),
    lName CHAR(20),
    orgEmail VARCHAR(30)
);

INSERT INTO Organizer
VALUES ('Satoru','Gojo','gojos@gmail.com'),
('Kento','Nanami','nanamik@gmail.com'),
('Suguru','Geto','getos@gmail.com'),
('Shoko','Ieiri','ieiris@gmail.com'),
('Toji','Fushiguro','fushigurot@gmail.com');

SELECT * FROM Organizer;

CREATE TABLE Event (
    eventID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    organizerID INT NOT NULL FOREIGN KEY REFERENCES Organizer(organizerID),
    title VARCHAR(30) UNIQUE,
    eventDate DATE DEFAULT GETDATE(),
    location VARCHAR(25),
    capacity INT
);

INSERT INTO Event (organizerID, title, eventDate, location, capacity)
VALUES(1, 'Cooking Workshop', '2025-11-05', 'Cafeteria', 15),
(2, 'Financial Literacy Workshop', '2025-10-27', 'Room D-210', 10),
(3, 'Music Showcase', '2025-12-11', 'Auditorium', 12),
(4, 'Writing Workshop', '2025-11-20', 'Library', 20),
(5, 'Coding Workshop', '2025-10-31', 'Room D-242', 8);

SELECT * FROM Event;

CREATE TABLE Registration (
    registrationID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    studentID INT NOT NULL FOREIGN KEY REFERENCES Student(studentID),
    eventID INT NOT NULL FOREIGN KEY REFERENCES Event(eventID), 
    status VARCHAR (10),
    time TIME(2),
);

--ENFORCING EVENT CAPACITY
GO
CREATE TRIGGER eventCap
ON Registration
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Event e ON i.eventID = E.eventID
        GROUP BY i.eventID, e.capacity
        HAVING COUNT(*) + 
            (SELECT COUNT(*) FROM Registration r
            WHERE r.eventID = i.eventID) > e.capacity
    )
BEGIN
    RAISERROR('Registration failed. Over capacity' 16, 1);
RETURN;
END

INSERT INTO Registration(studentID, eventID, status, time)
SELECT studentID, eventID, status, time FROM inserted;
END;

INSERT INTO Registration(studentID, eventID, status, time)
VALUES(1, 2, 'Complete', CURRENT_TIMESTAMP),
VALUES(5, 2, 'Complete', CURRENT_TIMESTAMP),
VALUES(8, 2, 'Pending', CURRENT_TIMESTAMP),
VALUES(9, 2, 'Complete', CURRENT_TIMESTAMP),
VALUES(10, 2, 'Pending', CURRENT_TIMESTAMP),
VALUES(13, 2, 'Complete', CURRENT_TIMESTAMP),

VALUES(2, 1, 'Pending', CURRENT_TIMESTAMP),
VALUES(3, 1, 'Complete', CURRENT_TIMESTAMP),
VALUES(4, 1, 'Complete', CURRENT_TIMESTAMP),
VALUES(6, 1, 'Pending', CURRENT_TIMESTAMP),
VALUES(7, 1, 'Pending', CURRENT_TIMESTAMP),
VALUES(11, 1, 'Complete', CURRENT_TIMESTAMP),
VALUES(12, 1, 'Complete', CURRENT_TIMESTAMP),
VALUES(13, 1, 'Complete', CURRENT_TIMESTAMP),
VALUES(16, 1, 'Pending', CURRENT_TIMESTAMP),
VALUES(18, 1, 'Complete', CURRENT_TIMESTAMP),
--at capacity

VALUES(14, 3, 'Complete', CURRENT_TIMESTAMP),
VALUES(15, 3, 'Complete', CURRENT_TIMESTAMP),
VALUES(17, 3, 'Pending', CURRENT_TIMESTAMP),
VALUES(18, 3, 'Complete', CURRENT_TIMESTAMP),
VALUES(19, 3, 'Complete', CURRENT_TIMESTAMP),
VALUES(3, 3, 'Pending', CURRENT_TIMESTAMP),
VALUES(5, 3, 'Pending', CURRENT_TIMESTAMP),
VALUES(20, 3, 'Complete', CURRENT_TIMESTAMP),
VALUES(7, 3, 'Complete', CURRENT_TIMESTAMP),
VALUES(4, 3, 'Complete', CURRENT_TIMESTAMP),

VALUES(19, 4, 'Complete', CURRENT_TIMESTAMP),
VALUES(21, 4, 'Complete', CURRENT_TIMESTAMP),
VALUES(22, 4, 'Complete', CURRENT_TIMESTAMP),
VALUES(23, 4, 'Pending', CURRENT_TIMESTAMP),
VALUES(24, 4, 'Pending', CURRENT_TIMESTAMP),
VALUES(25, 4, 'Pending', CURRENT_TIMESTAMP),
VALUES(1, 4, 'Complete', CURRENT_TIMESTAMP),
VALUES(5, 4, 'Complete', CURRENT_TIMESTAMP),
VALUES(6, 4, 'Complete', CURRENT_TIMESTAMP),
VALUES(10, 4, 'Complete', CURRENT_TIMESTAMP),
VALUES(17, 4, 'Complete', CURRENT_TIMESTAMP),
VALUES(20, 4, 'Complete', CURRENT_TIMESTAMP),
