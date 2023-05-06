#!/usr/bin/fish

set -l BOOTSTRAP_DIR        $HOME/.config/fish/bootstrap
set -l CUSTOM_DIR           $HOME/.config/fish/customs
set -l CUSTOM_CONF_DIR      $CUSTOM_DIR/conf.d
set -l CUSTOM_FUNC_DIR      $CUSTOM_DIR/functions
set -l CUSTOM_COMP_DIR      $CUSTOM_DIR/completions
set -l CUSTOM_THEME_DIR     $CUSTOM_DIR/themes
set -l BOOTSTRAP_CONFIG     $BOOTSTRAP_DIR/config.fish
set -l CUSTOM_CONFIG        $CUSTOM_DIR/config.fish

if not test -d $CUSTOM_DIR
    printf '[Init] mkdir -p %s\n' $CUSTOM_DIR
    mkdir -p $CUSTOM_DIR
end

if not test -d $CUSTOM_CONF_DIR
    printf '[Init] mkdir -p %s\n' $CUSTOM_CONF_DIR
    mkdir -p $CUSTOM_CONF_DIR
end

if not test -d $CUSTOM_FUNC_DIR
    printf '[Init] mkdir -p %s\n' $CUSTOM_FUNC_DIR
    mkdir -p $CUSTOM_FUNC_DIR
end

if not test -d $CUSTOM_COMP_DIR
    printf '[Init] mkdir -p %s\n' $CUSTOM_COMP_DIR
    mkdir -p $CUSTOM_COMP_DIR
end

if not test -d $CUSTOM_THEME_DIR
    printf '[Init] mkdir -p %s\n' $CUSTOM_DIR
    mkdir -p $CUSTOM_THEME_DIR
end

if not test -e $CUSTOM_CONFIG
    printf '[Init] Copy bootstrap config\n'
    cp $BOOTSTRAP_CONFIG $CUSTOM_CONFIG
end
