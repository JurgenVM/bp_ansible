#! /usr/bin/env bats
#
# Author:   Bert Van Vreckem <bert.vanvreckem@gmail.com>
#
# Test a DNS server

ns_ip=192.0.2.2
domain=linuxlab.net

@test 'DNS service should be running' {
  sudo systemctl status named.service
}

@test 'The `dig` command should be installed' {
  which dig
}

@test 'Named.conf should be syntactically correct' {
  sudo named-checkconf /etc/named.conf
}

@test 'Forward lookup zone should be syntactically correct' {
  sudo named-checkzone ${domain} /var/named/linuxlab.net
}

@test 'Reverse lookup zone for public servers should be syntactically correct' {
  sudo named-checkzone 2.0.192.in-addr.arpa /var/named/2.0.192.in-addr.arpa
}

@test 'Reverse lookup zone for private servers should be syntactically correct' {
  sudo named-checkzone 16.172.in-addr.arpa /var/named/16.172.in-addr.arpa
}

@test 'It should return the NS record(s)' {
  result="$(dig @${ns_ip} ${domain} NS +short)"
  [ -n "${result}" ] # The result should not be empty
}

@test "It should return the ip address for pu001" {
  result="$(dig @${ns_ip} pu001.${domain} +short)"
  [ "192.0.2.2" = "${result}" ]
}

@test "It should return the ip address for pu002" {
  result="$(dig @${ns_ip} pu002.${domain} +short)"
  [ "192.0.2.3" = "${result}" ]
}

@test "It should return the ip address for pu010" {
  result="$(dig @${ns_ip} pu010.${domain} +short)"
  [ "192.0.2.10" = "${result}" ]
}

@test "It should return the ip address for pu020" {
  result="$(dig @${ns_ip} pu020.${domain} +short)"
  [ "192.0.2.20" = "${result}" ]
}

@test "It should return the host name of 192.0.2.2" {
  result="$(dig @${ns_ip} -x 192.0.2.2 +short)"
  [ "pu001.${domain}." = "${result}" ]
}

@test "It should return the host name and ip of ns1" {
  result="$(dig @${ns_ip} ns1.${domain} +short)"
  echo ${result} | grep pu001.${domain}
  echo ${result} | grep 192.0.2.2
}

@test "It should return the host name of 172.16.0.11" {
  result="$(dig @${ns_ip} -x 172.16.0.11 +short)"
  [ "pr011.${domain}." = "${result}" ]
}

