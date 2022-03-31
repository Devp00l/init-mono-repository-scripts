# init-mono-repository-scripts
Scripts to easily merge repositories into one repository

## How to run this?

I recommend to make a specific clone of all repositories that should be combined.
For my merge I created a backup directory with all prepared clones so that I always could start in a clean state if something went wrong (during the creation of the scripts). At the end it worked flawlessly nevertheless I would recommend a backup directory with all repositories.

You need [git filter-repo](https://github.com/newren/git-filter-repo/blob/main/INSTALL.md) and a recent version of git. I used 2.35.1.

## merge-branch.sh
This script moves all files in a to combine repository into a subdirectory (This will only happen once). If the move is or was completed the given branch will be merged under the same name into the mono repository. It can also set a tag name at the last commit of the merged branch.

## merge-branches-and-tags.sh
This script is a wrapper around *merge-branch.sh* in order to merge all branches and tags of the given repository.

## push-everything.sh
Does exactly what you would expect. It pushes all branches and all tags in your repository.

## merge-all-branches-with-main-and-update-tags.sh
Does what the name looks like, but it also merges the old main branch into the new main branch. Use this with caution, as it seems to be not the best idea to merge main into all other branches.

