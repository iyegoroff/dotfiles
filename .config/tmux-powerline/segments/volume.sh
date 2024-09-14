# Print sound volume

platform=$(uname)

if [[ $platform == "Darwin" ]]; then
  run_segment() {
    local volume=$(osascript -e 'output volume of (get volume settings)')
    if [[ $volume == "0" ]]; then
      echo " 󰝟 "
    else
      echo "󰕾 $volume"
    fi

    return 0
  }
else
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
fi
