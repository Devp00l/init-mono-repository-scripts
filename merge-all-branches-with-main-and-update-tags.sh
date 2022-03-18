#!/bin/bash
# $1 = new main repo path
cd $(readlink -f $1)
# $2 = old main branch name
oldMain=$2
# $3 = new main branch name
newMain=$3

doMerge(){
  # $1 = branch
  # $2 = merge source
  echo "Merging $2 into $1"
  git checkout --quiet $1
  git merge --allow-unrelated-histories --no-edit --no-verify --quiet $2
  if [[ `git status --porcelain --untracked-files=no` ]]; then
    echo "Could not complete merge."
    exit 1
  fi
}

getHeads=$(git for-each-ref --format="%(refname:short)" refs/heads)
for b in $(echo $getHeads); do
  if [[ $b != *"$newMain"* ]]; then
    doMerge $b $newMain
  fi
done
doMerge $newMain $oldMain


getTags=$(git for-each-ref --format="%(refname:short)" refs/heads | grep "^tag-" | sed "s/tag-//")
for t in $(echo $getTags); do
  git checkout --quiet tag-$t
  git tag -f -a $t -m $t
done

