#!/bin/bash
if [ -f ~/.bash/.bash_nice ]; then
  if [ -f ~/.bash_nice ]; then
    mv ~/.bash_nice ~/.bash_nice.or
  fi
  ln -s ~/.bash/bash_nice ~/.bash_nice
  source ~/.bash_nice
fi
if [ -f ~/.bash/.bash_aliases ]; then
  if [ -f ~/.bash_aliases ]; then
    mv ~/.bash_aliases ~/.bash_aliases.or
  fi
  ln -s ~/.bash/bash_aliases.sh ~/.bash_aliases
  source ~/.bash_aliases
fi
bashrc="~/.profile"
if [ -f ~/.bashrc ]; then
  bashrc="~/.bashrc"
elif [ -f ~/.bash_login ]; then
  bashrc="~/.bash_login"
elif [ -f ~/.bash_profile ]; then
  bashrc="~/.bash_profile"
fi
echo"
if [ -f ~/.bash_nice ]; then
      . ~/.bash_nice
fi
if [ -f ~/.bash_aliases ]; then
      . ~/.bash_aliases
fi  
" >> $bashrc
if [ -f ~/.bash/.tmux.conf ]; then
  if [ -f ~/.tmux.conf ]; then
    mv ~/.tmux.conf ~/.tmux.conf.or
  fi
  ln -s ~/.bash/.tmux.conf ~/.tmux.conf
fi

