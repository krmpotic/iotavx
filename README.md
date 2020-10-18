# IOTAVX serial control (WIP)

## Introduction

IOTAVX SA3 has a RS232 port at the back of it. Using a RS232 to USB adapter
we can receive strings such as

`IrAddr:<iraddr> IrData:<irdata>`

where `<irdata>` is a button code, mapped to buttons in etc/button_codes.sh

We can use this to define our own actions for the remote.
See iota-custom.sh for an example.

## Requirements

### Hardware
- IOTAVX SA3 with remote
- RS232 -> USB adapter

## Software
- Linux (tested on Arch)

### iotavx-custom.sh
- playerctl
- dmenu
