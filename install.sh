#!/bin/bash

# install brew
which brew
if [ $? = 1 ]
then
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# general program installation
install() {
	which $1
	if [ $? != 0 ]
	then
		which brew
		if [ $? != 0 ]
		then
			sudo apt-get install $1
		else
			brew install $1
		fi
	fi
}

install zsh
install vim
install tmux

# dotfile linking
link() {
	if [ -L $HOME/$1 ]
	then
		ln -s $PWD/$1 $HOME/$1
	elif [ -f $HOME/$1 ]
	then
		ln -s $PWD/$1 $HOME/$1
	else
		ln -s $PWD/$1 $HOME/$1
	fi
}

link .vimrc
link .tmux.conf

# vim-specific
if ! [ -d ~/.vim/bundle/Vundle.vim ]
then
	git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

# zsh
if [ $SHELL != "/bin/zsh" ]
then
	chsh -s $(which zsh)
	ln -s $PWD/.zshrc $HOME/.zshrc
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# meteor
which meteor
if [ $? = 1 ]
then
	curl https://install.meteor.com/ | sh
fi

# karabiner
alias karabiner=/Applications/Karabiner.app/Contents/Library/bin/karabiner
ln -s $PWD/private.xml $HOME/Library/Application\ Support/Karabiner/private.xml
sh karabiner-import.sh
karabiner reloadxml
karabiner relaunch
