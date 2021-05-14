#! /bin/bash

# Generates a cache for files in the home directory.

# NEEDS fd-find and ripgrep

# at to cron, like at 9 minutes every even hour:
# 9 */2 * * * /home/finotti/code/fzf_open/find_cache.sh


# where to save data
CACHE_DIR=$HOME/.find_cache

# create directory if it does not exist
[ ! -d "$CACHE_DIR" ] && mkdir "$CACHE_DIR"

CUR_PATH="$PWD"

# create cache
cd "$HOME"
fdfind -a -t file > "$CACHE_DIR"/all_files
fdfind -a -t directory -L > "$CACHE_DIR"/all_directories

# ############ replace links ################

# reversing the order of the links makes it work with course links,
# like 351, as it is a link pointing to a link

for link in $(fdfind --exact-depth 1 --type l -a | sort -r); do
    link_loc=$"$HOME"/$(readlink "$link")
    sed -i'' s%^"$link_loc"%"$link"% "$CACHE_DIR"/all_files
    sed -i'' s%^"$link_loc"%"$link"% "$CACHE_DIR"/all_directories
done

# ###########################################


# let's prefilter the caches
cd "$CACHE_DIR"

for type in tex pdf org; do
    rg -i [.]"$type"$ all_files > "$type"_files
done

rg -i '[.]txt$|[.]text$|[.]md$' all_files > txt_files

rg -i '[.]xls$|[.]ods$|[.]cvs$|[.]xlsx$' all_files > ss_files

rg -i '[.]htm$|[.]html$|[.]php$' all_files > html_files

# return to original directory
cd "$CUR_PATH"

