# Open Files with fzf

Interactively open files using `fzf`.

## Dependencies

It depends on [fzf](https://github.com/junegunn/fzf), [fd (fd-find)](https://github.com/sharkdp/fd), [rg (ripgrep)](https://github.com/BurntSushi/ripgrep), and [bat](https://github.com/sharkdp/bat).

## Cache

`find_cache.sh` creates a cache of files and directories for the `fzf_open` script.

The default location is `$HOME/.find_cache`.  The optional file `$HOME/.find_cache._ignore` is used to skip files.  It must use the syntax for [fd find](https://github.com/sharkdp/fd).

It probably should be run in `cron`, e.g.:

```bash
# 9 */2 * * * $HOME/code/fzf_open/find_cache.sh
```


## Find

**Credit:** This was inspired by the video [Fuzzy Finding with fzf](https://www.youtube.com/watch?v=QeJkAs_PEQQ), by [nixcasts](https://www.youtube.com/@connermcd).

The `fzf_open.sh` script allows you to use the cache or look locally (with the suffix `h`) for files to open.  It uses `fzf` for fuzzy-filtering.

It has aliases at the end:

```bash
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
```
