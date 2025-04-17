#!/bin/sh
set -e
 
echo "Running ESLint..."
eslint_output=$(npx eslint src --format json || true)
 
echo "$eslint_output" | jq -c '.[]' | while read -r file; do
  file_path=$(echo "$file" | jq -r '.filePath')
  echo "$file" | jq -c '.messages[]' | while read -r msg; do
    line=$(echo "$msg" | jq -r '.line')
    col=$(echo "$msg" | jq -r '.column')
    severity=$(echo "$msg" | jq -r '.severity')
    message=$(echo "$msg" | jq -r '.message')
    level="notice"
    [ "$severity" -eq 2 ] && level="error"
    [ "$severity" -eq 1 ] && level="warning"
    
    echo "::${level} file=${file_path},line=${line},col=${col}::${message}"
  done
done
