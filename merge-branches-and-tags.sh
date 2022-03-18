#!/bin/bash

currentDir=$PWD
# $1 = main repo path
# $2 = secondary repo path
secondary=$(basename $2)
secondaryPath=$(readlink -f $2)
# $3 = sub dir name for secondary repo in main repo

# Move branches
cd $secondaryPath
git fetch --all --tags
getRemoteBranches=$(git for-each-ref --format="%(refname:short)" refs/remotes | sed 's/origin\///' | grep -v "HEAD")
echo $getRemoteBranches
cd "$currentDir"
for b in $(echo $getRemoteBranches); do
  ./merge-branch.sh $1 $2 $b $3
  if [ $? -ne 0 ]; then
    echo "Repository is dirty! Can't continue. Bye"
    exit 1
  fi
done


# Move tags into branches
cd $secondaryPath
getRemoteTags=$(git for-each-ref --format="%(refname:short)" refs/tags)
for b in $(echo $getRemoteTags); do
  git switch --quiet -c tag-$b # Create tag branch as tags can't be easily moved
done
cd "$currentDir"
for b in $(echo $getRemoteTags); do
  ./merge-branch.sh $1 $2 tag-$b $3 $b
  if [ $? -ne 0 ]; then
    echo "Repository is dirty! Can't continue. Bye"
    exit 1
  fi
done

