-- 1 - Create the hospital Database 
CREATE DATABASE SwintonHospitalDatabase;

-- 1.1 - Use the database
USE SwintonHospitalDatabase; 

-- 1.2 - Create the Patients table 
CREATE TABLE Patients(
	PatientID INT PRIMARY KEY IDENTITY(301,1),
	PatientName NVARCHAR(100) NOT NULL, 
	Address NVARCHAR(255) NOT NULL,
	DateOfBirth DATE NOT NULL,
	Gender NVARCHAR(10), 
	Insurance NVARCHAR(100) NOT NULL,
	PatientEmail NVARCHAR(255) NOT NULL, 
	Telephone NVARCHAR(20) NOT NULL, 
	Username NVARCHAR(50) NOT NULL, 
	PasswordHash BINARY(64) NOT NULL,	
	Salt UNIQUEIDENTIFIER, 
	CONSTRAINT Unique_Email UNIQUE (PatientEmail)
);

-- 1.2.1 - Patients table Data 
INSERT INTO Patients (PatientName, Address, DateOfBirth, Gender, Insurance, PatientEmail, Telephone, Username, PasswordHash, Salt)
VALUES
    ('John Smith', '123 Main St, MCR', '1980-03-15', 'AVF41', 'Male','j.smith@gmail.com', '074-9559-5119', 'johnsmith', HASHBYTES('SHA2_256', 'password1'), NEWID()),
    ('Alice Johnson', '456 Park Ave, MCR', '1985-06-22', 'BGY32', 'Female', 'a.johnson@gmail.com', '078-9595-5119', 'alicejohnson', HASHBYTES('SHA2_256', 'password2'), NEWID()),
    ('David Wilson', '789 High St, MCR', '1970-09-10', 'ICE03', 'Male', 'd.wilson@gmail.com', '075-5959-1919', 'davidwilson', HASHBYTES('SHA2_256', 'password3'), NEWID()),
    ('Emily Taylor', '101 Elm Rd, MCR', '1965-12-28', 'AVF04', 'Female', 'e.taylor@gmail.com', '077-8573-5119', 'emilytaylor', HASHBYTES('SHA2_256', 'password4'), NEWID()),
    ('Mark Evans', '202 Oak Ln, MCR', '1975-04-03', 'AVF01', 'Male', 'm.evans@gmail.com', '077-2220-3312', 'markevans', HASHBYTES('SHA2_256', 'password5'), NEWID()),
    ('John Smith', '303 Maple Ave, MCR', '1980-03-15', 'BGY96', 'Male', 'j.smith2@gmail.com', '057-9595-5119', 'johnsmith2', HASHBYTES('SHA2_256', 'password6'), NEWID()),
    ('Michael Brown', '404 Birch St, MCR', '1990-09-10', 'BGY23', 'Male', 'm.brown@gmail.com', '078-9595-5119', 'michaelbrown', HASHBYTES('SHA2_256', 'password7'), NEWID()),
    ('Olivia Wilson', '505 Pine Crescent, MCR', '1970-09-10', 'ICE08', 'Female', 'o.wilson@gmail.com', '072-9305-5309', 'oliviawilson', HASHBYTES('SHA2_256', 'password8'), NEWID()),
    ('Sophia Johnson', '606 Cedar Court, MCR', '1980-03-15', 'IAVF09', 'Female', 's.johnson@gmail.com', '076-9595-5119', 'sophiajohnson', HASHBYTES('SHA2_256', 'password9'), NEWID()),
    ('William Harris', '707 Spruce Ave, MCR', '1980-03-15', 'ICE10', 'Male','w.harris@gmail.com', '074-9145-6118', 'williamharris', HASHBYTES('SHA2_256', 'password10'), NEWID());

-- 1.2.2 - Let's view the Patients data
SELECT *
FROM Patients

