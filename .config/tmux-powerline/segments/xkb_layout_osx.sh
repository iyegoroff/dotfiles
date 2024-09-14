# Print keyboard input source

platform=$(uname)

if [[ $platform == "Darwin" ]]; then
  run_segment() {
    local input=$( \
      defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources \
      | egrep -w 'KeyboardLayout Name' \
      | sed -E 's/^.+ = \"?([^\"]+)\"?;$/\1/' \
    )
  
    echo "󰌌 ${input}"

    return 0
  }
fi
