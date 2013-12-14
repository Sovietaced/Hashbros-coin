## Hashbros-coin Web App
The Hashbros-coin web app is a coin agnostic web API that interacts with the Stratum DB to expose a northbound REST API for the main Hashbros web server.
# Notes
*Database name is always pooldb

*Passwords will always be a hashed value

# Instructions

After installing coin for server...

Set up the binary and start getting blocks, also make a new wallet for stratum

    `cp <coin>d /usr/bin/`
    `cp ~/.coin.conf ~/.<coin>`
    `cd `/.<coin>`
    `<coin>d -conf=coin.conf -daemon`
    `<coin>d -conf=coin.conf getaccountaddress hashbros`