-- 1.2.3 - Function to calculate the ages of the patients 
CREATE FUNCTION CalculateAge (@DateOfBirth DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;
    SET @Age = DATEDIFF(YEAR, @DateOfBirth, GETDATE());
    RETURN @Age;
END;

-- 1.2.4 - Get one of the patient's age
SELECT dbo.CalculateAge('1990-05-15') AS Age;

-- 1.2.5 - Let's create a view 
CREATE VIEW PatientAgeView AS
SELECT PatientID, PatientName, DateOfBirth, DATEDIFF(YEAR, DateOfBirth, GETDATE()) AS Age
FROM Patients;

-- 1.2.6 - Query the view to get the ages of the patients
SELECT * FROM PatientAgeView;

-- 1.2.7 - Procedure for patient registration
CREATE PROCEDURE RegisterNewPatient
    @PatientName NVARCHAR(100),
    @Address NVARCHAR(255),
    @DateOfBirth DATE,
    @Gender NVARCHAR(10),
    @Insurance NVARCHAR(100),
    @PatientEmail NVARCHAR(255),
    @Telephone NVARCHAR(20),
    @Username NVARCHAR(50),
    @Password NVARCHAR(50)  
AS
BEGIN
    SET NOCOUNT ON;

    -- Generate a unique salt for password hashing
    DECLARE @Salt UNIQUEIDENTIFIER = NEWID();

    -- Hash the password using SHA-256 algorithm with the salt
    DECLARE @PasswordHash BINARY(64);
    SET @PasswordHash = HASHBYTES('SHA2_256', @Password + CAST(@Salt AS NVARCHAR(36)));

    -- Insert the new patient record into the Patients table
    INSERT INTO Patients (PatientName, Address, DateOfBirth, Gender, Insurance, PatientEmail, Telephone, Username, PasswordHash, Salt)
    VALUES (@PatientName, @Address, @DateOfBirth, @Gender, @Insurance, @PatientEmail, @Telephone, @Username, @PasswordHash, @Salt);
END;

-- 1.2.8 - Let's register a new PatienT
EXEC RegisterNewPatient 
    @PatientName = 'John Doe',
    @Address = '123 Main Street',
    @DateOfBirth = '1990-05-15',
	@Gender = 'Male', 
    @Insurance = 'VFS38',
    @PatientEmail = 'john.doe@gmail.com',
    @Telephone = '07695855118',
    @Username = 'johndoe',
    @Password = 'password123';

-- 1.2.09 - Let's view the updated Patient's table 
SELECT *
FROM Patients

-- 1.2.10 - Let's delete the additional patient to carry out the coursework
CREATE PROCEDURE DeletePatientByName 
    @PatientName NVARCHAR(100)
AS
BEGIN
    DELETE FROM Patients WHERE PatientName = @PatientName;
END;

EXEC DeletePatientByName @PatientName = 'John Doe';

-- 1.2.11 - Let's view the deleted Patient's table update 
SELECT *
FROM Patients

-- 1.3 - Create the Doctors table
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY IDENTITY(201,1),
    DepartmentID INT NOT NULL, 
    DoctorName NVARCHAR(100) NOT NULL, 
    Speciality NVARCHAR(100) NOT NULL, 
    DepartmentName NVARCHAR(100) NOT NULL, 
    DrEmail NVARCHAR(255) NOT NULL, 
    Telephone NVARCHAR(20) NOT NULL,
    Username NVARCHAR(50) NOT NULL,
	PasswordHash BINARY(64) NOT NULL,	
	Salt UNIQUEIDENTIFIER,
    CONSTRAINT Unique_Email_Doctors UNIQUE (DrEmail),
);

-- 1.3.1 - Doctors table data 
INSERT INTO Doctors (DepartmentID, DoctorName, Speciality, DepartmentName, DrEmail, Telephone, Username, PasswordHash, Salt)
VALUES
    (101, 'Dr. John Smith', 'Cardiologist', 'Cardiology', 'j.smith@nhs.net', '01234 567890', 'johnsmith', HASHBYTES('SHA2_256', 'password11'), NEWID()),
    (102, 'Dr. Alice Johnson', 'Neurologist', 'Neurology','a.johnson@nhs.net', '01234 567891', 'alicejohnson', HASHBYTES('SHA2_256', 'password12'), NEWID()),
    (103, 'Dr. David Wilson', 'Orthopedic Surgeon', 'Orthopedics', 'd.wilson@nhs.net', '01234 567892', 'davidwilson', HASHBYTES('SHA2_256', 'password13'), NEWID()),
    (104, 'Dr. Emily Taylor', 'Pediatrician', 'Pediatrics', 'e.taylor@nhs.net', '01234 567893', 'emilytaylor', HASHBYTES('SHA2_256', 'password14'), NEWID()),
    (105, 'Dr. Mark Evans', 'Ophthalmologist', 'Ophthalmology', 'm.evans@nhs.net', '01234 567894', 'markevans', HASHBYTES('SHA2_256', 'password15'), NEWID()),
    (106, 'Dr. Michael Brown', 'Dermatologist', 'Dermatology', 'm.brown@nhs.net', '01234 567895', 'michaelbrown', HASHBYTES('SHA2_256', 'password16'), NEWID()),
    (107, 'Dr. Olivia Wilson', 'Oncologist', 'Oncology', 'o.wilson@nhs.net', '01234 567896', 'oliviawilson', HASHBYTES('SHA2_256', 'password17'), NEWID()),
    (108, 'Dr. Sophia Johnson', 'Gastroenterologist', 'Gastroenterology', 's.johnson@nhs.net', '01234 567897', 'sophiajohnson', HASHBYTES('SHA2_256', 'password18'), NEWID()),
    (109, 'Dr. William Harris', 'ENT Specialist', 'ENT (Ear, Nose, Throat)', 'w.harris@nhs.net', '01234 567898', 'williamharris', HASHBYTES('SHA2_256', 'password19'), NEWID()),
    (110, 'Dr. Daniel Clark', 'Urologist', 'Urology', 'd.clark@nhs.net', '01234 567899', 'danielclark', HASHBYTES('SHA2_256', 'password20'), NEWID());

