#!/usr/bin/env bash

docker exec -ti "${SUPERVISORD_HOSTNAME:-supervisord}" bash

