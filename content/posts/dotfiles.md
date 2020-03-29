---
date: "2017-03-10"
title: "My dotfiles"
draft: True
type: "post"
keywords:
  - "dotfiles"
  - "zsh"
  - "weechat"
---

**TL;DR**: In this post, I'm discussing my setup and the dotfiles needed to
reproduce it. Installation instructions can be found at
[SeanBE/dotfiles](https://github.com/SeanBE/dotfiles). You can find me on
Twitter using the handle [@SeanBE](https://twitter.com/seanBE).

## **Setting up Gnome Terminal**


## **Tmux and Vim**
## **Weechat**




Follow instructions to install my dotfiles. 
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
