#!/bin/bash

# Determine the directory of the script
script_dir="$(dirname "$(readlink -f "$0")")"

password="$(cat $script_dir/password.secret)"
key=d7c78f453acfaa35791f0232f351465c6d16ab94
certificate="$script_dir/certificate.pem"

$script_dir/server \
    --verbosity-level=debug \
    --password="$password" \
    --port=9876 \
    bash certum.sh pin.secret "$script_dir/manager/sc30pkcs11-3.0.6.68-MS.so" $certificate $key
