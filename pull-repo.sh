#!/bin/bash
# 只要一个目录下有 .git 则认为它是 git repo, 需要 pull,
# 否则就继续寻找它的子目录---采用递归的方式
# usage:
#  pull-git-repo.sh [ git-repo-directory ]

WORKINGDIR=$1
if [ "x$WORKINGDIR" == "x" ]; then
    WORKINGDIR='.'
fi
cd $WORKINGDIR

PATH='/usr/bin/:/usr/sbin:/sbin:/bin'

function gitPullCmd()
{
    DIRECTORY=$1
    echo $DIRECTORY
    cd $DIRECTORY
    ISAGITREPO=`ls -a | grep '^.git$' | wc -l`
    if [ $ISAGITREPO -gt 0 ]; then
            echo "$DIRECTORY 开始拉取数据"
            git pull
    else
        echo "处理 $DIRECTORY 的子目录"
        SUBDIR=`ls`
        for i in $SUBDIR;do
            if [ -d $i ]; then
                gitPullCmd $i
            fi
        done
    fi
    cd ..
    }

for FILE in `ls`; do
    if [ -d $FILE ]; then
        gitPullCmd $FILE
    fi
done
