#!/bin/sh

set -x

if [ "$2" = "GUN_POINT" ];
then
    #24(-1),26(1)
    traindata=data/GUN_POINT_TRAIN.csv
    testdata=data/GUN_POINT_TEST.csv
    N=50
    L=150
    lo=40
    hi=100
    Shape_num=244500
elif [ "$2" = "ECG200" ];
then
    #数据,31(-1)和69(1)
    traindata=data/ECG200_TRAIN.txt
    testdata=data/ECG200_TEST.txt
    N=100
    L=96
    lo=20
    hi=96
    Shape_num=285000
elif [ "$2" = "Yoga" ];
then
    #数据,137(1)和163(2)
    traindata=data/yoga_TRAIN.txt
    testdata=data/yoga_TEST.txt
    N=300
    L=426
    lo=50
    hi=400
    Shape_num=200000
elif [ "$2" = "ECGFiveDays" ];
then
    #N比较小,学习不出东西
    traindata=data/ECGFiveDays_TRAIN.txt
    testdata=data/ECGFiveDays_TEST.txt
    N=23
    L=136
    lo=40
    hi=100
    Shape_num=200000
elif [ "$2" = "Coffee" ];
then
    #数据0和1 N比较小?
    traindata=data/Coffee_TRAIN.txt
    testdata=data/Coffee_TEST.txt
    N=28
    L=286
    lo=50
    hi=200
    Shape_num=200000
elif [ "$2" = "Ham" ];
then
    #数据52(1)和57(2)
    traindata=data/Ham_TRAIN.txt
    testdata=data/Ham_TEST.txt
    N=109
    L=431
    lo=20
    hi=430
    Shape_num=200000
elif [ "$2" = "Herring" ];
then
    #数据39(1)和25(2)
    traindata=data/Herring_TRAIN.txt
    testdata=data/Herring_TEST.txt
    N=64
    L=512
    lo=50
    hi=500
    Shape_num=400000
elif [ "$2" = "PhalangesOutlinesCorrect" ];
then
    #数据628(1)和1172(2)
    traindata=data/PhalangesOutlinesCorrect_TRAIN.txt
    testdata=data/PhalangesOutlinesCorrect_TEST.txt
    N=1800
    L=80
    lo=30
    hi=60
    Shape_num=200000
elif [ "$2" = "Computers" ];
then
    #数据99(1)和151(2)
    traindata=data/Computers_TRAIN.txt
    testdata=data/Computers_TEST.txt
    N=150
    L=720
    lo=50
    hi=700
    Shape_num=200000
elif [ "$2" = "FordA" ];
then
    #数据639(1),681(-1)
    traindata=data/FordA_TRAIN.txt
    testdata=data/FordA_TEST.txt
    N=1320
    L=500
    lo=50
    hi=400
    Shape_num=200000
elif [ "$2" = "FordB" ];
then
    #数据409(1)和401(-1)
    #注意gpu_cmpdistance会超?
    traindata=data/FordB_TRAIN.txt
    testdata=data/FordB_TEST.txt
    N=810
    L=500
    lo=60
    hi=400
    Shape_num=200000
elif [ "$2" = "HandOutlines" ];
then
    #数据133(0)和237(1)
    #最长的,空间复杂度比FordA更大.大10倍左右
    traindata=data/HandOutlines_TRAIN.txt
    testdata=data/HandOutlines_TEST.txt
    N=370
    L=2709
    lo=200
    hi=500
    Shape_num=200000
elif [ "$2" = "Strawberry" ];
then
    #数据132(1),238(2)
    traindata=data/Strawberry_TRAIN.txt
    testdata=data/Strawberry_TEST.txt
    N=370
    L=235
    lo=50
    hi=230
    Shape_num=200000
elif [ "$2" = "WormsTwoClass" ];
then
    #数据33(1),44(2)
    traindata=data/WormsTwoClass_TRAIN.txt
    testdata=data/WormsTwoClass_TEST.txt
    N=77
    L=900
    lo=50
    hi=800
    Shape_num=200000
elif [ "$2" = "wafer" ];
then
    #1:9
    traindata=data/wafer_TRAIN.txt
    testdata=data/wafer_TEST.txt
    N=1000
    L=152
    lo=50
    hi=150
    Shape_num=107000
else
    echo "Please Select a valid data"
    exit 0
fi
w=$1

bin/shapelet $traindata $N $L $lo $hi $w -100 $testdata $Shape_num $3
outthrehold=$(cat temp/min.txt)
echo "Infogain = $outthrehold"
bin/shapelet $traindata $N $L $lo $hi $w $outthrehold $testdata $Shape_num $3 > temp/allcandidates.txt
bin/Averagetest $traindata $N $L $w $testdata
#rm temp/min.txt temp/allcandidates.txt
