#! /bin/bash
if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#Delete all rows from tables
echo $($PSQL "TRUNCATE teams, games")
#Read all fields of CSV
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_G OPPONENT_G
#Adding rows on TEAMS table
do
  #echo  $ROUND ' | '$WINNER $WINNER_G ' - ' $OPPONENT_G $OPPONENT
  TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER';")
  if [[ $WINNER != 'winner' ]]
    then
    if [[ -z $TEAMS ]]
    then
      ADD_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      if [[ ADD_TEAM=="INSERT 0 1" ]]
        then
        echo "$WINNER added to TEAMS"
      fi
    fi
  fi
  
  TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT';")
  if [[ $OPPONENT != 'opponent' ]]
    then
    if [[ -z $TEAMS ]]
    then
      ADD_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
      if [[ ADD_TEAM == "INSERT 0 1" ]]
        then
        echo "$OPPONENT added to TEAMS"
      fi
    fi
  fi


WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
if [[ -n $WIN_ID || -n $OPP_ID ]]
  then
  if [[ $YEAR != 'year' ]]
    then
    ADD_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WINNER_G, $OPPONENT_G);")
    if [[ ADD_GAME == "INSERT 0 1" ]]
      then
      echo "Game $WINNER - $OPPONENT added"  
    fi
  fi
fi
done