#!/bin/bash

set -e
set -u

# 版本校验
today_commit=$(curl --silent "https://api.github.com/repos/drawdb-io/drawdb/commits" | jq '.[0].sha' -r)
current_commit=$(cat currentcommit)

echo "current_commit:$current_commit commit:$today_commit"
# 判断版本号是否相同 如果相同就exit
if [[ "$current_commit" == "$today_commit" ]]; then
    exit
fi

echo "System initialization"
git config --global user.name "github-actions[bot]"
git config --global user.email  "41898282+github-actions[bot]@users.noreply.github.com"
echo machine github.com login $GITHUB_USER password $GITHUB_TOKEN > ~/.netrc

echo "Updating code repository in progress..."
echo "Package and publish nodes"
git clone https://github.com/drawdb-io/drawdb.git code
cd code
npm ci
npm run build

# gh-pages分支存在的情况
git clone -b gh-pages https://github.com/myhosts/drawdb-io.git gh-pages
echo ".git directory transfer"
mv gh-pages/.git dist

cd dist

# gh-pages分支不存在的时候
# git init
# git push https://github.com/myhosts/drawdb-io.git gh-pages  --force

echo 'gh.drawdb.vhosts.top' > CNAME
echo "$today_commit" > README.md
git add -A
git commit -m "deploy commit $today_commit"
git push -f origin gh-pages

cd ..
cd ..

echo "main branch Version update"
echo "$today_commit" >currentcommit
git add currentcommit
git commit -a -m "Automatically update version to  $today_commit"
git push -f origin main
