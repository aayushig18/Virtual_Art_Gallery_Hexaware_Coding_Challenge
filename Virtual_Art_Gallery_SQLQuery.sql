create database Virtual_art_gallery;
use Virtual_art_gallery;

CREATE TABLE Artists (
    ArtistID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Biography TEXT,
    Nationality VARCHAR(100)
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);

CREATE TABLE Artworks (
    ArtworkID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ArtistID INT,
    CategoryID INT,
    Year INT,
    Description TEXT,
    ImageURL VARCHAR(255),
    FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Create Exhibitions table
CREATE TABLE Exhibitions (
    ExhibitionID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    Description TEXT
);

-- Create ExhibitionArtworks table
CREATE TABLE ExhibitionArtworks (
    ExhibitionID INT,
    ArtworkID INT,
    PRIMARY KEY (ExhibitionID, ArtworkID),
    FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions(ExhibitionID),
    FOREIGN KEY (ArtworkID) REFERENCES Artworks(ArtworkID)
);

-- Insert data into Artists table
INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
(1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
(2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
(3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

-- Insert data into Categories table
INSERT INTO Categories (CategoryID, Name) VALUES
(1, 'Painting'),
(2, 'Sculpture'),
(3, 'Photography');

-- Insert data into Artworks table
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
(1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
(2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
(3, 'Guernica', 1, 1, 1937, 'Pablo Picassos powerful anti-war mural.', 'guernica.jpg');

-- Insert data into Exhibitions table
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
(1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
(2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

-- Insert data into ExhibitionArtworks table
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2);

/*Question1 Retrieve the names of all artists along with the number of artworks they have in the gallery, and
list them in descending order of the number of artworks.*/

SELECT A.Name, COUNT(Ar.ArtworkID) AS ArtworkCount
FROM Artists A
JOIN Artworks Ar ON A.ArtistID = Ar.ArtistID
GROUP BY A.Name
ORDER BY COUNT(Ar.ArtworkID) DESC;

/*Question2 List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order
them by the year in ascending order*/

SELECT aw.Title
FROM Artworks aw
JOIN Artists a ON aw.ArtistID = a.ArtistID
WHERE a.Nationality IN ('Spanish', 'Dutch')
ORDER BY aw.Year ASC;

/*Question3 Find the names of all artists who have artworks in the 'Painting' category, and the number of
artworks they have in this category.*/

SELECT A.Name, COUNT(Ar.ArtworkID) AS PaintingCount
FROM Artists A
JOIN Artworks Ar ON A.ArtistID = Ar.ArtistID
JOIN Categories C ON Ar.CategoryID = C.CategoryID
WHERE C.Name = 'Painting'
GROUP BY A.Name;

/*Question4 List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their
artists and categories.*/

SELECT Ar.Title, A.Name AS ArtistName, C.Name AS CategoryName
FROM ExhibitionArtworks EA
JOIN Artworks Ar ON EA.ArtworkID = Ar.ArtworkID
JOIN Artists A ON Ar.ArtistID = A.ArtistID
JOIN Categories C ON Ar.CategoryID = C.CategoryID
JOIN Exhibitions E ON EA.ExhibitionID = E.ExhibitionID
WHERE E.Title = 'Modern Art Masterpieces';

/*Question5 Find the artists who have more than two artworks in the gallery*/

SELECT A.Name
FROM Artists A
JOIN Artworks Ar ON A.ArtistID = Ar.ArtistID
GROUP BY A.Name
HAVING COUNT(Ar.ArtworkID) > 2;

/*Question6 Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and
'Renaissance Art' exhibitions*/

SELECT Ar.Title
FROM Artworks Ar
JOIN ExhibitionArtworks EA1 ON Ar.ArtworkID = EA1.ArtworkID
JOIN Exhibitions E1 ON EA1.ExhibitionID = E1.ExhibitionID
JOIN ExhibitionArtworks EA2 ON Ar.ArtworkID = EA2.ArtworkID
JOIN Exhibitions E2 ON EA2.ExhibitionID = E2.ExhibitionID
WHERE E1.Title = 'Modern Art Masterpieces' AND E2.Title = 'Renaissance Art';

/*Question7 Find the total number of artworks in each category*/

SELECT C.Name, COUNT(Ar.ArtworkID) AS TotalArtworks
FROM Categories C
JOIN Artworks Ar ON C.CategoryID = Ar.CategoryID
GROUP BY C.Name;

/*Question8 List artists who have more than 3 artworks in the gallery.*/

SELECT A.Name
FROM Artists A
JOIN Artworks Ar ON A.ArtistID = Ar.ArtistID
GROUP BY A.Name
HAVING COUNT(Ar.ArtworkID) >3;

/*Question9 Find the artworks created by artists from a specific nationality (e.g., Spanish)*/

SELECT Ar.Title
FROM Artworks Ar
JOIN Artists A ON Ar.ArtistID = A.ArtistID
WHERE A.Nationality = 'Spanish';

/*Question10 List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci.*/

SELECT E.Title
FROM Exhibitions E
JOIN ExhibitionArtworks EA1 ON E.ExhibitionID = EA1.ExhibitionID
JOIN Artworks Ar1 ON EA1.ArtworkID = Ar1.ArtworkID
JOIN Artists A1 ON Ar1.ArtistID = A1.ArtistID
JOIN ExhibitionArtworks EA2 ON E.ExhibitionID = EA2.ExhibitionID
JOIN Artworks Ar2 ON EA2.ArtworkID = Ar2.ArtworkID
JOIN Artists A2 ON Ar2.ArtistID = A2.ArtistID
WHERE A1.Name = 'Vincent van Gogh' AND A2.Name = 'Leonardo da Vinci';

/*Question11 Find all the artworks that have not been included in any exhibition.*/

SELECT Ar.Title
FROM Artworks Ar
LEFT JOIN ExhibitionArtworks EA ON Ar.ArtworkID = EA.ArtworkID
WHERE EA.ArtworkID IS NULL;

/*Question12 List artists who have created artworks in all available categories.*/

SELECT A.Name
FROM Artists A
JOIN Artworks Ar ON A.ArtistID = Ar.ArtistID
JOIN Categories C ON Ar.CategoryID = C.CategoryID
GROUP BY A.Name
HAVING COUNT(DISTINCT C.CategoryID) = (SELECT COUNT(CategoryID) FROM Categories);

/*Question13  List the total number of artworks in each category.*/

SELECT C.Name, COUNT(Ar.ArtworkID) AS TotalArtworks
FROM Categories C
JOIN Artworks Ar ON C.CategoryID = Ar.CategoryID
GROUP BY C.Name;

/*Question14 . Find the artists who have more than 2 artworks in the gallery*/

SELECT A.Name
FROM Artists A
JOIN Artworks Ar ON A.ArtistID = Ar.ArtistID
GROUP BY A.Name
HAVING COUNT(Ar.ArtworkID) > 2;

/*Question15 List the categories with the average year of artworks they contain, only for categories with more
than 1 artwork.*/

SELECT C.Name, AVG(Ar.Year) AS AvgYear
FROM Categories C
JOIN Artworks Ar ON C.CategoryID = Ar.CategoryID
GROUP BY C.Name
HAVING COUNT(Ar.ArtworkID) > 1;

/*Question16 Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition*/

SELECT Ar.Title
FROM Artworks Ar
JOIN ExhibitionArtworks EA ON Ar.ArtworkID = EA.ArtworkID
JOIN Exhibitions E ON EA.ExhibitionID = E.ExhibitionID
WHERE E.Title = 'Modern Art Masterpieces';

/*Question17 Find the categories where the average year of artworks is greater than the average year of all
artworks.*/

SELECT C.Name
FROM Categories C
JOIN Artworks Ar ON C.CategoryID = Ar.CategoryID
GROUP BY C.Name
HAVING AVG(Ar.Year) > (SELECT AVG(Year) FROM Artworks);

/*Question18 List the artworks that were not exhibited in any exhibition.*/

SELECT Ar.Title
FROM Artworks Ar
LEFT JOIN ExhibitionArtworks EA ON Ar.ArtworkID = EA.ArtworkID
WHERE EA.ArtworkID IS NULL;

/*Question19 Show artists who have artworks in the same category as "Mona Lisa."*/

SELECT DISTINCT A.Name
FROM Artists A
JOIN Artworks Ar ON A.ArtistID = Ar.ArtistID
WHERE Ar.CategoryID = (SELECT CategoryID FROM Artworks WHERE Title = 'Mona Lisa');

/*Question20 List the names of artists and the number of artworks they have in the gallery*/

SELECT A.Name, COUNT(Ar.ArtworkID) AS ArtworkCount
FROM Artists A
JOIN Artworks Ar ON A.ArtistID = Ar.ArtistID
GROUP BY A.Name;
