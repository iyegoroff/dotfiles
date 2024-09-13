# Print sound volume

run_segment() {
    local info=$(amixer get PCM)
    local volume=$(echo $info | paste -s | sed 's/.*\[\([0-9]*\)%.*/\1/')
    local mute=$(echo $info | grep "\[off\]")
    local is_quiet=$(echo "$volume == 0" | bc -l)
    if [ -n "$mute" ] || (($is_quiet)); then
      echo " 󰝟 "
    else
      echo "󰕾 $volume"
    fi
	return 0
}
