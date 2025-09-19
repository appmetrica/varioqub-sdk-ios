#!/bin/sh

set -e

mint bootstrap
mint run krzysztofzablocki/Sourcery --config sourcery-varioqub-network.yml
mint run krzysztofzablocki/Sourcery --config sourcery-varioqub.yml

protoc ./Sources/Varioqub/Protobuf/*.proto  --swift_out .
