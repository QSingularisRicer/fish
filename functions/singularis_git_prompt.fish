function ___singularis_git_info
    set -f gitdir           $argv[1]
    set -f inside_gitdir    $argv[2]
    set -f bare_repo        $argv[3]    # no use
    set -f inside_workspace $argv[4]    # no use
    set -q argv[5]; and set -f sha $argv[5]
    set -f branch   ''
    set -f detached false

    if test $inside_gitdir = 'true'
        set branch "GIT_DIR"
    else
        set branch (command git branch --show-current)
        if test -z $branch
            set detached true
            if set -q sha
                set branch (string shorten -m8 -c "" -- $sha)
            else
                set branch unknown
            end
        end
    end

    echo $branch
    echo $detached
end

function ___singularis_worktree_status
    set -f sha              $argv[1]
    # Assume we are inside the worktree
    set -f git_status       (command git -c core.fsmonitor= status --porcelain -z -unormal | string split0)
    set -f dirty            (string match -qr '^[ACDMR]' -- $git_status; and echo true; or echo false)
    set -f stagged          'invalid'
    if test -n "$sha"
        set stagged         (string match -qr '^[ACDMR].' -- $git_status; and echo true; or echo false)
    end
    set -f untracked        (string match -qr '\?\?' -- $git_status;     and echo true; or echo false)

    echo $dirty
    echo $stagged
    echo $untracked
end

function singularis_git_prompt
    # Git is not installed, return 1
    if not command -sq git
        return
    end
    set -f repo_info (command git rev-parse --git-dir --is-inside-git-dir --is-bare-repository --is-inside-work-tree HEAD 2>/dev/null)
    test -n "$repo_info"; or return # cannot get repo_info, just return

    set -f gitdir           $repo_info[1]
    set -f inside_gitdir    $repo_info[2]
    set -f bare_repo        $repo_info[3]
    set -f inside_workspace $repo_info[4]
    set -f HEAD_SHA         $repo_info[5]

    set -f git_info         (___singularis_git_info $repo_info)
    set -f current_branch   $git_info[1] # current branch
    set -f detached         $git_info[2]
    set -f git_label        ''

    # Include theme and set color variables
    source $HOME/.config/fish/themes/{$singularis_prompt_theme}.fish
    set -f __R              (set_color -o $red)
    set -f __G              (set_color -o $green)
    set -f __B              (set_color -o $blue)
    set -f __Y              (set_color -o $yellow)
    set -f __C              (set_color -o $cyan)
    set -f __M              (set_color -o $magenta)
    set -f __W              (set_color -o $white)
    set -f _BL              (set_color -o $black)
    set -f _RS              (set_color normal)

    set -f __orb            '(' # open round bracket
    set -f __crb            ')' # close round bracket
    set -f __osb            '[' # open square bracket
    set -f __csb            ']' # close square bracket
    set -f space            ' '
    set -f separator        '|'

    if test $inside_gitdir = true
        set git_label       '!'
    else
        if contains -- $detached yes true 1
            set git_label   'HEAD::'
        else
            set git_label   'git::'
        end
    end

    if test $inside_workspace = true
        set -l worktree_status  (___singularis_worktree_status $HEAD_SHA)
        set -l dirty_state      $worktree_status[1]
        set -l stagged_state    $worktree_status[2]
        set -l untracked_state  $worktree_status[3]
        set -f worktree_prompt  ''
        echo > $HOME/fish.log
        echo $worktree_status >> $HOME/fish.log
        if test $dirty_state = true; 
          or test $stagged_state = true; 
          or test $stagged_state = 'invalid'; 
          or test $untracked_state = true
            set worktree_prompt  $__W' => '$__osb
            contains -- $dirty_state true;          and set worktree_prompt $worktree_prompt$__Y'*'
            contains -- $stagged_state true;        and set worktree_prompt $worktree_prompt$_RS$separator$__G'+'
            contains -- $stagged_state 'invalid';   and set worktree_prompt $worktree_prompt$_RS$separator$__R'!'
            contains -- $untracked_state true;      and set worktree_prompt $worktree_prompt$_RS$separator$__B'%'
            set worktree_prompt $worktree_prompt$__W$__csb
        end 
    end

    printf '%s' $__orb$git_label$current_branch$__crb$worktree_prompt
end
