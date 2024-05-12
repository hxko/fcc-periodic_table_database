#!/bin/bash

# Check if the number of arguments is less than 1
if [ "$#" -lt 1 ]; then
    echo "Please provide an element as an argument."
    exit
fi

# Connect to the database and fetch element information based on the input
element_info=$(psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number::text = '$1' OR elements.symbol = '$1' OR elements.name = '$1';")

# Check if element_info is empty (no match found)
if [ -z "$element_info" ]; then
    echo "I could not find that element in the database."
    exit
fi

# Parse element information
IFS='|' read -r atomic_number name symbol type atomic_mass melting_point boiling_point <<< "$element_info"

# Print element information
echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
