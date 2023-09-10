#!/bin/sh


echo "Change authorship of commits"
echo "\n"
echo "WARNING: This operation is potentially dangerous and can rewrite the history of your Git repository. Use with caution and make sure you have a backup of your repository before running this script."

if [ $# -ne 3 ]; then
    read -p "Enter your old email address: " OLD_EMAIL
    read -p "Enter your correct name: " NAME
    read -p "Enter your correct email address: " EMAIL


    echo "\n"
    echo "$OLD_EMAIL ---> $EMAIL"
    echo "Are you sure you want to change the authorship of the commits? (y/n)"

    read -r CONFIRMATION
    if [ "$CONFIRMATION" != "y" ]; then
        echo "Aborting operation."
        exit 1
    fi
else
  OLD_EMAIL=$1
  NAME=$2
  EMAIL=$3
fi


output=$(git filter-branch --env-filter "
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
" --tag-name-filter cat -- --branches --tags)

echo "\n"

status=$?
if [ $status -eq 0 -a "$output" != *"Cannot"* ];
then
  echo "Please remember to force update on the remote repository."
  echo "Command: git push --force --tags origin 'refs/heads/*'"
else
  echo "Error occurred while changing authorship of commits."
fi
exit $status


