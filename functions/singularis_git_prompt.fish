function ___singularis_git_info
    set gitdir           $argv[1]
    set inside_gitdir    $argv[2]
    set bare_repo        $argv[3]    # no use
    set inside_workspace $argv[4]    # no use
    set -q argv[5]; and set  sha $argv[5]
    set branch   ''
    set detached false

    if test $inside_gitdir = true
        set branch $color_yellow'GIT_DIR'
    else
        set branch (command git branch --show-current)
        if test -z $branch
            set detached true
            if set -q sha
                set branch $color_red(string shorten -m8 -c "" -- $sha)
                # set branch (string sub -s 1 -l 8 -- $sha) # compatible with older fish
            else
                set branch $color_white'unknown'
            end
        else
            set branch $color_cyan$branch
        end
    end

    echo $branch
    echo $detached
end

function ___singularis_worktree_status
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
    set -l worktree_status  (___singularis_worktree_status $argv[1])
    set -l dirty_state      $worktree_status[1]
    set -l untracked_state  $worktree_status[2]
    set -l valid_state      $worktree_status[3]
    set worktree_prompt     $color_white' => '
    set dirty_mark          $color_yellow'*'
    set untracked_mark      $color_blue'%'
    set sep                 $no_color'|'

    # Invalid case
    if test $valid_state = 'invalid'
        echo $worktree_prompt$color_red'[!]'
        return
    end

    # Clean case
    if test $dirty_state != true; and test $untracked_state != true
        echo $worktree_prompt$color_green'[OK]'
        return
    end

    # Both case
    if test $dirty_state = true; and test $untracked_state = true
        echo $worktree_prompt$color_white'['$dirty_mark$sep$untracked_mark$color_white']'
        return
    end

    # Normal case
    if test $dirty_state = true
        echo $worktree_prompt$color_yellow'[*]'
    else
        echo $worktree_prompt$color_blue'[%]'
    end
end

function ___singularis_relative_upstream
    set -l count (command git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null | string replace \t " ")
    echo $count | read -l behind ahead
    switch "$count"
        case '' # no upstream                                                                                                                                                     
        case "0 0" # equal to upstream                                                                                                                                            
            echo ''
        case "0 *" # ahead of upstream                                                                                                                                            
            echo $color_green'[+'$ahead']'
        case "* 0" # behind upstream                                                                                                                                              
            echo $color_blue'[-'$behind']'
        case '*' # diverged from upstream                                                                                                                                         
            echo $color_yellow'[??]'
    end
end

function singularis_git_prompt
    # Git is not installed, return
    if not command -sq git
        return
    end
    set repo_info (command git rev-parse --git-dir --is-inside-git-dir --is-bare-repository --is-inside-work-tree HEAD 2>/dev/null)
    test -n "$repo_info"; or return # cannot get repo_info, just return

    # Include theme and set color variables
    source $singularis_theme_path
    set -g color_red             (set_color -o $red)
    set -g color_green           (set_color -o $green)
    set -g color_blue            (set_color -o $blue)
    set -g color_yellow          (set_color -o $yellow)
    set -g color_cyan            (set_color -o $cyan)
    set -g color_white           (set_color -o $white)
    set -g no_color              (set_color normal)

    set gitdir              $repo_info[1]
    set inside_gitdir       $repo_info[2]
    set bare_repo           $repo_info[3]
    set inside_workspace    $repo_info[4]
    set HEAD_SHA            $repo_info[5]

    set git_info            (___singularis_git_info $repo_info)
    set current_branch      $git_info[1]
    set detached            $git_info[2]
    set git_label           ''

    if test $inside_gitdir = true
        set git_label       $color_yellow'!'
    else
        if contains -- $detached yes true 1
            set git_label   $color_yellow'HEAD'
        else
            set git_label   $color_yellow'branch'
        end
    end

    set -f worktree_prompt         ''
    set -f relative_upstream       ''
    if test $inside_workspace = true
        set worktree_prompt (___singularis_worktree_prompt $HEAD_SHA)
        if not contains -- $detached yes true 1
            # Find relative upstream if not detached
            set relative_upstream (___singularis_relative_upstream)
        end
    end

    printf '%s'     $color_blue'(' $git_label $no_color'::' $current_branch $color_blue')'
    printf '%s'     $worktree_prompt
    printf '%s'     $relative_upstream
end
