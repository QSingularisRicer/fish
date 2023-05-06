function ___singularis_git_info
    set -q ___bXkgYXNz; or return
    set gitdir           $argv[1]
    set inside_gitdir    $argv[2]
    set bare_repo        $argv[3]    # no use
    set inside_workspace $argv[4]    # no use
    set -q argv[5]; and set  sha $argv[5]
    set branch   ''
    set detached false

    if test $inside_gitdir = 'true'
        set branch "GIT_DIR"
    else
        set branch (command git branch --show-current)
        if test -z $branch
            set detached true
            if set -q sha
                set branch (string shorten -m8 -c "" -- $sha)
                # set branch (string sub -s 1 -l 8 -- $sha) # compatible with older fish
            else
                set branch unknown
            end
        end
    end

    echo $branch
    echo $detached
end

function ___singularis_worktree_status
    set -q ___bXkgYXNz; or return
    set  sha              $argv[1]
    if not test -n "$sha"
        echo false
        echo false
        echo 'invalid'
        return
    end
    # Assume we are inside the worktree
    set git_status       (command git -c core.fsmonitor= status --porcelain -z -unormal | string split0)
    set dirty            (string match -qr '^\s*[ACDMR]' -- $git_status; and echo true; or echo false)
    set untracked        (string match -qr '^\?\?' -- $git_status;     and echo true; or echo false)

    echo $dirty
    echo $untracked
    echo 'valid'
end

function ___singularis_worktree_prompt
    set -q ___bXkgYXNz; or return
    set -l worktree_status  (___singularis_worktree_status $argv[1])
    set -l dirty_state      $worktree_status[1]
    set -l untracked_state  $worktree_status[2]
    set -l valid_state      $worktree_status[3]
    set worktree_prompt     $__W$__detail

    # Invalid case
    if test $valid_state = 'invalid'
        echo $worktree_prompt$__R$__osb$__invalid_char$__csb
        return
    end

    # Clean case
    if test $dirty_state != true; and test $untracked_state != true
        echo $worktree_prompt$__G$__osb$__clean_char$__csb
        return
    end

    # Both case
    if test $dirty_state = true; and test $untracked_state = true
        echo $worktree_prompt$__W$__osb$__Y$__dirty_char$_RS$__separator$__B$__untracked_char$__W$__csb
        return
    end

    # Normal case
    if test $dirty_state = true
        set worktree_prompt $worktree_prompt$__Y$__osb$__dirty_char$__csb
    else
        set worktree_prompt $worktree_prompt$__B$__osb$__untracked_char$__csb
    end
    echo $worktree_prompt
end

function ___singularis_relative_upstream
    set -q ___bXkgYXNz; or return
    set count (command git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null | string replace \t " ")
    switch "$count"
        case ''     # no upstream
            echo ''
        case '0 0'  # equal upstream
            echo ''
        case '0 *'  # ahead of upstream
            echo $__G'[+'$ahead']'
        case '* 0'  # behind of upstream
            echo $__B'[-'$behind']'
        case '*'
            echo $__Y'[DIVERGED]'
    end
end

function singularis_git_prompt
    # Git is not installed, return
    if not command -sq git
        return
    end
    set -g ___bXkgYXNz  # my ass
    set repo_info (command git rev-parse --git-dir --is-inside-git-dir --is-bare-repository --is-inside-work-tree HEAD 2>/dev/null)
    test -n "$repo_info"; or return # cannot get repo_info, just return

    set gitdir              $repo_info[1]
    set inside_gitdir       $repo_info[2]
    set bare_repo           $repo_info[3]
    set inside_workspace    $repo_info[4]
    set HEAD_SHA            $repo_info[5]

    set git_info            (___singularis_git_info $repo_info)
    set current_branch      $git_info[1] # current branch
    set detached            $git_info[2]
    set git_label           ''

    # Include theme and set color variables
    source $singularis_theme_path
    set -g __R                  (set_color -o $red)
    set -g __G                  (set_color -o $green)
    set -g __B                  (set_color -o $blue)
    set -g __Y                  (set_color -o $yellow)
    set -g __C                  (set_color -o $cyan)
    set -g __M                  (set_color -o $magenta)
    set -g __W                  (set_color -o $white)
    set -g _BL                  (set_color -o $black)
    set -g _RS                  (set_color normal)

    set -g __orb                '(' # open round bracket
    set -g __crb                ')' # close round bracket
    set -g __osb                '[' # open square bracket
    set -g __csb                ']' # close square bracket
    set -g __detail             ' => '
    set -g __separator          '|'
    set -g __invalid_char       '!'
    set -g __clean_char         'OK'
    set -g __dirty_char         '*'
    set -g __untracked_char     '%'
    set -g __connect            '::'

    if test $inside_gitdir = true
        set git_label       '!'
    else
        if contains -- $detached yes true 1
            set git_label   'HEAD'
        else
            set git_label   'branch'
        end
    end

    set worktree_prompt         ''
    set relative_upstream       ''
    if test $inside_workspace = true
        set worktree_prompt (___singularis_worktree_prompt $HEAD_SHA)
        if test $git_label = 'branch'; and test $bare_repo != true
            # Find relative upstream
            set relative_upstream (___singularis_relative_upstream)
        end
    end

    printf '%s' $__B$__orb$__Y$git_label$_RS$__connect$__C$current_branch$__B$__crb$worktree_prompt$relative_upstream

    # Clean stuffs
    set -e __R
    set -e __G
    set -e __B
    set -e __Y
    set -e __C
    set -e __M
    set -e __W
    set -e _BL
    set -e _RS
    set -e __orb
    set -e __crb
    set -e __osb
    set -e __csb
    set -e __detail
    set -e __separator
    set -e __invalid_char
    set -e __clean_char
    set -e __dirty_char
    set -e __untracked_char
    set -e __connect
    set -e ___bXkgYXNz
end
