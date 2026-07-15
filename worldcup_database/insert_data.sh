#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# while IFS=',' read -r col1 col2; 
# do
#     echo "$col1 matches $col2"
# done < data.csv

tail -n +2 games.csv | while IFS=',' read year round w o wg op; 
do
    # teams
    echo $($PSQL "INSERT INTO teams(name) VALUES('$w') ON CONFLICT (name) DO NOTHING")
    echo $($PSQL "INSERT INTO teams(name) VALUES('$o') ON CONFLICT (name) DO NOTHING")

  # games
    W_TEAMID=$($PSQL "SELECT team_id FROM teams WHERE name='$w'")
    # echo $($PSQL "SELECT team_id FROM teams WHERE name='$w'")
    O_TEAMID=$($PSQL "SELECT team_id FROM teams WHERE name='$o'")

    # echo "$year, $round, $W_TEAMID, $O_TEAMID, $wg, $op"
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
            VALUES($year, '$round', $W_TEAMID, $O_TEAMID, $wg, $op)")
done