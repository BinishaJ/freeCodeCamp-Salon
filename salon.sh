#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?"

DISPLAY_SERVICES(){

  #service option
  echo -e "\n1) Trim \n2) Cut \n3) Color"
  read SERVICE_ID_SELECTED

  #service type
  SERVICE_ID=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  #if not found
  if [[ -z $SERVICE_ID ]]
  then
    #display options again
    echo -e "\nEnter a valid option:"
    DISPLAY_SERVICES
  else
    #get phone number
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    #get name
    PHONE=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")

    #if not found 
    if [[ -z $PHONE ]]
    then
      echo -e "\nWhat's your name?"
      read CUSTOMER_NAME

      #insert new customer
      INSERT_ROW=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    else
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    fi    

    #get customer_id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    #get service time
    echo -e "\nEnter your time for the appointment"
    read SERVICE_TIME

    #create new appointment

    CUSTOMER_ID_FORMATTED=$(echo $CUSTOMER_ID | sed -E 's/^ *| *$//g')

    APPOINTMENT=$($PSQL "INSERT INTO appointments(time,service_id,customer_id) VALUES('$SERVICE_TIME', $SERVICE_ID_SELECTED, $CUSTOMER_ID_FORMATTED)")


    #prompt
    echo -e "\nI have put you down for a $SERVICE_ID at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

DISPLAY_SERVICES
