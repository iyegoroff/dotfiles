- setup config:

	echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc
	source $HOME/.bashrc
	git clone --bare git@github.com:iyegoroff/dotfiles.git $HOME/.cfg
	config checkout
	config config --local status.showUntrackedFiles no
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/RobotoMono.zip -P $HOME
	unzip $HOME/RobotoMono.zip -d $HOME/RobotoMono && rm -rf $HOME/RobotoMono.zip
	cargo install taplo-cli --locked
	npm i -g typescript-language-server vscode-langservers-extracted@4.8

- install tmux plugins (prefix + I)
- install fonts

