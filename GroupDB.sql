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

--Trigger for ensuring future events
GO
CREATE TRIGGER Future
ON Event
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted 
        WHERE eventDate <= GETDATE()
    )
    BEGIN
        RAISERROR ('Event must be in the future.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

INSERT INTO Event (organizerID, title, eventDate, location, capacity)
VALUES(1, 'Cooking Workshop', '2025-11-05', 'Cafeteria', 15),
(2, 'Financial Literacy Workshop', '2025-12-27', 'Room D-210', 10),
(3, 'Music Showcase', '2025-12-11', 'Auditorium', 12),
(4, 'Writing Workshop', '2025-11-20', 'Library', 20),
(5, 'Coding Workshop', '2025-11-31', 'Room D-242', 8);

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
CREATE TRIGGER eventCapacity
ON Registration
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Event e ON i.eventID = e.eventID
        GROUP BY i.eventID, e.capacity
        HAVING 
            (SELECT COUNT(*) FROM Registration r WHERE r.eventID = i.eventID)
            + COUNT(i.studentID) > e.capacity
    )
    BEGIN
        RAISERROR('Registration failed. Over capacity', 16, 1);
        RETURN;
    END;

    
    INSERT INTO Registration (studentID, eventID, status, time)
    SELECT studentID, eventID, status, time
    FROM inserted;
END;
GO

--constraint for unique registration, prevents duplicates
ALTER TABLE Registration
ADD CONSTRAINT UQ_StudentEvent UNIQUE(studentID, eventID);

--constraint so only two options can be used in status
ALTER TABLE Registration
ADD CONSTRAINT RegistrationStatus
CHECK (status IN ('Complete', 'Pending'));

INSERT INTO Registration(studentID, eventID, status, time)
VALUES(1, 2, 'Complete', CURRENT_TIMESTAMP),
(5, 2, 'Complete', CURRENT_TIMESTAMP),
(8, 2, 'Pending', CURRENT_TIMESTAMP),
(9, 2, 'Complete', CURRENT_TIMESTAMP),
(10, 2, 'Pending', CURRENT_TIMESTAMP),
(13, 2, 'Complete', CURRENT_TIMESTAMP),
(22, 2, 'Complete', CURRENT_TIMESTAMP),
(25, 2, 'Complete', CURRENT_TIMESTAMP),
(20, 2, 'Pending', CURRENT_TIMESTAMP),
(15, 2, 'Complete', CURRENT_TIMESTAMP),
--at capacity

(2, 1, 'Pending', CURRENT_TIMESTAMP),
(3, 1, 'Complete', CURRENT_TIMESTAMP),
(4, 1, 'Complete', CURRENT_TIMESTAMP),
(6, 1, 'Pending', CURRENT_TIMESTAMP),
(7, 1, 'Pending', CURRENT_TIMESTAMP),
(11, 1, 'Complete', CURRENT_TIMESTAMP),
(12, 1, 'Complete', CURRENT_TIMESTAMP),
(13, 1, 'Complete', CURRENT_TIMESTAMP),
(16, 1, 'Pending', CURRENT_TIMESTAMP),
(18, 1, 'Complete', CURRENT_TIMESTAMP),

(14, 3, 'Complete', CURRENT_TIMESTAMP),
(15, 3, 'Complete', CURRENT_TIMESTAMP),
(17, 3, 'Pending', CURRENT_TIMESTAMP),
(18, 3, 'Complete', CURRENT_TIMESTAMP),
(19, 3, 'Complete', CURRENT_TIMESTAMP),
(3, 3, 'Pending', CURRENT_TIMESTAMP),
(5, 3, 'Pending', CURRENT_TIMESTAMP),
(20, 3, 'Complete', CURRENT_TIMESTAMP),
(7, 3, 'Complete', CURRENT_TIMESTAMP),
(4, 3, 'Complete', CURRENT_TIMESTAMP),

(19, 4, 'Complete', CURRENT_TIMESTAMP),
(21, 4, 'Complete', CURRENT_TIMESTAMP),
(22, 4, 'Complete', CURRENT_TIMESTAMP),
(23, 4, 'Pending', CURRENT_TIMESTAMP),
(24, 4, 'Pending', CURRENT_TIMESTAMP),
(25, 4, 'Pending', CURRENT_TIMESTAMP),
(1, 4, 'Complete', CURRENT_TIMESTAMP),
(5, 4, 'Complete', CURRENT_TIMESTAMP),
(6, 4, 'Complete', CURRENT_TIMESTAMP),
(10, 4, 'Complete', CURRENT_TIMESTAMP),
(17, 4, 'Complete', CURRENT_TIMESTAMP),
(20, 4, 'Complete', CURRENT_TIMESTAMP),
(26, 4, 'Complete', CURRENT_TIMESTAMP),

(1, 5, 'Complete', CURRENT_TIMESTAMP),
(11, 5, 'Complete', CURRENT_TIMESTAMP),
(14, 5, 'Complete', CURRENT_TIMESTAMP),
(8, 5, 'Complete', CURRENT_TIMESTAMP),
(2, 5, 'Complete', CURRENT_TIMESTAMP),
(16, 5, 'Complete', CURRENT_TIMESTAMP),
(23, 5, 'Complete', CURRENT_TIMESTAMP),
(26, 5, 'Complete', CURRENT_TIMESTAMP);
--at capacity


SELECT * FROM Registration
ORDER BY eventID;
