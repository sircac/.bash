# ~/.bash_aliases: included in ~/.bashrc


#-- .bash_aliases --#
alias config="vim ~/.bash_aliases"
alias confin="source ~/.bash_aliases; echo -e '\n > File .bash_aliases reloaded.\n'"

#-- cd, ls,... --#
unalias rm
alias rm="rm -i"
unalias cp
alias cp="cp -iav" # https://www.rapidtables.com/code/linux/cp.html
unalias ls
alias ls='ls --color'
lth() { pwd; ls -ltrah --color=auto "$@"; pwd; }
lth() { 
  place=$(readlink -f .)
  if [ $# -gt 0 ]; then
    input=$(find $@ -print -quit)
    if [ -d $input ]; then
      place=$(readlink -f $input )
    else
      place=$(readlink -f $(dirname $input))
    fi
  fi
  echo $place; ls -ltrah --color=auto "$@"; echo $place;
}
alias l='lth'
alias x=cd
cs() {
  cd "$@"
  pwd
  ls -ltrah --color=auto
  pwd
}
alias c=cs
alias ..="c .."
alias ...="c ../.."
alias -- -="c -"
alias mo=more
alias cow="fortune | cowsay -n -f $(ls -1 /usr/share/cowsay/cows | shuf | head -n 1) | lolcat -f" # | aha --black


#-- terminal tools --#
e() {
  echo "$@"
}
t() {
  ./$@
}
tt() {
  /usr/bin/time -f "time:$(date +'%Y/%m/%d-%H:%M:%S')|real:%E|user:%U|sys:%S|cpu:%P" ./$@
}
xx() {
  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
  # Execute anything detached from terminal...
  # any_command >& /dev/null &
  setsid "$@" >& /dev/null &
  sleep 0.01
}
psao() { # My particular terminator...
  killall -r "$@"
  ps aux | grep -i "$@" | awk {'print $2'} | xargs kill -9
}
isrunning() {
  ps aux | grep -v " grep --color=auto -i $@" | grep -i "$@"
  # | head -n-1
}
calc() { bc <<< "$@"; }
calc() { awk "BEGIN{ print $* }" ;}
# awk 'BEGIN {
#    arc = 0.7071;
#    PI = 3.14159265;
#    asin = atan2(arc, sqrt(1-arc*arc)) * 180 / PI;
#    acos = atan2(sqrt(1-arc*arc), arc) * 180 / PI;
#    atan = atan2(arc,1) * 180 / PI;
#    printf "The arc sin for %f is %f degrees\n", arc, asin
# }'
lsum() { ls "$@" | wc -l; }
alias count="lsum"
#alias count="find . | wc -l"
lls() { ls -tr "$@" | sed 's/ /\\n/g'; }
llf() { ls -ltrah --color=auto "${*: 1:$#-1}" | grep "${*: -1}"; }
# alias space="echo -e ' > Use also:\n   du -h\n   du -h -u file\n   du -h -s directory'; df -h | grep -e '.*/$'"
# alias s="df -h | grep \"Disp\"; df -h | grep \"/dev/mapper/vgubuntu-root\"; df -h | grep \"nvme0n1p\"; df -h | grep \"udev\";"
alias space='df -hT -x squashfs -x tmpfs -x devtmpfs'
alias s=space
sizethis() {
  SAVEIFS=$IFS
  IFS=$(echo -en "\n\b")
  depth=1
  if [ $# -gt 0 ]; then
    depth=$1
  fi
  folders="$(du --max-depth=${depth} -b | sort -nr | cut -f2-)"
  for folder in $folders
  do
    du -hs "$folder"
  done
  IFS=$SAVEIFS
}
alias sz=sizethis
alias sizethisfast="du --max-depth=0 -h"
alias sf=sizethisfast
#alias sizethis="du --max-depth=1 -b | sort -nr | cut -f2- | xargs du -hs"
#alias listappsize="dpkg-query --show --showformat='${Package;-50}\t${Installed-Size}\n' | sort -k 2 -n | grep -v deinstall | awk '{printf "%.3f MB \t %s\n", $2/(1024), $1}' | tail -n 50"
alias ffind="echo 'find . -iname _*.txt_ | xargs grep _string_ -sl'"
# find a string within a string:
strindexfirst() {
  x="${1%%$2*}"
  [[ $x = $1 ]] && echo -1 || echo ${#x}
} # strindexfirst "123abc789" "abc"
alias strindex=strindexfirst
strindexlast() {
  x="${1%$2*}"
  [[ $x = $1 ]] && echo -1 || echo ${#x}
}
alias dif='diff -bitw --side-by-side --left-column'
alias fecha="date +'%Y_%m_%d'"
alias hora="date +'%H_%M_%S.%N'"
alias utar="tar xvzf"
# To render nicely a JSON file...
json () {
  jq --color-output . $@ | less -R
}
# To render an output with return carriages \r
cleanr () {
  if [[ -f ${1} ]] ; then
    cat ${1} | while read line; do
      echo ${line}
    done
  else
    echo -e "${1}" | cat | while read line; do
      echo ${line}
    done
  fi
}
# To order alphabetically in time the items in a folder
atouch () {
  start=`date -R`
  i=1
  find ./* | sort -r |
  while read file; do
      touch -d "$start - $i min" "$file"
      i=$(($i + 1))
  done
}


#-- editors --#
alias emacs="emacs -nw"
alias remacs="%emacs"
alias v=vim
alias rv="%vim"
# alias letsvim="setxkbmap -option 'caps:ctrl_modifier'; xcape -e '#66=Escape' -t 100"
# alias unvim="setxkbmap -option; pkill xscape"
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super>Right','<Super>l']"
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super>Left','<Super>h']"
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Super>Up','<Super>k']"
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Super>Down','<Super>j']"
# alias lv=letsvim
# alias uv=unvim
alias ed=vim


#-- paths --#
# alias mnt="cs ~/mnt"
# alias mm="cs ~/mnt"
alias temp="cs $TMPDIR"
alias tmp='temp'

#-- ubuntu --#
alias sinstall="sudo apt install"
shell() {
  if [ $# -gt 0 ] ; then
    xx x-terminal-emulator --window-with-profile=hold_terminal -e $1
    #xx gnome-terminal --window-with-profile=hold_terminal -e $1
  else
    xx x-terminal-emulator
  fi
}
alias n='xx nautilus . '
cleanboot() {
  sudo echo ""
  echo "Kernels @ /boot:"
  ll /boot/config-*-generic
  echo ""
  echo -n "sudo apt-get remove --purge "
  # sudo dpkg --list 'linux-image*' | grep ^ii | grep -v "-extra-" | awk '{print $2}' | sort | egrep "[0-9]-generic" | head -n -2 | tr '\n' ' '
  sudo dpkg --list 'linux-image*' | grep ^ii | grep -v "-extra-" | awk '{print $2}' | sort | egrep "[0-9]-generic" | head -n -1 | tr '\n' ' '
  echo ""
  echo ""
}
alias graphics="lspci | grep VGA; lspci -v -s 00:02.0"
# alias ofstab="sudo gedit /etc/fstab &; echo ' > if not work try: sudo ${EDITOR} /etc/fstab &'"
# alias ogrub="sudo gedit /etc/default/grub &; echo ' > old style in: /boot/grub/grub.cfg'; echo ' > if not work try: sudo ${EDITOR} /etc/grub.d/40_custom &'; echo ' > after change it do: sudo update-grub'"
# alias ogrub="echo ' > try:'; echo '   sudo su'; echo '   cd /usr/share/images/desktop-base'; echo '   gedit /boot/grub/grub.cfg &'; echo '   gedit /etc/default/grub &'; echo '   gedit /etc/grub.d/05_debian_theme &'; echo '   gedit /etc/grub.d/40_custom &'; echo ' > after change it do: sudo update-grub'"


#-- PROGRAMS --#
# alias root="root -l"
ume(){
  tar_ume(){
    if [ ! -f .ume.d ]; then
      tar -cf .ume.d ./.himitsu/*
      if [ -f .ume.d ]; then
        rm -fr .himitsu
        chmod 660 .ume.d
      fi
    fi
  }
  if [ ! -d .himitsu ]; then
    if [ ! -f .ume.d ]; then
      mkdir .himitsu
      chmod 760 .himitsu
      touch .himitsu/_
      chmod 660 .himitsu/_
      tar_ume
    fi
    tar xf .ume.d
    if [ -d .himitsu ]; then
      rm -fr .ume.d
      ( ( nautilus .himitsu ) & ) &
    fi
  else
    tar_ume
  fi
}
alias web1="sudo nethogs wlan0"
alias web2="sudo nethogs usb0"



#-- PING --#
alias pingu='ping 8.8.8.8'
# You can get a lot of info from an IP with 'dig www.google.es ANY'.
# Also check the open DNS service: http://www.opennicproject.org/
boolpingthis(){ ping -c 1 -W 1 "$@" &> /dev/null && echo 1 || echo 0; }
pingthis(){ [ $( boolpingthis "$@" ) == "1" ] &&  echo "Is online! :D" || echo "Seems offline... :("; }
alertonping(){
  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
  if [ $# -gt 1 ] ; then
    respawn=$(( $2 ))
  else
    respawn=60
  fi
  while [ 1 ]
  do
    momento=$( date +'%H:%M:%S %d/%m/%Y' )
    #ping $1 -c 1
    #if [ $? = 0 ]
    if [ $( boolpingthis "$1" ) == "1" ]
    then
      echo "Finally is online at $momento! :D"
      xx paplay /usr/share/sounds/Yaru/stereo/complete.oga >& /dev/null
      xx zenity --info --text "$1 is finally online\nat $momento! :D" >& /dev/null
      #--warning
      #--error
      break
    else
      echo "Seems offline at $momento... :("
    fi
    sleep $respawn
  done
}
beepalert(){
  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
  xx paplay /usr/share/sounds/Yaru/stereo/complete.oga >& /dev/null
  if [ $# -gt 0 ] ; then
    xx zenity --info --text $@ >& /dev/null
  fi
}
checkinternet() {
  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
  frequency=8
  if [ $# -gt 0 ] ; then
    frequency=$(( $1 - 2 ))
  fi
  initonline=true
  if ! ping -c1 google.com >& /dev/null; then
    initonline=false
    echo "We are offline... waiting for internet connection every $(( $frequency + 2 ))s"
  else
    echo "We are online... checking for disconnection every $(( $frequency + 2 ))s"
  fi
  downTime=0
  lastAccessTime=$(date +"%s")
  lastCheckTime=$(date +"%s")
  sleep 1s
  while [ true ]; do
    if ! ping -c1 google.com >& /dev/null; then
      #offline
      downTime=$(( $(date +"%s") - $lastAccessTime ))
    else
      #online
      downTime=0
      lastAccessTime=$(date +"%s")
    fi
    if [ $(( $(date +"%s") - $lastCheckTime )) -ge 120 ]; then
      lastCheckTime=$(date +"%s")
      #echo "Still checking... $(date '+%Y-%m-%d %H:%M:%S')"
      if [ "$initonline" = true ]; then
        echo "Still online... $(date '+%H:%M:%S')"
      else
        echo "Still offline... $(date '+%H:%M:%S')"
      fi
    fi
    if [ "$initonline" = true ]; then
      if [ $downTime -ge $(( $frequency * 3 )) ]; then
        # finally offline
        echo "We lost internet connection! $(date '+%H:%M:%S')"
        xx paplay /usr/share/sounds/Yaru/stereo/dialog-question.oga
        notify-send -i software-update-urgent "We lost internet connection!" -t $(( ( $frequency + 1 ) * 1000 ))
      fi
    else
      if [ $downTime -eq 0 ]; then
        # finally online
        echo "Finally coneccted to internet! $(date '+%H:%M:%S')"
        xx paplay /usr/share/sounds/Yaru/stereo/complete.oga >& /dev/null
        notify-send -i package_network "Finally coneccted to internet!" -t $(( ( $frequency + 1 ) * 1000 ))
      fi
    fi
    sleep "$(( $frequency + 2 ))s"
  done
}
alias checkin=checkinternet



#-- NET --#
alias ports='sudo netstat -taupen'
alias hiftop="sudo iftop -i wlo1"



#-- SSH --#
# gpg -c .filepass (and introduce system pass)
gpgpassit(){
  # $1 the gpg protected file without ~/.*pass.gpg
  # $2 is the user@server to ssh
  if [ ! -f ~/.$1pass ]; then
    gpg -d -q ~/.$1pass.gpg > ~/.$1pass
    chmod 400 ~/.$1pass
  fi
  ( ( sleep 2s; find ~/.*pass -type 'f' -size -10k -delete ) &) &> /dev/null
  if [ $# -gt 1 ] ; then
    sshpass -f ~/.$1pass ${@:2}
  else
    cat ~/.$1pass
  fi
}
ugpgpassit(){
  # To update or store a new password
  if [ -f ~/.$1pass.gpg ]; then
    echo "Old password: $(gpg -d -q ~/.$1pass.gpg)"
    mv -f ~/.$1pass.gpg ~/.$1pass.gpg.old
  fi
  read -s -p "New password: " pass
  echo $pass > ~/.$1pass
  echo ""
  echo "Now introduce system pass..."
  gpg -c ~/.$1pass
  echo "Done!"
  ( ( sleep 2s; find ~/.*pass -type 'f' -size -10k -delete ) &) &> /dev/null
}
# Usage:
# alias server="gpgpassit server ssh user@server -X"
# More:

# TIMER bar
timer(){
  #timer TOTAL_MINUTES WARNING_1 WARNING_2
  TOTAL_MINUTES=$1
  break1=0
  break2=0
  echo ''
  echo " timer $1 $2 $3 "
  echo ''
  source ~/.bash/extra/bar.sh   
  i=0               
  total=$( echo "(60*${TOTAL_MINUTES})/1" | bc )
  if [ $# -gt 1 ] ; then
    warn1=$( echo "(60*$2)/1" | bc )
    break1=1
  fi
  if [ $# -gt 2 ] ; then
    warn2=$( echo "(60*$3)/1" | bc )
    break2=1
  fi
  max_size=120
  size=$( echo "(60*${TOTAL_MINUTES})/1" | bc )
  if [ $total -gt ${max_size} ] ; then
    size=$( echo "(10*${TOTAL_MINUTES})/1" | bc )
    if [ $total -gt ${max_size} ] ; then
      size=${max_size}
    fi
  fi
  bar '    > '      
  for ((i=1; i <= $total; i++)); do
    bar $i $total $size
    if [ $# -gt 1 ] ; then
      if [ $i -gt $warn1 ] && [ $break1 -gt 0 ] ; then
        # echo "BREAK #1"
        echo ""
        echo ""
        echo "BREAK #1"
        echo ""
        break1=$(($break1-1))
      fi
    fi
    if [ $# -gt 2 ] ; then
      if [ $i -gt $warn2 ] && [ $break2 -gt 0 ] ; then
        echo ""
        echo ""
        echo "BREAK #2"
        echo ""
        break2=$(($break2-1))
      fi
    fi
    sleep 1
  done
  bar
  echo ''
  echo ''
}

# VNC servers
alias vnc="~/.bash/extra/scrapping_vnc.sh"
#myshowvncserver() {
#  if [ -f ~/.vnc/x11vncPORT.txt ]; then
#    port=$( grep -i "PORT=" ~/.vnc/x11vncPORT.txt )
#    port=${port#"PORT="}
#    echo " vncviewer -via user@server localhost:$port"
#  else
#    echo " > vncserver not running..."
#    echo "   startvnc"
#  fi
#}
#alias showvncserver=myshowvncserver
#alias showvnc=showvncserver
#mystartvncserver() {
#  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
#  if [ $# -gt 0 ] ; then
#    local=$(( $1 ))
#  else
#    local=2
#  fi
#
#  for f in ~/.vnc/*:${local}.pid; do
#    #[ -e "$f" ] && echo "vncserver :${local} already running" || vncserver :${local}
#    if [ -e "$f" ]; then
#      echo " > vncserver :${local} already running"
#      showvnc
#      #echo "killing vncserver :${local} ..."
#      #vncserver -kill :${local}
#      #rm ~/.vnc/x11vncPORT.txt -fr
#    else
#      vncserver :${local};
#      ( ( x11vnc -shared -forever -display :${local} >> ~/.vnc/x11vncPORT.txt )& )&
#      ( sleep 5.0; echo " ";  echo " "; showvnc; echo " ";  echo " " )&
#    fi
#    break
#  done
#}
##alias startvncserver="((vncserver -kill :\!*; vncserver :\!*; xhost +; ~/vnc/x11vnc -shared -forever -display :\!* )&)&"
#alias startvncserver=mystartvncserver
#alias startvnc="startvncserver"
#myendvncserver() {
#  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
#  if [ $# -gt 0 ] ; then
#    local=$(( $1 ))
#  else
#    local=2
#  fi
#
#  for f in ~/.vnc/*:${local}.pid; do
#    #[ -e "$f" ] && echo "vncserver :${local} already running" || vncserver :${local}
#    if [ -e "$f" ]; then
#      echo " > killing vncserver :${local} ..."
#      vncserver -kill :${local}
#      rm ~/.vnc/x11vncPORT.txt -fr
#    else
#      echo " > vncserver :${local} is not running, nothing to kill..."
#    fi
#    break
#  done
#}
#alias endvncserver=myendvncserver
#alias endvnc="endvncserver"
#alias killvncserver="endvnc"
#alias killvnc="endvnc"
# uxplay() {
#   tmux new -s "UxPlay" -d "~/UxPlay/build/uxplay"
# }

# SSH tunneling
report_local_port_forwardings() {
  echo " = LOCAL PORT FORWARDINGS ="
  lsof -a -i4 -P -c '/^ssh$/' -u$USER -s TCP:LISTEN
  echo " by "
  ps -f -p $(lsof -t -a -i4 -P -c '/^ssh$/' -u$USER -s TCP:LISTEN)
}
report_remote_port_forwardings() {
  echo " = REMOTE PORT FORWARDING ="
  ps -f -p $(lsof -t -a -i -c '/^ssh$/' -u$USER -s TCP:ESTABLISHED) | awk '
  NR == 1 || /R (\S+:)?[[:digit:]]+:\S+:[[:digit:]]+.*/
  ' 
}
tunnels(){
  report_local_port_forwardings
  report_remote_port_forwardings
}
close_tunnels(){
  for pid in `ps -f -p $(lsof -t -a -i4 -P -c '/^ssh$/' -u$USER -s TCP:LISTEN) | grep ssh | awk '{print $2}'`; do
    kill $pid
  done
}
# sudo ss -tulpn | egrep 'Port|5911|5910|5900|5921'
# sudo lsof -i -P -n | egrep 'NAME|LISTEN' | egrep 'NAME|5911|5910|5900|5921'

# VPN:
# alias vpn="xx ~/netExtenderClient/netExtenderGui; xx remmina"

# TMUX
ta(){
  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
  if [ $# -eq 0 ]; then
    tmux attach
  else
    session_name=$( tmux ls | awk -F ":" '{print $1}' | sed "${1}q;d" )
    echo "Attaching to \"# $1 ${session_name}\"..."
    tmux attach-session -t "${session_name}"
  fi
}
alias at=ta
tk(){
  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
  if [ $# -eq 0 ]; then
    tmux kill-session
  else
    session_name=$( tmux ls | awk -F ":" '{print $1}' | sed "${1}q;d" )
    echo "Killing \"# $1 ${session_name}\"..."
    tmux kill-session -t "${session_name}"
  fi
}
alias tl="tmux ls | cat -n | sed 's/\t/ /g' | awk -F ' ' '{ \$1 = sprintf(\"[%s]\", \$1) } 1'"
alias lt=tl
tn() {
  title="nova $@ | `date +'%Y-%m-%d %Hh%M %Ss'`"
  tmux new -s "${title}"
}
# tserver() {
#   title="server | `date +'%Y-%m-%d %Hh%M %Ss'`"
#   tmux new -s "${title}" 'ssh user@server -X'
# }
alias tx="tmux kill-server"

#-- REMOTE MOUNTING --#
#mymountserver() {
#  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
#  echo " > Mounting... "
#  modprobe fuse
#  sshfs user@server:/path/remote/folder /path/local/folder
#  echo " > Mounted!                                                                 "
#}
#myumountserver(){
#  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
#  echo " > Unmounting..."
#  fusermount -zu /path/local/folder | echo -e "\r"
#  echo " > Unmounted!                                                               "
#}

# For PDF compression check also ~/.bash/extra/shrinkpdf.sh
# For text detection in a PDF check also 'ocrmypdf input.pdf output.pdf'
#For vectorize fonts on PDF to PS
mypdf2ps() {
  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
  if [ $# -gt 1 ] ; then
    input=$1
    output=$2
  elif [ $# -gt 0 ] ; then
    input=$1
    output=${1%.*}
    output="${output}.ps"
  else
    return
  fi
  echo "${input} -> ${output}"
  gs -sDEVICE=ps2write -dNOCACHE -sOutputFile=${output} -q -dbatch -dNOPAUSE ${input} -c quit
}
alias pdf2ps=mypdf2ps
#For render asimage a PDF
mypdf2png() {
  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
  if [ $# -gt 1 ] ; then
    input=$1
    output=$2
  elif [ $# -gt 0 ] ; then
    input=$1
    output=${1%.*}
    output="${output}.png"
  else
    return
  fi
  echo "convert -density 150 ${input} -quality 100 ${output}"
  convert -density 150 ${input} -quality 100 ${output}
# convert -density 150/300 r180322_weekly_summary.pdf -quality 90/Compression r180322_weekly_summary.png
}
alias pdf2png=mypdf2png
# pdf2eps
mypdf2eps() {
  pdfcrop $2.pdf
  pdftops -f $1 -l $1 -eps "$2-crop.pdf" 
  rm -fr  "$2-crop.pdf"
  mv  "$2-crop.eps" ${2}_p${1}.eps
}
alias pdf2eps=mypdf2eps

# NOTES about image resizing and concatenating:
unalias img
img() {
 echo "imgsize ./*.* # To list image dimensions"
 echo "convert -append *.png out.png # For vertical concatenating"
 echo "convert +append *.png out.png # For horizontal concatenating"
 echo "convert '*.jpg[200x]' resized%03d.png # For resizing to a fixed width keeping the ratio"
 echo "convert '*.jpg[x200]' resized%03d.png # For resizing to a fixed height keeping the ratio"
 echo "convert myimage.png -rotate 90 myimage-rotated.png # To rotate clockwise an image"
}
# https://askubuntu.com/questions/135477/how-can-i-scale-all-images-in-a-folder-to-the-same-width

# To make a simple bash script ready to edit
mymakebash() {
  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
  if [ $# -gt 0 ] ; then
    script_file="$1.sh"
  else
    la_fecha="$( fecha )"
    la_hora="$( hora )"
    script_file="temp_bash__${la_fecha}__${la_hora}.sh"
  fi
  if [ ! -f $script_file ]; then
    echo -e -n "#!/bin/bash\n{\n\n  #do things with parameters like \$@, \$1, \${@:3}, \${*: -1}, \${*: 1:\$#-1}...:\n\n  echo \" > Done!\"\n  echo \"\"\n\n  exit\n\n}" > $script_file
    chmod +x $script_file
    vim $script_file
    # emacs $script_file
    # rm -fr ${script_file}~
  else
    echo " > File $script_file already exists!"
  fi
}
alias makebash=mymakebash
alias mb=makebash


#For image info and more:
picroot() {
  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
  root '~/.bash/extra/pic.C("'$1'")' ${@:2}
}
# alias pic "root '/sps/km3net/users/sagustin/local/macros/utiles/pic.C("\""\!*"\"")'"
alias pic=feh
myslide() {
  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
  location=.
  if [ $# -gt 0 ] ; then
    option=$1
    if [ $1 -eq 0 ] ; then
      location=/path/to/folder1
    elif [ $1 -eq 1 ] ; then
      location=/path/to/folder2
    else
      location=/path/to/folder3
    fi
  fi
  xx feh --hide-pointer -zsZFD 7 $location
}
alias slide=myslide
myslideshow() {
  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
  if [ $# -gt 2 ] ; then
    location=$1
    timer=$2
    answer=$3
  elif [ $# -gt 1 ] ; then
    location=$1
    timer=$2
    answer=0
  elif [ $# -gt 0 ] ; then
    location=$1
    timer=5
    answer=0
  else
    location=`zenity --file-selection --directory --title="Choose your picture folder"`
    timer=`zenity --entry --title="Slideshow options" --text="Seconds between images" --entry-text "10"`
    if [ $timer -eq ""]; then
      exit 1
    fi
    zenity --question --ok-label="Random" --cancel-label="Not random" --text="Do you want it random?"
    answer=$?
  fi
  if [ $answer -eq 0 ]; then
    #echo "Random!"
    xx feh --hide-pointer -zsrZFD $timer $location
  else
    #echo "Not Random!"
    xx feh --hide-pointer -srZFD $timer $location
  fi
}
alias slideshow=myslideshow

# FOR NEW BASH:
#! /bin/bash
# ~/.bash_aliases: called in ~/.bashrc

unalias f &>/dev/null
function f { find . -name $@ -print ; } # to find a file in a hierarchy
unalias h &>/dev/null
function h { if [ $# -gt 0 ] ; then history | fgrep $@; else history; fi; } # just type 'h latex' to get the last latex command

#mynewless() {
#  echo $@
#  less ${1}
#  rm - -fr
#}
#alias less="less $@; rm - -fr;"
#alias less=mynewless

# To compile a C++ scprit to ROOT:
doroot () {
  # filename=$(basename "$fullfile")
  # extension="${filename##*.}"
  # filename="${filename%.*}"
  scriptname=$(basename "$1")
  scriptname="${scriptname%.*}"
  echo "Compiling ${scriptname}..."
  g++ -o ${scriptname} $1 `root-config --cflags` `root-config --libs` -lRooFitCore -lRooFit -g -Wl,--no-as-needed
  # # To do a library to load in python:
  # ROOTINCL = `${ROOTSYS}/bin/root-config --cflags`
  # rm -f ${scriptname}.so
  # rootcint -f ${scriptname}dict.cc -c -g ${ROOTINCL} ${scriptname}.cc ${scriptname}.linkdef.h
  # g++ -fPIC -c -g -o ${scriptname}dict.o ${ROOTINCL} ${scriptname}dict.cc
  # g++ -fPIC -c -g -o ${scriptname}.o ${ROOTINCL} ${scriptname}.cc
  # g++ -fPIC -shared ${ROOTINCL} -o ${scriptname}.so ${scriptname}dict.o ${scriptname}.o
  # rm -f ${scriptname}.o ${scriptname}dict.* ${scriptname}.linkdef.h
}
# doroot script.C

gitnotes() {
  echo " > Info:"
  echo "git remote -v"
  echo " > Creating:"
  echo "cd existing_folder"
  echo "git init"
  echo "git remote add origin https://github.com/sircac/.bash.git"
  echo "git add ."
  echo 'git commit -m "Initial commit" (-a)'
  echo "git push -u origin master"
  echo " > Updating:"
  echo "git pull origin master"
  echo " > Uploading:"
  echo "git add . (or whatever you want to add)"
  echo 'git commit -m "Comment about the commit" (-a)'
  echo "git push -u origin master"
}
gitout() {
  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
  if [ $# -gt 0 ] ; then
    git commit -a -m "$1"
  else
    git commit -a -m "Lazy commit without a meaningful comment at `date +'%Y/%m/%d %H:%M:%S.%N'`"
  fi
  git push -u origin master
}
gitin() {
  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
  git pull origin master
}

#maker() {
#  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
#  cd $1 > /dev/null
#  make ${@:2}
#  cd - > /dev/null
#}
#alias makes='maker src'
alias so='source setenv.sh'


mypanic() {
  #do things with parameters like $@, $1, ${@:3}, ${*: -1}, ${*: 1:$#-1}...:
  echo "KEEP CALM"
  echo ":D"
  echo ""
  echo "firefox -P \"mine\""
  echo "sudo apt-get install linux-image-3.16.0-55-generic"
  echo "apt-cache search linux-image"
  echo "mv .cache .cache_or"
  echo "dconf dump /org/compiz/ > .compiz_or"
  echo "dconf load /org/compiz/ < .compiz_or"
  echo "dconf load /org/compiz/ < .compiz_or_last_working"
  echo "dconf reset -f /org/compiz/"
  echo "rm .cache/dconf"
  echo "mv .config/monitors.xml .config/monitors_or.xml"
  echo "sudo apt-get update"
  echo "sudo apt-get install --reinstall ubuntu-desktop"
  echo "sudo apt-get install unity"
  echo "sudo shutdown -r now"
  echo "sleep 5; xrandr -d :0 -q"
  echo "chvt 7; xrandr -d :0 --output eDP1 --mode 1920x1080"
  echo "chvt 7; xrandr -d :0 --output DVI-1-0 --mode 1920x1080"
  echo "ll .config/monitors.xml_or"
  echo "chmod 775 .Xauthority .ICEauthority"
  echo "sudo lshw | grep product"
  echo "compilers; sudo /usr/lib/virtualbox/vboxdrv.sh setup"
  echo "pulseaudio -k && sudo alsa force-reload"
  echo "fusermount -zu /mount/point"
  echo "pkill -9 sshfs"
  echo "sudo apt-get remove virtualbox-5.1"
  echo "sudo dpkg -i virtualbox-5.1_5.1.26-117224~Ubuntu~xenial_amd64.deb"
  echo "ffmpeg -i ev40.mp4 out.gif"
  echo "ffmpeg -i video.mp4 -i audio.opus out.mp4"
  echo "pulseaudio -k && sudo alsa force-reload"
  echo "xrandr --output DP-3 --mode 1920x1080 --rate 60"
  echo "On slow boot:"
  echo "  systemd-analyze"
  echo "  systemd-analyze blame"
  echo "  e /etc/initramfs-tools/conf.d/resume"
  echo "  e /etc/default/grub"
  echo "  e /etc/fstab"
  echo "  blkid"
  echo "  tldr command"
}
alias panic=mypanic
alias shitdown='sudo shutdown -r now'
# alias monitor="xrandr --output DP-3 --mode 1920x1080 --rate 60"

# face recognition lock password
# sudo howdy list
# sudo howdy -U nikkun add
# sudo howdy config
# https://itsfoss.com/face-unlock-ubuntu/

# alias joke='~/.bash/extra/joke.pl 0 "todo va bien... ]:)~>"'

#EOF
