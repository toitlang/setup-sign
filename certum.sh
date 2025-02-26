#!/bin/bash

# Check if the correct number of arguments are provided.
# The unsigned executable and signed executable must be the last arguments.
if [ $# -ne 6 ]; then
  echo "Usage: $0 <cert_pin_file> <pkcs11_module> <certificate.pem> <key> <unsigned_executable> <signed_executable>"
  exit 1
fi

cert_pin_file="$1"
shift
pkcs11_module="$1"
shift
certificate="$1"
shift
key="$1"
shift
unsigned_exe="$1"
shift
signed_exe="$1"

# Check if the input files exist.
if [ ! -f "$unsigned_exe" ]; then
  echo "Error: Unsigned executable not found: $unsigned_exe"
  exit 1
fi

if [ ! -f "$cert_pin_file" ]; then
  echo "Error: CERT_PIN file not found: $cert_pin_file"
  exit 1
fi

if [ ! -f "$pkcs11_module" ]; then
  echo "Error: PKCS#11 module not found: $pkcs11_module"
  exit 1
fi

# Read the CERT_PIN from the file.
CERT_PIN=$(cat "$cert_pin_file")

# Run the osslsigncode command.
osslsigncode sign \
  -pkcs11module "$pkcs11_module" \
  -certs "$certificate" \
  -key "$key" \
  -pass "$CERT_PIN" \
  -h sha256 \
  -t http://time.certum.pl/ \
  -in "$unsigned_exe" \
  -out "$signed_exe"

# Check the return code of osslsigncode.
if [ $? -ne 0 ]; then
  echo "Error: osslsigncode failed."
  exit 1
fi

echo "Successfully signed $unsigned_exe and saved as $signed_exe"

exit 0
