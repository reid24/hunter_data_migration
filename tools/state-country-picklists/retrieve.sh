#!/bin/bash
rm -rf unpackaged
rm -f unpackaged.zip
sfdx force:mdapi:retrieve -u hunter-fulluat -r . -k def/src/package.xml
unzip unpackaged.zip
rm unpackaged.zip