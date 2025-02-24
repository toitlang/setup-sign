# Signing server

Most of the instructions come from https://teonite.com/blog/windows-codesign-certum-hsm/

```
sudo apt install opensc opensc-pkcs11 libpcsclite-dev pcscd libacsccid1 \
    libengine-pkcs11-openssl osslsigncode
```

```
sudo systemctl enable pcscd.service
sudo systemctl enable pcscd.socket
```

Also recommended:
```
sudo apt install pcsc-tools
```

We also installed libccid. Not 100% sure it was necessary.
```
sudo apt install libccid
```

The smart-card access on Ubuntu is guarded by policy-kit.
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

------
Not done yet. Probably not needed.

Copy the `manager/cryptoCertum3PKCS-3.0.6.69-MS.so` to `/usr/lib/libcryptoCertum3PKCS.so`
and symlink it to `/usr/lib/libcrypto3PKCS.so`
```
sudo cp manager/cryptoCertum3PKCS-3.0.6.69-MS.so /usr/lib/libcryptoCertum3PKCS.so
sudo ln -s /usr/lib/usr/lib/libcryptoCertum3PKCS.so /usr/lib/libcrypto3PKCS.so
```
