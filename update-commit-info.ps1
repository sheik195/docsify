# Loop through all Markdown files in the repo (root and docs folder)
Get-ChildItem -Path . -Recurse -Include *.md | ForEach-Object {

    $file = $_.FullName
    # Skip any generated files like *_git_info.md
    if ($file -like "*_git_info.md") { return }

    # Get last commit info for this file
    $commitInfo = git log -1 --pretty=format:"**Last modified by:** %an  |  **Commit message:** %s  |  **Commit date:** %ad" $file

    # Read original content
    $content = Get-Content $file

    # Remove old commit info if exists (optional)
    if ($content[0] -like "**Last modified by:***") {
        $content = $content[1..($content.Length - 1)]
    }

    # Write new commit info at top
    $commitInfo | Out-File -Encoding utf8 $file
    $content | Out-File -Append -Encoding utf8 $file
}
