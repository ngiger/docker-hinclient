# Dokumentation des Aufsetzten eines HIN-Clients

Vorgängig muss aus einem Windows oder Mac der Zugang zum HIN konfiguriert werden, da HIN leider Linux nur halbwegs unterstützt.

Der ganze Setup basiert auf einem Shell Script von Fabian Schmid, das man als Referenz unter [client.sh](client.sh) anschauen kann.

## Stand August 2017

Gemäss einer Aussage des HIN-Support läuft die akutelle HIN-Client Version für Linux (1.5.3-50) nur mir der OpenJDK 8u121b13

    Besten Dank für Ihre Anfrage. Das Problem ist wie Sie bereits vermutet haben nicht Ihre Internet Verbindung.
    Mit der Aktuellsten OpenJDK und OracleJava hat der HIN Client ein Problem und funktioniert nicht richtig.
    Wir Empfehlen Ihnen eine Extra Java Installation zu erstellen, und diese ältere Version für den HIN Client zu nutzen.

## Vorbedingungen

Getestet wurde unter Debian Stretch (amd64). Andere Linux-Version/Distribution könnne auch laufen. Gebraucht werden git, docker und docker-compose, welche unter Debian Stretch wie folgt installert wurden `sudo apt-get install git docker-ce docker-compose`

## Installation

    git clone https://github.com/ngiger/docker-hinclient.git /usr/local/src/docker-hinclient
    cd /usr/local/src/docker-hinclient
    cp docker-compose.example docker-compose.yml
    # Adapt in docker-compose.yml the values PASSPHRASE and IDENTITY_FILE
    docker-compose up --build
    
Check that everything is fine. It should look like [example.up_build](example.up_build) 

If you use systemd you can make the HIN-client start automatically by using the following commands.

    sudo cp docker-hinclient.service /etc/systemd/system
    sudo systemctl daemon-reload
    sudo systemctl enable docker-hinclient.service
    sudo systemctl start docker-hinclient.service
    sudo systemctl status docker-hinclient.service 
    # It will take some time till Finished all checks signals, that the
    # you may follow the log using
    tail -f logs/HIN\ Client/hinclient.log 


## Tests

Die Ports werden unverändert weitergeleitet, nämlich
* 5018 SMTP
* 5019 POP43
* 5020 IMAP

Zum Testen, ob die Verbindung mit dem Port 5018 (SMTP) möglich ist, kann man die Befehle `telnet localhost 5018` und `openssl s_client -connect localhost:5018` verwenden. Die Ausgabe sollte dann etwa so aussehen.

    > telnet localhost 5018
    Trying ::1...
    Connected to localhost.
    Escape character is '^]'.
    Connection closed by foreign host.
    > openssl s_client -connect localhost:5018
    CONNECTED(00000003)
    write:errno=104
    ---
    no peer certificate available
    ---
    No client certificate CA names sent
    ---
    SSL handshake has read 0 bytes and written 176 bytes
    Verification: OK
    ---
    New, (NONE), Cipher is (NONE)
    Secure Renegotiation IS NOT supported
    Compression: NONE
    Expansion: NONE
    No ALPN negotiated
    SSL-Session:
      Protocol  : TLSv1.2
      Cipher    : 0000
      Session-ID: 
      Session-ID-ctx: 
      Master-Key: 
      PSK identity: None
      PSK identity hint: None
      SRP username: None
      Start Time: 1504169193
      Timeout   : 7200 (sec)
      Verify return code: 0 (ok)
      Extended master secret: no

# Tracking down errors

If you see in the log `java.security.UnrecoverableKeyException: PKCS12 verification error, incorrect password` then you misstyped your password or it does not match the HIN-identify file.

# Disclaimer

By using Dockerfiles contained in this repo and/or container images derived from them, you are agreeing to any and all applicable license agreements & export rules related to unlimited strength crypto, etc..
