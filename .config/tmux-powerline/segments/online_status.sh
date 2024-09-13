# Print online status

run_segment() {
    if ($(ping -c 1 -w 3 www.google.com >/dev/null 2>&1)); then
      echo "󰖩"
    else
      echo "󰤯"
    fi
	return 0
}
