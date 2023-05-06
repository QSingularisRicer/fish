function fish_prompt --description 'Write out the prompt'
    # import color
    source $singularis_theme_path

    # set color variables
    set __B                      (set_color -o   $blue)
    set __G                      (set_color -o   $green)
    set __M                      (set_color      $magenta)
    set __C                      (set_color -o   $cyan)
    set __RS                     (set_color      normal)

    # Set variables
    set suffix                   '>' # your suffix
    set space                    ' ' # just a space
    set _osb                     '[' # open square bracket
    set _csb                     ']' # close square bracket
    set _at                      '@' # just an 'at' character
    set __prompt_user            $USER
    set __prompt_hostname        (prompt_hostname)
    set __prompt_pwd             (prompt_pwd)

    # Print
    printf '%s'         $__B$_osb$space$__G$__prompt_user$_at$__prompt_hostname$space$__RS$__M$__prompt_pwd$space$__B$_csb
    #fish_git_prompt
    singularis_git_prompt
    printf '\n%s'       $__C$space$suffix$space$__RS
end
