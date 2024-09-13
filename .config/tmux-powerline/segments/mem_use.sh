# Print memory usage

run_segment() {
    free -hL --mega | sed -e 's/.*MemUse\s*\([0-9\.]*\)\(\S*\)\s*MemFree.*/ \1 \2/'
    return 0
}
