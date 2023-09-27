#! /bin/bash

# Open files uzing fzf

# DEPENDENCIES: fzf, ripgrep, batcat (bat), fdfind (fd, fd-find)

# ########## IMPORTANT ##############
# If an argument is given, it must be only one, and the filter will be
# on file names only!
####################################


# CREDITS: See
# https://www.youtube.com/watch?v=QeJkAs_PEQQ

# Note: add option -H for hidden files in fdfind

# directory to save cache
CACHE_DIR="$HOME"/.find_cache

if [ ! -d "$CACHE_DIR" ]
then
    echo "No cache directory.  Generate cache first."
    exit 1
fi


# ###############################
# main functions

# IMPORTANT: these next two need PARENTHESES instead of curly braces,
# to force it to run in a subshell!
open_with () (
    # Opens file with command if any arguments,
    # exit if no arguments.
    # SYNTAX: open_with -c command args
    IFS='
'
    if [ "$#" -ge 3 ]
    then
        cmdf=$2
        shift 2

        $cmdf $@
    else
        exit 1
    fi
)

# Again, parentheses instead of curly braces!
fzf_open_file () (
    # General function to open files with fzf.
    # SYNTAX:
    # fzfet_open_file -h <pattern> -c <command> [-p <preview>]
    # or
    # fzf_open_file -f <file> -c <command> [-p <preview>]

    # make sure spaces are not a problem
    IFS='
'

    pattern=''
    preview=''

    # set opptions
    while getopts "h:c:f:p:" opt; do
        case $opt in
            h)
                pattern="$OPTARG"
                ;;
            c)
                cmd="$OPTARG"
                ;;
            f)
                file="$OPTARG"
                ;;
            p)
                preview="$OPTARG"
        esac
    done

    shift $((OPTIND -1))

    if [ -z "$pattern" ]
    then
        if [ -z "$preview" ]
        then
            if [ $# -eq 0 ]
            then
                open_with -c $cmd $(fzf -m  < "$CACHE_DIR"/"$file")
            else
                open_with -c $cmd $(rg -i "$1"'[^/]*$' "$CACHE_DIR"/"$file" | fzf -m)
            fi
        else
            if [ $# -eq 0 ]
            then
                open_with -c $cmd $(fzf -m --preview="$preview" < "$CACHE_DIR"/"$file")
            else
                open_with -c $cmd $(rg -i "$1"'[^/]*$' "$CACHE_DIR"/"$file" | fzf -m --preview="$preview")
            fi
        fi
    else
        if [ -z "$preview" ]
        then
            if [ $# -eq 0 ]
            then
                open_with -c $cmd $(fdfind -I "$pattern" | fzf -m)
            else
                open_with -c $cmd $(fdfind -I "$pattern" | rg -i "$1"'[^/]*$' | fzf -m)
            fi
        else
            if [ $# -eq 0 ]
            then
                open_with -c $cmd $(fdfind -I "$pattern" | fzf -m --preview="$preview")
            else
                open_with -c $cmd $(fdfind -I "$pattern" | rg -i "$1"'[^/]*$' | fzf -m --preview="$preview")
            fi
        fi

    fi
)


#####################################
# LaTeX files

open_latex_emacs() {
    fzf_open_file -f "tex_files" -c "em" -p "batcat --color=always {}" $1
}

open_latex_emacs_here() {
    fzf_open_file -h "[.]tex$" -c "em" -p "batcat --color=always {}" $1
}

#####################################
# text files

open_text_emacs() {
    fzf_open_file -f "txt_files" -c "em" -p "batcat --color=always {}" $1
}

open_text_emacs_here() {
    fzf_open_file -h "[.]txt$|[.]md$|[.]text$" -c "em" -p "batcat --color=always {}" $1
}

#####################################
# org files

open_org_emacs() {
    fzf_open_file -f "org_files" -c "em" -p "batcat --color=always {}" $1
}

open_org_emacs_here() {
    fzf_open_file -h "[.]org$" -c "em" -p "batcat --color=always {}" $1
}

#####################################
# spreadsheet files

open_spreadsheet() {
    fzf_open_file -f "ss_files" -c "localc" $1
}

open_spreadsheet_here() {
    fzf_open_file -h "[.]xls$|[.]ods$|[.]csv$|[.]xlsx$" -c "localc" $1
}

#####################################
# html files

open_html_emacs() {
    fzf_open_file -f "html_files" -c "em" -p "batcat --color=always {}" $1
}

open_html_emacs_here() {
    fzf_open_file -h "[.]htm$|[.]html$|[.]php$" -c "em" -p "batcat --color=always {}" $1
}

#####################################
# PDFs


open_pdf() {
    fzf_open_file -f "pdf_files" -c "okular" -p "pdftotext {} -" $1
}

open_pdf_here() {
    fzf_open_file -h "[.]pdf|[.]djvu$" -c "okular" -p "pdftotext {} -" $1
}

#####################################
# generic files

# Note that xdg-open only works for a single file!
open_file() {
    OIFS="$IFS"
    IFS='
'
    # if [ $# -eq 0 ]
    # then
    #     fzf -m --preview="xdg-mime query filetype {}" < "$CACHE_DIR"/all_files |\
    #         xargs -ro -d "\n" xdg-open  &> /dev/null
    # else
    #     rg -i "${@}"'[^/]*$' "$CACHE_DIR"/all_files |\
    #         fzf -m --preview="xdg-mime query filetype {}" |\
    #             xargs -ro -d "\n" xdg-open  &> /dev/null
    # fi
    if [ $# -eq 0 ]
    then
        xdg-open $(fzf --preview="xdg-mime query filetype {}" < "$CACHE_DIR"/all_files) &> /dev/null
    else
        xdg-open $(rg -i "${@}"'[^/]*$' "$CACHE_DIR"/all_files |\
            fzf --preview="xdg-mime query filetype {}") &> /dev/null
    fi
    IFS="$OIFS"
}


open_file_here() {
    # if [ $# -eq 0 ]
    # then
    #     fdfind -I -t f -L |\
    #         fzf -m --preview="xdg-mime query filetype {}" |\
    #         xargs -ro -d "\n" xdg-open  &> /dev/null
    # else
    #     fdfind -I -t f -L -i "${@}"'[^/]*$' |\
    #         fzf -m --preview="xdg-mime query filetype {}" |\
    #             xargs -ro -d "\n" xdg-open  &> /dev/null
    # fi
        if [ $# -eq 0 ]
    then
        xdg-open $(fdfind -I -t f -L |\
            fzf --preview="xdg-mime query filetype {}") &> /dev/null
    else
        xdg-open $(fdfind -I -t f -L -i "${@}"'[^/]*$' |\
            fzf -m --preview="xdg-mime query filetype {}") &> /dev/null
    fi
    IFS="$OIFS"
}

#####################################
# directories

# NOTE: we cannot use open_with here, since it runs in a subshell,
# which makes the change of directories not affect the shell

my_cd() {
    if [ "$#" -ge 1 ]
    then
        cd $1
    fi
}

cd_fzf() {
    OIFS="$IFS"
    IFS='
'
    if [ $# -eq 0 ]
    then
        my_cd $(fzf --preview="tree -C -L 1 {}" < "$CACHE_DIR"/all_directories)
    else
        # my_cd $(rg -i "${@}"'[^/]*$' "$CACHE_DIR"/all_directories |\
        #          fzf --preview="tree -C -L 1 {}")
        my_cd $(rg -i "${@}" "$CACHE_DIR"/all_directories |\
                 fzf --preview="tree -C -L 1 {}")
    fi
    IFS="$OIFS"
}


cd_fzf_here() {
    OIFS="$IFS"
    IFS='
'
    if [ $# -eq 0 ]
    then
        my_cd $(fdfind -I -t d -L | fzf --preview="tree -C -L 1 {}")
    else
        my_cd $(fdfind -I -t d -L -i $@ | fzf --preview="tree -C -L 1 {}")
    fi
    IFS="$OIFS"
}

# ######################################
# kill running process

fzf_ps_kill() {
    mykill $(psf "$1" | fzf -m | awk '{print $2}')
}

# ######################################
# apt install

apti() {
    sudo apt install $(apt-cache search $@ |\
                      cut -d' ' -f1 |\
                      fzf -m --preview="apt-cache show {} | grep -v '^Maint\|^Arch\|^Depen\|^Tag\|^MD5\|^Filename\|^Priority\|Description-md5\|SHA256\|^Size\|^Section\|^Source\|^Replace\|^Breaks' | fold -w 60 -s")
}

# ###################################
# ALIASES

alias of='open_file'
alias ofh='open_file_here'
alias etex='open_latex_emacs'
alias etexh='open_latex_emacs_here'
alias etxt='open_text_emacs'
alias etxth='open_text_emacs_here'
alias eorg='open_org_emacs'
alias eorgh='open_org_emacs_here'
alias oss='open_spreadsheet'
alias ossh='open_spreadsheet_here'
alias ehtml='open_html_emacs'
alias ehtmlh='open_html_emacs_here'
alias opdf='open_pdf'
alias opdfh='open_pdf_here'
alias cdf='cd_fzf'
alias cdfh='cd_fzf_here'
alias pskill='fzf_ps_kill'
