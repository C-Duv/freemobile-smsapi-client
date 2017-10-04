#!/bin/sh

#
# Script d'envoi de notification SMS via l'API Free Mobile
# https://github.com/C-Duv/freemobile-smsapi-client
#
# Auteur: DUVERGIER Claude (http://claude.duvergier.fr)
#
# Nécessite: sed, sh et wget
#
# Possible usages: see usage_help()


readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))

usage_error () {
    echo "ERROR: ${1}" >&2
    echo ""
    usage_help
    exit 1
}

usage_help () {
    echo "Possible usages:"
    echo "* ${PROGNAME} [options] [message]"
    echo "* echo \"All your base are belong to us\" | ${PROGNAME} [options]"
    echo ""
    echo "Options:"
    echo "* -c file    specify configuration file"
    echo "* -h         display this help"
}

CONFIG_FILE=""
while getopts "c:h" option; do
    case "$option" in
        c) CONFIG_FILE=${OPTARG} ;;
        :) usage_error "Invalid arguments" ;;
        h) usage_help ; exit 0 ;;
    esac
done
shift $((OPTIND-1))


##
## Configuration système
##

# Caractère de fin de ligne
# (http://en.wikipedia.org/wiki/Percent-encoding#Character_data)
NEWLINE_CHAR="%0D" # Valeurs possibles : %0A, %0D et %0D%0A

# URL d'accès à l'API
SMSAPI_BASEURL="https://smsapi.free-mobile.fr"

# Action d'envoi de notification
SMSAPI_SEND_ACTION="sendmsg"


##
## Configuration utilisateur
##

# Login utilisateur / identifiant Free Mobile (celui utilisé pour accéder à
# l'Espace Abonné)
USER_LOGIN="1234567890"

# Clé d'identification (générée et fournie par Free Mobile via l'Espace Abonné,
# "Mes Options" : https://mobile.free.fr/moncompte/index.php?page=options)
API_KEY="s0me5eCre74p1K3y"

# Texte qui sera ajouté AVANT chaque message envoyé
MESSAGE_HEADER="Notification :
"

# Texte qui sera ajouté APRÈS chaque message envoyé
MESSAGE_FOOTER="
--
Le serveur de la maison"


##
## Fichier de configuration
##

if [ -n "${CONFIG_FILE}" ]; then
    if [ -e "${CONFIG_FILE}" ]; then
        . "${CONFIG_FILE}"
    else
        echo "ERROR: Configuration file \"${CONFIG_FILE}\" does not exists." >&2
        exit 2
    fi
else
    if [ -e "${PROGDIR}/.freemobile-smsapi" ]; then
        . "${PROGDIR}/.freemobile-smsapi"
    elif [ -e "${HOME}/.freemobile-smsapi" ]; then
        . "${HOME}/.freemobile-smsapi"
    fi
fi


##
## Vérifications des paramètres requis
##

if [ -z "${USER_LOGIN}" ] \
    || [ -z "${API_KEY}" ] \
    || [ -z "${SMSAPI_BASEURL}" ] \
    || [ -z "${SMSAPI_SEND_ACTION}" ] \
; then
    echo "ERROR: Either USER_LOGIN, API_KEY, SMSAPI_BASEURL or " \
         "SMSAPI_SEND_ACTION is not set" >&2
    exit 2
fi


##
## Traitement du message
##

MESSAGE_TO_SEND=""
if [ "${1}" ]; then # Message en tant qu'argument de la ligne de commande
    MESSAGE_TO_SEND="${1}"
else # Message lu de STDIN
    while read line
    do
        MESSAGE_TO_SEND="${MESSAGE_TO_SEND}${line}\n"
    done
    MESSAGE_TO_SEND=${MESSAGE_TO_SEND%"\n"} # Retire le dernier saut de ligne
fi

# Assemble header, message et footer
FINAL_MESSAGE_TO_SEND="${MESSAGE_HEADER}${MESSAGE_TO_SEND}${MESSAGE_FOOTER}"

##
## Appel à l'API (envoi)
##

# echo "Will send the following to ${USER_LOGIN}:" #DEBUG
# echo "${FINAL_MESSAGE_TO_SEND}" #DEBUG

# Converts newlines to $NEWLINE_CHAR
FINAL_MESSAGE_TO_SEND=$(\
    echo -n "${FINAL_MESSAGE_TO_SEND}" | \
    sed '{:q;N;s/\n/'${NEWLINE_CHAR}'/g;t q}'\
)
# echo "Newline encoded message:" #DEBUG
# echo "${FINAL_MESSAGE_TO_SEND}" #DEBUG

# Particularités de l'appel de curl et la/les options associées :
# * Renvoi le code réponse HTTP uniquement :
#       --write-out "%{http_code}" --silent --output /dev/null
#
HTTP_STATUS_CODE=$(\
    curl \
        --write-out "%{http_code}" \
        --silent \
        --output /dev/null \
        --get "${SMSAPI_BASEURL}/${SMSAPI_SEND_ACTION}" \
        --data "user=${USER_LOGIN}" \
        --data "pass=${API_KEY}" \
        --data "msg=${FINAL_MESSAGE_TO_SEND}" \
)

# Codes réponse HTTP possibles
# 200 : Le SMS a été envoyé sur votre mobile.
# 400 : Un des paramètres obligatoires est manquant.
# 402 : Trop de SMS ont été envoyés en trop peu de temps.
# 403 : Le service n'est pas activé sur l'espace abonné, ou login / clé
#       incorrect.
# 500 : Erreur côté serveur. Veuillez réessayez ultérieurement.

if [ "${HTTP_STATUS_CODE}" -eq 200 ]; then
    # echo "API responded with 200: exiting with 0" #DEBUG
    exit 0
else
    echo "Error: API responded with ${HTTP_STATUS_CODE}"
    exit 1
fi
