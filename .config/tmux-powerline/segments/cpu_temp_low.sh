# Print CPU temperature

run_segment() {
    local temp=$(sensors | grep Package | sed -e 's/[^+]*+\([\s0-9\.]*\).*/\1/' | bc -l)
    local is_low=$(echo "$temp < $TMUX_POWERLINE_SEG_CPU_TEMP_THRESHOLD" | bc -l)
    if (($is_low)); then
      echo " $temp°"
    fi
	return 0
}
