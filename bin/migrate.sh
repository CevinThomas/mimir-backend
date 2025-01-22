#!/bin/bash -e

./rails db:migrate

exec "${@}"