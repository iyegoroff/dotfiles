# shellcheck shell=bash
# Prints memory usage

TMUX_POWERLINE_SEG_MEM_USED_ICON_DEFAULT=" "
TMUX_POWERLINE_SEG_MEM_USED_UNIT_DEFAULT="GB"

generate_segmentrc() {
	read -r -d '' rccontents <<EORC
# Memory icon
export TMUX_POWERLINE_SEG_MEM_USED_ICON="${TMUX_POWERLINE_SEG_MEM_USED_ICON_DEFAULT}"
# Measure unit of memory: "GB" or "MB".
# In context of this segment "1 GB" equals "2 ^ 30 bytes" and "1 MB" eqauls "2 ^ 20 bytes".
export TMUX_POWERLINE_SEG_MEM_USED_UNIT="${TMUX_POWERLINE_SEG_MEM_USED_UNIT_DEFAULT}"
EORC
	echo "$rccontents"
}

# based on https://github.com/thewtex/tmux-mem-cpu-load
__tp_mem_used_info() {
	if tp_shell_is_macos; then
		local stats
		local bytes_per_page
		local free_pages
		local external_pages
		local mem_total_bytes
		local mem_used_bytes
    
		stats=$(vm_stat)
		bytes_per_page=$(echo $stats | sed -e 's/.*page size of \([0-9]*\).*/\1/')
		mem_total_bytes=$(sysctl hw.memsize | sed -e 's/^hw.memsize: \([0-9*]\)/\1/')
		free_pages=$(echo $stats | sed -e 's/.*Pages free: \([0-9]*\).*/\1/')
		external_pages=$(echo $stats | sed -e 's/.*File-backed pages: \([0-9]*\).*/\1/')
		mem_used_bytes=$(echo "$mem_total_bytes - ($free_pages + $external_pages) * $bytes_per_page" | bc -l)

		echo $mem_used_bytes $mem_total_bytes

	elif tp_shell_is_linux; then
	  local meminfo
	  local mem_total
		local mem_total_bytes
	  local mem_free
	  local shmem
	  local buffers
	  local cached
	  local s_reclaimable
		local mem_used_bytes

		meminfo=$(cat /proc/meminfo)
		mem_total=$(echo $meminfo | sed -e 's/^MemTotal: \([0-9]*\).*/\1/')
		mem_total_bytes=$(echo "$mem_total * 1024" | bc -l)
		mem_free=$(echo $meminfo | sed -e 's/.* MemFree: \([0-9]*\).*/\1/')
		shmem=$(echo $meminfo | sed -e 's/.* Shmem: \([0-9]*\).*/\1/')
		buffers=$(echo $meminfo | sed -e 's/.* Buffers: \([0-9]*\).*/\1/')
		cached=$(echo $meminfo | sed -e 's/.* Cached: \([0-9]*\).*/\1/')
		s_reclaimable=$(echo $meminfo | sed -e 's/.* SReclaimable: \([0-9]*\).*/\1/')
		mem_used_bytes=$(echo "($mem_total - $mem_free + $shmem - $buffers - $cached - $s_reclaimable) * 1024" | bc -l)

		echo $mem_used_bytes $mem_total_bytes
	fi
};

tp_mem_used_gigabytes() {
	read -r mem_used_bytes mem_total_bytes < <(__tp_mem_used_info)
	echo "$mem_used_bytes / 1073741824" | bc -l
}

tp_mem_used_megabytes() {
	read -r mem_used_bytes mem_total_bytes < <(__tp_mem_used_info)
	echo "$mem_used_bytes / 1048576" | bc -l
}

tp_mem_used_percentage_at_least() {
	read -r mem_used_bytes mem_total_bytes < <(__tp_mem_used_info)
	echo "$mem_used_bytes / $mem_total_bytes" | bc -l
}

run_segment() {
	__process_settings

	local mem_used

	if [ -eq "$TMUX_POWERLINE_SEG_MEM_USED_UNIT" "GB" ]; then
		mem_used=$(echo $(__round $(tp_mem_used_gigabytes) 2) GB)
	else
		mem_used=$(echo $(__round $(tp_mem_used_megabytes) 0) MB)
	fi
	
	if [ -n "$mem_used" ]; then
		echo "${TMUX_POWERLINE_SEG_MEM_USED_ICON}${mem_used}"
		return 0
	else
		return 1
	fi
}

__process_settings() {
	if [ -z "$TMUX_POWERLINE_SEG_MEM_USED_ICON" ]; then
		export TMUX_POWERLINE_SEG_MEM_USED_ICON="${TMUX_POWERLINE_SEG_MEM_USED_ICON_DEFAULT}"
	fi
	if [ -z "$TMUX_POWERLINE_SEG_MEM_USED_UNIT" ]; then
		export TMUX_POWERLINE_SEG_MEM_USED_UNIT="${TMUX_POWERLINE_SEG_MEM_USED_UNIT_DEFAULT}"
	fi
};

# source https://askubuntu.com/a/179949
__round() {
	printf "%.$2f" "$(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc)"
};
