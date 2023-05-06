# Customize fish functions
set -l CUSTOMIZE_CONF   $HOME/.config/fish/customs/conf.d
set -l CUSTOMIZE_FUNC   $HOME/.config/fish/customs/functions
set -l CUSTOMIZE_COMP   $HOME/.config/fish/customs/completions

if test -d $CUSTOMIZE_CONF
    for config_file in $CUSTOMIZE_CONF/*.fish
        source $config_file
    end
end

if test -d $CUSTOMIZE_FUNC
    for custom_function in $CUSTOMIZE_FUNC/*.fish
        source $custom_function
    end
end

if test -d $CUSTOMIZE_COMP; and not contains -- $CUSTOMIZE_COMP $PATH
    set -a fish_complete_path $CUSTOMIZE_COMP
end

# Override system theme
set -l DEFAULT_THEME_DIR    $HOME/.config/fish/themes
set -l OVERRIDE_THEME_DIR   $HOME/.config/fish/customs/themes
# Uncomment this line to set your custom themes
#   vvv
# set -l pto mocha     # prompt_theme_override
#
if set -q pto; and test -n "$pto"
    test -e $DEFAULT_THEME_DIR/{$pto}.fish; 
        and set singularis_theme_path $DEFAULT_THEME_DIR/{$pto}.fish

    test -e $OVERRIDE_THEME_DIR/{$pto}.fish;
        and set singularis_theme_path $OVERRIDE_THEME_DIR/{$pto}.fish;
        or printf 'WARNING: %s not found\n' $OVERRIDE_THEME_DIR/{$pto}.fish
end
