#!/bin/bash
# This script allows repo merges with history in place for branches

# $1 = main repo path
main=$(basename $1)
mainPath=$(readlink -f $1)

# $2 = secondary repo path
secondary=$(basename $2)
secondaryPath=$(readlink -f $2)

# $3 = branch or tag to be moved
branch=$3
#temp_branch=$3_prepare_for_merge_$(date +%N)

# $4 = sub dir name for secondary repo in main repo
subdir=$4

# $5 = tag name
tagName=$5

areThereChanges(){
  if [[ `git status --porcelain --untracked-files=no` ]]; then
    echo "There are uncommited changes in $mainPath."
    exit 1
  fi
}

switchToBranch(){
  exists=`git show-ref refs/heads/$branch`
  if [ -n "$exists" ]; then
    echo "Merging $branch"
    git switch --quiet $branch
  else
    echo "Creating $branch"
    git switch --quiet -c $branch
  fi
}

createTag(){
  exists=`git show-ref refs/tags/$tagName`
  if [ -n "$exists" ]; then
    git tag -f -a $tagName -m $tagName
  else
    git tag -a $tagName -m $tagName
  fi
}


if [ ! -d $secondaryPath/$subdir ]; then
  cd $secondaryPath
  areThereChanges $secondaryPath
  echo "Rewriting paths in commit history"
  git filter-repo --force --to-subdirectory-filter $subdir
fi


cd $mainPath
areThereChanges $mainPath
git remote add $secondary $secondaryPath
git fetch --all --quiet
git checkout --quiet $secondary/$branch # Needed in order to complete the merge
switchToBranch
git merge --allow-unrelated-histories --no-edit --no-verify --quiet $secondary/$3
areThereChanges $mainPath
if [[ $tagName ]]; then
  git tag -f -a $tagName -m $tagName
fi
git remote remove $secondary

