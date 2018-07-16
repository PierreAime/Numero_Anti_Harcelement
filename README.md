# Numero_Anti_Harcelement
Les scripts complets adaptés pour la Raspberry PI pour le numéro Anti Harcelement pour tous que le gouvernement français a fait annulé par la pression de Elliot Lepers, Clara Gonzales et Caroline de Haas.

# Programme Numero Anti Harcelement pour tous !
Logiciel et script permettant de faire de la prévention contre le harcelement pour tous et toutes.
Gestion automatique des SMS via des méthodes libres et open-sources

Composé en 3 parties :
numantiharcelement : demon dans /etc/init.d permettant de démarrer, redemarrer, stopper ou connaître l'état du logiciel
modem.sh : script dans /usr/bin, permettant d'initialiser le modem GSM/3G
antiv2.sh : version v2 de mon script, permettant :
- de simuler un "Coucou à la réception du SMS"
- de filtrer les numéros "hors France"
- d'envoyer les SMS de prévention
- de stopper les émissions de SMS au bout du 5eme recu par un meme numéro : anti SPAM

Par Pierre-Aimé IMBERT (pai.logicielslibres@gmail.com)

Ce(tte) œuvre est mise à disposition selon les termes de la licence Creative Commons Attribution :
- Pas d’Utilisation Commerciale
- Pas de modification ou refonte autorisée
- Nommer l'auteur (Pierre-Aimé IMBERT) dans le projet

https://creativecommons.org/licenses/by-nc-nd/4.0/
