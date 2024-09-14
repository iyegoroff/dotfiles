# Print CPU temperature

platform=$(uname)

if [[ $platform == "Darwin" ]]; then
  run_segment() {
    local temp=$(smctemp -c | bc -l)
    local is_high=$(echo "$temp >= $TMUX_POWERLINE_SEG_CPU_TEMP_THRESHOLD" | bc -l)
    if (($is_high)); then
      echo " ${temp}°"
    fi

  	return 0
  }
else
  run_segment() {
    local temp=$(sensors | grep Package | sed -e 's/[^+]*+\([\s0-9\.]*\).*/\1/' | bc -l)
    local is_high=$(echo "$temp >= $TMUX_POWERLINE_SEG_CPU_TEMP_THRESHOLD" | bc -l)
    if (($is_high)); then
      echo " $temp°"
    fi

  	return 0
  }
fi

