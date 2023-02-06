#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1  ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT atomic_number, type, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number=$1")
else
  ELEMENT=$($PSQL "SELECT atomic_number, type, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol= '$1' OR name= '$1'")
fi

if [[ -z $ELEMENT ]]
then
  echo -e "I could not find that element in the database."
  exit
fi

echo $ELEMENT | while IFS=" |" read ID TYPE NAME SYMBOL MASS MELT BOIL
do
  echo -e "The element with atomic number $ID is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
done