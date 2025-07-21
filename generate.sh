#!/bin/sh

set -e

mint bootstrap
mint run krzysztofzablocki/Sourcery --config sourcery-varioqub-network.yml
mint run krzysztofzablocki/Sourcery --config sourcery-varioqub.yml

protoc --plugin="$(mint which apple/swift-protobuf)" ./Sources/Varioqub/Protobuf/*.proto  --swift_out .
