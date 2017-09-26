if exists("g:visualmarks_loaded")
    finish
endif

"call visualmarks#LoadHighlights()

command! VisualmarksHighlight silent! call visualmarks#HlMarkAll()
command! VisualmarksUnhighlight silent! call visualmarks#UnHlMarkAll()

"TODO
"command! VisualmarkersOn
"command! VisualmarkersOff

autocmd! BufLeave * silent! call visualmarks#MarkBuffer()
autocmd! BufEnter * silent! call visualmarks#UnmarkBuffer()

let g:visualmarks_loaded = 1