-- 1.3.2 - Let's view Doctors data
SELECT *
FROM Doctors

-- 1.4 - Create the Departments table
CREATE TABLE Departments (
	DepartmentID INT PRIMARY KEY IDENTITY(101,1),
	DepartmentName NVARCHAR(100) NOT NULL, 
	DoctorID INT NOT NULL,
	FOREIGN KEY (DoctorId) REFERENCES Doctors(DoctorID)
);

-- 1.4.1 - Insert sample data into the Departments table
INSERT INTO Departments (DepartmentName, DoctorID)
VALUES
    ('Cardiology', '201'),
    ('Neurology', '202'),
    ('Orthopedics', '203'),
    ('Pediatrics', '204'),
    ('Ophthalmology', '205'),
    ('Dermatology', '206'),
    ('Oncology', '207'),
    ('Gastroenterology', '208'),
    ('ENT (Ear, Nose, Throat)', '209'),
    ('Urology', '210');

-- 1.4.2 - Let's view Departments data
SELECT *
FROM Departments

-- 1.5 - Create the Appointments table 
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY IDENTITY(401,1),
    PatientID INT NOT NULL, 
	DoctorID INT NOT NULL,
	Date DATE,
	StartTime TIME, 
	EndTime TIME, 
	Reason NVARCHAR (MAX), 
	Status NVARCHAR(20) CHECK (Status IN ('Pending', 'Confirmed', 'Refused', 'Cancelled', 'Completed')), -- Pending, Confirmed, Refused, Cancelled, completed
	CONSTRAINT FK_PatientID_Appointments FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    CONSTRAINT FK_DoctorID_Appointments FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
);

-- 1.5.1 - Appointments table data
INSERT INTO Appointments (PatientID, DoctorID, Date, StartTime, EndTime, Reason, Status)
VALUES
	(301, 201, '2024-02-25', '08:00', '09:00', 'Oncology consultation', 'Completed'),
	(301, 202, '2024-02-26', '08:00', '09:00', 'Feeling tensed', 'Completed'),
	(302, 203, '2024-02-27', '17:40', '18:00', 'Check up', 'Completed'),
	(302, 204, '2024-02-28', '11:00', '11:10', 'Check up', 'Completed'),
	(303, 205, '2024-02-29', '09:45', '10:00', 'Diabetes check up', 'Completed'),
    (301, 201, NULL, NULL, NULL,'Regular checkup', 'Pending'),
	(303, 203, NULL, NULL, NULL, 'Back pain', 'Refused'),
	(303, 206, '2024-03-01', '09:30', '10:00', 'Diabetes check up', 'Completed'),
	(304, 207, '2024-03-02', '16:00', '16:30', 'Oncology consultation', 'Completed'),
	(304, 208, '2024-03-03', '11:00', '11:20', 'Mental health issues', 'Completed'),
	(305, 209, '2024-03-04', '09:30', '10:00', 'Gout symptoms', 'Completed'),
	(305, 210, '2024-03-05', '09:30', '10:00', 'Gout symptoms', 'Completed'),
	(306, 201, '2024-03-06', '11:30', '12:00', 'Hypertension issues', 'Completed'),
	(306, 202, '2024-03-07', '09:30', '09:30', 'Hypertension issues', 'Completed'),
	(307, 203, '2024-03-08', '14:00', '15:00', 'Cancer', 'Completed'),
	(307, 204, '2024-03-09', '11:00', '11:30', 'Check up', 'Completed'),
	(308, 205, '2024-03-10', '18:00', '18:05', 'Diabetes check up', 'Completed'),
	(308, 206, '2024-03-11', '11:00', '12:00', 'Diabetes check up', 'Completed'),
	(309, 207, '2024-03-12', '08:00', '08:30', 'Mental health issues', 'Completed'),
	(309, 208, '2024-03-13', '08:00', '08:30', 'Mental health issues', 'Completed'),
	(310, 209, '2024-03-14', '10:00', '11:00', 'Gout symptoms', 'Completed'),
	(310, 210, '2024-03-15', '10:00', '11:00', 'Gout symptoms', 'Completed'),
	(304, 209, NULL, NULL, NULL, 'ENT examination', 'Pending'),
	(304, 204, '2024-06-25', NULL, NULL, 'Child vaccination', 'Cancelled'),
	(301, 207, '2024-06-25', '08:00', '09:00', 'Oncology consultation', 'Confirmed'),
	(302, 208, '2024-06-25', '13:00', '14:00', 'Stomach pain', 'Confirmed'),
	(304, 207, '2024-06-25', '09:00', '10:00', 'Oncology consultation', 'Confirmed'),
	(305, 208, '2024-06-25', '09:30', '10:00', 'Indigestion', 'Confirmed'),
    (306, 206, '2024-06-25', '11:00', '12:00', 'Skin rash', 'Confirmed'),
	(303, 201, '2024-06-27', '09:00', '10:00', 'Heart palpitations', 'Confirmed'),
	(305, 205, NULL, NULL, NULL, 'Eye examination', 'Pending'),
	(305, 210, NULL, NULL, NULL, 'Urinary tract infection', 'Pending'),
	(308, 210, '2024-07-25', '10:00', '11:00', 'Kidney stone', 'Confirmed'),
    (302, 202, '2024-06-27', '10:00', '11:00', 'Headache', 'Confirmed'),
	(306, 209, NULL, NULL, NULL, 'Sore throat', 'Pending'),
    (307, 207, '2024-06-25', '11:00', '12:00', 'Oncology consultation', 'Cancelled'),
	(307, 209, NULL, NULL, NULL, 'Ear infection', 'Pending'),
    (308, 208, '2024-06-25', '08:00', '09:00', 'Stomach ache', 'Confirmed'),
    (309, 210, NULL, NULL, NULL, 'Prostate check', 'Pending'),
    (310, 210, NULL, NULL, NULL, 'Bladder issues', 'Pending');

