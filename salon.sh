#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -A -c"
SERVICE_ID_SELECTED=""
SERVICE_NAME=""

MAIN_MENU() {
    VALID_CHOICE=false
    while [[ "$VALID_CHOICE" = "false" ]]
    do
        # Show the main menu
        # echo -e "\nMAIN MENU\n"
        $PSQL "SELECT * FROM services" | while IFS="|" read -r SERVICE_ID SERVICE_NAME
        do
            echo -e "$SERVICE_ID) $SERVICE_NAME"
        done

        # Chose a service
        read SERVICE_ID_SELECTED
        case $SERVICE_ID_SELECTED in
            1|2|3)
                SERVICE_NAME=$($PSQL "SELECT name FROM services where service_id = $SERVICE_ID_SELECTED")
                echo "Selected service: $SERVICE_NAME"
                VALID_CHOICE=true
                return 0
                ;;
            *) MAIN_MENU  ;;
        esac
    done
}

MAIN_MENU


# Enter phone number
echo "Enter phone number"
read CUSTOMER_PHONE

# Check if the customer exists
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers where phone = '$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_ID ]]
then
    echo "Enter your name"
    read CUSTOMER_NAME
    $PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')"
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers where phone = '$CUSTOMER_PHONE'")
else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers where phone = '$CUSTOMER_PHONE'")
fi
echo "Enter time"
read SERVICE_TIME
$PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')"

echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

