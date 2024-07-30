#!/bin/bash

echo "TB WebApp Clone and Merge"
echo "Incoming variables:"
echo "    CUSTOM_DIR     = $CUSTOM_DIR"
echo "    WORKSPACES_DIR = $WORKSPACES_DIR"
echo "    WORKSPACE_NAME = $WORKSPACE_NAME"
echo "    TB_WEBAPP_PAT  = $TB_WEBAPP_PAT"
echo ""

echo "$ cd $WORKSPACES_DIR"
cd $WORKSPACES_DIR

echo "$ rm -r -f $WORKSPACE_NAME"
rm -r -f $WORKSPACE_NAME

echo "$ git clone https://github.com/travelbank/web-app.git"
git clone https://$TB_WEBAPP_PAT@github.com/travelbank/web-app.git $WORKSPACE_NAME
exitValue=$?
if [ $exitValue != 0 ] ; then
    echo "Error: git clone https://github.com/travelbank/web-app.git failed with status: $exitValue"
    exit $exitValue
fi

echo "$ cd $WORKSPACE_NAME"
cd $WORKSPACE_NAME

echo "$ git checkout --detach HEAD"
git checkout --detach HEAD
exitValue=$?
if [ $exitValue != 0 ] ; then
    echo "Error: git checkout --detach HEAD failed with status: $exitValue"
    exit $exitValue
fi

echo "$ git ls-remote"
git ls-remote | grep intl-lingoport-PROD | awk -F '/' '{print $3}' | while read -r branch ; do
    echo "$ git merge origin/$branch"
    git merge origin/$branch -X theirs --no-edit
    exitValue=$?
    if [ $exitValue != 0 ] ; then
        echo "Error: git merge origin/$branch failed with status: $exitValue"
        exit $exitValue
    fi
done

exit 0