-- 1.5.2 - let's view the Appointments data
SELECT *
FROM Appointments

-- 1.5.3 - Appointment recovery procedure
CREATE PROCEDURE RecoverAppointments
AS
BEGIN
    BEGIN TRY
        INSERT INTO Appointments (PatientID, DoctorID, Date, StartTime, EndTime, Reason, Status)
        VALUES
            (301, 201, '2024-02-25', '08:00', '09:00', 'Oncology consultation', 'Completed'),
            (301, 202, '2024-02-26', '08:00', '09:00', 'Feeling tensed', 'Completed'),
            (302, 203, '2024-02-27', '17:40', '18:00', 'Check up', 'Completed'),
            (302, 204, '2024-02-28', '11:00', '11:10', 'Check up', 'Completed'),
            (303, 205, '2024-02-29', '09:45', '10:00', 'Diabetes check up', 'Completed'),
            (301, 201, NULL, NULL, NULL,'Regular checkup', 'Pending'),
            (303, 203, NULL, NULL, NULL, 'Back pain', 'Refused'),
            (303, 206, '2024-03-01', '09:30', '10:00', 'Diabetes check up', 'Completed'),
            (304, 207, '2024-03-02', '16:00', '16:30', 'Oncology consultation', 'Completed'),
            (304, 208, '2024-03-03', '11:00', '11:20', 'Mental health issues', 'Completed'),
            (305, 209, '2024-03-04', '09:30', '10:00', 'Gout symptoms', 'Completed'),
            (305, 210, '2024-03-05', '09:30', '10:00', 'Gout symptoms', 'Completed'),
            (306, 201, '2024-03-06', '11:30', '12:00', 'Hypertension issues', 'Completed'),
            (306, 202, '2024-03-07', '09:30', '09:30', 'Hypertension issues', 'Completed'),
            (307, 203, '2024-03-08', '14:00', '15:00', 'Cancer', 'Completed'),
            (307, 204, '2024-03-09', '11:00', '11:30', 'Check up', 'Completed'),
            (308, 205, '2024-03-10', '18:00', '18:05', 'Diabetes check up', 'Completed'),
            (308, 206, '2024-03-11', '11:00', '12:00', 'Diabetes check up', 'Completed'),
            (309, 207, '2024-03-12', '08:00', '08:30', 'Mental health issues', 'Completed'),
            (309, 208, '2024-03-13', '08:00', '08:30', 'Mental health issues', 'Completed'),
            (310, 209, '2024-03-14', '10:00', '11:00', 'Gout symptoms', 'Completed'),
            (310, 210, '2024-03-15', '10:00', '11:00', 'Gout symptoms', 'Completed'),
            (304, 209, NULL, NULL, NULL, 'ENT examination', 'Pending'),
            (304, 204, '2024-06-25', NULL, NULL, 'Child vaccination', 'Cancelled'),
            (301, 207, '2024-06-25', '08:00', '09:00', 'Oncology consultation', 'Confirmed'),
            (302, 208, '2024-06-25', '13:00', '14:00', 'Stomach pain', 'Confirmed'),
            (304, 207, '2024-06-25', '09:00', '10:00', 'Oncology consultation', 'Confirmed'),
            (305, 208, '2024-06-25', '09:30', '10:00', 'Indigestion', 'Confirmed'),
            (306, 206, '2024-06-25', '11:00', '12:00', 'Skin rash', 'Confirmed'),
            (303, 201, '2024-06-27', '09:00', '10:00', 'Heart palpitations', 'Confirmed'),
            (305, 205, NULL, NULL, NULL, 'Eye examination', 'Pending'),
            (305, 210, NULL, NULL, NULL, 'Urinary tract infection', 'Pending'),
            (308, 210, '2024-07-25', '10:00', '11:00', 'Kidney stone', 'Confirmed'),
            (302, 202, '2024-06-27', '10:00', '11:00', 'Headache', 'Confirmed'),
            (306, 209, NULL, NULL, NULL, 'Sore throat', 'Pending'),
            (307, 207, '2024-06-25', '11:00', '12:00', 'Oncology consultation', 'Cancelled'),
            (307, 209, NULL, NULL, NULL, 'Ear infection', 'Pending'),
            (308, 208, '2024-06-25', '08:00', '09:00', 'Stomach ache', 'Confirmed'),
            (309, 210, NULL, NULL, NULL, 'Prostate check', 'Pending'),
            (310, 210, NULL, NULL, NULL, 'Bladder issues', 'Pending');
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred during recovery: ' + ERROR_MESSAGE();
    END CATCH
