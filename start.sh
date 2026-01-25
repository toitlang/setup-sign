#!/bin/bash

# Determine the directory of the script
script_dir="$(dirname "$(readlink -f "$0")")"

password="$(cat $script_dir/password.secret)"
certum_sh="$script_dir/certum.sh"
pin_secret="$script_dir/pin.secret"
pkcs11_so="$script_dir/manager/sc30pkcs11-3.0.6.68-MS.so"
certificate="$script_dir/certificate.pem"
key=key="pkcs11:token=common%20profile;id=%D7%C7%8F%45%3A%CF%AA%35%79%1F%02%32%F3%51%46%5C%6D%16%AB%94;type=private"

$script_dir/server \
    --verbosity-level=debug \
    --password="$password" \
    --port=9876 \
    bash "$certum_sh" "$pin_secret" "$pkcs11_so" "$certificate" "$key"
