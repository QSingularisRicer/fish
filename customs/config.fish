# User config
set -l CUSTOMIZE_PATH        $HOME/.config/fish/override
set -l CUSTOMIZE_CONF_PATH   $CUSTOMIZE_PATH/config.d
set -l CUSTOMIZE_FUNC_PATH   $CUSTOMIZE_PATH/functions

if test -d $CUSTOMIZE_CONF_PATH
  for conf in $CUSTOMIZE_CONF_PATH/*.fish
    source $conf
  end
end

if test -d $CUSTOMIZE_FUNC_PATH
  for func in $CUSTOMIZE_FUNC_PATH/*.fish
    source $func
  end
end
