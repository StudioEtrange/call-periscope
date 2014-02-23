#!/bin/sh
#########################################################################
# Test: Script to invoke Periscope using Sick Beard's Parameters
# It should properly download subtitles for each finished / succesfully
# processed download. Well, in fact it does.
#
# Alvaro "Effenberg" Leal <AlvaroLeal.Backup@GMail.com>, 2011
# Get the latest code at http://code.google.com/p/call-periscope/
# Tweaked by Studio Etrange
#	* support 2 languages in the same time
#########################################################################

#SET THIS OR IT WILL NOT WORK
LANG1=fr
LANG2=en
PERISCOPE_BIN=periscope
CALL_PERISCOPE_LOG=/opt/call-periscope/CallPeriscope.log

#########################################################################

#Other Args / Variables. Leave it alone.
PROCESSED_EPISODE_FULL_PATH=$1
PROCESSED_EPISODE_PATH=`dirname "${1}"`
PROCESSED_EPISODE_FILE_NAME=`basename "${1}"`
ORIGINAL_EPISODE_NAME=`basename "${2}"`
PERISCOPE_LANG1="-l $LANG1"
PERISCOPE_LANG2="-l $LANG2"
PERISCOPE_OPTS="--lang-in-name -f -q '$ORIGINAL_EPISODE_NAME'"

PYCMD1="import os;os.rename('$PROCESSED_EPISODE_PATH' + os.sep + '$ORIGINAL_EPISODE_NAME'[:-4] + '.srt', '$PROCESSED_EPISODE_PATH' + os.sep + '$ORIGINAL_EPISODE_NAME'[:-4] + '.$LANG1.srt')"
PYCMD2="import os;os.rename('$PROCESSED_EPISODE_PATH' + os.sep + '$ORIGINAL_EPISODE_NAME'[:-4] + '.srt', '$PROCESSED_EPISODE_PATH' + os.sep + '$ORIGINAL_EPISODE_NAME'[:-4] + '.$LANG2.srt')"


#Debug - too see if its beeing invoked at all
date >> $CALL_PERISCOPE_LOG
echo Pre-invoking periscope -v to check that it is ok...
echo Periscope version: `$PERISCOPE_BIN --version` >> $CALL_PERISCOPE_LOG

#Check what we are gettiong from Sick Beard
echo CallPeriscope.sh Received arg 1: $1 >> $CALL_PERISCOPE_LOG
echo CallPeriscope.sh Received arg 2: $2 >> $CALL_PERISCOPE_LOG
echo CallPeriscope.sh Received arg 3: $3 >> $CALL_PERISCOPE_LOG
echo CallPeriscope.sh Received arg 4: $4 >> $CALL_PERISCOPE_LOG
echo CallPeriscope.sh Received arg 5: $5 >> $CALL_PERISCOPE_LOG

#Check if we processed it right and got what we needed
echo Processed args are: >> $CALL_PERISCOPE_LOG
echo Arg 1: $PROCESSED_EPISODE_FULL_PATH >> $CALL_PERISCOPE_LOG
echo Arg 2: $ORIGINAL_EPISODE_NAME >> $CALL_PERISCOPE_LOG
echo Processed Episode Path is $PROCESSED_EPISODE_PATH >> $CALL_PERISCOPE_LOG
echo Processed Episode File Name is $PROCESSED_EPISODE_FILE_NAME >> $CALL_PERISCOPE_LOG

#Now lets finally do something
echo Changing Directory to provided episode path... >> $CALL_PERISCOPE_LOG
echo From `pwd` >> $CALL_PERISCOPE_LOG
cd "${PROCESSED_EPISODE_PATH}"
echo To `pwd` >> $CALL_PERISCOPE_LOG
echo Invoking Periscope to original episode name $ORIGINAL_EPISODE_NAME >> $CALL_PERISCOPE_LOG
echo The final command line is: >> $CALL_PERISCOPE_LOG
echo $PERISCOPE_BIN $PERISCOPE_OPTS $PROCESSED_EPISODE_FILE_NAME >> $CALL_PERISCOPE_LOG
echo Invoking it now: >> $CALL_PERISCOPE_LOG


#Call Pesriscope with proper command line args - Now its not up to us
`$PERISCOPE_BIN $PERISCOPE_LANG1 $PERISCOPE_OPTS $PROCESSED_EPISODE_FILE_NAME >> $CALL_PERISCOPE_LOG`
python -c "$PYCMD1"
echo Renamed subtitle file with $LANG1 language >> $CALL_PERISCOPE_LOG

`$PERISCOPE_BIN $PERISCOPE_LANG2 $PERISCOPE_OPTS $PROCESSED_EPISODE_FILE_NAME >> $CALL_PERISCOPE_LOG`
python -c "$PYCMD2"
echo Renamed subtitle file with $LANG2 language >> $CALL_PERISCOPE_LOG

echo Settings right of all srt files >> $CALL_PERISCOPE_LOG
chmod 777 $PROCESSED_EPISODE_PATH/*.srt


#And exit
echo Exiting... >> $CALL_PERISCOPE_LOG
exit 0
