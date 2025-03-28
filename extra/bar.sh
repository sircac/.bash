#!/bin/bash
{

  # A simple bar progress with simple use...
  # bar "  > " ("[=>-]#") # Settings...
  # bar i total (length)  # Use...

  export pbar_last=''
  export pbar_status=0
  export pbar_start=`date +%s%N`
  export pbar_settings='   [=>-]='
  # export pbar_settings='  [=>-]#'
  bar() { # int current[1,total] (int total int barsize) OR 'tabs' ('[=>-]#')

    if [[ $# -eq 0 ]]; then
      local now=`date +%s%N`
      local runtime=$(( $now-$pbar_start ))
      runtime=$(( $runtime / 1000000000 ))
      echo -n "$pbar_last"
      printf " - TIME %d:%0.2d \e[K" $(( $runtime/60 )) $(( $runtime%60 ))
      echo -en "\033[K\r"
      return
    fi

    # Setting the bar
    if ! [[ $1 =~ ^-?[0-9]+$ ]] ; then
      if [[ $# -ge 2 ]]; then
        export pbar_settings="$1$2";
      else
        export pbar_settings="$1${pbar_settings:${#pbar_settings}-6:6}"
      fi
      return
    fi

    # Let's get the bar variables
    if [ $pbar_status -eq 0 ]; then
      pbar_status=1
      pbar_start=`date +%s%N`
      export pbar_ended=${pbar_settings:${#pbar_settings}-1:1}
      export pbar_right="${pbar_settings:${#pbar_settings}-2:1}"
      export pbar_notfill="${pbar_settings:${#pbar_settings}-3:1}"
      export pbar_arrow="${pbar_settings:${#pbar_settings}-4:1}"
      export pbar_fill="${pbar_settings:${#pbar_settings}-5:1}"
      export pbar_left="${pbar_settings:${#pbar_settings}-6:1}"
      export pbar_tab="${pbar_settings:0:${#pbar_settings}-6}"
    fi

    local pbar_current=$1
    local pbar_total=100
    if [[ $# -ge 2 ]]; then pbar_total=$2; fi
    local pbar_size=10
    if [[ $# -ge 3 ]]; then pbar_size=$3; fi

    # Let's draw the bar
    local j=0
    local fill=$pbar_fill
    local arrow=$pbar_arrow
    local progress=$(( ($pbar_size * 1000 * $pbar_current ) / ( $pbar_total * 1000 ) ))
    if [ $progress == $pbar_size ]; then
      fill="$pbar_ended";
      arrow="$pbar_ended";
    fi
    #
    # echo -n "$pbar_tab$pbar_left"
    # for ((j=0; j < $progress; j++)) ; do echo -n "$fill"; done
    # echo -n "$arrow"
    # for ((j=$progress; j < $pbar_size; j++)) ; do echo -n "$pbar_notfill"; done
    # echo -n "$pbar_right "
    # printf "% 3s.%d%% (% ${#pbar_total}s/%i)" $(( $pbar_current*100/$pbar_total )) $(( ($pbar_current*1000/$pbar_total)%10 )) $pbar_current $pbar_total
    #
    pbar_last="$pbar_tab$pbar_left"
    for ((j=0; j < $progress; j++)) ; do pbar_last="$pbar_last$fill"; done
    pbar_last="$pbar_last$arrow"
    for ((j=$progress; j < $pbar_size; j++)) ; do pbar_last="$pbar_last$pbar_notfill"; done
    pbar_last="$pbar_last$pbar_right $(printf "% 3s.%d%% (% ${#pbar_total}s/%i)" $(( $pbar_current*100/$pbar_total )) $(( ($pbar_current*1000/$pbar_total)%10 )) $pbar_current $pbar_total)"
    if [ -z "$ENVIRONMENT" ] || [ $ENVIRONMENT = "ACCESS" ]; then
      echo -n "$pbar_last"
      local now=`date +%s%N`
      local runtime=$(( $now-$pbar_start ))
      if [ $progress == $pbar_size ]; then
        runtime=$(( $runtime / 1000000000 ))
        printf " - TIME %d:%0.2d \e[K" $(( $runtime/60 )) $(( $runtime%60 ))
      elif [[ $pbar_current > 1 ]]; then
        runtime=$(( ( ( $runtime * $pbar_total / ($pbar_current - 1) ) - $runtime ) / 1000000000 ))
        printf " - ETA %d:%0.2d \e[K" $(( $runtime/60 )) $(( $runtime%60 ))
      else
        printf " - ETA ??:?? \e[K"
      fi
      echo -en "\033[K\r"
    fi
    #

    if [ $progress == $pbar_size ]; then pbar_status=0; fi

  }

  return

}
