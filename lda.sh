#!/bin/bash
##################################
# Author : cndaqiang             #
# Update : 2022-04-13            #
# Build  : 2022-04-13            #
# What   : Build ONCVPSP of LDA  #
##################################

rm -rf lda.out
ONCVDIR=/home/cndaqiang/code/source/oncvpsp-4.0.1
#ONCVDIR=/home/cndaqiang/code/source/oncvpsp-3.3.1
FUN=PZ #You still need to change awk command below.
for i in $( ls W.in2 | grep -v lda )
do
    echo $i
    prefix=$(echo $i | awk -F. '{ print $1 }')
    sed  3d $i | sed "3i$(sed -n  3p $i | awk '{ print $1,$2,$3,$4,3,$6 }')" > lda.$i
    ${ONCVDIR}/src/oncvpsp.x   < lda.$i > lda.out
    awk 'Begin{out=0};/END_PSP/{out=0}; {if(out == 1) {print}};\
        /Begin PSP_UPF/{out=1}' lda.out > ${prefix}_ONCV_${FUN}_sr.upf
    rm -rf lda.out
    exit
    ${ONCVDIR}/src/oncvpspnr.x < lda.$i > lda.out
    awk 'Begin{out=0};/END_PSP/{out=0}; {if(out == 1) {print}};\
        /Begin PSP_UPF/{out=1}' lda.out > ${prefix}_ONCV_${FUN}_fr.upf
    rm -rf lda.out
done
#delet delete empty files
echo rm $(for i in $( ls | grep PZ); do echo $i $(grep UPF $i | head -1) ; done | grep -v UPF | xargs)

