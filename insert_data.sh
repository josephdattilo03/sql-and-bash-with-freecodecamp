#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOAL OPPONENT_GOAL
do
if [[ $YEAR -ne 'year' ]]
  then
  #Get winner id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  #If the winner team is not in the team database then add it
  if [[ -z $WINNER_ID ]]
    then
      ADD_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
  #Get opponent id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  #If the opponent team is not in the team database then add it
  if [[ -z $OPPONENT_ID ]]
    then
      ADD_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi
  INSERT_TEAM_RESULT=$($PSQL "INSERT INTO games(year,winner_id,opponent_id,winner_goals,opponent_goals,round) VALUES($YEAR,$WINNER_ID,$OPPONENT_ID,$WINNER_GOAL,$OPPONENT_GOAL,'$ROUND')")
fi
done