# Installation Guide for the Graph Database part

Please follow this guide to set up the project

## Prerequisites

- Neo4j Server

## Setup (for development)

- Put csv files to Neo4j's import directory `<neo4j-home>\import`
- Start Neo4j server and open front end
- Run these commands:

```cypher
--Create user nodes
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///User.csv" AS row
CREATE (:User {userID: row.iUserId,useremail: row.cEmail, userFirstName: row.cFirstName,userLastName:row.cLastName,userAdress:row.cAddress,cityID:row.iCityId,userPhonenumber:row.cPhoneNo,userTotalPaid:row.fTotalPaid});

--Create city nodes
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///City.csv" AS row
CREATE (:City {cityID: row.iCityId,cityZipCode: row.cZipCode, cityName: row.cCity});

--Create product nodes
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Product.csv" AS row
CREATE (:Product {productID: row.iProductId,productName: row.cName, productDescription: row.cDescription,productUnitPrice:row.fUnitPrice,productQuantity:row.iQuantity,productAverageRating:row.fAverageRating});

--Create relationship "User rated products"
LOAD CSV WITH HEADERS FROM "file:///Rating.csv" AS row
MATCH (user:User {userID: row.iUserId})
MATCH (product:Product {productID: row.iProductId})
CREATE (user)-[r:RATED]->(product)
SET r.rating =row.iRating

--Create relationship "User lives in city"
LOAD CSV WITH HEADERS FROM "file:///User.csv" AS row
MATCH (user:User {userID: row.iUserId})
MATCH (city:City {cityID: row.iCityId})
CREATE (user)-[r:LIVES_IN]->(city)
```