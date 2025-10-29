# shellcheck shell=bash
# Prints memory usage
# In context of this segment "1 GB" means 1073741824 bytes.

TMUX_POWERLINE_SEG_MEM_USED_ICON_DEFAULT=" "

generate_segmentrc() {
	read -r -d '' rccontents <<EORC
# Memory icon
export TMUX_POWERLINE_SEG_MEM_USED_ICON="${TMUX_POWERLINE_SEG_MEM_USED_ICON_DEFAULT}"
EORC
	echo "$rccontents"
}

run_segment() {
	__process_settings
  
	if tp_shell_is_macos; then
		local stats
		local page_size
		local free_pages
		local external_pages
		local hw_memsize
		local mem
    
		stats=$(vm_stat)
		page_size=$(echo $stats | sed -e 's/.*page size of \([0-9]*\).*/\1/')
		hw_memsize=$(sysctl hw.memsize | sed -e 's/^hw.memsize: \([0-9*]\)/\1/')
		free_pages=$(echo $stats | sed -e 's/.*Pages free: \([0-9]*\).*/\1/')
		external_pages=$(echo $stats | sed -e 's/.*File-backed pages: \([0-9]*\).*/\1/')
		mem=$(echo "($hw_memsize - ($free_pages + $external_pages) * $page_size) / 1073741824" | bc -l)

		echo "${TMUX_POWERLINE_SEG_MEM_USED_ICON}$(__round $mem 2) GB"
		return 0

	elif tp_shell_is_linux; then
		local used_bytes
		local mem

		used_bytes=$(free -b | grep Mem | sed -e 's/Mem:\s*[0-9\.]*\w*\s*\([0-9\.]*\)*.*/\1/')
		mem=$(echo "$used_bytes / 1073741824" | bc -l)

		echo "${TMUX_POWERLINE_SEG_MEM_USED_ICON}$(__round $mem 2) GB"
		return 0
	fi
}

__process_settings() {
	if [ -z "$TMUX_POWERLINE_SEG_MEM_USED_ICON" ]; then
		export TMUX_POWERLINE_SEG_MEM_USED_ICON="${TMUX_POWERLINE_SEG_MEM_USED_ICON_DEFAULT}"
	fi
}

# source https://askubuntu.com/a/179949
__round() {
	printf "%.$2f" "$(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc)"
};
