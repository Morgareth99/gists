#
# Init file for fish
#

#
# Some things should only be done for login terminals
#

if status --is-login

	#
	# Set some value for LANG if nothing was set before, and this is a
	# login shell.
	#

	if not set -q LANG >/dev/null
		set -gx LANG en_US.UTF-8
	end

	# Check for i18n information in
	# /etc/sysconfig/i18n

	if test -f /etc/sysconfig/i18n
		eval (cat /etc/sysconfig/i18n |sed -ne 's/^\([a-zA-Z]*\)=\(.*\)$/set -gx \1 \2;/p')
	end

	#
	# Put linux consoles in unicode mode.
	#

	if test "$TERM" = linux
		if expr "$LANG" : ".*\.[Uu][Tt][Ff].*" >/dev/null
			if which unicode_start >/dev/null
				unicode_start
			end
		end
	end
end

function _common_section
  printf $c1
  printf $argv[1]
  printf $c0
  printf ":"
  printf $c2
  printf $argv[2]
  printf $argv[3]
  printf $c0
  printf ", "
end

function section
  _common_section $argv[1] $c3 $argv[2] $ce
end

function error
  _common_section $argv[1] $ce $argv[2] $ce
end

alias ls "ls --color=auto --group-directories-first"

function fish_prompt
  # $status gets nuked as soon as something else is run, e.g. set_color
  # so it has to be saved asap.
  set -l last_status $status

  # c0 to c4 progress from dark to bright
  # ce is the error colour
  set -g c0 (set_color 005284)
  set -g c1 (set_color 0075cd)
  set -g c2 (set_color 009eff)
  set -g c3 (set_color 6dc7ff)
  set -g c4 (set_color ffffff)
  set -g ce (set_color $fish_color_error)

  # Clear the line because fish seems to emit the prompt twice. The initial
  # display, then when you press enter.
  printf "\033[K"

  # Current time
  # printf (date "+$c2%H$c0:$c2%M$c0:$c2%S, ")
  if [ $last_status -ne 0 ]
      error last $last_status
      set -ge status
  end

  # Track the last non-empty command. It's a bit of a hack to make sure
  # execution time and last command is tracked correctly.
  set -l cmd_line (commandline)
  if test -n "$cmd_line"
      set -g last_cmd_line $cmd_line
      set -ge new_prompt
  else
      set -g new_prompt true
  end

  # Show last execution time and growl notify if it took long enough
  set -l now (date +%s)
  if test $last_exec_timestamp
      set -l taken (math $now - $last_exec_timestamp)
      if test $taken -gt 10 -a -n "$new_prompt"
          error taken $taken
          echo "Returned $last_status, took $taken seconds"
          # Clear the last_cmd_line so pressing enter doesn't repeat
          set -ge last_cmd_line
      end
  end
  set -g last_exec_timestamp $now

  # Show loadavg when too high
  set -l load1m (uptime | grep -o '[0-9]\+\.[0-9]\+' | head -n1)
  set -l load1m_test (math $load1m \* 100 / 1)
  if test $load1m_test -gt 100
      error load $load1m
  end

  # Show disk usage when low
  set -l du (df / | tail -n1 | sed "s/  */ /g" | cut -d' ' -f 5 | cut -d'%' -f1)
  if test $du -gt 80
      error du $du%%
  end

  # Virtual Env
  if set -q VIRTUAL_ENV
      section env (basename "$VIRTUAL_ENV")
  end


  # Current Directory
  # 1st sed for colourising forward slashes
  # 2nd sed for colourising the deepest path (the 'm' is the last char in the
  # ANSI colour code that needs to be stripped)
  printf $c1
  printf (pwd | sed "s#$HOME#~#g" | sed "s,/,$c0/$c1,g" | sed "s,\(.*\)/[^m]*m,\1/$c3,")

  # Prompt on a new line
  printf $c4
  printf " > "
end

set -g -x fish_greeting ""

set -gx LESS_TERMCAP_mb \e'[01;31m'
set -gx LESS_TERMCAP_mb \e'[04;34m'
set -gx LESS_TERMCAP_md \e'[01;33m'
set -gx LESS_TERMCAP_me \e'[0m'
set -gx LESS_TERMCAP_se \e'[0m'
set -gx LESS_TERMCAP_so \e'[01;44;33m'
set -gx LESS_TERMCAP_ue \e'[0m'
set -gx LESS_TERMCAP_us \e'[01;32m'

