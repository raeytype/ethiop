#!/bin/bash

# /usr/local/opt/python\@3.14/libexec/bin/python mf2ff.py

export PYTHONPATH="/usr/local/Cellar/fontforge/20251009_1/lib/python3.14/site-packages/"

ffpython=/usr/local/opt/python\@3.14/libexec/bin/python

#
# Expected usages:  ./convert-mf.sh metafont
#

if [[ "$1" ]]; then
	echo "ARG: $1"
else
	echo "Missing argument for input directory."
	exit
fi

logdir="otf/logs"
if [ ! -d $logdir ]; then
	mkdir -p $logdir
fi

ls -d $1/* |
while read dir
do
	if [[ -d $dir && $dir != "$1/letters" ]] ; then
		# echo "DIR: $dir"
		ls $dir/*.mf  |
		while read file
		do
			# echo "    FILE: $file"
			outfile=`echo $file | cut -d/ -f3 | cut -d. -f1`
			outdir=`echo $file | cut -d/ -f2`
			if [ ! -d $outdir ]; then 
				mkdir -p $outdir
			fi
			outfile="otf/$outdir/$outfile.otf"
			logfile=`echo $file | cut -d/ -f3`
			logfile="$logdir/$logfile.log"

			# echo "    OUTFILE: $outfile"
			# echo "    LOGFILE: $logfile"

			$ffpython mf2ff.py -otf $file
			rm $logfile
		done
	fi
done


