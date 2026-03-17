#!/bin/sh

# Start clean
rm -rf ./dist
mkdir -p ./dist

# Copy the Rapid dist folders (use -L to dereference any symlinks)
cp -RL ./node_modules/rapid2/dist ./dist/rapid2
cp -RL ./node_modules/rapid3/dist ./dist/rapid3

# Remove example code
rm -rf ./dist/rapid2/examples
rm -rf ./dist/rapid3/examples
