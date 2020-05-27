# milter_greylist

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with milter_greylist](#setup)
    * [What milter_greylist affects](#what-milter_greylist-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with milter_greylist](#beginning-with-milter_greylist)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description
Installs and configures milter-greylist - opensource solution to shrug one time spam off. Its source is at http://hcpnet.free.fr/milter-greylist and most verbose manual I found at 
http://milter-greylist.wikidot.com/

## Setup
Add the following into your manifest
    include 'milter_greylist'

### What milter_greylist affects **OPTIONAL**
This puppet module installs milter-greylist packages, configures /etc/mail/greylist.conf and enables milter-greylist service

### Setup Requirements **OPTIONAL**
Epel repository needs to be installed for milter-greylist package

### Beginning with milter_greylist

install module
include into manifest
run manifest

## Usage

Just including milter_greylist runs milter-greylist with default settings to greylist everyone except @mynetworks
```
include milter_greylist
```

To add more IP subnets into mynetworks whitelist
```
include milter_greylist
class milter_greylist {
  mynetworks => '10.0.0.0/8 192.168.0.0/22 127.0.0.1/8',
}
```

It is advisable to set certain whitelisted IP addresses or countries to avoid getting into initial delay trouble
```
include milter_greylist
class milter_greylist {
  whlcountries => ['CA'],
  whlips => ['8.8.8.8', '8.8.4.4'],
}
```

By default milter-greylist is configured to listen to inet socket, if you have reasons to use unix socket instead try this
```
include milter_greylist
class milter_greylist {
  socket => '/var/run/milter-greylist/milter-greylist.sock',
}
```

## Limitations

If your MTA is Postfix then unless you set smtpd_delay_open_until_valid_rcpt = no in Postfix's main.cf, you won;t get queue id logged

## Development

In the Development section, tell other users the ground rules for contributing to your project and how they should submit their work.

## Release Notes/Contributors/Etc. **Optional**

0.1 - Initial version with whitelist by country and by IPs