END;

-- 1.6 - Create the Notifications table
CREATE TABLE Notifications (
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
	Date DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    NotificationType NVARCHAR(20) CHECK (NotificationType IN ('Confirmed', 'Cancelled')),
    CONSTRAINT FK_PatientID_Notifications FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    CONSTRAINT FK_DoctorID_Notifications FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- 1.6.1 - Notifications table data
INSERT INTO Notifications (PatientID, DoctorID, Date, StartTime, EndTime, NotificationType)
VALUES
	-- Appointment 2024-06-15
	(302,  202,  '2024-06-15', '10:00', '11:00', 'Confirmed'),
	-- Appointment 2024-06-25
	(304, 204, '2024-06-25', '08:30', '09:30', 'Cancelled'),
	(306, 206, '2024-06-25', '11:00', '12:00', 'Confirmed'),
	(301, 207, '2024-06-25', '08:00', '09:00', 'Confirmed'),
	(304, 207, '2024-06-25', '11:00', '12:00', 'Confirmed'),
	(308, 208, '2024-05-25', '08:00', '09:00', 'Confirmed'),
	(305, 208, '2024-06-25', '09:30', '10:00', 'Confirmed'),
	(307, 207, '2024-06-25', '11:00', '12:00', 'Cancelled'),
	(302, 208, '2024-06-25', '13:00', '14:00', 'Confirmed'),
	-- Appointment 2024-06-27
	(303, 201, '2024-06-27', '09:00', '10:00', 'Confirmed'),
	-- Appointment 2024-07-25
	(308, 210, '2024-07-25', '10:00', '11:00', 'Confirmed'),
	(310, 210, '2024-07-25', '11:00', '12:00', 'Confirmed'),
	(309, 210, '2024-07-25', '11:00', '12:00', 'Cancelled');

-- 1.6.2 - Let's view notifications data
SELECT *
FROM Notifications

-- 1.7 - Create the MedicalRecrds table
CREATE TABLE MedicalRecords (
	Date DATE NOT NULL,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    Diagnosis NVARCHAR(255),
    Allergies NVARCHAR(255),
    Medicine NVARCHAR(255),
    MedicinePrescribeDate DATE,
    HospitalExitDate DATE,
    CONSTRAINT FK_PatientID_MR FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    CONSTRAINT FK_DoctorID_MR FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
);

-- 1.7.1 - MedicalRecords data
INSERT INTO MedicalRecords (Date, PatientID, DoctorID, Allergies, Diagnosis, Medicine, HospitalExitDate)
VALUES
    -- Josh Smith history 
    ('2024-02-25', 301, 201, 'Penicillin', 'Cancer', 'Aspirin, Inhaler', NULL),
    ('2024-02-26', 301, 202, 'Nuts', 'Hypertension, Bronchitis', 'Beta-blockers, Corticosteroids', NULL),
    -- Alice Johnson history
    ('2024-02-27', 302, 203, 'Shellfish', 'Migraine, Gastritis', 'Triptans, Antacids', '2024-03-01'),
    ('2024-02-28', 302, 204, 'Pollen', 'Migraine, Gastritis', 'Analgesics, Proton pump inhibitors', '2024-03-02'),
    -- David Wilson history
    ('2024-02-29', 303, 205, 'Dairy', 'Arthritis, Diabetes', 'NSAIDs, Insulin', NULL),
    ('2024-03-01', 303, 206, 'Peanuts', 'Arthritis, Diabetes', 'DMARDs, Metformin', NULL),
    -- Emily Taylor history 
    ('2024-03-02', 304, 207, 'Eggs', 'Cancer', 'Antidepressants, Anxiolytics', NULL),
    ('2024-03-03', 304, 208, 'Pollen', 'Depression, Anxiety', 'SSRIs, Benzodiazepines', NULL),
    -- Mark Evans history 
    ('2024-03-04', 305, 209, 'Shellfish', 'Gout, Hypothyroidism', 'NSAIDs, Levothyroxine', '2024-03-06'),
    ('2024-03-05', 305, 210, 'Nuts', 'Gout, Hypothyroidism', 'Colchicine, Thyroid hormone replacement', '2024-03-07'),
    -- John Smith history 
    ('2024-03-06', 306, 201, 'Penicillin', 'Hypertension, Bronchitis', 'Aspirin, Inhaler', NULL),
    ('2024-03-07', 306, 202, 'Nuts', 'Hypertension, Bronchitis', 'Beta-blockers, Corticosteroids', NULL),
    -- Michael Brown history 
    ('2024-03-08', 307, 203, 'Shellfish', 'Cancer', 'Triptans, Antacids', '2024-03-10'),
    ('2024-03-09', 307, 204, 'Pollen', 'Migraine, Gastritis', 'Analgesics, Proton pump inhibitors', '2024-03-11'),
    -- Olivia Wilson history
    ('2024-03-10', 308, 205, 'Dairy', 'Arthritis, Diabetes', 'NSAIDs, Insulin', NULL),
    ('2024-03-11', 308, 206, 'Peanuts', 'Arthritis, Diabetes', 'DMARDs, Metformin', NULL),
    -- Sophia Johnson history 
    ('2024-03-12', 309, 207, 'Eggs', 'Depression, Anxiety', 'Antidepressants, Anxiolytics', NULL),
    ('2024-03-13', 309, 208, 'Pollen', 'Depression, Anxiety', 'SSRIs, Benzodiazepines', NULL),
    -- William Harris history
    ('2024-03-14', 310, 209, 'Shellfish', 'Gout, Hypothyroidism', 'NSAIDs, Levothyroxine', '2024-03-16'),
    ('2024-03-15', 310, 210, 'Nuts', 'Gout, Hypothyroidism', 'Colchicine, Thyroid hormone replacement', '2024-03-17');

-- 1.7.2 - Let's view medical record data
SELECT *
FROM MedicalRecords


-- 1.8 - Create the DoctorAvailability table to track doctor's availability
CREATE TABLE DoctorAvailability (
    DoctorID INT,
    Date DATE,
    StartTime TIME,
    EndTime TIME,
    Availability NVARCHAR(50) CHECK (Availability IN ('Available', 'Meeting', 'Training', 'Conference', 'Holidays', 'Busy')),
    CONSTRAINT FK_DoctorID_Availability FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
);

-- 1.8.1 - DoctorAvailability table data to see doctor's availability
INSERT INTO DoctorAvailability (DoctorID, Date, StartTime, EndTime, Availability)
VALUES
    -- Dr. John Smith
    (201, '2024-06-27', '09:00', '10:00', 'Available'),
    (201, '2024-06-27', '10:00', '18:00', 'Training'),
    -- Dr. Alice Johnson
    (202, '2024-06-15', '10:00', '15:00', 'Available'),
    -- Dr. David Wilson
    (203, '2024-06-27', '08:00', '16:00', 'Busy'),
    -- Dr. Emily Taylor
    (204, '2024-06-25', '08:00', '12:00', 'Meeting'),
    (204, '2024-06-25', '12:00', '18:00', 'Busy'),
    -- Dr. Mark Evans
    (205, '2024-07-25', '08:00', '18:00', 'Holidays'), 
    -- Dr. Michael Brown
    (210, '2024-06-25', '10:00', '15:00', 'Available'),  
    -- Dr. Olivia Wilson
    (207, '2024-06-25', '08:00', '12:00', 'Available'),
    (207, '2024-06-25', '12:00', '18:00', 'Holidays'),
    -- Dr. Sophia Johnson
    (208, '2024-06-25', '08:00', '18:00', 'Available'),
    -- Dr. William Harris
    (209, '2024-06-25', '08:00', '17:00', 'Conference'),
    (209, '2024-06-25', '17:00', '18:00', 'Available'),
    -- Dr. Daniel Clark
    (210, '2024-07-25', '10:00', '12:00', 'Available');

-- 1.8.2 - Let's view doctor availabilities data
Select *
FROM DoctorAvailability

-- 1.9 - Create table for Feedback
CREATE TABLE CompletionAndFeedback (
	FeedbackID INT PRIMARY KEY IDENTITY(501,1), 
	AppointmentID INT, 
    PatientID INT,
    DoctorID INT,
	Date DATE NOT NULL,
	NotificationType NVARCHAR(20) CHECK (NotificationType IN ('Completed', 'Rebook')),
    Feedback NVARCHAR(MAX),
	FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    CONSTRAINT FK_Feedback_PatientID FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    CONSTRAINT FK_Feedback_DoctorID FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- 1.9.1 - Feedback table data
INSERT INTO CompletionAndFeedback (AppointmentID, PatientID, DoctorID, Date, NotificationType, Feedback)
VALUES
    (402, 302, 202, '2024-06-15', 'Completed', 'I feel secure every time I meet the doctor.'),
    (406, 306, 206, '2024-06-25', 'Completed', 'I undertood my situation after seeing the doctor.'),
    (408, 308, 208, '2024-06-25', 'Completed', 'Poor experience.'),
    (411, 301, 207, '2024-06-25', 'Completed', 'My doctor is great.'),
    (412, 304, 207, '2024-06-25', 'Completed', 'It was nice to see the doctor as always.'),
    (413, 302, 208, '2024-06-25', 'Completed', 'The doctor has the right word to cheer me up.'),
    (414, 305, 208, '2024-06-25', 'Completed', 'The doctor is ok'),
    (417, 308, 210, '2024-07-25', 'Completed', 'I will not meet this doctor again'),
    (420, 303, 201, '2024-06-27', 'Completed', 'cool appointment');

-- 1.9.2 - Let's view completion and feedback data 
SELECT *
FROM CompletionAndFeedback

-- 1.9.3 - Recovery procedure 
CREATE PROCEDURE RestoreFeedbackData
AS
BEGIN
    BEGIN TRY
        -- Check if the data is already present
        IF EXISTS (SELECT 1 FROM CompletionAndFeedback)
        BEGIN
            RAISERROR ('Feedback data already exists. No action needed.', 16, 1);
            RETURN;
        END
        
        -- Re-insert lost data from a backup source
        INSERT INTO CompletionAndFeedback (AppointmentID, PatientID, DoctorID, Date, NotificationType, Feedback)
        VALUES
            (402, 302, 202, '2024-06-15', 'Completed', 'I feel secure every time I meet the doctor.'),
            (406, 306, 206, '2024-06-25', 'Completed', 'I understood my situation after seeing the doctor.'),
            (408, 308, 208, '2024-06-25', 'Completed', 'Poor experience.'),
            (411, 301, 207, '2024-06-25', 'Completed', 'My doctor is great.'),
            (412, 304, 207, '2024-06-25', 'Completed', 'It was nice to see the doctor as always.'),
            (413, 302, 208, '2024-06-25', 'Completed', 'The doctor has the right word to cheer me up.'),
            (414, 305, 208, '2024-06-25', 'Completed', 'The doctor is ok'),
            (417, 308, 210, '2024-07-25', 'Completed', 'I will not meet this doctor again'),
            (420, 303, 201, '2024-06-27', 'Completed', 'cool appointment');

        PRINT 'Feedback data restored successfully.';
    END TRY
    BEGIN CATCH
        -- Handle any errors that occur during the restoration process
        PRINT 'An error occurred while restoring feedback data: ' + ERROR_MESSAGE();
    END CATCH;
END;

-- 2. Add the constraint to check that the appointment date is not in the past.
ALTER TABLE Appointments
ADD CONSTRAINT chk_appointment_date CHECK (Date >= '2022-03-01');

-- 2.1 Let's check that the constraint was applied.
INSERT INTO Appointments (PatientID, DoctorID, Date, StartTime, EndTime, Reason, Status)
VALUES
	(310, 201, '2022.02.05', '08:00', '09:00', 'Oncology consultation', 'Completed');

-- 3. List all the patients with older than 40 and have Cancer in diagnosis.
SELECT * 
FROM Patients
JOIN MedicalRecords ON Patients.PatientID = MedicalRecords.PatientID
WHERE Patients.DateOfBirth < DATEADD(year, -40, GETDATE())
AND MedicalRecords.Diagnosis = 'Cancer';

-- 4. The hospital also requires stored procedures or user-defined functions to do the following things:
-- a) Search the database of the hospital for matching character strings by name of medicine. 
CREATE PROCEDURE SearchMedicine
    @MedicineName NVARCHAR(100)
AS
BEGIN
    SELECT *
    FROM MedicalRecords
    WHERE Medicine LIKE '%' + @MedicineName + '%'
    ORDER BY Date DESC;
END;

EXEC SearchMedicine 'Aspirin';

-- b) Return a full list of diagnosis and allergies for a specific patient
CREATE PROCEDURE GetPatientDiagnosisAndAllergies
    @PatientID INT
