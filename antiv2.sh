#!/bin/sh

# Programme Numero Anti Harcelement pour tous !
# Logiciel et script permettant de faire de la prévention contre
# le harcelement pour tous et toutes.
# Gestion automatique des SMS via des méthodes libres et open-sources

# Par Pierre-Aimé IMBERT (pai.logicielslibres@gmail.com)

# Ce(tte) œuvre est mise à disposition selon les termes de la
# Licence Creative Commons Attribution :
# - Pas d’Utilisation Commerciale
# - Pas de modification ou refonte autorisée
# - Nommer l'auteur (Pierre-Aimé IMBERT) dans le projet
# https://creativecommons.org/licenses/by-nc-nd/4.0/


echo "Initialisation du modem GSM"
/usr/bin/modem.sh

echo "Montage de la cle USB"
sudo mkdir -p /media/SMS
sudo mount /dev/sda1 /media/SMS
sudo chmod -R 777 /media/SMS

sudo rm -R /media/SMS/sms.log
sudo rm -R /media/SMS/ram.log
sudo rm -R /media/SMS/TEST
sudo rm -R /media/SMS/system.csv

while true;do

	echo "####################" >> /media/SMS/ram.log
	echo "Reinitialisation buffers et cache memoire"
	free
	sync
	sudo echo 1 > /proc/sys/vm/drop_caches
	sudo echo 2 > /proc/sys/vm/drop_caches
	sudo echo 3 > /proc/sys/vm/drop_caches
	free >> /media/SMS/ram.log

	gammu getallsms > /media/SMS/LISTE
	grep Location /media/SMS/LISTE > /media/SMS/LISTE2
	sed -i '1d' /media/SMS/LISTE2
	sed -i s/', folder "Inbox", SIM memory, Inbox folder'//g /media/SMS/LISTE2
	sed -i s/'Location '//g /media/SMS/LISTE2

	while [ -s /media/SMS/LISTE2 ]
		do

		export o=`head -n 1 /media/SMS/LISTE2`

		gammu getsms 1 $o > /media/SMS/SMS
		grep "Remote number" /media/SMS/SMS > /media/SMS/TEST

		sed -i 's/Remote number        : //g' /media/SMS/TEST
		sed -i 's/"//g' /media/SMS/TEST
		export NUMSMS=`cat /media/SMS/TEST`
		export NUMSMSVALABLE=`cat /media/SMS/TEST | grep +336`
		export NUMSMSVALABLES=`cat /media/SMS/TEST | grep +337`

		grep "SMSC number" /media/SMS/SMS > /media/SMS/TEST2
		sed -i 's/SMSC number          : //g' /media/SMS/TEST2
		sed -i 's/"//g' /media/SMS/TEST2
		export NUMSMSCENTER=`cat /media/SMS/TEST2 | grep +33`

		export NUMSMSCHAR=`cat /media/SMS/TEST | wc -m`

		if [ -z "${NUMSMSVALABLE}" ] && [ -z "${NUMSMSVALABLES}" ] ; then
			echo "SMS RECU : ${NUMSMS} Numero NON National OU NON Valide ! Classement dans les SPAMS" >> /media/SMS/sms.log
			echo "Archivage du message" >> /media/SMS/sms.log
			cat /media/SMS/SMS >> /media/SMS/SPAM/spam.txt
		elif [ -z "${NUMSMSCENTER}" ] ; then
			echo "SMS RECU : ${NUMSMS} Numero NON National OU NON Valide ! Classement dans les SPAMS" >> /media/SMS/sms.log
			echo "Archivage du message" >> /media/SMS/sms.log
			cat /media/SMS/SMS >> /media/SMS/SPAM/spam.txt
		elif [ "${NUMSMSCHAR}" -ne "13" ] ; then
			echo "SMS RECU : ${NUMSMS} Numero NON National OU NON Valide ! Classement dans les SPAMS" >> /media/SMS/sms.log
			echo "Archivage du message" >> /media/SMS/sms.log
			cat /media/SMS/SMS >> /media/SMS/SPAM/spam.txt
		else
			grep -i -e "arcelement" -i -e "arcélement" -i -e "arcèlement" -i -e "HARCELEMENT" -i -e "harcelement" -i -e "harcélement" -i -e "Harcélement" -i -e "harcèlement" -i -e "Harcèlement" /media/SMS/SMS > /media/SMS/AIDESLOG
			sed -i 's/HARCELEMENT//g' /media/SMS/AIDESLOG
			sed -i 's/Harcelement//g' /media/SMS/AIDESLOG
			sed -i 's/harcelement//g' /media/SMS/AIDESLOG
			sed -i 's/harcélement//g' /media/SMS/AIDESLOG
			sed -i 's/Harcélement//g' /media/SMS/AIDESLOG
			sed -i 's/Harcèlement//g' /media/SMS/AIDESLOG
			sed -i 's/harcèlement//g' /media/SMS/AIDESLOG
			sed -i 's/arcèlement//g' /media/SMS/AIDESLOG
			sed -i 's/arcélement//g' /media/SMS/AIDESLOG
			sed -i 's/arcelement//g' /media/SMS/AIDESLOG
			sed -i 's/\.//g' /media/SMS/AIDESLOG
			sed -i 's/\;//g' /media/SMS/AIDESLOG
			sed -i 's/\,//g' /media/SMS/AIDESLOG
			sed -i 's/\://g' /media/SMS/AIDESLOG
			sed -i 's/\ //g' /media/SMS/AIDESLOG
			export TESTALGO=`cut -c1-2 /media/SMS/AIDESLOG | grep -E '06|07'`
			export TESTALGOO=`cat /media/SMS/TEST | wc -m`
			if [ -z "${TESTALGO}" ] && [ "${TESTALGOO}" -ne "11" ] ; then
				mkdir -p /media/SMS/${NUMSMS}
				echo "NHGAMMUFOIS" >> /media/SMS/${NUMSMS}/sms.txt
				export NUMSMSTEST=`grep -o NHGAMMUFOIS /media/SMS/${NUMSMS}/sms.txt | wc -l`
				cat /media/SMS/SMS >> /media/SMS/${NUMSMS}/sms.txt

				if [ "${NUMSMSTEST}" -eq "1" ]; then
					echo "SMS RECU : ${NUMSMS} Envoi du message preventif" >> /media/SMS/sms.log
					gammu sendsms TEXT ${NUMSMS} -text "Vous recevez ce message car votre interlocuteur(trice) estime que vous l'harceliez. Veuillez ne plus l'importuner ainsi !" >> /media/SMS/sms.log
				fi

				if [ "${NUMSMSTEST}" -eq "2" ] || [ "${NUMSMSTEST}" -eq "3" ] || [ "${NUMSMSTEST}" -eq "4" ]; then
					echo "SMS RECU : ${NUMSMS} Envoi du message avertissement" >> /media/SMS/sms.log
					gammu sendsms TEXT ${NUMSMS} -text "Ce n'est pas la 1ere fois que votre interlocuteur(trice) estime que vous l'harceliez. Veuillez ne plus l'importuner ainsi !" >> /media/SMS/sms.log
				fi

				if [ "${NUMSMSTEST}" -eq "5" ]; then
					echo "SMS RECU : ${NUMSMS} Envoi du message alerte" >> /media/SMS/sms.log
					gammu sendsms TEXT ${NUMSMS} -text "Suite à de nombreux signalements d'harcelement, vous risquez des poursuites judiciaires !" >> /media/SMS/sms.log
				fi

				if [ "${NUMSMSTEST}" -ge "6" ]; then
					echo "SMS RECU : ${NUMSMS} Classement du SMS uniquement car depasse le niveau alerte" >> /media/SMS/sms.log
					echo "Archivage du message" >> /media/SMS/sms.log
				fi
			else
				mkdir -p /media/SMS/AIDES
				echo "NHGAMMUFOIS" >> /media/SMS/AIDES/aides.txt
				cat /media/SMS/SMS >> /media/SMS/AIDES/aides.txt
				export NUMAIDES=`cat /media/SMS/AIDESLOG`
				echo "SMS RECU POUR LEURRER : ${NUMAIDES} Envoi du message" >> /media/SMS/sms.log
				gammu sendsms TEXT ${NUMAIDES} -text "Coucou ^^" >> /media/SMS/sms.log
			fi
		fi
		gammu deletesms 1 $o
		sed -i '1d' /media/SMS/LISTE2
		rm -R /media/SMS/TEST2
		rm -R /media/SMS/SMS
		rm -R /media/SMS/TEST
	done
done
