#!/usr/bin/zsh

set -eu
export BC_LINE_LENGTH=999

p1="0450863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B23522CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6"
p1="02df2089105c77f266fa11a9d33f05c735234075f2e8780824c6b709415f9fb485"
echo p1 $p1

p2=$(for i in `seq 1 2 129`;do echo $p1|cut -c$i-$((i+1));done|while read B;do printf "\x$B";done|sha256sum|cut -c-64)
p2=$(for i in `seq 1 2 65`;do echo $p1|cut -c$i-$((i+1));done|while read B;do printf "\x$B";done|sha256sum|cut -c-64)
echo p2 $p2

p3=$(openssl rmd160 <(for i in `seq 1 2 63`;do echo $p2|cut -c$i-$((i+1));done|while read B;do printf "\x$B";done)|awk '{print $2}')
p3=a4051c02398868af83f28f083208fae99a769263
echo p3 $p3

p4=$(echo 00$p3)
p4=$(echo 05$p3)
echo p4 $p4

p5=$(for i in `seq 1 2 41`;do echo $p4|cut -c$i-$((i+1));done|while read B;do printf "\x$B";done|sha256sum|cut -c-64)
echo p5 $p5

p6=$(for i in `seq 1 2 63`;do echo $p5|cut -c$i-$((i+1));done|while read B;do printf "\x$B";done|sha256sum|cut -c-64)
echo p6 $p6

p7=$(echo $p6|cut -c-8)
echo p7 $p7

p8=$(echo $p4$p7)
echo p8 $p8

p91=$(echo "obase=10; ibase=16; $(echo $p8|tr 'abcdef' 'ABCDEF')"|bc)
echo p91 $p91

ans=$p91 && p92=( $(while [[ "$ans" != "0" ]];do r=$(echo "$ans%58"|bc);ans=$(echo "$ans/58"|bc);echo $r;done|tac|tr '\n' ' ') )
echo p92 $p92

i=0 && base58=(1 2 3 4 5 6 7 8 9 A B C D E F G H J K L M N P Q R S T U V W X Y Z a b c d e f g h i j k m n o p q r s t u v w x y z) && p93=$(for i in $p92;do echo $base58[(($i+1))];done|tr -d '\n')
echo p93 $p93

num=$(( ($(echo $p8|sed -e 's/\(0*\).*/\1/'|wc -c)-1)  / 2  )) && p94=$(echo $(yes 1|head -n$num|tr -d '\n')$p93)

echo p94 $p94
