function fish_prompt --description 'Write out the prompt'
  # import color
  # eval (cat ~/.config/fish/functions/__qEnv/colors)
  # source ~/.config/fish/functions/__qEnv/colors
  source ~/.config/fish/themes/mocha.fish

  # Set variables
  set -l suffix    ' > '

  # Print
  set_color -o
  set_color $blue;      printf '[ '
  set_color $green;     printf '%s ' $USER@(prompt_hostname)
  set_color normal
  set_color $magenta;   printf '%s ' (prompt_pwd)
  set_color normal
  set_color -o
  set_color $blue;      printf ']'
  fish_git_prompt
  set_color $cyan;      printf '\n %s ' "$suffix"
  set_color normal
end
