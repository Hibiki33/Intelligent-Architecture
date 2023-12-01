wget https://github.com/tmux/tmux/releases/download/2.2/tmux-2.2.tar.gz
wget https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz
wget http://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz

tar -xzf ncurses-*.tar.gz
cd ncurses-*
./configure --prefix=/usr CXXFLAGS="-fPIC" CFLAGS="-fPIC"
make && sudo make install 

export LC_ALL=C
tar -xzf libevent-*.tar.gz
cd libevent-*
./configure --prefix=/usr
make && sudo make install 

export LC_ALL=C
tar -xzf tmux-*.tar.gz
cd tmux-*
./configure
make && sudo make install

## if `tmux: need UTF-8 locale (LC_CTYPE) but have ANSI_X3.4-1968`
# sudo locale-gen "en_US.UTF-8"
# sudo dpkg-reconfigure locales
## select en_US.UTF-8 by spacebar
# export LANG=en_US.UTF-8
# sudo reboot