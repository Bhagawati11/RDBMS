
CREATE DATABASE AnimalConservationProject;
USE AnimalConservationProject;


CREATE TABLE Location (
    LocationID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Coordinates VARCHAR(50),
    Country VARCHAR(50),
    Description TEXT
);

CREATE TABLE Species (
    SpeciesID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    ScientificName VARCHAR(100),
    ConservationStatus VARCHAR(50),
    BiologicalCategory VARCHAR(100)
);

CREATE TABLE Volunteer (
    VolunteerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(200)
);

CREATE TABLE ConservationProject (
    ProjectID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    Budget DECIMAL(15, 2)
);

-- Step 2: Create tables with dependencies
CREATE TABLE Researcher (
    ResearcherID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    ProjectID INT,
    Specialization VARCHAR(100),
    FOREIGN KEY (ProjectID) REFERENCES ConservationProject(ProjectID)
);

CREATE TABLE Habitat (
    HabitatID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Type VARCHAR(50),
    LocationID INT,
    ResearcherID INT,
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID),
    FOREIGN KEY (ResearcherID) REFERENCES Researcher(ResearcherID)
);

CREATE TABLE Tracking (
    TrackingID INT PRIMARY KEY AUTO_INCREMENT,
    AnimalID INT,
    GPSLocation VARCHAR(100),
    TimeStamp DATETIME,
    VolunteerID INT,
    FOREIGN KEY (VolunteerID) REFERENCES Volunteer(VolunteerID)
);

CREATE TABLE Animal (
    AnimalID INT PRIMARY KEY AUTO_INCREMENT,
    TrackingID INT,
    SpeciesID INT,
    HabitatID INT,
    Name VARCHAR(100),
    Gender VARCHAR(10),
    DateOfBirth DATE,
    FOREIGN KEY (TrackingID) REFERENCES Tracking(TrackingID),
    FOREIGN KEY (SpeciesID) REFERENCES Species(SpeciesID),
    FOREIGN KEY (HabitatID) REFERENCES Habitat(HabitatID)
);


ALTER TABLE Tracking
ADD CONSTRAINT fk_tracking_animal
FOREIGN KEY (AnimalID) REFERENCES Animal(AnimalID);


CREATE TABLE Threat (
    ThreatID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    LocationID INT,
    HabitatID INT,
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID),
    FOREIGN KEY (HabitatID) REFERENCES Habitat(HabitatID)
);

CREATE TABLE MitigatingPlan (
    PlanID INT PRIMARY KEY AUTO_INCREMENT,
    ThreatID INT,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (ThreatID) REFERENCES Threat(ThreatID)
);

CREATE TABLE Report (
    ReportID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(200) NOT NULL,
    Date DATE,
    Content TEXT,
    ResearcherID INT,
    ProjectID INT,
    FOREIGN KEY (ResearcherID) REFERENCES Researcher(ResearcherID),
    FOREIGN KEY (ProjectID) REFERENCES ConservationProject(ProjectID)
);

CREATE TABLE Donor (
    DonorID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(200)
);

CREATE TABLE Donation (
    DonationID INT PRIMARY KEY AUTO_INCREMENT,
    DonorID INT,
    Date DATE,
    Amount DECIMAL(15, 2),
    FOREIGN KEY (DonorID) REFERENCES Donor(DonorID)
    
);

CREATE TABLE Campaign (
    CampaignID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    ProjectID INT,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (ProjectID) REFERENCES ConservationProject(ProjectID)
);

CREATE TABLE Event (
    EventID INT PRIMARY KEY AUTO_INCREMENT,
    ProjectID INT,
    Name VARCHAR(100) NOT NULL,
    Date DATE,
    Location VARCHAR(200),
    FOREIGN KEY (ProjectID) REFERENCES ConservationProject(ProjectID)
);

ALTER TABLE Donation
ADD COLUMN ProjectID INT,
ADD CONSTRAINT fk_donation_conservationproject
FOREIGN KEY (ProjectID) REFERENCES conservationproject(ProjectID);

# 1st normal form

# anomaly related to report and researcher

select * from Report;

SELECT CONSTRAINT_NAME
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Report'
  AND CONSTRAINT_TYPE = 'FOREIGN KEY';
  
ALTER TABLE Report
DROP FOREIGN KEY Report_ibfk_1;

ALTER TABLE Report
DROP COLUMN ResearcherID;

CREATE TABLE ReportResearcher (
    ReportID INT,
    ResearcherID INT,
    PRIMARY KEY (ReportID, ResearcherID),  -- Composite primary key
    FOREIGN KEY (ReportID) REFERENCES Report(ReportID),
    FOREIGN KEY (ResearcherID) REFERENCES Researcher(ResearcherID)
);
select * from ReportResearcher;
#conservation project are related to species, habitat,threat


