if exists("g:visualmarkers_loaded")
    finish
endif

call visualmarkers#LoadHighlights()

command! MeHlMarkAll silent! call visualmarkers#HlMarkAll()
command! MeUnHlMarkAll silent! call visualmarkers#UnHlMarkAll()

autocmd! BufLeave * silent! call visualmarkers#MarkBuffer()
autocmd! BufEnter * silent! call visualmarkers#ReturnToLastLocation()

let g:visualmarkers_loaded = 1
