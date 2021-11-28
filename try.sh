#! /bin/bash 

export TRY_INTERVAL=5
export TRY_NUMBER=12 

default_interval=5
default_number=12


check_interval_value( ) {

if [[ -z "$interval" ]];then
    if [[ ! -z "$TRY_INTERVAL" ]];then
      interval=$TRY_INTERVAL
    else
      interval=$default_interval  
    fi
fi
}


check_number_value( ) {

if [[  -z "$number" ]];then
    if [[ ! -z "$TRY_NUMBER" ]];then
      number=$TRY_NUMBER
    else
      number=$default_NUMBER 
    fi
fi
}

check_commnad_value( ) {
if [[ -z "$cm" ]];then
  echo "there is no command to run"
  exit 1
fi	
}

while getopts i:n:c: flag
do
    case "${flag}" in
        i) interval=${OPTARG};;
        n) number=${OPTARG};;
        c) cm=${OPTARG};;
    esac
done

check_interval_value
check_number_value
check_commnad_value

($cm) &> /dev/null
if [[ $? -eq 0 ]];then
	exit 0  
else
  for n in $(eval echo {1..$number} );do
    ($cm) &> /dev/null
    if [[ $? -eq 0 ]];then
	exit 0 
    else	
    	echo "trying to run the commnad... $n"
	sleep $interval
    fi
  done
  echo "There is some problems to run this command" >&2  
  exit 1
fi
