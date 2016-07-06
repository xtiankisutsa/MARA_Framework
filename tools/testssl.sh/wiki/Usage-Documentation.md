
### NAME 
   testssl.sh -- check encryption of SSL/TLS servers


### SYNTAX

testssl.sh <options>

     -h, --help                    what you're looking at
     -b, --banner                  displays banner + version of testssl.sh
     -v, --version                 same as previous
     -V, --local                   pretty print all local ciphers
     -V, --local <pattern>         which local ciphers with <pattern> are available?
                                   (if pattern not a number: word match)

testssl.sh <options> URI    (`testssl.sh URI` does everything except `-E`)

     -e, --each-cipher             checks each local cipher remotely
     -E, --cipher-per-proto        checks those per protocol
     -f, --ciphers                 checks common cipher suites
     -p, --protocols               checks TLS/SSL protocols
     -S, --server_defaults         displays the servers default picks and certificate info
     -P, --preference              displays the servers picks: protocol+cipher
     -y, --spdy, --npn             checks for SPDY/NPN
     -x, --single-cipher <pattern> tests matched <pattern> of ciphers
                                   (if <pattern> not a number: word match)
     -U, --vulnerable              tests all vulnerabilities
     -B, --heartbleed              tests for heartbleed vulnerability
     -I, --ccs, --ccs-injection    tests for CCS injection vulnerability
     -R, --renegotiation           tests for renegotiation vulnerabilities
     -C, --compression, --crime    tests for CRIME vulnerability
     -T, --breach                  tests for BREACH vulnerability
     -O, --poodle                  tests for POODLE (SSL) vulnerability
     -Z, --tls-fallback            checks TLS_FALLBACK_SCSV mitigation
     -F, --freak                   tests for FREAK vulnerability
     -A, --beast                   tests for BEAST vulnerability
     -J, --logjam                  tests for LOGJAM vulnerability
     -s, --pfs, --fs,--nsa         checks (perfect) forward secrecy settings
     -4, --rc4, --appelbaum        which RC4 ciphers are being offered?
     -H, --header, --headers       tests HSTS, HPKP, server/app banner, security headers, cookie, reverse proxy, IPv4 address

  special invocations:

     -t, --starttls <protocol>     does a default run against a STARTTLS enabled <protocol>
     --xmpphost <to_domain>        for STARTTLS enabled XMPP it supplies the XML stream to-'' domain -- sometimes needed
     --mx <domain/host>            tests MX records from high to low priority (STARTTLS, port 25)
     --ip <ip>                     a) tests the supplied <ip> v4 or v6 address instead of resolving host(s) in URI 
                                   b) arg "one" means: just test the first DNS returns (useful for multiple IPs)
     --file <fname>                mass testing option: Reads command lines from <fname>, one line per instance.
                                   Comments via # allowed, EOF signals end of <fname>. Implicitly turns on "--warnings batch"
partly mandatory parameters:

     URI                           host|host:port|URL|URL:port   (port 443 is assumed unless otherwise specified)
     pattern                       an ignore case word pattern of cipher hexcode or any other string in the name, kx or bits
     protocol                      is one of ftp,smtp,pop3,imap,xmpp,telnet,ldap (for the latter two you need e.g. the supplied openssl)

tuning options (can also be preset via environment variables):

     --bugs                        enables the "-bugs" option of s_client, needed e.g. for some buggy F5s
     --assuming-http               if protocol check fails it assumes HTTP protocol and enforces HTTP checks
     --ssl-native                  fallback to checks with OpenSSL where sockets are normally used
     --openssl <PATH>              use this openssl binary (default: look in $PATH, $RUN_DIR of testssl.sh
     --proxy <host>:<port>         connect via the specified HTTP proxy
     -6                            use also IPv6 checks, works only with supporting OpenSSL version and IPv6 connectivity
     --sneaky                      leave less traces in target logs: user agent, referer
     --quiet                       don't output the banner. By doing this you acknowledge usage terms normally appearing in the banner
     --log, --logging              logs stdout to <NODE-YYYYMMDD-HHMM.log> in current working directory
     --logfile <file>              logs stdout to <file/NODE-YYYYMMDD-HHMM.log> if file is a dir or to specified file
     --wide                        wide output for tests like RC4, BEAST. PFS also with hexcode, kx, strength, RFC name
     --show-each                   for wide outputs: display all ciphers tested -- not only succeeded ones
     --warnings <batch|off|false>  "batch" doesn't wait for keypress, "off" or "false" skips connection warning
     --color <0|1|2>               0: no escape or other codes,  1: b/w escape codes,  2: color (default)
     --debug <0-6>                 1: screen output normal but debug output in temp files.  2-6: see line ~120

All options requiring a value can also be called with `=` (e.g. `testssl.sh -t=smtp --wide --openssl=/usr/bin/openssl <URI>`.

<URI> is always the last parameter.

Need HTML output? Just pipe through "aha" (Ansi HTML Adapter: github.com/theZiz/aha) like

   `testssl.sh <options> <URI> | aha >output.html`

### Exit status

**0**    testssl.sh finished sucessfully  
**245**  no bash used or called with sh  
**249**  temp file generation problem  
**251**  feature not yet supported  
**252**  no DNS resolver found or not executable / proxy couldn't be determined from given values / -xmpphost supplied but OPENSSL too old  
**253**  no SSL/TLS enabled server / OPENSSL too old / couldn't connect to proxy / couldn't connect via STARTTLS  
**254**  no OPENSSL found or not exexutable / no IPv4 address could be determined / illegal STARTTLS protocol supplied / supplied file name not readable   

### RFCs

fixme

### FILES

**etc/*pem**              Certificate stores from Linux, Mozilla Firefox, Windows 7, JDK 8

**etc/mapping-rfc.txt**   provides a file with mapping from OpenSSL cipher suites names to the ones from IANA / used in the RFCs

### AUTHORS

Developed by Dirk Wetter and others, see https://github.com/drwetter/testssl.sh/blob/master/CREDITS.md

### COPYRIGHT

Copyright © 2016 Dirk Wetter. License GPLv2: Free Software Foundation, Inc.  
       This is free software: you are free to change and redistribute it.  Usage WITHOUT ANY WARRANTY. USE at your OWN RISK.


### BUGS

Known ones see https://testssl.sh/bugs

### SEE ALSO

ciphers(1), openssl(1)

