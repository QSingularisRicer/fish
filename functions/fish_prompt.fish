function fish_prompt --description 'Write out the prompt'
    # import color
    # eval (cat ~/.config/fish/functions/__qEnv/colors)
    # source ~/.config/fish/functions/__qEnv/colors
    source ~/.config/fish/themes/mocha.fish
    set -l __B                      (set_color -o   $blue)
    set -l __G                      (set_color -o   $green)
    set -l __M                      (set_color      $magenta)
    set -l __C                      (set_color -o   $cyan)
    set -l __RS                     (set_color      normal)

    # Set variables
    set -l __suffix                 '>'
    set -l __space                  ' '
    set -l __open_sqr               '['
    set -l __close_sqr              ']'
    set -l __at                     '@'
    set -l __prompt_user            $USER
    set -l __prompt_hostname        (prompt_hostname)
    set -l __prompt_pwd             (prompt_pwd)

    # Print
    printf '%s'         $__B$__open_sqr$__space$__G$__prompt_user$__at$__prompt_hostname$__space$__RS$__M$__prompt_pwd$__space$__B$__close_sqr 
    #fish_git_prompt
    __singularis_git_prompt
    printf '\n%s'       $__C$__space$__suffix$__space$__RS
end
