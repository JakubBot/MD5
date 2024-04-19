source constants.sh

function isNumber2 {
  
  re='^[0-9]+$'
  if ! [[ $1 =~ $re ]] ; then
  # if not number return 0
    echo $FALSE
    # return $FALSE
  else
    echo $TRUE
  fi
}