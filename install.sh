#!/usr/bin/env bash

# ok, two will fail depending on your platform but who cares ;-)
brew install node
brew install python
sudo apt-get install node
sudo apt-get install python

# install the tooling locally (from package.json)
npm install
pip install csvkit