AS
BEGIN
    SELECT Diagnosis, Allergies
    FROM MedicalRecords
    WHERE PatientID = @PatientID;
END;

EXEC GetPatientDiagnosisAndAllergies @PatientID = 307;

-- Return a full list of diagnosis and allergies for a specific patient who has an appointment today
CREATE PROCEDURE GetPatientDiagnosisAndAllergiesForToday
    @PatientID INT
AS
BEGIN
    DECLARE @Today DATE = CAST(GETDATE() AS DATE);

    -- Retrieve diagnosis and allergies for the patient with appointments today
    SELECT MR.Diagnosis, MR.Allergies
    FROM MedicalRecords MR
    INNER JOIN Appointments A ON MR.PatientID = A.PatientID
    WHERE A.PatientID = @PatientID
    AND CONVERT(DATE, A.Date) = @Today;
END;

EXEC GetPatientDiagnosisAndAllergiesForToday @PatientID = 307;

-- c) Update the details for an existing doctor
CREATE PROCEDURE NewDoctorDetails
    @DoctorID INT,
    @DoctorName NVARCHAR(100),
    @Speciality NVARCHAR(100),
    @DepartmentID INT,
    @DrEmail NVARCHAR(255),
    @Telephone NVARCHAR(20),
    @Username NVARCHAR(50),
    @Password NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Generate a unique salt for password hashing
    DECLARE @Salt UNIQUEIDENTIFIER = NEWID();

    -- Hash the password using SHA-256 algorithm with the salt
    DECLARE @PasswordHash BINARY(64);
    SET @PasswordHash = HASHBYTES('SHA2_256', @Password + CAST(@Salt AS NVARCHAR(36)));

    -- Update the details for the specified doctor
    UPDATE Doctors
    SET DoctorName = @DoctorName,
        Speciality = @Speciality,
        DepartmentID = @DepartmentID,
        DrEmail = @DrEmail,
        Telephone = @Telephone,
        Username = @Username,
        PasswordHash = @PasswordHash,
        Salt = @Salt
    WHERE DoctorID = @DoctorID;
