#!/usr/bin/env bash

# Creates a TS-ready p5.js sketch using the starter kit provided by
# https://github.com/Gaweph/p5-typescript-starter

if [ $# -eq 0 ]; then
    echo "Provide a name for your new sketch. For example:"
    echo "  $ ./create-ts-sketch my-new-sketch"
    exit -1
fi

SKETCH_NAME=$1

if [ -d $SKETCH_NAME ]; then
    echo "Directory $SKETCH_NAME already exists."
    exit -1
fi

# Clone the starter kit and remove what we don't need.
git clone https://github.com/Gaweph/p5-typescript-starter $SKETCH_NAME
cd $SKETCH_NAME
rm p5-typescript-demo.png
rm LICENSE
rm build/*.js
rm sketch/*.ts
echo "# $SKETCH_NAME" > README.md

# Change the included example sketch to a really basic one.
TEMPLATE=$(cat << Template
let y: number = 100;

function setup(): void {
    createCanvas(800, 600);
    stroke(255);
    frameRate(30);
}

function draw(): void {
    background(0);
    y = y - 1;
    if (y < 0) {
        y = height;
    }
    line(0, y, width, y);
}
Template
)

echo "$TEMPLATE" > sketch/sketch.ts

# Install everything while we're at it
npm install
npm start
