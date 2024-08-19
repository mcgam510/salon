#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~~~ MICHAEL'S SALON ~~~~\n"
echo -e "Welcome to Michael's Salon, how can I help you?\n"

#main menu ask for service
MAIN_MENU () {
  #echo -e "Welcome to Michael's Salon, how can I help you?\n"
  echo -e "1) cut\n2) color\n3) perm\n4) style \n5) trim"

  read SERVICE_ID_SELECTED

  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  #if not found
  if [[ -z $SERVICE_ID ]]
  then
    echo -e "\nI could not find that service. What would you like today?"
    MAIN_MENU
  else
    #else- ask for phone
    echo -e "\nWhat's your phone number?"

    read CUSTOMER_PHONE

    PHONE=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    
    #if not found, ask for name
    if [[ -z $PHONE ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"

      read CUSTOMER_NAME
        
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi
    
    SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    
    #ask for time
    echo -e "\nWhat time would you like your $SERVICE, $CUSTOMER_NAME?"

    read SERVICE_TIME
    
    #insert appointment
    INSERT_APPT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")
    #confirm message
    echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU
