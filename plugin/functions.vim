function LargeFile()
    setlocal eventignore+=FileType
    setlocal bufhidden=unload
    setlocal undolevels=-1
    autocmd VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."
endfunction

function RestoreRegister()
    if &clipboard != "unnamed" && &clipboard != "unnamedplus"
        let @" = s:restore_reg
    elseif &clipboard == "unnamed"
        let @* = s:restore_reg
    elseif &clipboard == "unnamedplus"
        let @+ = s:restore_reg
    endif
    return ''
endfunction

function CopyWithoutClobberRepl()
    if &clipboard != "unnamed" && &clipboard != "unnamedplus"
        let s:restore_reg = @"
    elseif &clipboard == "unnamed"
        let s:restore_reg = @*
    elseif &clipboard == "unnamedplus"
        let s:restore_reg = @+
    endif
    return "p@=RestoreRegister()\<cr>"
endfunction

function VisualSearchCurrentSelection(direction)
    let       l:saved_reg = @"
    execute   'normal! vgvy'
    let       l:pattern = escape(@", '\\/.*$^~[]')
    let       l:pattern = substitute(l:pattern, "\n$", '', '')
    if        a:direction ==# 'b'
        execute 'normal! ?' . l:pattern . "\<cr>"
    elseif    a:direction ==# 'f'
        execute 'normal! /' . l:pattern . '^M'
    endif
    let       @/ = l:pattern
    let       @" = l:saved_reg
endfunction

function Op_adjust_window_height(motion_wiseness)
    execute (line("']") - line("'[") + 1) 'wincmd' '_'
    normal! `[zt
endfunction
