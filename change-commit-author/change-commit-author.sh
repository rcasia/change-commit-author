#!/bin/sh

echo "Change authorship of commits"
read -p "Enter your correct name: " NAME
read -p "Enter your correct email address: " EMAIL
read -p "Enter your old email address: " OLD_EMAIL

git filter-branch --env-filter "
if [ \"\$GIT_COMMITTER_EMAIL\" = \"$OLD_EMAIL\" ]
then
    export GIT_COMMITTER_NAME=\"$NAME\"
    export GIT_COMMITTER_EMAIL=\"$EMAIL\"
fi
if [ \"\$GIT_AUTHOR_EMAIL\" = \"$OLD_EMAIL\" ]
then
    export GIT_AUTHOR_NAME=\"$NAME\"
    export GIT_AUTHOR_EMAIL=\"$EMAIL\"
fi
" --tag-name-filter cat -- --branches --tags

echo "The authorship of the commits has been changed successfully. Please remember to force update on the remote repository."
echo "Command: git push --force --tags origin 'refs/heads/*'"
