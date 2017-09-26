"if !exists("b:hl_toggle_markers")
"    let b:hl_toggle_markers = 0
"endif

function! visualmarkers#LoadHighlights()
    highlight Buffer_Mark     ctermfg=Black ctermbg=Brown   guifg=Black guibg=Brown
    highlight A_Mark          ctermfg=Black ctermbg=Cyan    guifg=Black guibg=#137b7a
    highlight B_Mark          ctermfg=Black ctermbg=Yellow  guifg=Black guibg=#ffa500
    highlight C_Mark          ctermfg=Black ctermbg=Red     guifg=Black guibg=Red
    
    hi! link visualmarkersHighlights Buffer_Mark
    hi! link visualmarkersHighlights A_Mark
    hi! link visualmarkersHighlights B_Mark
    hi! link visualmarkersHighlights C_Mark
endfunction
 
"Hack to spawn marker when on an end of line character
function! visualmarkers#SpawnMarker()
    if !hlexists("a:visualmarkersHighlights")
        call visualmarkers#LoadHighlights()
    endif

    if col(".") == col("$")
        let last_pos = getpos(".")
        normal! k
        let curr_pos = getpos(".")

        "If the cursor is on top of the mark position when redrawn, nothing will show.
        "So when cursor position changes, redraw to show mark.
        if last_pos[1] != curr_pos[1] 
            redraw
            "normal! j
        else
            let last_pos = curr_pos
            normal! j
            let curr_pos = getpos(".")

            if last_pos[1] != curr_pos[1]
                redraw
                "normal! k
            endif
        endif
   endif
endfunction

"Vim redraws the screen when switching buffers. Must create a dummy white space 
"as a placeholder.
"function! visualmarkers#FakeBufferCursor()
"    if col(".") == col("$")
"        call setline(line("."), " ")
"        write
"    endif
"endfunction

function! visualmarkers#HlMarkBuffer() 
    let b:hl_toggle_markers = 1
    let b:hl_mark_buffer_id = matchadd("Buffer_Mark", "\\%'l")
    call visualmarkers#SpawnMarker()
endfunction

function! visualmarkers#HlMarkA() 
    silent! call visualmarkers#UnHlMarkA()
    let b:hl_toggle_markers = 1
    let b:hl_mark_a = matchadd("A_Mark", "\\%'a")
    call visualmarkers#SpawnMarker()
endfunction

function! visualmarkers#HlMarkB()
    silent! call visualmarkers#UnHlMarkB()
    let b:hl_toggle_markers = 1
    let b:hl_mark_b = matchadd("B_Mark", "\\%'b")
    call visualmarkers#SpawnMarker()
endfunction
 
function! visualmarkers#HlMarkC()
    silent! call visualmarkers#UnHlMarkC()
    let b:hl_toggle_markers = 1
    let b:hl_mark_c = matchadd("C_Mark", "\\%'c")
    call visualmarkers#SpawnMarker()
endfunction

function! visualmarkers#UnHlMarkBuffer()

    "Remove dummy white space for cursor.
    "Conditions to remove dummy white space:
    "   1. The cursor must be on the first column.
    "   2. The line must contain only one character and it must be a white space.
    "   3. The second (last) column must be the end of line.
    "When conditions are met, this script should/will remove that one character, a dummy white space that
    "   was placed before switching buffers.
    "let line = getline(".")
    "let col_num = col(".")
    "if col_num == 1
    "    \ && strlen(line) <= 1 && matchstr(line, "\ ") != ""
    "    \ && col_num + 1 == col("$") 
    "    "Safer to delete one character than an entire line
    "    normal! x
    "    "call setline(line("."), "")
    "endif
    normal! ``
    let buffer_delete = matchdelete(b:hl_mark_buffer_id)
    delmarks `
endfunction

function! visualmarkers#UnHlMarkA()
    if exists("b:hl_mark_a")
        let a_delete =  matchdelete(b:hl_mark_a)
    endif
endfunction

function! visualmarkers#UnHlMarkB()
    if exists("b:hl_mark_b")
        let b_delete = matchdelete(b:hl_mark_b)
    endif
endfunction

function! visualmarkers#UnHlMarkC()
    if exists("b:hl_mark_c")
        let c_delete = matchdelete(b:hl_mark_c)
    endif
endfunction

function! visualmarkers#HlMarkAll()
    call visualmarkers#HlMarkA()
    call visualmarkers#HlMarkB()
    call visualmarkers#HlMarkC()
endfunction

function! visualmarkers#UnHlMarkAll()
    call visualmarkers#UnHlMarkBuffer()
    call visualmarkers#UnHlMarkA()
    call visualmarkers#UnHlMarkB()
    call visualmarkers#UnHlMarkC()
endfunction

function! visualmarkers#ToggleHlMarkers()
    if b:hl_toggle_markers == 1
        let b:hl_toggle_markers = 0
        silent! call visualmarkers#UnHlMarkAll()
        echo "Marker highlight removed"
    else
        let b:hl_toggle_markers = 1
        silent! call visualmarkers#HlMarkAll()
        echo "Marker highlight on"
    endif
endfunction

function! visualmarkers#MarkBuffer()
    silent! call visualmarkers#UnHlMarkBuffer()
    normal! m`
    silent! call visualmarkers#HlMarkBuffer()
endfunction
