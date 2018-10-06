#!/bin/bash

EXTRA_PATH="/vagrant/provision/extra"
SCRIPT="drupal.sh"

vagrant ssh -c "sudo bash ${EXTRA_PATH}/${SCRIPT}"
