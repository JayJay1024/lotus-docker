#!/bin/bash

lotus-seed pre-seal --sector-size 2048 --num-sectors 2

lotus-seed genesis new localnet.json && lotus-seed genesis add-miner localnet.json ~/.genesis-sectors/pre-seal-t01000.json

nohup lotus daemon --lotus-make-genesis=dev.gen --genesis-template=localnet.json --bootstrap=false > /home/lotus.log 2>&1 &
sleep 2
lotus wait-api

lotus wallet import ~/.genesis-sectors/pre-seal-t01000.key

lotus wallet set-default `lotus wallet list`  && lotus wallet balance

lotus-storage-miner init --genesis-miner --actor=t01000 --sector-size=2048 --pre-sealed-sectors=~/.genesis-sectors --pre-sealed-metadata=~/.genesis-sectors/pre-seal-t01000.json --nosync

nohup lotus-storage-miner run --nosync --enable-gpu-proving=true > /home/miner.log 2>&1 &


echo "Balance:"
lotus wallet balance

echo "Peers:"
lotus net peers

echo "Listening:"
lotus net listen

echo "Good job ~"
