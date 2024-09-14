# Print memory usage

platform=$(uname)

if [[ $platform == "Darwin" ]]; then
  run_segment() {
    local mem=$(\
        vm_stat \
        | perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+)[^\d]+(\d+)/ and printf("%-16s % 16.2f Mi\n", "$1:", $2 * $size / 1000000000);' \
        | grep "^active\|wired\|compressor|\speculative" \
        | grep -o '[0-9\.]*' \
        | paste -sd+ - \
        | bc -l \
    )
    echo " ${mem} GB"
    return 0
  }

else
  run_segment() {
    # free -hL --mega | sed -e 's/.*MemUse\s*\([0-9\.]*\)\(\S*\)\s*MemFree.*/ \1 \2/'
    free -h --mega | grep Mem | sed -e 's/Mem:\s*[0-9\.]*\w*\s*\([0-9\.]*\)*\(\S*\).*/ \1 \2/'
    return 0
  }
fi

