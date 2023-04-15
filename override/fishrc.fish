# User config
set -l OVERRIDE_PATH        $HOME/.config/fish/override
set -l OVERRIDE_CONF_PATH   $OVERRIDE_PATH/config.d
set -l OVERRIDE_FUNC_PATH   $OVERRIDE_PATH/functions

if test -d $OVERRIDE_CONF_PATH
  for conf in $OVERRIDE_CONF_PATH/*.fish
    source $conf
  end
end

if test -d $OVERRIDE_FUNC_PATH
  for f in $OVERRIDE_FUNC_PATH/*.fish
    source $f
  end
end
