#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER=$((1 + RANDOM%1000))

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
  WHERE user_id = $USER_ID
  ")

  USER_GAMES=$($PSQL "
  SELECT games_played
  FROM users
  WHERE user_id = $USER_ID
  ")

  USER_RECORD=$($PSQL "
  SELECT best_game
  FROM users
  WHERE user_id = $USER_ID
  ")

  echo "Welcome back, $USER_NAME! You have played $USER_GAMES games, and your best game took $USER_RECORD guesses."
fi

echo "Guess the secret number between 1 and 1000:"
read USER_GUESS
I=1

while [[ $USER_GUESS -ne $NUMBER ]]
do
  if [[ $USER_GUESS =~ ^[0-9]+$ ]]
  then
    if (( $USER_GUESS > $NUMBER ))
    then
      echo "It's lower than that, guess again:"
    elif ((  $USER_GUESS < $NUMBER ))
    then
      echo "It's higher than that, guess again:"
    fi

    ((I++))
  else
    echo "That is not an integer, guess again:"
  fi
  
  read USER_GUESS
done

echo "You guessed it in $I tries. The secret number was $NUMBER. Nice job!"

# updating user games_played
USER_ID=$($PSQL "
SELECT user_id
FROM users
WHERE name = '$USER_NAME'
")

UPDATE_USER_GAMES_PLAYED=$($PSQL "
UPDATE users
SET games_played = games_played + 1
WHERE user_id = '$USER_ID'
")

# #updating user best_game
USER_RECORD=$($PSQL "
  SELECT best_game
  FROM users
  WHERE user_id = $USER_ID
")

if [[ -z $USER_RECORD || $I -lt $USER_RECORD ]]
then
  UPDATE_USER_BEST_GAME=$($PSQL "
  UPDATE users
  SET best_game = $I
  WHERE user_id = $USER_ID
  ")
fi