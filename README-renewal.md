# Renewal

## Certum Product
Buy an "Open Source Code Signing - code". I bought mine for Eur 31.25 (25 + taxes).

Provide the requested information at https://certmanager.certum.pl/dashboard.
Specifically, the open-source status, ...
Verification can take a few days.

## Activation
Requires a Windows/macosx machine (or VM). If using a VM see https://knowledge.broadcom.com/external/article/323394.

If using a Windows machine (borrowed?):
- Install proCertum CardManager: https://support.certum.eu/en/cert-offer-card-manager/
  The 4.14.0 version also installs SimplySign (which we need?).

Go to activate. This will launch the Certum apps from the browser.

Activation should be straight forward at this point.

Don't forget to install the new certificate on the USB dongle.

## Update of the sign server
Use `pkcs11-tool --module $PWD/manager/sc30pkcs11-3.0.6.68-MS.so --list-objects` to get the new ID of the certificate.
You can match the Certificate serial number (on the Certum page) with the "serial" of the printed output.

Take the id of the new certificate and replace the old ID in the `start.sh`. Note that you will need to add plenty of '%'s.

Finally, download the PEM of the new certificate (from the CERTUM page) and replace the existing certificate.pem.

You need to restart the server after all of that: `sudo systemctl restart toit-sign.service`
