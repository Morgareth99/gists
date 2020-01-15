#!/usr/bin/env bash

dnscount=0
dnsnames=(x12345.foo.bar.org x2345.foo.bar.org x3456.foo.bar.org)

csrdetails=$(mktemp)

export country=DE
export state=Hessen
export location="Frankfurt am Main"
export organization="Foobar eG"
export organization_unit="IT"
export email="info@foobar.org"
export domain="${dnsnames[0]}"

cat > ${csrdetails} <<-EOF
[req]
default_bits = 4096
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C=${country}
ST=${state}
L=${location}
O=${organization}
OU=${organization_unit}
emailAddress=${email}
CN=${domain}

[ req_ext ]
subjectAltName = @SAN

[ SAN ]
EOF
  
echo -n "subjectAltName=" >> $csrdetails

for i in "${dnsnames[@]}"; do
  let j=${dnscount}+1
  echo -n "DNS.${j}:${dnsnames[$dnscount]}" >> "${csrdetails}"
  echo -n "," >> $csrdetails
  let dnscount+=1
done
echo >> $csrdetails

sed -i 's/,$//g' $csrdetails

echo
echo "=== CSR will be written to file: ${domain}_SAN.csr"
echo "=== CRT will be written to file: ${domain}_SAN.crt"
echo
openssl req -reqexts SAN -extensions SAN -x509 -new -sha256 -nodes -out ${domain}_SAN.crt -newkey rsa:4096 -keyout ${domain}.key -config ${csrdetails}

rm ${csrdetails}




