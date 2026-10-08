# EaglerPanel

This setup runs a Purpur 1.17.1 game server behind a Waterfall 1.20 proxy. It
expects Debian or Ubuntu and installs Java 17 with `apt-get`; the installer does
not upgrade or remove unrelated system packages. It uses the project's existing
Waterfall build 562; PaperMC marks Waterfall unsupported and archived.

## Install and run

From the project directory, run:

```sh
./install.sh
./paper.sh
```

Keep the game server running. In a second terminal, start the proxy:

```sh
./waterfall.sh
```

The proxy listens on port `25577` by default (see `waterfall/config.yml`). Open
that port in your firewall and connect players to it. The Paper server listens
on loopback at `127.0.0.1:25565` and is configured as the proxy's lobby; keep
that backend port private because it uses offline-mode behind the proxy.

Run the scripts from any working directory; they resolve files relative to
their own location. `paper.sh` defaults to an 8 GB heap and `waterfall.sh` to
4 GB. Override those defaults if needed, for example
`PAPER_MEMORY=4G ./paper.sh` and `WATERFALL_MEMORY=1G ./waterfall.sh`. The proxy
restarts after an unexpected failure; a clean exit or Ctrl+C stops it.