END;

-- Let's execute the command 
EXEC NewDoctorDetails
    @DoctorID = 201,  
    @DoctorName = 'Dr. Rishy Sunak',
    @Speciality = 'Cardiology',
    @DepartmentID = 101,
    @DrEmail = 'rishysunak@nhs.net',
    @Telephone = '07845953119',
    @Username = 'rishysunak',
    @Password = 'password21';

SELECT *
FROM Doctors

-- d) Delete the appointment who status is already completed.
-- Begin transaction for checkpoint
BEGIN TRANSACTION;

DELETE FROM CompletionAndFeedback
WHERE AppointmentID IN (SELECT AppointmentID FROM Appointments WHERE Status = 'completed');

DELETE FROM Appointments
WHERE Status = 'completed';

ALTER TABLE CompletionAndFeedback
ADD CONSTRAINT FK__Completio__Appoi__4222D4EF
FOREIGN KEY (AppointmentID)
REFERENCES Appointments(AppointmentID)
ON DELETE CASCADE;

Select *
From Appointments 

--5. View of the hospital requirements 
--5.1. Let's restore the deleted data
ROLLBACK TRANSACTION;

--5.2. Let's create a view containing all the required information
CREATE VIEW DoctorAppointmentDetails AS
SELECT A.PatientID,
       A.DoctorID,
       A.Date AS AppointmentDate,
       A.StartTime,
       A.EndTime,
       A.Reason AS AppointmentReason,
       A.Status AS AppointmentStatus,
       P.PatientName,
       P.Address AS PatientAddress,
       P.DateOfBirth AS PatientDateOfBirth,
       P.Gender AS PatientGender,
       P.Insurance AS PatientInsurance,
       P.PatientEmail,
       P.Telephone AS PatientTelephone,
       D.DoctorName,
       D.Speciality AS DoctorSpecialty,
       D.DepartmentID,
       Dep.DepartmentName AS DoctorDepartment,
       R.Feedback AS DoctorFeedback
