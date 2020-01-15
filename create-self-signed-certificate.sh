#!/usr/bin/env bash

# GitHub: @netzverweigerer

# specify PEM key size (default: 2048, consider using 4096 here)
keysize=4096

# number of days the certificate will be valid for (3650 = 10 years)
days=3650

usage () {
  echo "USAGE: $0 <domain name> <generic name> <email address>"
}

msg () {
  tput setaf 6
  echo ">>> $@"
  tput sgr0
}

if [[ "$#" -ne 3 ]]; then
  usage
  exit 1
fi

# use arguments from commandline
domain="$1"
shift
name="$1"
shift
email="$1"
shift

keyfile="${domain}.key"
csrfile="${domain}.csr"
crtfile="${domain}.crt"

if [[ -e "${keyfile}" ]]; then
  msg "ERROR: Key file ${keyfile} already exists. Exiting."
  exit 100
fi

if [[ -e "${csrfile}" ]]; then
  msg "ERROR: CSR file ${csrfile} already exists. Exiting."
  exit 100
fi

if [[ -e "${crtfile}" ]]; then
  msg "ERROR: Certificate file ${crtfile} already exists. Exiting."
  exit 100
fi

msg "Writing new private key file to: ${keyfile}"
msg "Writing CSR file to: ${keyfile}"

msg "Creating CSR ..."
openssl req -newkey rsa:${keysize} -sha256 -nodes -subj "/C=DE/ST=${name}/L=${name}/O=${name}/OU=${name}/CN=${domain}/emailAddress=${email}/subjectAltName=${domain}" -keyout "${keyfile}" -out "${csrfile}"

msg "Signing CSR ..."
openssl x509 -in ${csrfile} -out ${crtfile} -req -signkey ${keyfile} -days ${days}

if [[ -f "$crtfile" ]]; then
  msg "Operation done. This is the created certificate file: "
  ls -al "${crtfile}"
else
  msg "ERROR: Certificate file could not be created. Exiting."
  exit 255
fi



