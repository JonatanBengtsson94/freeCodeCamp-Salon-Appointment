#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -c"

MAIN_MENU(){
    echo -e "\nMAIN MENU\n"
    $PSQL "SELECT * FROM services" | while read SERVICE_ID NAME
    do
        echo $SERVICE_ID") " $NAME
    done
}

MAIN_MENU