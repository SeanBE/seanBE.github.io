---
date: "2017-03-10"
title: "My dotfiles"
keywords:
  - "dotfiles"
  - "zsh"
  - "weechat"
---

**TL;DR**: Follow instructions to install my dotfiles. 
```
git clone --bare https://github.com/SeanBE/dotfiles.git $HOME/.dotfiles
# Git directory has been cloned to ~/.dotfiles .
# You might have existing files that conflict with my dotfiles.
# The following will fail with conflicts if your existing files are not removed.
# Use flag -f if you simply do not care.
git --work-tree=$HOME --git-dir=$HOME/.dotfiles checkout

git --work-tree=$HOME --git-dir=$HOME/.dotfiles submodule update --init
--recursive

ln -s $HOME/.vim/autoload/vim-plug/plug.vim $HOME/.vim/autoload/plug.vim

source ~/.zshrc
dot config --local status.showUntrackedFiles no
```

Start ```vim``` and run ```:PlugInstall```.

Start ```tmux``` and press ```prefix + I```. 


### Conclusion
