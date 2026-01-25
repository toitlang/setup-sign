# Signing server

Most of the instructions come from https://teonite.com/blog/windows-codesign-certum-hsm/

```
sudo pacman -S pcsclite pcsc-tools opensc acsccid libp11 ccid
yay -S osslsigncode
```

```
sudo systemctl enable pcscd.service
sudo systemctl enable pcscd.socket
```

The smart-card access is guarded by policy-kit.
I had to add the 50-smartcard-access.rules file together with the group 'smartcard-access':
```
sudo groupadd smartcard-access
sudo usermod -aG smartcard-access flo
```

Check that the smart-card reader and the card is recognized:
```
pcsc_scan
```
It should list the Certum Electronic Seal (PKI).

Download the proCertumCardManager and extract the .so file from it.

https://www.files.certum.eu/software/proCertumCardManager/Linux-Ubuntu/2.2.11/proCertumCardManager-2.2.11-x86_64-ubuntu.bin

When asked about the sudo-password just abort the process. The manager is already extracted.
```
chmod +x proCertumCardManager-2.2.11-x86_64-ubuntu.bin
./proCertumCardManager-2.2.11-x86_64-ubuntu.bin --keep --target $PWD/manager
```

The only file we need from the extracted manager is `sc30pkcs11-3.0.6.68-MS.so`.

Use it to get the key-id:
```
pkcs11-tool --module $PWD/manager/sc30pkcs11-3.0.6.68-MS.so --list-objects
```
If you don't get any public key information (just a "Using slot 0 with a present token (0x0)") then the
dynamic library wasn't used. Maybe the wrong dynamic library?

Get the certificate.pem from your account at Certum.

Note that we can't just use the URI that is given by pkcs11-tool, but need to insert a few '%'s.

Run osslsigncode as follows:
```
osslsigncode sign \
  -pkcs11module $PWD/manager/sc30pkcs11-3.0.6.68-MS.so \
  -certs certificate.pem \
  -key="pkcs11:token=common%20profile;id=%D7%C7%8F%45%3A%CF%AA%35%79%1F%02%32%F3%51%46%5C%6D%16%AB%94;type=private" \
  -pass "$CERT_PIN" \
  -h sha256 \
  -t http://time.certum.pl/ \
  -in unsigned.exe \
  -out signed.exe
```
