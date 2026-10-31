#!/bin/bash

if ! command -v elm >/dev/null; then
  echo 'Could not find elm in PATH'
  exit 2
fi

echo "Compiling site..."
elm make src/Main.elm >/dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "Failed to compile site..."
  exit 2
fi

filename="$1"
fileout="$(mktemp)"

if [ -z "$filename" ]; then
  echo "File name not provided, using STDIN..."
  filename=/dev/stdin
fi

function cleanup() {
  echo "Removing $fileout"
  rm -f "$fileout"
  echo "Done!"
}

trap cleanup EXIT

while read -r LINE; do
  if [[ "$LINE" =~ 'REPLACE ME - WORK' ]]; then
    echo "\$elm\$html\$Html\$text(\"$(cat data/work.txt | tr '\n' ' ')\")"
    continue
  fi

  if [[ "$LINE" =~ 'REPLACE ME - STUDIES' ]]; then
    echo "\$elm\$html\$Html\$text(\"$(cat data/studies.txt | tr '\n' ' ')\")"
    continue
  fi

  if [[ "$LINE" =~ 'REPLACE ME - HOBBIES' ]]; then
    echo "\$elm\$html\$Html\$text(\"$(cat data/hobbies.txt | tr '\n' ' ')\")"
    continue
  fi

  echo "$LINE"

  if [ "$LINE" = '<head>' ]; then
    echo '<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/picnic">'
    echo '<link rel="stylesheet" href="./css/styles.css">'
  fi
done < "$filename" > "$fileout"

if [ "$filename" != /dev/stdin ]; then
  echo "Copying $fileout to $filename..."
  cp "$fileout" "$filename"
fi

