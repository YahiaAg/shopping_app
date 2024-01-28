import 'package:mysql_client/mysql_client.dart';

class Database {
  static MySQLConnection? connection;
  static Future<void> makeConnection() async {
    try{ 
    final conn = await MySQLConnection.createConnection(
      secure: false,
      host: "DESKTOP-4S0OI2A",//localhost
      port: 3306,
      userName: "yahia",
      password: "yahia",
      databaseName: "1csminiproject", // optional
    );
// actually connect to database
    await conn.connect();
     connection = conn;
    print("connected");}catch(e){
      print(e);
      print("not connected");
    }
    /*CREATE TABLE Customers (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(50),
    WilayaNumber INT CHECK (WilayaNumber BETWEEN 1 AND 58)
);
CREATE TABLE Products (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(50) ,
    Price DECIMAL(10,2) ,
    Description VARCHAR(255),
    ImageURL VARCHAR(255),
    IsFavorite bool
);
CREATE TABLE ProductDetailes (
    ProductID INT,
    Size VARCHAR(10) CHECK (Size IN ('S', 'M', 'L', 'XL', 'XXL','XXXL')),
    Quantity INT,
    PRIMARY KEY (ProductID, Size),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
);

CREATE TABLE OrderDetails (
    ProductID INT,
    UserID INT,
    Quantity INT ,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
    PRIMARY KEY (UserID, ProductID, SizeID),
    FOREIGN KEY (ProductID, SizeID) REFERENCES ProductDetails(ProductID, SizeID));
    */

    // print all rows as Map<String, String>
  }  }