CREATE TABLE ProjectSpecies (
    ProjectID INT,
    SpeciesID INT,
    PRIMARY KEY (ProjectID, SpeciesID),  -- Composite primary key
    FOREIGN KEY (ProjectID) REFERENCES ConservationProject(ProjectID),
    FOREIGN KEY (SpeciesID) REFERENCES Species(SpeciesID)
);
use wildlifeconservationprojects;

CREATE TABLE ProjectHabitat (
    ProjectID INT,
    HabitatID INT,
    PRIMARY KEY (ProjectID, HabitatID), 
    FOREIGN KEY (ProjectID) REFERENCES ConservationProject(ProjectID),
    FOREIGN KEY (HabitatID) REFERENCES Habitat(HabitatID)
);


CREATE TABLE ProjectThreat (
    ProjectID INT,
    ThreatID INT,
    PRIMARY KEY (ProjectID, ThreatID), 
    FOREIGN KEY (ProjectID) REFERENCES ConservationProject(ProjectID),
    FOREIGN KEY (ThreatID) REFERENCES Threat(ThreatID)
);

SELECT CONSTRAINT_NAME
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Animal'
  AND CONSTRAINT_TYPE = 'FOREIGN KEY';


ALTER TABLE Animal
DROP FOREIGN KEY animal_ibfk_1;  
ALTER TABLE Animal
DROP COLUMN TrackingID;  

CREATE TABLE AnimalTracking (
    AnimalID INT,
    TrackingID INT,
    PRIMARY KEY (AnimalID, TrackingID),  -- Composite primary key
    FOREIGN KEY (AnimalID) REFERENCES Animal(AnimalID),
    FOREIGN KEY (TrackingID) REFERENCES Tracking(TrackingID)
);

INSERT INTO Location (Name, Coordinates, Country, Description)
VALUES
    ('Kaziranga National Park', '26.5735° N, 93.1715° E', 'India', 'Famous for one-horned rhinoceros.'),
    ('Ranthambore National Park', '26.0172° N, 76.5025° E', 'India', 'Known for its tiger population.'),
    ('Sundarbans National Park', '21.9497° N, 88.9401° E', 'India', 'Largest mangrove forest in the world.'),
    ('Gir National Park', '21.1366° N, 70.7839° E', 'India', 'Home to the Asiatic lion.'),
    ('Periyar National Park', '9.4667° N, 77.1333° E', 'India', 'Famous for elephants and tigers.'),
    ('Bandipur National Park', '11.6667° N, 76.6167° E', 'India', 'Part of the Nilgiri Biosphere Reserve.');
    
INSERT INTO Species (Name, ScientificName, ConservationStatus, BiologicalCategory)
VALUES
    ('Bengal Tiger', 'Panthera tigris tigris', 'Endangered', 'Mammal'),
    ('Indian Elephant', 'Elephas maximus indicus', 'Endangered', 'Mammal'),
    ('Indian Rhinoceros', 'Rhinoceros unicornis', 'Vulnerable', 'Mammal'),
    ('Asiatic Lion', 'Panthera leo persica', 'Endangered', 'Mammal'),
    ('Indian Peafowl', 'Pavo cristatus', 'Least Concern', 'Bird'),
    ('Ganges River Dolphin', 'Platanista gangetica', 'Endangered', 'Mammal');
    
INSERT INTO Volunteer (Name, Email, Phone, Address)
VALUES
    ('Rahul Sharma', 'rahul.sharma@example.com', '+91 9876543210', 'Mumbai, Maharashtra'),
    ('Priya Patel', 'priya.patel@example.com', '+91 8765432109', 'Ahmedabad, Gujarat'),
    ('Amit Singh', 'amit.singh@example.com', '+91 7654321098', 'Delhi, Delhi'),
    ('Anjali Desai', 'anjali.desai@example.com', '+91 6543210987', 'Bangalore, Karnataka'),
    ('Vikram Reddy', 'vikram.reddy@example.com', '+91 5432109876', 'Hyderabad, Telangana'),
    ('Sneha Gupta', 'sneha.gupta@example.com', '+91 4321098765', 'Kolkata, West Bengal');

INSERT INTO ConservationProject (Name, StartDate, EndDate, Budget)
VALUES
    ('Project Tiger', '2020-01-01', '2025-12-31', 5000000.00),
    ('Save the Elephants', '2019-06-15', '2024-06-14', 3000000.00),
    ('Rhino Conservation', '2021-03-01', '2026-02-28', 4000000.00),
    ('Lion Protection Program', '2018-09-10', '2023-09-09', 2500000.00),
    ('Peafowl Habitat Restoration', '2022-05-20', '2027-05-19', 1500000.00),
    ('Ganges Dolphin Rescue', '2020-11-01', '2025-10-31', 2000000.00);
    
