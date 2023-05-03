#!/usr/bin/fish

set -l BOOTSTRAP_CUSTOM_DIR         $HOME/.config/fish/customs
set -l BOOTSTRAP_CUSTOM_FUNC_DIR    $BOOTSTRAP_CUSTOM_DIR/functions
set -l BOOTSTRAP_CUSTOM_COMP_DIR    $BOOTSTRAP_CUSTOM_DIR/completions
set -l BOOTSTRAP_CUSTOM_CONF_DIR    $BOOTSTRAP_CUSTOM_DIR/conf.d
set -l BOOTSTRAP_CUSTOM_CONFIG      $BOOTSTRAP_CUSTOM_DIR/config.fish

if not test -d $BOOTSTRAP_CUSTOM_DIR
    echo "[Init] mkdir -p $BOOTSTRAP_CUSTOM_DIR"
    mkdir -p $BOOTSTRAP_CUSTOM_DIR
end

if not test -d $BOOTSTRAP_CUSTOM_FUNC_DIR
    echo "[Init] mkdir -p $BOOTSTRAP_CUSTOM_FUNC_DIR"
    mkdir -p $BOOTSTRAP_CUSTOM_FUNC_DIR
end

if not test -d $BOOTSTRAP_CUSTOM_COMP_DIR
    echo "[Init] mkdir -p $BOOTSTRAP_CUSTOM_COMP_DIR"
    mkdir -p $BOOTSTRAP_CUSTOM_COMP_DIR
end

if not test -d $BOOTSTRAP_CUSTOM_CONF_DIR
    echo "[Init] mkdir -p $BOOTSTRAP_CUSTOM_CONF_DIR"
    mkdir -p $BOOTSTRAP_CUSTOM_CONF_DIR
end

if not test -e $BOOTSTRAP_CUSTOM_CONFIG
    echo "[Init] Make config file"
    echo 'set -l CUSTOMIZE_FUNC ~/.config/fish/customs/functions
    set -l CUSTOMIZE_CONF ~/.config/fish/customs/conf.d
    set -l CUSTOMIZE_COMP ~/.config/fish/customs/completions

    if test -d $CUSTOMIZE_FUNC
    for f in $CUSTOMIZE_FUNC/*.fish
    source $f
    end
    end

    if test -d $CUSTOMIZE_CONF
    for conf in $CUSTOMIZE_CONF/*.fish
    source $conf
    end
    end

    if test -d $CUSTOMIZE_COMP
    if contains $CUSTOMIZE_COMP $PATH
    set -a PATH $CUSTOMIZE_COMP
    end
    end' > $BOOTSTRAP_CUSTOM_CONFIG
end
