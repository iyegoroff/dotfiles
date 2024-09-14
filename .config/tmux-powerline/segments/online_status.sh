# Print online status

platform=$(uname)

if [[ $platform == "Darwin" ]]; then
  run_segment() {
    if ($(ping -c 1 -t 3 www.google.com >/dev/null 2>&1)); then
      echo "󰖩"
    else
      echo "󰤯"
    fi

  	return 0
  }
else
  run_segment() {
    if ($(ping -c 1 -w 3 www.google.com >/dev/null 2>&1)); then
      echo "󰖩"
    else
      echo "󰤯"
    fi

  	return 0
  }
fi

