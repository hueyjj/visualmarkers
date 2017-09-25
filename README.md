visualmarkers
======

visualmarkers is a small vim script plugin that highlights vim's built-in marker positions.

![Markers screenshot](https://raw.githubusercontent.com/hueyjj/visualmarkers/master/screenshots/markers.PNG)

Download
=======

    git clone https://github.com/hueyjj/visualmarkers.git

or a package manger would work too

Manual install
=======

Add visualmarkers to vim's run time path in the vimrc

    set runtimepath+=~/path/to/visualmarkers

Add visualmarker's help documentation to vim's helptags

    helptags ~/path/to/visualmarkers/doc

In the vimrc
======
After adding visualmarker to vim's runtimepath, add these.

    "Highlight markers
    nnoremap <silent> ma ma:call visualmarkers#HlMarkA()<CR>
    nnoremap <silent> mb mb:call visualmarkers#HlMarkB()<CR>
    nnoremap <silent> mc mc:call visualmarkers#HlMarkC()<CR>
    
    nnoremap <Leader>z :call visualmarkers#ToggleHlMarkers()<CR>

The visualmarkers functions (HlMarkA, HlMarkB, HlMarkC) should be called after using a mark. While there
are at least 26 (alphabets) + 10 (digits) marks available, this plugin only uses a few markers, as in three.
Ideally, it is up to the user to add their preferred marks directly in the visualmarkers script itself (visualmarkers.vim).
Colors are also directly customizable in the script.

Main cases
=======
1) While in normal mode, using ma, mb, mc, etc. (setting marks), should place a mark down. The marks should
immediately show the highlights.

2) When switching buffers and all buffers are visible, a mark will be placed at the cursor's previous position. That
mark should immediately show its highlight. Switching back to the buffer that has the mark will remove that mark.

3) When it becomes necessary, the markers can all be removed through the ToggleHlMarkers function. The
highlights should also return when toggled again.

