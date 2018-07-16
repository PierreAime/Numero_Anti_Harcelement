#!/bin/sh

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

echo "Initialisation du modem 3G que je possedes."
sudo usb_modeswitch -v 0x12d1 -p 0x1446 -M 55534243123456780000000000000011060000000000000000000000000000
sleep 5

echo " "
echo "Identification du modem"
sudo gammu -c /root/.gammurc identify
sleep 5

echo " "
echo "Deverouillage de la carte SIM avec le code PIN"
sudo gammu entersecuritycode PIN 0000

echo " "
echo "Fin de l'initialisation du modem"
