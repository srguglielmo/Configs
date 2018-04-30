# srg's .zlogin
# This is run for login shells after .zshrc.

# Freeze the terminal settings.
#ttyctl -f

# Print some quick info.
uname -mprs
uptime
#who -q
w -hi | grep -v $USER

# Homebrew's fortune
if [[ -x /usr/local/bin/fortune ]]; then
	if [[ -x /usr/local/bin/lolcat ]]; then
		/usr/local/bin/fortune -as | /usr/local/bin/lolcat
	else
		/usr/local/bin/fortune -as
	fi
fi

#log

# What year is it again?
mesg y
msgs -f

if [[ -r ~/TODO ]]; then
	echo "----- TODO -----"
	cat ~/TODO
fi

