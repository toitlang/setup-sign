# Sign server

## Cloudflare tunnel
Set up the cloudflare tunnel to contact our signing service on
port 9876 (`http://localhost:9876`).

## Service
We are using 'screen' to keep the sign-service running when the ssh sessions ends.

The signing service isn't yet started automatically.

Run
```
screen -d -m -S sign sign/start.sh
```

Use `screen -ls` to see all screens that are already running, and use
`screen -d -r SESSION` to attach to it (detaching first if necessary).

Example:
```
$ screen -ls
There is a screen on:
        35329.sign      (Detached)
1 Socket in /home/flo/.screen.

$ screen -d -r sign
```

### Detach
Use ctrl-a,ctrl-d to leave a screen session without terminating it.
