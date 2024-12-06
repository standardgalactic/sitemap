#!/bin/bash

# Replace 'GITHUB_PERSONAL_ACCESS_TOKEN' with your personal access token
TOKEN="GITHUB_PERSONAL_ACCESS_TOKEN"

# Output file for repositories with deployed GitHub Pages
OUTPUT_FILE="repos_with_pages.txt"

# Clear or create the output file
> $OUTPUT_FILE

# Iterate through paginated API results
for page in {1..200}; do
    echo "Fetching page $page..."
    curl -s -H "Authorization: token $TOKEN" \
         "https://api.github.com/user/repos?per_page=100&page=$page" | \
         jq -r '.[] | select(.has_pages == true) | .full_name' >> $OUTPUT_FILE
done

echo "Repositories with GitHub Pages deployed have been saved to $OUTPUT_FILE"