INSERT INTO Researcher (Name, ProjectID, Specialization)
VALUES
    ('Dr. Rajesh Kumar', 1, 'Tiger Conservation'),
    ('Dr. Ananya Iyer', 2, 'Elephant Behavior'),
    ('Dr. Arjun Mehta', 3, 'Rhino Habitat Management'),
    ('Dr. Kavita Joshi', 4, 'Lion Population Studies'),
    ('Dr. Ravi Verma', 5, 'Avian Ecology'),
    ('Dr. Sunita Rao', 6, 'Aquatic Mammals');
    
INSERT INTO Habitat (Name, Type, LocationID, ResearcherID)
VALUES
    ('Kaziranga Grasslands', 'Grassland', 1, 3),
    ('Ranthambore Forests', 'Forest', 2, 1),
    ('Sundarbans Mangroves', 'Mangrove', 3, 6),
    ('Gir Dry Deciduous Forest', 'Forest', 4, 4),
    ('Periyar Evergreen Forest', 'Forest', 5, 2),
    ('Bandipur Scrubland', 'Scrubland', 6, 5);
    

    
INSERT INTO Animal (SpeciesID, HabitatID, Name, Gender, DateOfBirth)
VALUES
    (1, 1, 'Raja', 'Male', '2018-05-15'),
    (2, 2, 'Lakshmi', 'Female', '2017-08-20'),
    (3, 3, 'Ganesh', 'Male', '2019-03-10'),
    (4, 4, 'Simba', 'Male', '2016-11-25'),
    (5, 5, 'Mayur', 'Male', '2020-02-14'),
    (6, 6, 'Ganga', 'Female', '2015-07-30');
    
INSERT INTO Tracking (AnimalID, GPSLocation, TimeStamp, VolunteerID)
VALUES
    (1, '26.5735° N, 93.1715° E', '2023-10-01 10:00:00', 1),
    (2, '26.0172° N, 76.5025° E', '2023-10-02 11:00:00', 2),
    (3, '21.9497° N, 88.9401° E', '2023-10-03 12:00:00', 3),
    (4, '21.1366° N, 70.7839° E', '2023-10-04 13:00:00', 4),
    (5, '9.4667° N, 77.1333° E', '2023-10-05 14:00:00', 5),
    (6, '11.6667° N, 76.6167° E', '2023-10-06 15:00:00', 6);
    
INSERT INTO Threat (Name, Description, LocationID, HabitatID)
VALUES
    ('Poaching', 'Illegal hunting of tigers.', 1, 1),
    ('Deforestation', 'Loss of elephant habitats.', 2, 2),
    ('Flooding', 'Rising water levels in Sundarbans.', 3, 3),
    ('Human-Wildlife Conflict', 'Lions attacking livestock.', 4, 4),
    ('Habitat Fragmentation', 'Breaking up of peafowl habitats.', 5, 5),
    ('Pollution', 'Industrial waste in the Ganges.', 6, 6);
    
INSERT INTO MitigatingPlan (ThreatID, StartDate, EndDate)
VALUES
    (1, '2023-01-01', '2023-12-31'),
    (2, '2023-02-01', '2023-11-30'),
    (3, '2023-03-01', '2023-10-31'),
    (4, '2023-04-01', '2023-09-30'),
    (5, '2023-05-01', '2023-08-31'),
    (6, '2023-06-01', '2023-07-31');
    
INSERT INTO Report (Title, Date, Content, ProjectID)
VALUES
    ('Tiger Population Survey', '2023-09-15', 'Survey of tiger populations in Kaziranga.', 1),
    ('Elephant Migration Patterns', '2023-08-20', 'Study of elephant migration in Ranthambore.', 2),
    ('Rhino Habitat Assessment', '2023-07-25', 'Assessment of rhino habitats in Sundarbans.', 3),
    ('Lion Conservation Report', '2023-06-30', 'Report on lion conservation efforts in Gir.', 4),
    ('Peafowl Population Study', '2023-05-15', 'Study of peafowl populations in Periyar.', 5),
    ('Ganges Dolphin Health Report', '2023-04-10', 'Health assessment of Ganges dolphins.', 6);
    
INSERT INTO Donor (Name, Email, Phone, Address)
VALUES
    ('Anil Ambani', 'anil.ambani@example.com', '+91 9876543210', 'Mumbai, Maharashtra'),
    ('Kiran Mazumdar', 'kiran.mazumdar@example.com', '+91 8765432109', 'Bangalore, Karnataka'),
    ('Ratan Tata', 'ratan.tata@example.com', '+91 7654321098', 'Mumbai, Maharashtra'),
    ('Nita Ambani', 'nita.ambani@example.com', '+91 6543210987', 'Mumbai, Maharashtra'),
    ('Azim Premji', 'azim.premji@example.com', '+91 5432109876', 'Bangalore, Karnataka'),
    ('Shiv Nadar', 'shiv.nadar@example.com', '+91 4321098765', 'Chennai, Tamil Nadu');
    
