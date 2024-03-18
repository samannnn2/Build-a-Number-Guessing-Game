#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER=$((1 + RANDOM%1000))
echo $NUMBER

echo "Enter your username:"
read USER_NAME

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
  VALUES('$USER_NAME');
  ")

  echo "Welcome, $USER_NAME! It looks like this is your first time here."
else
  USER_NAME=$($PSQL "
  SELECT name
  FROM users
  WHERE user_id = '$USER_ID'
  ")

  USER_GAMES=$($PSQL "
  SELECT games_played
  FROM users
  WHERE user_id = '$USER_ID'
  ")

  USER_RECORD=$($PSQL "
  SELECT best_game
  FROM users
  WHERE user_id = '$USER_ID'
  ")

  echo "Welcome back, $USER_NAME! You have played $USER_GAMES games, and your best game took $USER_RECORD guesses."
fi