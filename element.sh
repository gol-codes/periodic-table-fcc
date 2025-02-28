#!/bin/bash

# Check if an argument is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 1
fi

# Query the database for element details
RESULT=$(psql -U freecodecamp -d periodic_table -t --no-align -c "
SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
FROM elements e
JOIN properties p ON e.atomic_number = p.atomic_number
JOIN types t ON p.type_id = t.type_id
WHERE e.atomic_number::TEXT = '$1' OR e.symbol = '$1' OR e.name = '$1';")

# Check if an element was found
if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
else
  IFS="|" read -r atomic_number name symbol type atomic_mass melting_point boiling_point <<< "$RESULT"
  echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
fi
