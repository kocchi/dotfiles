#!/bin/sh

STEP1=1

STARTDIR=`pwd`

if [ "$STEP1" = 1 ]; then
    echo ""
    echo "#####"
    echo "##### START STEP1 #####"
    echo "##### synboric link (.vimrc .vim/)"
    echo "#####"

    DOT_HOME=$HOME/git/dotfiles

    cd $HOME
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

    cd $DOT_HOME

    dotfiles=(`find . -name "dot.*"`)

    for file in ${dotfiles[@]};
    do
        new=`echo "$file" | sed s/.\\\/dot//g`;
        cmd="ln -snf $PWD/dot$new ~/$new"

        echo $cmd
        eval $cmd
    done

    source ~/.zshrc

    cd $DOT_HOME/dot.vim/bundle/

    git clone git@github.com:Shougo/neobundle.vim.git

    cd $DOT_HOME

    RET=$?
    if [ "$RET" != 0 ]; then
        echo "ERROR STEP 1"
        exit 1
    fi
fi

echo ""
echo "##### setup end #####"
