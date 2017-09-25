if exists("g:visualmarkers_loaded")
    finish
endif

"Highlight markers
highlight! Buffer_Mark   ctermfg=Black ctermbg=Yellow guifg=Black guibg=Yellow
highlight! A_Mark        ctermfg=Black ctermbg=Green guifg=Black guibg=Green
highlight! B_Mark        ctermfg=Black ctermbg=White guifg=Black guibg=White
highlight! C_Mark        ctermfg=Black ctermbg=DarkMagenta guifg=Black guibg=DarkMagenta

command! MeHlMarkAll silent! call visualmarkers#HlMarkAll()
command! MeUnHlMarkAll silent! call visualmarkers#UnHlMarkAll()

autocmd! BufLeave * silent! call visualmarkers#MarkBuffer()
autocmd! BufEnter * silent! call visualmarkers#UnHlMarkBuffer()

let g:visualmarkers_loaded = 1
