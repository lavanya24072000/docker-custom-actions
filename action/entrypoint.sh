#!/bin/bash
 
cd "$GITHUB_WORKSPACE"
 
echo "Running ESLint..."
 
# Run ESLint and generate JSON report
eslint . --ext .js,.jsx,.ts,.tsx -f json -o eslint-report.json || true
 
# Check if report exists and not empty
if [ -s eslint-report.json ]; then
  cat eslint-report.json | jq -c '.[]' | while read -r file; do
    filePath=$(echo "$file" | jq -r '.filePath')
    echo "$file" | jq -c '.messages[]' | while read -r msg; do
      line=$(echo "$msg" | jq -r '.line')
      col=$(echo "$msg" | jq -r '.column')
      message=$(echo "$msg" | jq -r '.message')
      severity=$(echo "$msg" | jq -r '.severity')
 
      if [ "$severity" -eq 2 ]; then
        level="error"
      else
        level="warning"
      fi
 
      echo "::${level} file=${filePath},line=${line},col=${col}::${message}"
    done
  done
else
  echo "No ESLint output found."
fi
