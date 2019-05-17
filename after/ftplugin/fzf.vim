setl laststatus=0 noshowmode noruler

if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= '|setl laststatus<' . '|setl showmode<' . '|setl ruler<'
else
    let b:undo_ftplugin = 'setl laststatus<' . '|setl showmode<' . '|setl ruler<'
endif
