#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"


NUMBER=$(( 1 + RANDOM % 1000 ))
echo $NUMBER

echo "Enter your username:"
read -e -n 22 USER
# read -p "Enter your username: " -n 22 USERNAME

PSQL_USER=$($PSQL "SELECT username FROM player WHERE username ilike'$USER'")

if [[ -z $PSQL_USER ]];
then
  echo "Welcome, $USER! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM player WHERE username='$PSQL_USER'")
  BEST_GAME=$($PSQL "SELECT best_game FROM player WHERE username='$PSQL_USER'")
  
  echo -e "\nWelcome back, $PSQL_USER! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

echo -e "\nGuess the secret number between 1 and 1000:"
read GUESS

NUMBER_OF_GUESSES=0

while [ $GUESS != $NUMBER ]
do
# $my_var =~ ^[+-]?[0-9]+$
  if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
    ((NUMBER_OF_GUESSES++))
    echo "That is not an integer, guess again:"
    read GUESS
  elif [[ $GUESS < $NUMBER ]]; then
    ((NUMBER_OF_GUESSES++))
    echo "It's higher than that, guess again:"
    read GUESS
  elif [[ $GUESS > $NUMBER ]]; then
    ((NUMBER_OF_GUESSES++))
    echo "It's lower than that, guess again:"
    read GUESS
  fi
done

((NUMBER_OF_GUESSES++))

if [[ -z $PSQL_USER ]];
then
  echo $($PSQL "INSERT INTO player(username, games_played, best_game) VALUES('$USER', 1, $NUMBER_OF_GUESSES)")
else
  ((GAMES_PLAYED++))
  if [[ NUMBER_OF_GUESSES < BEST_GAME ]]; 
  then 
    NUMBER_OF_GUESSES=$BEST_GAME
  fi

  echo $($PSQL "UPDATE player SET games_played=$GAMES_PLAYED, best_game=$NUMBER_OF_GUESSES WHERE username='$PSQL_USER'")
fi

echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $NUMBER. Nice job!"
