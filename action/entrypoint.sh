#!/bin/bash
 
# Change directory to GitHub workspace
cd "$GITHUB_WORKSPACE" || exit 1
 
# Run ESLint and generate a JSON report
echo "Running ESLint..."
eslint . --ext .js,.jsx,.ts,.tsx -f json -o eslint-report.json || true
 
# Check if the report exists and is not empty
if [ -s eslint-report.json ]; then
  # Read the ESLint report
  cat eslint-report.json | jq -c '.[]' | while read -r file; do
    filePath=$(echo "$file" | jq -r '.filePath')
    
    # Iterate through the messages in the file
    echo "$file" | jq -c '.messages[]' | while read -r msg; do
      line=$(echo "$msg" | jq -r '.line')
      column=$(echo "$msg" | jq -r '.column')
      message=$(echo "$msg" | jq -r '.message')
      severity=$(echo "$msg" | jq -r '.severity')
 
      # Set the annotation level based on severity
      if [ "$severity" -eq 2 ]; then
        level="error"
      else
        level="warning"
      fi
 
      # Output the annotation in GitHub Actions format
      echo "::${level} file=${filePath},line=${line},col=${column}::${message}"
 
      # If the level is "error", fail the pipeline
      if [ "$level" == "error" ]; then
        exit 1
      fi
    done
  done
else
  echo "No ESLint output found."
fi
 
