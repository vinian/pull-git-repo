#!/bin/bash
# 只要一个目录下有 .git 则认为它是 git repo, 需要 pull,
# 否则就继续寻找它的子目录---采用递归的方式

BASEDIR='.'
PATH='/usr/bin/:/usr/sbin:/sbin:/bin'
DIRECTORY=`ls`

function findGitRepo()
{
	ISAGITREPO=`ls -a | grep '^.git$' | wc -l`
	[[ $ISAGITREPO -gt 0 ]] && return 0 || return 1
}

function gitPullCmd()
{
	DIRECTORY=$1
	cd $DIRECTORY
	if ( findGitRepo ); then
        echo "$DIRECTORY 开始拉取数据"
        git pull
	else
		SUBDIR=`ls`	
		for i in $SUBDIR;do
			if [ -d $i ]; then
                cd $i;
				if ( findGitRepo ); then
                    echo "$i 开始拉取数据"
                    git pull
				else
                    echo "$i 递归的处理这个目录"
                    # how to handle this
                    # "gitPullCmd $i" i don't think so
				fi
                cd ..
			fi
		done
	fi
	cd ..
}

for FILE in $DIRECTORY; do
    if [ -d $FILE ]; then
        gitPullCmd $FILE 
    fi
done
