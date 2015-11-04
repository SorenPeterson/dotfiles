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
# $1: Name of file
# $2: Location of link
	if [ -L "$2/$1" ] # There is already a symbolic link in place
	then
		rm $2/$1 # Remove the link
		ln -s $PWD/$1 "$2/$1" # And create one for these dotfiles
	elif [ -f "$2/$1" ] # There is a file already there
	then
		mv "$2/$1" "$2/$1.old" # Move it to a safe place
		ln -s $PWD/$1 "$2/$1" # And create the link
	else
		ln -s $PWD/$1 "$2/$1"
	fi
}

link .vimrc $HOME
link .tmux.conf $HOME

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
link private.xml "$HOME/Library/Application Support/Karabiner/"
# sh karabiner-import.sh
# karabiner reloadxml
# karabiner relaunch

