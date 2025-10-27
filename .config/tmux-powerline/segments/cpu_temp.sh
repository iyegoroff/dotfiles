# spellcheck shell=bash
# Prints CPU temperature
# Requirements:
#   lm_sensors (Linux only)
#   smctemp (Macos only)

source "$TMUX_POWERLINE_CONFIG_DIR/cpu_temp_util.sh"

run_segment() {
  local temp=$(cpu_temp_value)

  if [ -n "$temp" ]; then
      echo "${TMUX_POWERLINE_SEG_CPU_TEMP_ICON}${temp}°"
      return 0
  else
	    return 1
	fi
}

