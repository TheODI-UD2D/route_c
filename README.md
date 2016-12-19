[![Build Status](http://img.shields.io/travis/TheODI-UD2D/route_c.svg?style=flat-square)](https://travis-ci.org/TheODI-UD2D/route_c)
[![Dependency Status](http://img.shields.io/gemnasium/TheODI-UD2D/route_c.svg?style=flat-square)](https://gemnasium.com/TheODI-UD2D/route_c)
[![Coverage Status](http://img.shields.io/coveralls/TheODI-UD2D/route_c.svg?style=flat-square)](https://coveralls.io/r/TheODI-UD2D/route_c)
[![Code Climate](http://img.shields.io/codeclimate/github/TheODI-UD2D/route_c.svg?style=flat-square)](https://codeclimate.com/github/TheODI-UD2D/route_c)
[![Gem Version](http://img.shields.io/gem/v/route_c.svg?style=flat-square)](https://rubygems.org/gems/route_c)
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://TheODI-UD2D.mit-license.org)

# Route C

A Ruby script for the Raspberry Pi to show how crowded a station on the Victoria line is (with fake data currently)

# Installation

## Install the gem

```
sudo gem install route_c
```

## Set environment variables

For this to work, you will need a running instance of [Sir Handel](https://github.com/TheODI-UD2D/sir_handel), together
with the correct username and password. You can then set the relevant variables like so:

```
export SIR_HANDEL_USERNAME=username
export SIR_HANDEL_USERNAME=password
```

## Hardware

### Crudely-drawn circuit

![How to Pi](http://i.imgur.com/35a4myB.png)

You might also need the [Treasure Map](http://pinout.xyz/)

![](https://www.raspberrypi.org/documentation/usage/gpio-plus-and-raspi2/images/gpio-numbers-pi2.png)

The final setup should look something like this:

![](pi-setup.jpg)

Make a note of where your inputs and outputs are connected for the config below

## Set config

Create a file in your home directory at `.routec/config.yaml`. The following variables are configurable:

```
base_url: {The base URL of your Sir Handel instance's arriving endpoint - i.e. http://example.org/stations/arriving/ }
interval: {The interval (in fractions of seconds) you want each LED to wait before turning on / off}
pause: {The interval you want to wait before turning the lights off}
lights:
  {A YAML array of the GPIO ports that have LEDs connected}
button: {The GPIO port that the button is connected to}
station: {The Victoria line station that you want `routec watch` to query}
direction: {The direction you want `routec watch` to query (either `northbound` or `southbound`)}
```

# Running

## For a one off display of station crowding

```
sudo -E routec {STATION} {DIRECTION (either `northbound` or `southbound`)}
```

(This defaults to the current time on the 23rd September)

## For a one off display of station crowding for a particular datetime

```
sudo -E routec {STATION} {DIRECTION (either `northbound` or `southbound`)} --time={DATETIME}
```

## To watch for a button press and return current station crowding

```
sudo -E routec watch
```

(This defaults to the current time on the 23rd September)

# Running on boot

* Create a file in `/etc/init.d/routec` and copy the text from [this example file](./routec.init.d.example) to it.
* Replace YOUR USERNAME and YOUR PASSWORD with the username and password for your Sir Handel instance
* Run `sudo update-rc.d route_c defaults`
* Reboot your Pi
