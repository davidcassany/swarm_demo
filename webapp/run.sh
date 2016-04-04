#!/bin/bash

ping -c 1 mongodbd || exit 1 
rackup config.ru -p 3000 -o 0.0.0.0

