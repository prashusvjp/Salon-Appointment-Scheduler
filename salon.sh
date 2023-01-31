#!/bin/bash

echo -e "\n~~~~~ MY SALON ~~~~~\n"
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c "

MAIN_MENU(){
  if [[ ! -z $1 ]]
  then
    echo -e "\n$1"
  else
    echo -e "\nWelcome to My Salon, how can I help you?\n"
  fi
    #get_services
    GET_SERVICES_RESULT=$($PSQL "select * from services")
    echo "$GET_SERVICES_RESULT" | while read SERVICE_ID BAR SERVICE_NAME
    do
      #display menu
      if [[ $NAME = name ]]
      then
        continue
      fi
      echo "$SERVICE_ID) $SERVICE_NAME"
    done
    read SERVICE_ID_SELECTED
    CHECK_SERVICE_ID=$($PSQL "select name from services where service_id='$SERVICE_ID_SELECTED';")
    if [[ -z $CHECK_SERVICE_ID ]]
    then
      #if service does not exist
      MAIN_MENU "I could not find that service. What would you like today?"
    else
      #get phone number
      echo -e "\nWhat's your phone number?"
      read CUSTOMER_PHONE
      #get customer id using phone number
      CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")
      if [[ -z $CUSTOMER_ID ]]
      then
        #get customer name
        echo -e "\nI don't have a record for that phone number, what's your name?"
        read CUSTOMER_NAME
        #Add customer and get ID
        INSERT_DATA_RESULT="$($PSQL "insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME');")"
        if [[ $INSERT_DATA_RESULT == "INSERT 0 1" ]]
        then
          #get customer id
          CUSTOMER_ID="$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")"
        fi
      else
        #get name
        CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE';")
      fi
      #get appointment time
      echo -e "\nWhat time would you like your $CHECK_SERVICE_ID, $CUSTOMER_NAME?"
      read SERVICE_TIME
      #Add appointment
      INSERT_DATA_RESULT="$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME');")"
      if [[ $INSERT_DATA_RESULT == "INSERT 0 1" ]] 
      then
        echo -e "\nI have put you down for a $CHECK_SERVICE_ID at $SERVICE_TIME, $CUSTOMER_NAME."
      fi
    fi

}

MAIN_MENU
