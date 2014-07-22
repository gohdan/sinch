#!/bin/sh

ORIGIFS=$IFS
ORIGOFS=$OFS;

IFS=$(echo -en "\n\b")
OFS=$(echo -en "\n\b")

ROOT_PATH=$(cd $(dirname $0) && pwd);
CONF_PATH=$ROOT_PATH/config
SITE_PATH=$ROOT_PATH/sites


for i in `ls $CONF_PATH`; do

	if [ "example" != "$i" ]; then

		echo "====== SITE: $i ======"
		echo ''

		source $CONF_PATH/$i

		HOST_PATH=$SITE_PATH/$i

		if [ -e $HOST_PATH ]; then

			MASTER_PATH=$HOST_PATH/master
		
			if [ -e $MASTER_PATH ]; then

				CURRENT_PATH=$HOST_PATH/current
				if [ -e $CURRENT_PATH ]; then

					# FTP block

					FTPURL="ftp://$USER:$PASS@$HOST"

					lftp -c "set ftp:list-options -a;
					open '$FTPURL';
					lcd '$ROOT_PATH';
					lcd '$SITE_PATH';
					lcd '$CURRENT_PATH';
					cd '$RDIR';
					mirror -e --verbose --exclude-glob $EXCL
					bye"

					# end: FTP block

					diff -bqr $CURRENT_PATH $MASTER_PATH

					echo ''

				else
					echo "ERROR: no directory "$CURRENT_PATH
				fi

			else
				echo "ERROR: no directory $MASTER_PATH, create and put master copy there"
			fi

		else
			echo "ERROR: no directory "$HOST_PATH
		fi
	fi

done

IFS=$ORIGIFS
OFS=$ORIGOFS

