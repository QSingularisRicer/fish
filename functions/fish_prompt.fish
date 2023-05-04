function fish_prompt --description 'Write out the prompt'
    # import color
    source $HOME/.config/fish/themes/{$singularis_prompt_theme}.fish

    # set color variables
    set -l __B                      (set_color -o   $blue)
    set -l __G                      (set_color -o   $green)
    set -l __M                      (set_color      $magenta)
    set -l __C                      (set_color -o   $cyan)
    set -l __RS                     (set_color      normal)

    # Set variables
    set -l suffix                   '>' # your suffix
    set -l space                    ' ' # just a space
    set -l _osb                     '[' # open square bracket
    set -l _csb                     ']' # close square bracket
    set -l _at                      '@' # just an 'at' character
    set -l __prompt_user            $USER
    set -l __prompt_hostname        (prompt_hostname)
    set -l __prompt_pwd             (prompt_pwd)

    # Print
    printf '%s'         $__B$_osb$space$__G$__prompt_user$_at$__prompt_hostname$space$__RS$__M$__prompt_pwd$space$__B$_csb
    #fish_git_prompt
    singularis_git_prompt
    printf '\n%s'       $__C$space$suffix$space$__RS
end
