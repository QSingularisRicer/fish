# User config
set -l CUSTOMIZED_CONF $HOME/.config/fish/customs/conf.d 
set -l CUSTOMIZED_FUNC $HOME/.config/fish/customs/functions

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
