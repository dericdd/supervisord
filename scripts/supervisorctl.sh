#!/usr/bin/env bash

sudo docker exec -ti supervisord supervisorctl "$@"
