- install
    git, wget, unzip, rust, curl, node, tmux, bat, nnn, tree, helix, alacritty, terminator

- setup config:

	echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc
	echo "export NNN_FIFO='/tmp/nnn.fifo'" >> $HOME/.bashrc 
	echo "export NNN_PLUG='v:preview-tui'" >> $HOME/.bashrc 
	echo "export NNN_BATTHEME='Visual Studio Dark+'" >> $HOME/.bashrc 
	source $HOME/.bashrc
	git clone --bare git@github.com:iyegoroff/dotfiles.git $HOME/.cfg
	config checkout
	config config --local status.showUntrackedFiles no
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/RobotoMono.zip -P $HOME
	unzip $HOME/RobotoMono.zip -d $HOME/RobotoMono && rm -rf $HOME/RobotoMono.zip
	cargo install taplo-cli --locked
	npm i -g typescript-language-server vscode-langservers-extracted@4.8
	sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"

- install tmux plugins (prefix + I)
- install fonts (copy them to `/usr/local/share/fonts` and rebuild the font cache with `fc-cache -f -v`)

