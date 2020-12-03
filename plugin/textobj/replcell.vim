if exists('g:loaded_textobj_replcell')
    finish
end

" Snippets based on those of
" https://github.com/GCBallesteros/vim-textobj-hydrogen

let s:pattern = '^\s*\S*\s*%%'
let s:flags_no_c = 'nW'
let s:flags = s:flags_no_c . 'c'

call textobj#user#plugin('replcell', {
            \ '-': {
            \ '*sfile*': expand('<sfile>:p'),
            \ 'move-n': ']r', 'move-n-function': 's:move_n',
            \ 'move-p': '[r', 'move-p-function': 's:move_p',
            \ 'select-a': 'ar', 'select-a-function': 's:select_a',
            \ 'select-i': 'ir', 'select-i-function': 's:select_i',
            \ }})

function! s:move_n()
    let search_line = search(s:pattern, s:flags)
    if search_line == 0
        return 0
    else
        let target_line = search_line
    end

    let curr_pos = getpos('.')
    let pos = [curr_pos[0], target_line, 1, curr_pos[3]]
    return ['V', pos, 0]
endfunction

function! s:move_p()
    let search_line = search(s:pattern, s:flags_no_c . 'b')
    if search_line == 0
        let target_line = 1
    else
        let target_line = search_line
    end

    let curr_pos = getpos('.')
    let pos = [curr_pos[0], target_line, 1, curr_pos[3]]
    return ['V', pos, 0]
endfunction

function! s:select_a()
    let search_start = search(s:pattern, s:flags . 'b')
    let search_end = search(s:pattern, s:flags_no_c)

    if search_start == 0
        let start_line = 1
    else
        let start_line = search_start
    end

    if search_end == 0
        let end_line = line('$')
    else
        let end_line = search_end - 1
    end

    let curr_pos = getpos('.')
    let start_pos = [curr_pos[0], start_line, 1, curr_pos[3]]
    let end_pos = [curr_pos[0], end_line, 0, curr_pos[3]]

    return ['V', start_pos, end_pos]
endfunction

function! s:select_i()
    let search_start = search(s:pattern, s:flags_no_c . 'b')
    let search_end = search(s:pattern, s:flags_no_c)

    if search_start == 0
        let start_line = 1
    else
        let start_line = search_start + 1
    end

    if search_end == 0
        let end_line = line('$')
    else
        let end_line = search_end - 1
    end

    let start_line = nextnonblank(start_line)
    if start_line == 0 || getline(start_line) =~ s:pattern
        return 0
    end

    let end_line = prevnonblank(end_line)
    if end_line == 0 || getline(end_line) =~ s:pattern
        return 0
    end

    let curr_pos = getpos('.')
    let start_pos = [curr_pos[0], start_line, 1, curr_pos[3]]
    let end_pos = [curr_pos[0], end_line, 0, curr_pos[3]]

    return ['V', start_pos, end_pos]
endfunction

let g:loaded_textobj_replcell = 1
