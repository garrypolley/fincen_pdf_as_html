#!/bin/bash

# Create the main docs directory and crawlable subdirectory
rm -rf docs
mkdir -p docs/crawlable

# Create the main index.html file
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

# Create the crawlable index.html file
cat << EOF > docs/crawlable/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crawlable Documentation Index</title>
</head>
<body>
    <h1>Crawlable Documentation Index</h1>
    <ul>
EOF

# Loop through subdirectories in the htmls folder
for dir in htmls/*/; do
    dir_name=$(basename "$dir")
    root_html=$(find "$dir" -maxdepth 1 -name "*.html" ! -name "*-*.html" ! -name "*_ind.html" | head -n 1)

    if [ -n "$root_html" ]; then
        root_html_name=$(basename "$root_html")
        title=$(grep -m 1 "<TITLE>" "$root_html" | sed -e 's/<TITLE>//' -e 's/<\/TITLE>//' -e 's/^ *//' -e 's/ *$//')

        # Create subdirectories in docs and crawlable for this section
        mkdir -p "docs/$dir_name"
        mkdir -p "docs/crawlable/$dir_name"

        # Copy all files from the original directory to the new subdirectory
        cp -R "$dir"* "docs/$dir_name/"

        # Add links to the main index.html file
        echo "        <li><a href=\"$dir_name/$root_html_name\">$title</a></li>" >> docs/index.html
        echo "        <li><a href=\"crawlable/$dir_name/index.html\">$title (Crawlable)</a></li>" >> docs/index.html

        # Add a link to the crawlable index.html file
        echo "        <li><a href=\"$dir_name/index.html\">$title</a></li>" >> docs/crawlable/index.html

        # Create an index file for the crawlable subdirectory
        cat << EOF > "docs/crawlable/$dir_name/index.html"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$title - Crawlable Index</title>
</head>
<body>
    <h1>$title - Crawlable Index</h1>
    <ul>
EOF

        # Add links to all files in the original directory
        find "$dir" -type f | while read -r file; do
            rel_path="${file#$dir}"
            file_name=$(basename "$file")
            echo "        <li><a href=\"../../$dir_name/$rel_path\">$file_name</a></li>" >> "docs/crawlable/$dir_name/index.html"
        done

        # Close the crawlable subdirectory index file
        echo "    </ul>
</body>
</html>" >> "docs/crawlable/$dir_name/index.html"
    fi
done

# Close the main index.html file
cat << EOF >> docs/index.html
    </ul>
</body>
</html>
EOF

# Close the crawlable index.html file
cat << EOF >> docs/crawlable/index.html
    </ul>
</body>
</html>
EOF

echo "fincen-docs.garrypolley.com" > docs/CNAME

echo "Documentation structure created in the 'docs' directory with crawlable subdirectories."
