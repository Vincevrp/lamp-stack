#!/bin/bash

EXTRA_PATH="/vagrant/provision/extra"
SCRIPT="create-db.sh"

vagrant ssh -c "sudo bash ${EXTRA_PATH}/${SCRIPT}"
