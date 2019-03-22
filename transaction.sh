#!/usr/bin/zsh

set -eu

p1=$(( $(echo -n $1|wc -c) -1))
echo p1 $p1

p2=$(for i in `seq 1 2 $p1`;do echo -n $1|cut -c$i-$((i+1));done|while read B;do printf "\x$B";done|sha256sum|cut -c-64)
echo p2 $p2

p3=$(for i in `seq 1 2 63`;do echo -n $p2|cut -c$i-$((i+1));done|while read B;do printf "\x$B";done|sha256sum|cut -c-64)
echo p3 $p3


p4=$(for i in `seq 1 2 63`;do echo -n $p3|cut -c$((64-i))-$((64-i+1))|tr -d '\n';done)
echo p4 $p4