FROM Appointments A
JOIN Patients P ON A.PatientID = P.PatientID
JOIN Doctors D ON A.DoctorID = D.DoctorID
JOIN Departments Dep ON D.DepartmentID = Dep.DepartmentID
LEFT JOIN CompletionAndFeedback R ON A.AppointmentID = R.AppointmentID;

-- Let's view the data to make sure that all the information are back 
SELECT * FROM DoctorAppointmentDetails;
SELECT * FROM CompletionAndFeedback; 

--6. Creation of a trigger procedure to change the current state of appointment from available to cancel
-- Create the trigger procedure
CREATE TRIGGER UpdateAppointmentState
ON Appointments
AFTER UPDATE
AS
BEGIN
    IF (UPDATE(Status))
    BEGIN
        UPDATE Appointments
        SET Status = 'Available'
        FROM Appointments a
        JOIN inserted i ON a.AppointmentID = i.AppointmentID
        WHERE i.Status = 'Cancelled';
    END
END;

ALTER TABLE Appointments DROP CONSTRAINT CK__Appointme__Statu__30F848ED;

UPDATE Appointments
SET Status = 'Cancelled'
WHERE AppointmentID = 424

UPDATE Appointments
SET Status = 'Cancelled'
WHERE AppointmentID = 436

SELECT *
FROM Appointments

--7. Query which allows the hospital to identify the number of completed appointments with speciality of doctor as 'Gastroenterologists'
SELECT COUNT(*) AS CompletedAppointments
FROM Appointments A
JOIN (
    SELECT DoctorID
    FROM Doctors
    WHERE Speciality = 'Gastroenterologist'
) AS D ON A.DoctorID = D.DoctorID
WHERE A.Status = 'Completed';

-- 9. If the patient leaves the hospital system, the hospital wants to retain their information on the system, but they should keep a record of the date the patient left
-- 9.1 Alter the 'Patients' table
ALTER TABLE Patients
ADD DepartureDate DATE;

-- 9.2 Create a stored procedure to update the patient's departure 
CREATE PROCEDURE UpdatePatientDepartureDate
    @PatientID INT,
    @DepartureDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Update the departure date for the specified patient
    UPDATE Patients
    SET DepartureDate = @DepartureDate
    WHERE PatientID = @PatientID;
END;

-- Call the procedure to update the departure for a specific PatientID 301
EXEC UpdatePatientDepartureDate
    @PatientID = 301,  
    @DepartureDate = '2024-04-23';  