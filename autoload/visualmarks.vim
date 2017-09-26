if !exists("g:visualmarks_buffer_mark")
    let g:visualmarks_buffer_mark = "l"    "Default
endif

let s:del_buffer_mark = "delmarks " . g:visualmarks_buffer_mark
let s:visualmarks_mark_names = []

function! visualmarks#SetHighlights(mark_settings)
    let s:visualmarks_mark_names = []
    let g:visualmarks_highlights = []
    for clr in a:mark_settings
        call add(s:visualmarks_mark_names, clr[0])

        let mark_id = "visualmarks_" . clr[0] . "_mark"
        let termfg = clr[1]
        let termbg = clr[2]
        let guifg = clr[3]
        let guibg = clr[4]

        let highlight = [
            \"highlight", mark_id,
            \"ctermfg=" . termfg,   "ctermbg="  . termbg, 
            \"guifg="   . guifg,    "guibg="    . guibg,
        \]
        let highlight = join(highlight, ' ')
        call add(g:visualmarks_highlights, highlight)
    endfor
    call visualmarks#LoadHighlights()
endfunction

function! visualmarks#LoadHighlights()
    highlight visualmarks_clear_mark ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE

    if exists("g:visualmarks_highlights")
        for hl in g:visualmarks_highlights
            execute hl
        endfor
    endif
endfunction
 
"Hack to spawn marker when on an end of line character
function! visualmarks#SpawnMarker(marker, buffer_change)
    if !hlexists(a:marker)
        call visualmarks#LoadHighlights()
    endif

    if col(".") == col("$")
        let last_pos = getpos(".")
        normal! k
        let curr_pos = getpos(".")

        "If the cursor is on top of the mark position when redrawn, nothing will show.
        "So when cursor position changes, redraw to show mark.
        if last_pos[1] != curr_pos[1] 
            redraw
            if !a:buffer_change
                normal! j
            endif
        else
            let last_pos = curr_pos
            normal! j
            let curr_pos = getpos(".")

            if last_pos[1] != curr_pos[1]
                redraw
                if !a:buffer_change
                    normal! k
                endif
            endif
        endif
    endif
    redraw
endfunction

function! visualmarks#HighlightMark(name)
    if "buffer" == a:name
        let name = "buffer"
        let mark = g:visualmarks_buffer_mark
        let change = 1
    else
        let name = a:name
        let mark = a:name
        let change = 0
    endif

    call visualmarks#UnhighlightMark(name)
    call matchadd("visualmarks_" . name . "_mark", "\\%'" . mark)
    call visualmarks#SpawnMarker("visualmarks_" . name . "_mark", change)
    let b:hl_toggle_markers = 1
endfunction

function! visualmarks#UnhighlightMark(name)
    if "buffer" == a:name
        let name = g:visualmarks_buffer_mark
    else
        let name = a:name
    endif

    let off = matchadd("visualmarks_clear_mark", "\\%'" . name)
endfunction

function! visualmarks#HighlightAll()
    for name in s:visualmarks_mark_names
        if "buffer" != name
            call visualmarks#HighlightMark(name)
        endif
    endfor
endfunction

function! visualmarks#UnhighlightAll()
    call clearmatches()
endfunction

function! visualmarks#ToggleHlMarkers()
    if b:hl_toggle_markers == 1
        let b:hl_toggle_markers = 0
        call visualmarks#UnhighlightAll()
        echo "Marker highlight hide"
    else
        let b:hl_toggle_markers = 1
        call visualmarks#HighlightAll()
        echo "Marker highlight show"
    endif
endfunction

function! visualmarks#MarkBuffer()
    call visualmarks#UnhighlightMark("buffer")
    execute s:del_buffer_mark
    execute "normal! m" . g:visualmarks_buffer_mark
    call visualmarks#HighlightMark("buffer")
endfunction

function! visualmarks#UnmarkBuffer()
    execute "normal! `" . g:visualmarks_buffer_mark
    delmarks g:visualmarks_buffer_mark
    call visualmarks#UnhighlightMark("buffer")
    execute s:del_buffer_mark
endfunction
