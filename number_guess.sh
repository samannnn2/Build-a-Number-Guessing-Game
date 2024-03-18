#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER=$((1 + RANDOM%1000))
echo $NUMBER

echo "Enter your username:"
read USERNAME

USER_ID=$($PSQL "
SELECT user_id
FROM users
WHERE name = '$USER_NAME'
")

if [[ -z $USER_ID ]]
then

  INSERT_NEW_USER=$($PSQL "
  INSERT
  INTO users(name)
  VALUES('$USER_NAME')
  ")

  echo "Welcome, $USER_NAME! It looks like this is your first time here."
else
  echo "Welcome back, $USER_NAME! You have played <games_played> games, and your best game took <best_game> guesses."
fi