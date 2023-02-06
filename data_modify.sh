#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

echo -e "\nChange column name from weight to atomic_mass"
echo "$($PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass")"

echo -e "\nChange column name from melting_point to melting_point_celsius"
echo "$($PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius")"

echo -e "\Change column name from boiling_point to boiling_point_celsius"
echo "$($PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius")"

echo -e "\nAdd UNIQUE constraint to the symbol and name column"
echo "$($PSQL "ALTER TABLE elements ADD UNIQUE(symbol, name)")"

echo -e "\nChange boiling_point and melting_point to NOT NULL"
echo "$($PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL")"
echo "$($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL")"

echo -e "\nAdd NOT NULL to symbol and name column"
echo "$($PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL")"
echo "$($PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL")"

echo -e "\nMake atomic_number a foreign key in properties table"
echo "$($PSQL "ALTER TABLE properties ADD FOREIGN KEY(atomic_number) REFERENCES elements(atomic_number)")"

echo -e "\nCreate a types table"
echo "$($PSQL "CREATE TABLE types()")"
echo "$($PSQL "ALTER TABLE types ADD COLUMN type_id INT PRIMARY KEY")"
echo "$($PSQL "ALTER TABLE types ADD COLUMN type VARCHAR(40) NOT NULL")"

echo -e "\nAdd three rows to types table"
echo "$($PSQL "INSERT INTO types(type_id, type) VALUES(1, 'metal'), (2, 'nonmetal'), (3, 'metalloid') ")"


echo -e "\nPrperty Table should have type_id REFERENCE types table"
echo "$($PSQL 'ALTER TABLE properties ADD COLUMN type_id INT')"
echo "$($PSQL "ALTER TABLE properties ADD FOREIGN KEY(type_id) REFERENCES types(type_id)")"
echo "$($PSQL "UPDATE properties SET type_id=1 WHERE type='metal'")"
echo "$($PSQL "UPDATE properties SET type_id=2 WHERE type='nonmetal'")"
echo "$($PSQL "UPDATE properties SET type_id=3 WHERE type='metalloid'")"
echo "$($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL")"

echo -e "\nCapitalize the first letter of the element"
echo "$($PSQL "UPDATE elements SET symbol=INITCAP(LOWER(symbol))")"

echo -e "\nRemove trailing zeros from the atomic_mass column in the properties table"
echo "$($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL")"
echo "$($PSQL "UPDATE properties SET atomic_mass=TRIM(TRAILING '0' FROM atomic_mass::VARCHAR)::DECIMAL")"

echo -e "\nValues for the 9th and 10th element for the project (Neow and Fluorine)"
echo "$($PSQL "INSERT INTO elements(atomic_number, symbol, name) VALUES(9, 'F', 'Fluorine')")"
echo "$($PSQL "INSERT INTO PROPERTIES(atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) VALUES(9, 'nonmetal',18.998, -220, -188.1, 2)")"
echo "$($PSQL "INSERT INTO elements(atomic_number, symbol, name) VALUES(10, 'Ne', 'Neon')")"
echo "$($PSQL "INSERT INTO PROPERTIES(atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) VALUES(10, 'nonmetal',20.18, -248.6, -246.1, 2)")"

echo -e "\nDelete the non-existing records from the tables"
echo "$($PSQL "DELETE FROM properties WHERE atomic_number=1000")"
echo "$($PSQL "DELETE FROM elements WHERE atomic_number=1000")"

echo -c "\nDelete the type column from properties"
echo "$($PSQL "ALTER TABLE properties DROP COLUMN type")"