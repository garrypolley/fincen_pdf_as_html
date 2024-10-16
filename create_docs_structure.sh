#!/bin/bash

# Create the main docs directory
rm -rf docs
mkdir -p docs

# Create the index.html file
cat << EOF > docs/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Documentation Index</title>
</head>
<body>
    <h1>Documentation Index</h1>
    <ul>
EOF

# Loop through subdirectories in the htmls folder
for dir in htmls/*/; do
    dir_name=$(basename "$dir")
    root_html=$(find "$dir" -maxdepth 1 -name "*.html" ! -name "*-*.html" ! -name "*_ind.html" | head -n 1)

    if [ -n "$root_html" ]; then
        root_html_name=$(basename "$root_html")
        title=$(grep -m 1 "<TITLE>" "$root_html" | sed -e 's/<TITLE>//' -e 's/<\/TITLE>//' -e 's/^ *//' -e 's/ *$//')

        # Create a subdirectory in docs for this section
        mkdir -p "docs/$dir_name"

        # Copy all files from the original directory to the new subdirectory
        cp -R "$dir"* "docs/$dir_name/"

        # Add a link to the index.html file
        echo "        <li><a href=\"$dir_name/$root_html_name\">$title</a></li>" >> docs/index.html
    fi
done

# Close the HTML file
cat << EOF >> docs/index.html
    </ul>
</body>
</html>
EOF

echo "Documentation structure created in the 'docs' directory."
