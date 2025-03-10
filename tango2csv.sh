#!/bin/bash

# Check if a word was provided as an argument
if [ -z "$1" ]; then
  echo "Please provide a word as an argument."
  exit 1
fi

# Execute the tango command with the provided word
tango "$1" | awk '
BEGIN {ORS=""; kanji=""; hiragana=""; meanings_count=0; max_meanings=5}
(/^.+\(.*\)$/) {
    if (kanji) {
        print kanji ";" hiragana ";" meaning "\n"
    }
    split($0, a, "\\(")
    kanji = a[1]
    hiragana = a[2]
    sub("\\)", "", hiragana)
    meaning = ""
    meanings_count = 0
    next
}
NR>1 && $0 != "" && $0 !~ /\[和独辞典\]/ && meanings_count < max_meanings {
    if (meaning != "") {
        meaning = meaning "<br>"
    }
    meaning = meaning $0
    meanings_count++
}
END {
    if (kanji) {
        print kanji ";" hiragana ";" meaning "\n"
    }
}' >> output.csv
