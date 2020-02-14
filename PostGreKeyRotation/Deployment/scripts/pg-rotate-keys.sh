#!/bin/bash

ACTIVEROLE=$1

if [ -z "${ACTIVEROLE}" ]; then
    echo "Usage:  $0 <active role>"
    exit 1;
else
    echo "ACTIVEROLE: ${ACTIVEROLE}"

    PGSERVER=${PGSERVER:-"<database-server-name>"}
    PGDB=${PGDB:-"<database-name>"}
    PGUSER=${PGUSER:-"<database-admin-role>@<database-server-name>"}
    KEYVAULTNAME=${KEYVAULTNAME:-"jwrotatekeyvault"}

    export PGPASSWORD="MyB@dP2\$\$wd"

    KEYVAULTSECRETNAME="pgmainbluepwd"

    INACTIVEROLE="pgapproleblue"
    if [ "${ACTIVEROLE}" == "pgapproleblue" ]; then
        INACTIVEROLE="pgapprolegreen"
        KEYVAULTSECRETNAME="pgmaingreenpwd"
    fi

    echo ""
    echo "Changing password and activating login for role: ${INACTIVEROLE}"

    NEWPWD=$(openssl rand -base64 32)

    SQL="ALTER ROLE ${INACTIVEROLE} WITH PASSWORD '${NEWPWD}'; ALTER ROLE ${INACTIVEROLE} WITH LOGIN;"

    echo ""
    echo "------------------------------------------"
    echo "psql output:"
    echo "------------------------------------------"
    echo ""

    psql "sslmode=require host=${PGSERVER} dbname=${PGDB} user=${PGUSER}" -c "${SQL}"

    echo ""
    echo "------------------------------------------"

    echo ""
    echo "Setting ${KEYVAULTSECRETNAME}"
    echo ""
    echo "------------------------------------------"
    echo "az keyvault output:"
    echo "------------------------------------------"
    echo ""

    az keyvault secret set --vault-name "${KEYVAULTNAME}" --name "${KEYVAULTSECRETNAME}" --value "${NEWPWD}"

    echo ""
    echo "------------------------------------------"
fi
