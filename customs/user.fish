# User config
set -l CUSTOMIZED_CONF $HOME/.config/fish/customs/conf.d 
set -l CUSTOMIZED_FUNC $HOME/.config/fish/customs/functions
set -l CUSTOMIZED_COMP $HOME/.config/fish/customs/completions

if test -d $CUSTOMIZED_CONF
  for conf in $CUSTOMIZED_CONF/*.fish
    source $conf
  end
end

if test -d $CUSTOMIZED_FUNC
  for func in $CUSTOMIZED_FUNC/*.fish
    source $func
  end
end

if test -d $CUSTOMIZED_COMP
  if not contains $CUSTOMIZED_COMP $fish_complete_path
    set -a fish_complete_path $CUSTOMIZED_COMP
  end
end
