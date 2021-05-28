#!/bin/bash
#Reads a csv file with a single column and no header line by line and replaces the specified lines that match the variables
file=$1;
char=['!:@#$%^&*()_+'];
# endOfTheLine=$mline | awk '{print $2}';
email0Line='"email_verified": 0';
email0Update='"email_verified": false';
email1Line='"email_verified": 1';
email1Update='"email_verified": true';
pictureLine='"picture": null,';
pictureUpdate='"picture": "https://tongal.s3.amazonaws.com/resources/images/profile-pictures/default.jpg",';
yellow=`tput setaf 3`;
nc=`tput sgr0`;

function replaceInline() {
  echo "Hello $file";
  #Ignore the header
  # exec < $file;
  # read header;
  filesUpdated=0;
  
  #Remove log files if they exist
  if [[ -f results.txt ]];
  then
    rm results.txt;
  fi

  if [[ -f result-errors.txt ]];
  then
    rm result-errors.txt;
  fi

  # If the .csv list exists, proceed
  if [[ -f $file ]];
  then
    while IFS="," read -r json_file 
    do
      if [[ -f $json_file ]];
      then
        echo ${yellow}"Working on it ...."${nc};

        while IFS=$'\n' read -r mline;
        do
          # email_verifiedValue=$mline | awk '{print $2}';
          if [[ "$mline" =~ $email0Line ]];
          then
            # echo "found a match for email verified 0: $mline";
            # the @ before the 's' is the delimiter.  It can be anything you want such as a |
            # This was done to prevent the script from choking on values that contained double quotes
            sed -i "s@$mline@$email0Update@" $json_file;
            filesUpdated=`expr $filesUpdated + 1`;
          fi

          if [[ "$mline" =~ $email1Line ]];
          then
            # echo "found a match for email verified 1: $mline";
            sed -i "s@$mline@$email0Update@" $json_file;
            filesUpdated=`expr $filesUpdated + 1`;
          fi

          if [[ "$mline" =~ $pictureLine ]];
          then
            # echo "found a picture: $mline";
            sed -i "s@$mline@$pictureUpdate@" $json_file;
            filesUpdated=`expr $filesUpdated + 1`;
          fi

        done < $json_file
        wait
        touch results.txt;
        echo "The process has finished with a total of $filesUpdated lines updated including the $json_file file";
        echo "The process has finished with a total of $filesUpdated lines updated including the $json_file file" >> results.txt;
        else
          touch result-errors.txt;
          echo "The $json_file file listed within the supplied .csv file does not exist";
          echo "The $json_file file listed within the supplied .csv file does not exist" >> result-errors.txt;
      fi
    done < $file
    wait
    else 
      echo "The supplied .csv file containing the list of JSON files does not exist.";
  fi
}

replaceInline