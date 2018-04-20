#!/bin/sh

ENV=dev

# get dependencies
MIX_ENV=$ENV mix deps.get

# build
MIX_ENV=$ENV mix compile

# publish hex
MIX_ENV=$ENV mix hex.publish