#! /bin/bash

# Open files uzing fzf


# DEPENDENCIES: fzf



CACHE_DIR="$HOME"/.find_cache

if [ ! -d "$CACHE_DIR" ]
then
    echo "No cache directory.  Generate cache first."
    exit 1
fi

#####################################

# ########## IMPORTANT ##############
# If an argument is given, it must be only one, and the filter will be
# on file names only!
####################################

# LaTeX files
open_latex_emacs() (
    OIFS="$IFS"
    IFS='
'
    if [ $# -eq 0 ]
    then
        em $(fzf -m --preview="batcat --color=always {}" < "$CACHE_DIR"/tex_files)
    else
        em $(rg -i "${@}"'[^/]*$' "$CACHE_DIR"/tex_files | fzf -m --preview="batcat --color=always {}")
    fi
    IFS="$OIFS"
)

open_latex_emacs_here() (
    OIFS="$IFS"
    IFS='
'
    if [ $# -eq 0 ]
    then
        em $(fdfind [.]tex$ | fzf -m --preview="batcat --color=always {}")
    else
        em $(fdfind [.]tex$ | rg -i "${@}"'[^/]*$' | fzf -m --preview="batcat --color=always {}")
    fi
    IFS="$OIFS"
)

#####################################

# text files

open_text_emacs() (
    OIFS="$IFS"
    IFS='
'
    if [ $# -eq 0 ]
    then
        em $(fzf -m --preview="batcat --color=always {}" < "$CACHE_DIR"/txt_files)
    else
        em $(rg -i "${@}"'[^/]*$' "$CACHE_DIR"/txt_files | fzf -m --preview="batcat --color=always {}")
    fi
    IFS="$OIFS"
)

open_text_emacs_here() (
    OIFS="$IFS"
    IFS='
'
    if [ $# -eq 0 ]
    then
        em $(fdfind '[.]txt$|[.]md$|[.]text$' | fzf -m --preview="batcat --color=always {}")
    else
        em $(fdfind '[.]txt$|[.]md$|[.]text$' | rg -i "${@}"'[^/]*$' | fzf -m --preview="batcat --color=always {}")
    fi
    IFS="$OIFS"
)

#####################################

# org files

open_org_emacs() (
    OIFS="$IFS"
    IFS='
'
    if [ $# -eq 0 ]
    then
        em $(fzf -m --preview="batcat --color=always {}" < "$CACHE_DIR"/org_files)
    else
        em $(rg -i "${@}"'[^/]*$' "$CACHE_DIR"/org_files | fzf -m --preview="batcat --color=always {}")
    fi
    IFS="$OIFS"
)

open_org_emacs_here() (
    OIFS="$IFS"
    IFS='
'
    if [ $# -eq 0 ]
    then
        em $(fdfind '[.]org$' | fzf -m --preview="batcat --color=always {}")
    else
        em $(fdfind '[.]org$' | rg -i "${@}"'[^/]*$' | fzf -m --preview="batcat --color=always {}")
    fi
    IFS="$OIFS"
)

#####################################

# spreadsheet files

open_spreadsheet() (
    OIFS="$IFS"
    IFS='
'
    if [ $# -eq 0 ]
    then
        localc $(fzf -m < "$CACHE_DIR"/ss_files)
    else
        localc $(rg -i "${@}"'[^/]*$' "$CACHE_DIR"/ss_files | fzf -m)
    fi
    IFS="$OIFS"
)

open_spreadsheet_here() (
    OIFS="$IFS"
    IFS='
'
    if [ $# -eq 0 ]
    then
        localc $(fdfind '[.]xls$|[.]ods$|[.]cvs$|[.]xlsx$' | fzf -m)
    else
        localc $(fdfind '[.]xls$|[.]ods$|[.]cvs$|[.]xlsx$' | rg -i "${@}"'[^/]*$' | fzf -m)
    fi
    IFS="$OIFS"
)

#####################################

# html files

open_html_emacs() (
    OIFS="$IFS"
    IFS='
'
    if [ $# -eq 0 ]
    then
        em $(fzf -m --preview="batcat --color=always {}" < "$CACHE_DIR"/html_files)
    else
        em $(rg -i "${@}"'[^/]*$' "$CACHE_DIR"/html_files | fzf -m --preview="batcat --color=always {}")
    fi
    IFS="$OIFS"
)

open_html_emacs_here() (
    OIFS="$IFS"
    IFS='
'
    if [ $# -eq 0 ]
    then
        em $(fdfind '[.]htm$|[.]html$|[.]php$' | fzf -m --preview="batcat --color=always {}")
    else
        em $(fdfind '[.]htm$|[.]html$|[.]php$' | rg -i "${@}"'[^/]*$' | fzf -m --preview="batcat --color=always {}")
    fi
    IFS="$OIFS"
)

#####################################

# PDFs

open_pdf()  (
    OIFS="$IFS"
    IFS='
'
    if [ $# -eq 0 ]
    then
        okular $(fzf -m --preview="pdftotext {} -" < "$CACHE_DIR"/pdf_files)
    else
        okular $(rg -i "${@}"'[^/]*$' "$CACHE_DIR"/pdf_files | fzf -m --preview="pdftotext {} -")
    fi
    IFS="$OIFS"
)


open_pdf_here() (
    OIFS="$IFS"
    IFS='
'
    if [ $# -eq 0 ]
    then
        okular $(fdfind [.]pdf$ | fzf -m --preview="pdftotext {} -")
    else
        okular $(fdfind [.]pdf$ | rg -i "${@}"'[^/]*$' | fzf -m --preview="pdftotext {} -")
    fi
    IFS="$OIFS"
)


#####################################

# generic files

open_file() (
    OIFS="$IFS"
    IFS='
'
    if [ $# -eq 0 ]
    then
        fzf -m --preview="xdg-mime query filetype {}" < "$CACHE_DIR"/all_files |\
            xargs -ro -d "\n" xdg-open 2>&-
    else
        rg -i "${@}"'[^/]*$' "$CACHE_DIR"/all_files |\
            fzf -m --preview="xdg-mime query filetype {}" |\
                xargs -ro -d "\n" xdg-open 2>&-
    fi
)


open_file_here() (
    if [ $# -eq 0 ]
    then
        fdfind -t f -L |\
            fzf -m --preview="xdg-mime query filetype {}" |\
            xargs -ro -d "\n" xdg-open 2>&-
    else
        fdfind -t f -L -i "${@}"'[^/]*$' |\
            fzf -m --preview="xdg-mime query filetype {}" |\
                xargs -ro -d "\n" xdg-open 2>&-
    fi
    IFS="$OIFS"
)



#####################################

# directories

cd_fzf() {
    OIFS="$IFS"
    IFS='
'
    if [ $# -eq 0 ]
    then
        cd $(fzf --preview="tree -C -L 1 {}" \
           --bind="ctrl-p:toggle-preview" < "$CACHE_DIR"/all_directories)
    else
        cd $(rg -i "${@}"'[^/]*$' "$CACHE_DIR"/all_directories |\
                 fzf --preview="tree -C -L 1 {}" \
                     --bind="ctrl-p:toggle-preview")
    fi
    IFS="$OIFS"
}


cd_fzf_here() {
    OIFS="$IFS"
    IFS='
'
    if [ $# -eq 0 ]
    then
        cd "$(fdfind -t d -L |\
           fzf --preview="tree -C -L 1 {}" \
           --bind="ctrl-p:toggle-preview")"
    else
        cd "$(fdfind -t d -L -i $@ |\
           fzf --preview="tree -C -L 1 {}" \
           --bind="ctrl-p:toggle-preview"
)"
    fi
    IFS="$OIFS"
}



fzf_ps_kill() (
    mykill $(psf "$1" | fzf -m | awk '{print $1}')
)


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
alias fzf_ps_kill='pskill'
