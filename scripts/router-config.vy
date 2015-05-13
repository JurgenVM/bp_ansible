#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

configure

# Fix for error "INIT: Id "TO" respawning too fast: disabled for 5 minutes"
delete system console device ttyS0

# Commands here

set protocols rip network '192.0.2.0/24'
set protocols rip network '172.16.0.0/16'
set protocols rip redistribute connected
set system host-name 'router'
set system name-server '192.0.2.2'
set system name-server '192.0.2.3'
set system time-zone 'Europe/Brussels'


commit
save