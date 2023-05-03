function __singularis_git_info
    set -l gitdir           $argv[1]
    set -l inside_gitdir    $argv[2]
    set -l bare_repo        $argv[3]
    set -l inside_workspace $argv[4]
    set -q argv[5]; and set -l sha $argv[5]
    set -l branch   ''
    set -l detached false

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

function __singularis_git_prompt
    # Git is not installed, return 1
    if not command -sq git
        return
    end
    set -l repo_info (command git rev-parse --git-dir --is-inside-git-dir --is-bare-repository --is-inside-work-tree HEAD 2>/dev/null)
    test -n "$repo_info"; or return # cannot get repo_info, just return

    set -l gitdir           $repo_info[1]
    set -l inside_gitdir    $repo_info[2]
    set -l bare_repo        $repo_info[3]
    set -l inside_workspace $repo_info[4]
    set -q $repo_info[5]; and set -l sha $repo_info[5]

    set -l git_info         (__singularis_git_info $repo_info)
    set -l current_branch   $git_info[1] # current branch
    set -l detached         $git_info[2]
    set -l git_label        ''

    set -l __orb            '(' # open round bracket
    set -l __crb            ')' # close round bracket

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
    end

    printf '%s' $__orb$git_label$current_branch$__crb
end
