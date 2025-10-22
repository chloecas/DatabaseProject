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
('Kiyotaka','Ijichi','ijichik@gmail.com',2);

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
    title VARCHAR(30),
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
    status VARCHAR (10) UNIQUE,
    time VARCHAR(10),
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
end;

INSERT INTO Registration(studentID, eventID, status, time)
VALUES()