set -g -x LS_COLORS 'bd=48;5;108;38;5;223;01:ca=01;38;5;95:cd=48;5;108;38;5;223;01:di=01;38;5;61:do=48;5;234;38;5;180;01:ex=01;38;5;108:pi=48;5;234;38;5;180;01:ln=48;5;234;38;5;223:or=48;5;234;38;5;187:ow=48;5;234;38;5;180:su=48;5;234;38;5;66:sg=48;5;234;38;5;66:so=48;5;234;38;5;180;01:st=48;5;180;38;5;234:tw=48;5;180;38;5;234:*.7z=01;38;5;174:*.arj=01;38;5;174:*.bz2=01;38;5;174:*.bz=01;38;5;174:*.gz=01;38;5;174:*.rar=01;38;5;174:*.tar=01;38;5;174:*.tgz=01;38;5;174:*.tbz=01;38;5;174:*.tbz2=01;38;5;174:*.xz=01;38;5;174:*.zip=01;38;5;174:*.apk=01;38;5;95:*.deb=01;38;5;174:*.jad=01;38;5;95:*.jar=01;38;5;95:*.rpm=01;38;5;174:*.bmp=00;38;5;109:*.gif=00;38;5;109:*.ico=00;38;5;109:*.jpg=00;38;5;109:*.JPG=00;38;5;109:*.jpeg=00;38;5;109:*.png=00;38;5;109:*.svg=00;38;5;109:*.xbm=00;38;5;109:*.xpm=00;38;5;109:*.aac=00;38;5;106:*.au=00;38;5;106:*.flac=00;38;5;106:*.mid=00;38;5;106:*.midi=00;38;5;106:*.mka=00;38;5;106:*.mp3=00;38;5;106:*.mpc=00;38;5;106:*.ogg=00;38;5;106:*.ra=00;38;5;106:*.wav=00;38;5;106:*.mov=00;38;5;66:*.mpg=00;38;5;66:*.mpeg=00;38;5;66:*.m2v=00;38;5;66:*.mkv=00;38;5;66:*.ogm=00;38;5;66:*.mp4=00;38;5;66:*.m4v=00;38;5;66:*.mp4v=00;38;5;66:*.vob=00;38;5;66:*.qt=00;38;5;66:*.nuv=00;38;5;66:*.wmv=00;38;5;66:*.asf=00;38;5;66:*.rm=00;38;5;66:*.rmvb=01;38;5;66:*.flc=00;38;5;66:*.avi=00;38;5;66:*.fli=00;38;5;66:*.flv=00;38;5;66:*.gl=00;38;5;66:*.m2ts=00;38;5;66:*.divx=00;38;5;66:*.webm=00;38;5;66:*.awk=00;38;5;151:*.bash=00;38;5;151:*.bat=00;38;5;151:*.BAT=00;38;5;151:*.sed=00;38;5;151:*.sh=00;38;5;151:*.zsh=00;38;5;151:*CMakeLists.txt=00;38;5;187:*.cabal=00;38;5;187:*Makefile=00;38;5;187:*.mk=00;38;5;187:*.make=00;38;5;187:*.c=01;38;5;187:*.h=01;38;5;187:*.s=01;38;5;187:*.cs=01;38;5;187:*.java=01;38;5;187:*.scala=01;38;5;187:*.hs=01;38;5;187:*.py=01;38;5;187:*.rb=01;38;5;187:*.php=01;38;5;187:*.pl=01;38;5;187:*.vim=01;38;5;187:*.js=01;38;5;187:*.coffee=01;38;5;187:*.go=01;38;5;187:*.lisp=01;38;5;187:*.scm=01;38;5;187:*.txt=04;38;5;188:*.tex=04;38;5;188:*.html=04;38;5;188:*.xhtml=04;38;5;188:*.xml=04;38;5;188:*.md=04;38;5;188:*.mkd=04;38;5;188:*.markdown=04;38;5;188:*.org=04;38;5;188:*.pandoc=04;38;5;188:*.pdc=04;38;5;188:*.pdf=04;38;5;188:*rc=04;38;5;180:*.conf=04;38;5;180:*Dockerfile=04;38;5;180:*README=04;38;5;187:*LICENSE=04;38;5;187:*AUTHORS=04;38;5;187:*.gitignore=00;38;5;248:*.gitmodules=00;38;5;248:*.log=00;38;5;239:*.bak=00;38;5;239:*.aux=00;38;5;239:*.toc=00;38;5;239:*~=00;38;5;239:*#=00;38;5;239:*.swp=00;38;5;239:*.tmp=00;38;5;239:*.temp=00;38;5;239:*.o=00;38;5;239:*.pyc=00;38;5;239:*.class=00;38;5;239:*.cache=00;38;5;239:*.pacnew=48;5;95;38;5;108:*.pacsave=48;5;95;38;5;108:*.pacorig=48;5;95;38;5;108:*PKGBUILD=00;38;5;110:*.rpmsave=48;5;95;38;5;108:*.rpmorig=48;5;95;38;5;108:*.rpmnew=48;5;95;38;5;108:*.spec=00;38;5;110:'