INSERT INTO Donation (DonorID, Date, Amount, ProjectID)
VALUES
    (1, '2023-01-10', 100000.00, 1),
    (2, '2023-02-15', 50000.00, 2),
    (3, '2023-03-20', 75000.00, 3),
    (4, '2023-04-25', 200000.00, 4),
    (5, '2023-05-30', 150000.00, 5),
    (6, '2023-06-05', 100000.00, 6);
    
INSERT INTO Campaign (Name, ProjectID, StartDate, EndDate)
VALUES
    ('Save the Tigers', 1, '2023-01-01', '2023-12-31'),
    ('Protect the Elephants', 2, '2023-02-01', '2023-11-30'),
    ('Rhino Rescue', 3, '2023-03-01', '2023-10-31'),
    ('Lion Guardians', 4, '2023-04-01', '2023-09-30'),
    ('Peafowl Preservation', 5, '2023-05-01', '2023-08-31'),
    ('Dolphin Conservation', 6, '2023-06-01', '2023-07-31');
    
INSERT INTO Event (ProjectID, Name, Date, Location)
VALUES
    (1, 'Tiger Awareness Day', '2023-07-29', 'Kaziranga National Park'),
    (2, 'Elephant Festival', '2023-08-12', 'Ranthambore National Park'),
    (3, 'Rhino Conservation Workshop', '2023-09-15', 'Sundarbans National Park'),
    (4, 'Lion Pride Day', '2023-10-20', 'Gir National Park'),
    (5, 'Peafowl Photography Contest', '2023-11-05', 'Periyar National Park'),
    (6, 'Ganges Dolphin Rescue Seminar', '2023-12-10', 'Bandipur National Park');
    
    
# Insertion anamoly : 
ALTER TABLE Tracking  
MODIFY COLUMN VolunteerID INT NULL;  

ALTER TABLE Tracking  
ADD CONSTRAINT fk_tracking_volunteer  
FOREIGN KEY (VolunteerID) REFERENCES Volunteer(VolunteerID)  
ON DELETE SET NULL;

#- LEFT JOIN
-- We want to retrieve a list of all Donors and the amount of money they donated. Some donors might not have made any donations, so we want to include them even if they haven't donated.

SELECT
    Donor.Name AS DonorName,
    Donation.Amount AS DonationAmount
FROM
    Donor
LEFT JOIN
    Donation ON Donor.DonorID = Donation.DonorID;

-- RIGHT JOIN
-- List of the campaigns and their associated conservation projects, including campaigns that might not be linked to any project, using a RIGHT JOIN
SELECT
    Donation.DonationID,
    Donation.Date AS DonationDate,
    Donation.Amount,
    Donor.Name AS DonorName,
    Donor.Email AS DonorEmail
FROM
    Donation
RIGHT JOIN
    Donor
ON
    Donation.DonorID = Donor.DonorID;
    
SELECT
    ConservationProject.Name AS ProjectName,
    Researcher.Name AS ResearcherName,
    Researcher.Specialization AS ResearcherSpecialization
FROM
    ConservationProject
INNER JOIN
    Researcher ON ConservationProject.ProjectID = Researcher.ProjectID;
    
-- GROUP BY
-- animals there in each habitat, and the average age of animals in each habitat
SELECT Habitat.Name AS HabitatName,
       COUNT(Animal.AnimalID) AS NumberOfAnimals,
       AVG(YEAR(CURDATE()) - YEAR(Animal.DateOfBirth)) AS AverageAge
FROM Animal
JOIN Habitat ON Animal.HabitatID = Habitat.HabitatID
GROUP BY Habitat.HabitatID, Habitat.Name;

#query  to calculate the number of animals and their average age for each habitat.
SELECT 
    Habitat.Name AS HabitatName,
    (SELECT COUNT(*) FROM Animal WHERE Animal.HabitatID = Habitat.HabitatID) AS NumberOfAnimals,
    (SELECT AVG(YEAR(CURDATE()) - YEAR(DateOfBirth)) FROM Animal WHERE Animal.HabitatID = Habitat.HabitatID) AS AverageAge
FROM 
    Habitat;
    
#query  to calculate the number of donations and the total amount donated for each project.
SELECT 
    ConservationProject.Name AS ProjectName,
    (SELECT COUNT(*) FROM Donation WHERE Donation.ProjectID = ConservationProject.ProjectID) AS NumberOfDonations,
    (SELECT SUM(Amount) FROM Donation WHERE Donation.ProjectID = ConservationProject.ProjectID) AS TotalAmountDonated
FROM 
    ConservationProject;