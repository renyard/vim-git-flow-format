let s:branches = ['master', 'develop']
let s:prefixes = ['feature', 'release', 'hotfix', 'support', 'versiontag']

" Branch prefixes used by Git Flow.
if !exists('g:git_flow_prefixes')
    let g:git_flow_prefixes = {
        \ 'master': '',
        \ 'develop': '',
        \ 'feature': 'F:',
        \ 'release': 'R:',
        \ 'hotfix': 'H:',
        \ 'support': 'S:',
        \ 'versiontag': 'V:'
    \ }
endif

function! Git_flow_branch_format(name)
    if !strlen(a:name)
        return ''
    endif

    let branch = a:name
    let prefix = ''
    let icon = ''

    let prefixes = Git_flow_populate_prefixes()

    for [key, value] in items(prefixes)
        if (match(branch, key) == 0)
            let prefix = key
        endif
    endfor

    " Set the icon if prefixes and prefix are populated.
    if (len(prefixes) && strlen(prefix))
        let icon = prefixes[prefix]
    endif

    if strlen(icon)
        " Strip the prefix from the branch name.
        let branch = substitute(branch, prefix, '', '')

        let output = ' ' . icon

        " Don't add '/' if branch is an empty string.
        if strlen(branch)
            let output = output . branch
        endif

        return output
    else
        " Did not find prefix, so just return the branch name.
        return branch
    endif
endfunction

function! Git_flow_get_conf(key)
    " Get the file path of the current buffer.
    let file_path = expand('%:p:h')

    let l:git_cmd = 'cd ' . file_path . ' && git config --get gitflow.' . a:key
    let l:git_out = system(l:git_cmd)

    " If the exit code was not 0, return an empty string.
    if v:shell_error
        return ''
    endif

    " Strip line breaks from command output.
    return substitute(l:git_out, '\n', '', '')
endfunction

" Populate the prefixes from git config.
function! Git_flow_populate_prefixes()
    if exists("b:git_flow_config_prefixes") && len(b:git_flow_config_prefixes)
        return b:git_flow_config_prefixes
    endif

    let prefixes = {}

    " Loop over branches and prefixes.
    for branch in s:branches
        let l:prefix = Git_flow_get_conf('branch.' . branch)
        if strlen(l:prefix)
            let prefixes[l:prefix] = g:git_flow_prefixes[branch]
        endif
    endfor

    for branch in s:prefixes
        let l:prefix = Git_flow_get_conf('prefix.' . branch)
        if strlen(l:prefix)
            let prefixes[l:prefix] = g:git_flow_prefixes[branch]
        endif
    endfor

    let b:git_flow_config_prefixes = prefixes

    return prefixes
endfunction
