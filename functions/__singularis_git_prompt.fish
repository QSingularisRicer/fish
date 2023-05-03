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
end
