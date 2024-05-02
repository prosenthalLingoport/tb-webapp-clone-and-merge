TB_WEBAPP_PAT=

echo "$ git clone https://github.com/travelbank/web-app.git"
git clone https://$TB_WEBAPP_PAT@github.com/travelbank/web-app.git
exitValue=$?
if [ $exitValue != 0 ] ; then
    echo "Error: git clone https://github.com/travelbank/web-app.git failed with status: $exitValue"
    exit $exitValue
fi

echo "$ cd web-app"
cd web-app

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
