if test -f /etc/profile.d/git-sdk.sh
then
	TITLEPREFIX=SDK-${MSYSTEM#MINGW}
else
	TITLEPREFIX=$MSYSTEM
fi

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [ \1 ]/'
}

if test -f ~/.config/git/git-prompt.sh
then
	. ~/.config/git/git-prompt.sh
else
	PS1='\[\033]0;Git | Bash v\v | \W\007\]' # set window title
	PS1="$PS1"'\n'                 # new line
	PS1="$PS1"'\[\e[0;36m\]'       # change to turquoise
	PS1="$PS1"'>> '                # initial symbol
	PS1="$PS1"'\[\e[1;34m\]'       # change to bold blue
	PS1="$PS1"'[ \u ]'             # user
	PS1="$PS1"'\[\e[0;31m\]'       # change to red
	PS1="$PS1"'[ \@ ]'             # time
	PS1="$PS1"'\[\033[0m\]'        # change to blue
	PS1="$PS1"'[ \d ]'             # day
	PS1="$PS1"'\[\033[35m\]'       # change to purple
	PS1="$PS1"'[ \w ]'             # working directory
	if test -z "$WINELOADERNOEXEC"
	then
		GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
		COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
		COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
		COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
		if test -f "$COMPLETION_PATH/git-prompt.sh"
		then
			. "$COMPLETION_PATH/git-completion.bash"
			. "$COMPLETION_PATH/git-prompt.sh"
			PS1="$PS1"'\[\033[36m\]'          # change color to turquoise
			PS1="$PS1""$(parse_git_branch)"   # bash function
		fi
	fi
	PS1="$PS1"'\[\e[0;36m\]'        # change color to turquoise
	PS1="$PS1"'\n'                  # new line
	PS1="$PS1"'>> '                 # prompt: always >>
	PS1="$PS1"'\[\e[0;33m\]'        # change color to yellow
fi

MSYS2_PS1="$PS1"               # for detection by MSYS2 SDK's bash.basrc

# Evaluate all user-specific Bash completion scripts (if any)
if test -z "$WINELOADERNOEXEC"
then
	for c in "$HOME"/bash_completion.d/*.bash
	do
		# Handle absence of any scripts (or the folder) gracefully
		test ! -f "$c" ||
		. "$c"
	done
fi
