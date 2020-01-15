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
subjectAltName = @alt_names

[ alt_names ]
EOF

for i in "${dnsnames[@]}"; do
  let j=${dnscount}+1
  echo "DNS.${j} = ${dnsnames[$dnscount]}" >> "${csrdetails}"
  let dnscount+=1
done

echo "Writing to CSR file: ${domain}.csr"
openssl req -new -sha256 -nodes -out ${domain}.csr -newkey rsa:4096 -keyout ${domain}.key -config ${csrdetails}

rm ${csrdetails}




