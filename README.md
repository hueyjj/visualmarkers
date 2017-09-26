visualmarks
======

visualmarks is a small vim script plugin that highlights vim's built-in marks.

![Markers screenshot](https://raw.githubusercontent.com/hueyjj/visualmarks/master/screenshots/markers.PNG)

Download
=======

    git clone https://github.com/hueyjj/visualmarks.git

or a package manger would work too

Manual install
=======

Add visualmarks to vim's run time path in the vimrc

    set runtimepath+=~/path/to/visualmarks

Add visualmarker's help documentation to vim's helptags

    helptags ~/path/to/visualmarks/doc

In the vimrc
======
After adding visualmarker to vim's runtimepath, add these.

```vim
"Highlight markers
let g:visualmarks_buffer_mark = 'l' "change if user uses 'l' to mark

"Set custom colors
"   Function takes a list of mark settings, where each setting should be
"   ["name of mark", ctermfg, ctermbg, guifg, guibg]
"   e.g ["o", "red", "white", "#ffffff, "#000000"]
call visualmarks#SetHighlights([ 
    \["buffer", "black", "white",   "black", "white"],
    \["a",      "black", "cyan",    "black", "#137b71"],
    \["b",      "black", "yellow",  "black", "#ffa500"],
    \["c",      "black", "red",     "black", "red"],
    \["d",      "black", "red",     "black", "red"],
    \["e",      "black", "red",     "black", "red"],
\])

"Remap marks to itself plus a function call to highlight.
"Make sure the mark command match the argument that is passed into the function.
nnoremap <silent> ma ma:call visualmarks#HighlightMark("a")<CR>
nnoremap <silent> mb mb:call visualmarks#HighlightMark("b")<CR>
nnoremap <silent> mc mc:call visualmarks#HighlightMark("c")<CR>
nnoremap <silent> md md:call visualmarks#HighlightMark("d")<CR>
nnoremap <silent> me me:call visualmarks#HighlightMark("e")<CR>

"Show or hide the highlights
nnoremap <Leader>z :call visualmarks#ToggleHlMarkers()<CR>
```

The visualmarks functions should be called after using a mark. While there
are at least 26 (alphabets) + 10 (digits) marks available, the example only uses a few markers.
Ideally, it is up to the user to add their preferred marks in their vimrc.
Colors are also customizable.

Usage
=======
1) While in normal mode, using ma, mb, mc, etc. (setting marks), should place a mark down. The marks should
immediately show the highlights.

2) When switching buffers and all buffers are visible, a mark will be placed at the cursor's previous position. That
mark should immediately show its highlight. Switching back to the buffer that has the mark will remove that highlight and mark.

3) When it becomes necessary, the highlights can all be hidden through the ToggleHlMarkers function or through commands:

```vim
:VisualmarksHighlight
:VisualmarksUnhighlight
```

If there are marks down, the highlights should also become visible when toggled again.
