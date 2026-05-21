#!/usr/bin/env python3
import os

EXCLUDE = {'index.html'}  # files to ignore
LINK_PREFIX = './'        # as requested

def generate_index():
    html_files = sorted(
        f for f in os.listdir('.')
        if f.endswith('.html') and f not in EXCLUDE
    )

    links = '\n'.join(
        f'    <li><a href="{LINK_PREFIX}{f}">{f}</a></li>'
        for f in html_files
    )

    html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Index of Reading List</title>
  <link rel="stylesheet" href="./main.css" />
</head>
<body>
  <h1 class="title p-name">Index</h1>
  <ul>
{links}
  </ul>
</body>
</html>
"""
    with open('index.html', 'w', encoding='utf-8') as f:
        f.write(html_content)

if __name__ == '__main__':
    generate_index()
    print("index.html generated successfully.")
