## Hashbros-coin Web App
The Hashbros-coin web app is a coin agnostic web API that interacts with the Stratum DB to expose a northbound REST API for the main Hashbros web server.
# Notes
*Database name is always pooldb

*Passwords will always be a hashed value

# Instructions

After installing coin for server...

Start the daemon, it should fail but will create some folders. Then set up the binary and start getting blocks, also make a new wallet for stratum
    
    `<coind>d`
    `cp <coin>d /usr/bin/`
    `cp ~/.coin.conf ~/.<coin>`
    `cd `/.<coin>`
    `<coin>d -conf=coin.conf -daemon`
    `<coin>d -conf=coin.conf getaccountaddress hashbros`

Copy the address that was just printed. Add it to the stratum config, fix the config, and start stratum.

    `cd ~/stratum-mining-litecoin`
    `nano conf/config.py`
    `byobu`
    `twistd -ny launcher.tac`
    
Stratum should probably show that the coin is downloading blocks. If it's not you fucked something up.
