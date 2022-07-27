#!/bin/bash
echo NB

string=''

if [ -n $string ]
then
  echo True #not outputted
fi

string=''

if [[ -n $string ]]
then
  echo True
fi

echo ex 0

integer_1=10
integer_2=10

if [[ $integer_1 -eq $integer_2 ]]
then
  # we can combine variables and string with `echo`
  echo $integer_1 and $integer_2 are the same!
fi

echo
echo ex 1 #nested if

integer=4

if [[ $integer -lt 10 ]]
then
  echo $integer is less than 10
  if [[ $integer -lt 5 ]]
  then
    echo $integer is also less than 5
  fi
fi

#ex 2 skipped

echo
echo ex 3 #elif, else

integer=15

if [[ $integer -lt 10 ]]
then
  echo $integer is less than 10
elif [[ $integer -gt 20 ]]
then
  echo $integer is more than 20
else
  echo $integer is between 10 and 20
fi

echo
echo ex 4 # && (and)

integer=11

if [[ $integer -gt 10 ]] && [[ $integer -lt 20 ]]
then
  echo $integer is between 11 and 19
fi

echo
echo ex 5 # || (or)

integer=12

if [[ $integer -lt 5 ]] || [[ $integer -gt 10 ]]
then
  echo $integer is less than 5 or more than 10
fi

echo
echo ex 6 # ! (not, in context of a test) NB: use parentheses

integer=8

if ! ([[  $integer -lt 5 ]] || [[ $integer -gt 10 ]])
then
  echo $integer is between 5 and 10
fi
