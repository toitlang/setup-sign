# Sign server

## Cloudflare tunnel
Set up the cloudflare tunnel to contact our signing service on
port 9876 (`http://localhost:9876`).

### Install cloudflared

sudo pacman -S cloudflared

Make sure to enable/start the service. (Not 100% if necessary,
or if calling `cloudflared service install` does it for us).
```
sudo systemctl enable cloudflared.service
sudo systemctl start cloudflared.service
```

You can verify the status with
```bash
systemctl status cloudflared.service
```

### Store the credentials
Save the pin (password for the smart-card) in a file `pin.secret`.

Store the server password (used by the signing action) in `password.secret`.


### Install the signing server
Compile the `main.toit` from
https://github.com/toitlang/action-sign-server/tree/main/server
and save it as `server`. The [start-script](./start.sh) will run it
with the correct parameters, using the `pin.secret` and `password.secret`.

### Set up the forwarding
Create a tunnel at
https://one.dash.cloudflare.com/aa65eefaafad855c94b5b2b237e6dcc3/networks/tunnels

Configure the public hostname sign.toit.io to point to the service
http://localhost:9876.

## Service
Copy the `toit-sign.service.template` to `toit-sign.service` and
adjust it (replacing the username, and maybe the location of the
script).

Copy the service script to /etc/systemd/system/
```bash
sudo cp toit-sign.service /etc/systemd/system
```

Reload the systemd daemon to register the new service:
```bash
sudo systemctl daemon-reload
```

Enable and start the service. Then check if it is running correctly.
```bash
sudo systemctl enable toit-sign.service
sudo systemctl start toit-sign.service
sudo systemctl status toit-sign.service
```
