if !exists("g:visualmarker_buffer_mark")
    let g:visualmarker_buffer_mark = "l"    "Default
endif

let s:del_buffer_mark = "delmarks " . g:visualmarker_buffer_mark

function! visualmarkers#SetHighlights(user_highlights)
endfunction

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

   redraw
endfunction

function! visualmarkers#HlMarkBuffer() 
    let b:hl_toggle_markers = 1
    let b:hl_mark_buffer_id = matchadd("Buffer_Mark", "\\%'" . g:visualmarker_buffer_mark)
    call visualmarkers#SpawnMarker()
endfunction

function! visualmarkers#HlMarkA() 
    if b:hl_mark_a > 0
        visualmarkers#UnHlMarkA()
    endif

    silent! call visualmarkers#UnHlMarkA()
    let b:hl_toggle_markers = 1
    let b:hl_mark_a = matchadd("A_Mark", "\\%'a")
    call visualmarkers#SpawnMarker()
endfunction

function! visualmarkers#HlMarkB()
    if b:hl_mark_a > 0
        visualmarkers#UnHlMarkA()
    endif

    silent! call visualmarkers#UnHlMarkB()
    let b:hl_toggle_markers = 1
    let b:hl_mark_b = matchadd("B_Mark", "\\%'b")
    call visualmarkers#SpawnMarker()
endfunction
 
function! visualmarkers#HlMarkC()
    if b:hl_mark_a > 0
        visualmarkers#UnHlMarkA()
    endif

   silent! call visualmarkers#UnHlMarkC()
    let b:hl_toggle_markers = 1
    let b:hl_mark_c = matchadd("C_Mark", "\\%'c")
    call visualmarkers#SpawnMarker()
endfunction

function! visualmarkers#UnHlMarkBuffer()
    let buffer_delete = matchdelete(b:hl_mark_buffer_id)
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
    execute s:del_buffer_mark
    execute "normal! m" . g:visualmarker_buffer_mark
    silent! call visualmarkers#HlMarkBuffer()
endfunction

function! visualmarkers#ReturnToLastLocation()
    execute "normal! `" . g:visualmarker_buffer_mark
    silent! call visualmarkers#UnHlMarkBuffer()
    execute s:del_buffer_mark
endfunction
