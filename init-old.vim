function! VimrcLoadPlugins()
    " Install Dein.vim if not available
    if &runtimepath !~# '/dein.vim'
      let s:dein_dir = expand('~/.cache/dein/repos/github.com/Shougo/dein.vim')

      if !isdirectory(s:dein_dir)
        call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_dir))
      endif

      execute 'set runtimepath^=' . s:dein_dir
    endif
    let g:dein#install_progress_type = 'title'
    let g:dein#enable_notification = 1

    if dein#load_state('~/.cache/dein')
      call dein#begin('~/.cache/dein')

      call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
      call dein#add('wsdjeg/dein-ui.vim')
      call dein#add('haya14busa/dein-command.vim')

      " Linting
      call dein#add('w0rp/ale')

      " Language Server + Autocomplete + Sources
      call dein#add('autozimu/LanguageClient-neovim', {'build': './install.sh', 'rev': 'next'})
      call dein#add('roxma/LanguageServer-php-neovim',  {'build': 'composer install && composer run-script parse-stubs'})
      call dein#add('Shougo/deoplete.nvim')
      call dein#add('Shougo/neco-syntax')
      call dein#add('wellle/tmux-complete.vim')

      " Enhancements: TODO, split into improvements, vimlike, and additions
      " call dein#add('airblade/vim-gitgutter')
      call dein#add('airblade/vim-gitgutter')
      " call dein#add('mhinz/vim-signify')
      call dein#add('christoomey/vim-tmux-navigator')
      call dein#add('dhruvasagar/vim-table-mode')
      call dein#add('ervandew/supertab')
      call dein#add('farmergreg/vim-lastplace')
      call dein#add('haya14busa/incsearch-fuzzy.vim')
      call dein#add('haya14busa/incsearch.vim')
      call dein#add('haya14busa/vim-asterisk')
      call dein#add('jiangmiao/auto-pairs')
      call dein#add('junegunn/fzf', { 'dir': '~/.fzf', 'build': './install --all' })
      call dein#add('junegunn/fzf.vim')
      call dein#add('junegunn/vim-easy-align')
      call dein#add('kana/vim-operator-user')
      call dein#add('matze/vim-move')
      call dein#add('sbdchd/neoformat')
      call dein#add('sickill/vim-pasta') " Smarter pasting with indention
      call dein#add('tmux-plugins/vim-tmux')
      call dein#add('tommcdo/vim-exchange')
      call dein#add('tpope/vim-commentary')
      " Look into caw and https://github.com/Shougo/shougo-s-github/tree/master/vim/rc
      call dein#add('tpope/vim-repeat')
      call dein#add('tpope/vim-surround')
      call dein#add('triglav/vim-visual-increment')
      call dein#add('wellle/targets.vim')
      call dein#add('kassio/neoterm')

      call dein#add('andymass/vim-matchup')

      call dein#add('dkasak/gruvbox') " Gruvbox with better haskell highlighting

      call dein#add('raghur/vim-ghost', {'do': ':GhostInstall'})

      " Languages
      call dein#add('mattn/emmet-vim', { 'on_ft': ['javascript.jsx', 'javascript', 'php', 'css', 'html', 'gohtmltmpl']})
      call dein#add('sheerun/vim-polyglot')
      call dein#add('ekalinin/Dockerfile.vim', { 'on_ft': 'Dockerfile' })
      call dein#add('styled-components/vim-styled-components')
      call dein#add('ap/vim-css-color', { 'on_ft': ['css', 'html', 'php', 'javascript', 'javascript.jsx'] })
      call dein#add('vim-pandoc/vim-pandoc-syntax', { 'on_ft': ['markdown', 'pandoc', 'markdown.pandoc'] })
      call dein#add('vim-pandoc/vim-pandoc', { 'on_ft': ['markdown', 'pandoc', 'markdown.pandoc'] })
      call dein#end()
      call dein#save_state()

      if dein#check_install()
        call dein#install()
      endif
    endif
endfunction

"
" Plugin Configs
"
function! VimrcLoadPluginSettings()
  " neoterm
  tnoremap <Esc> <C-\><C-n>
  nnoremap <silent> <F12> :botright Ttoggle<CR>
  let g:neoterm_autoinsert = 1
  let g:neoterm_size = 12

  " machup
  let g:loaded_matchit = 1
  let g:matchup_transmute_enabled = 1
  let g:matchup_surround_enabled = 1
  let g:matchup_matchparen_deferred = 1
  let g:matchup_matchparen_status_offscreen = 0

  " ale
  nmap <silent> <C-p> <Plug>(ale_previous_wrap)
  nmap <silent> <C-n> <Plug>(ale_next_wrap)
  let g:ale_sh_shellcheck_options = '-x'
  let g:ale_open_list = 0
  let g:ale_haskell_brittany_options = "--write-mode inplace"

  " LanguageClient-neovim
  set hidden " Required for rename operation
  let g:LanguageClient_autoStart = 1
  let g:LanguageClient_serverCommands = {
        \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
        \ 'python': ['pyls'],
        \ 'haskell': ['hie-wrapper', '--lsp'],
        \ 'Dockerfile': ['docker-langserver', '--stdio'],
        \ 'javascript.jsx': ['javascript-typescript-stdio'],
        \ 'html': ['html-languageserver', '--stdio'],
        \ 'json': ['vscode-json-languageserver', '--stdio'],
        \ 'sh': ['bash-language-server', 'start'],
        \ 'yaml': ['node', '/home/jared/dev/yaml-language-server/out/server/src/server.js', '--stdio']
        \ }
  " \ 'php': ['php', '/home/jared/.config/composer/vendor/felixfbecker/language-server/bin/php-language-server.php'],

  nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
  nnoremap <silent> gr :call LanguageClient#textDocument_rename()<CR>
  nnoremap <silent> gs :call LanguageClient#textDocument_documentSymbol()<CR>
  nnoremap <silent> <leader>f :call LanguageClient#textDocument_formatting()<CR>
  nnoremap <silent> gR :call LanguageClient#textDocument_references()<CR>
  nnoremap <silent> gh :call LanguageClient#textDocument_hover()<CR>

  " supertab
  let g:SuperTabDefaultCompletionType = "<c-n>"
  " emmet.vim
  let g:user_emmet_expandabbr_key = '<c-e>'
  let g:use_emmet_complete_tag = 1
  let g:user_emmet_install_global = 0

  let g:user_emmet_settings = {
      \  'javascript.jsx' : {
      \      'extends' : 'jsx',
      \  },
      \  'javascript' : {
      \      'extends' : 'jsx',
      \  },
      \}

  " autocmd FileType html,php,scss,css,javascript,javascript.jsx,gohtmltmpl EmmetInstall

  " deoplete.vim
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#enable_smart_case = 1
  let g:deoplete#auto_complete_delay = 10
  let g:deoplete#auto_refresh_delay = 10
  let g:deoplete#refresh_always = 1
  let g:deoplete#num_processes = 0

  " tmux-complete.vim
  let g:tmuxcomplete#trigger = ''
  let g:tmuxcomplete#asyncomplete_source_options = {
        \ 'name':      'tmux',
        \ 'whitelist': ['*'],
        \ 'priority': -1,
        \ 'config': {
        \     'splitmode':      'words',
        \     'filter_prefix':   0,
        \     'show_incomplete': 1,
        \     'sort_candidates': 0,
        \     'scrollback':      0,
        \     'truncate':        0
        \     }
        \ }

  " neoformat
  let g:neoformat_basic_format_align = 1
  let g:neoformat_basic_format_retab = 1
  let g:neoformat_basic_format_trim  = 1
  let g:neoformat_try_formatprg = 1
  let g:neoformat_run_all_formatters = 1
  let g:neoformat_only_msg_on_error = 1

  " vim-pandoc
  let g:pandoc#modules#disabled = ["folding"]
  let g:pandoc#completion#bib#mode = "citeproc"
  let g:pandoc#formatting#equalprg=''

  " vim-polygot
  let g:polygot_disabled = ['Dockerfile', 'markdown', 'graphql']
  let g:haskell_enable_quantification = 1
  let g:haskell_enable_pattern_synonyms = 1
  let g:haskell_indent_disable = 1
  let g:haskell_enable_typeroles = 1

  " vim-table-mode
  let g:table_mode_motion_up_map = ''
  let g:table_mode_motion_down_map = ''
  let g:table_mode_motion_left_map = ''
  let g:table_mode_motion_right_map = ''

  " vim-easy-align
  xmap <CR> <Plug>(EasyAlign)

  " vim-exchange
  xmap gx <Plug>(Exchange)

  " vim-tmux-navigator
  let g:tmux_navigator_no_mappings = 1
  nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
  nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
  nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
  nnoremap <silent> <M-l> :TmuxNavigateRight<cr>

  " vim-move
  let g:move_key_modifier = 'C'

  " incsearch.vim
  function! s:config_fuzzyall(...) abort
    return extend(copy({
          \   'converters': [
          \     incsearch#config#fuzzy#converter(),
          \     incsearch#config#fuzzyspell#converter()
          \   ],
          \ }), get(a:, 1, {}))
  endfunction

  noremap <silent><expr> z/ incsearch#go(<SID>config_fuzzyall({'is_stay': 0}))
  noremap <silent><expr> z? incsearch#go(<SID>config_fuzzyall({'is_stay': 0, 'command': '?'}))
  noremap <expr> / incsearch#go({'command': '/', 'is_stay': 0})
  noremap <expr> ? incsearch#go({'command': '?', 'is_stay': 0})

  let g:incsearch#auto_nohlsearch = 1

  " Improved asterisk along with incsearch
  map *   <Plug>(incsearch-nohl)<Plug>(asterisk-*)
  map g*  <Plug>(incsearch-nohl)<Plug>(asterisk-g*)
  map #   <Plug>(incsearch-nohl)<Plug>(asterisk-#)
  map g#  <Plug>(incsearch-nohl)<Plug>(asterisk-g#)

  map z*  <Plug>(incsearch-nohl0)<Plug>(asterisk-z*)
  map gz* <Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)
  map z#  <Plug>(incsearch-nohl0)<Plug>(asterisk-z#)
  map gz# <Plug>(incsearch-nohl0)<Plug>(asterisk-gz#)

  " vim-signify
  " let g:signify_realtime = 1
  " let g:signify_update_on_focusgained = 1
  let g:gitgutter_map_keys = 0

  " vim-ghost
  autocmd BufNewFile,BufRead *ghost* setl ft=html
endfunction

"
" Mappings

function! VimrcLoadMappings()
    " General thoughts: Operator + non-motion is an 'invalid operation' in vim
    "                   oprator + second operator is also 'invalid'
    "                   With those in mind, there are lots of empty binds in
    "                   vim available

    " clear search highlight with ,s
    nnoremap <silent> <leader>s :noh<CR>
    " move to last change
    nnoremap gI `.
    " BC calc from current line
    map <leader>c yypkA<ESC>j:.!wcalc -E -P6<CR>kJ
    "Insert new lines in normal mode
    nnoremap <silent> go :pu _<CR>:'[-1<CR>
    nnoremap <silent> gO :pu! _<CR>:']+1<CR>
    " J is 'join' so K is 'kut', which comes in useful a surprising amount
    nnoremap K i<CR><ESC>
    " Why isn't this default? C = c$, D = d$...
    nnoremap Y y$
    " For some reason, this works without breaking syntax highlighting
    nnoremap <C-L> :redraw!<CR>

    " Edit file with sudo: Does not work in neovim
    " command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
    " command W :execute ':silent w !sudo tee > /dev/null %'
    " command! W :SudoWrite

    " Replace cursor under word. Pressing . will move to next match and repeat
    nnoremap c* /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgn
    nnoremap c# ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgN
    " Delete cursor under word. Pressing . will move to next match and repeat
    nnoremap d* /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``dgn
    nnoremap d# ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>``dgN

    function! Op_adjust_window_height(motion_wiseness)
      execute (line("']") - line("'[") + 1) 'wincmd' '_'
      normal! `[zt
    endfunction
    call operator#user#define('adjust', 'Op_adjust_window_height')
    map _  <Plug>(operator-adjust)

    call operator#user#define_ex_command('neoformat','Neoformat')
    " map = <Plug>(operator-neoformat)

endfunction


" Settings

function! VimrcLoadSettings()
    filetype plugin indent on
    set backspace=indent,eol,start        " backspace over everything in insert mode
    set clipboard=unnamedplus             " Sets the default register of vim for system clipboard compatibility
    set backup
    set undofile                          " create '.<FILENAME>.un~' for persiting undo history
    set lazyredraw                        " speed increase, but doesn't seem to be needed
    set virtualedit=block
    set mouse=
    set dir=~/.config/nvim/backup//
    set undodir=~/.config/nvim/backup//
    set backupdir=~/.config/nvim/backup//
    set noerrorbells visualbell t_vb=     " disable annoying terminal sounds
    set list
    set listchars=tab:▸\ ,extends:❯,precedes:❮,eol:¬,trail:⌴
    set showbreak=↪\ \
    set fillchars=diff:⣿,vert:│,fold:\
    set showcmd                           " display incomplete commands
    set cmdheight=1
    set scrolloff=2
    set sidescrolloff=2
    set number                             " display line numbers on the left
    set shortmess+=aI

    set expandtab         " expand tabs into spaces
    set softtabstop=4     " number of spaces used with tab/bs
    set shiftwidth=4      " indent with two spaces
    set ignorecase        " ignore case when searching
    set smartcase         " disable 'ignorecase' if search pattern has uppercase characters
    set hlsearch          " highlight previous search matches
    set noshowmatch       " briefly jump to the matching bracket on insert
    set nowrap            " automatically wrap text when 'textwidth' is reached
    set foldmethod=indent " by default, fold using indentation
    set foldlevel=0       " if fold everything if 'foldenable' is set
    set foldnestmax=10    " maximum fold depth
    set nofoldenable      " don't fold by default

    set synmaxcol=500     " maximum length to apply syntax highlighting
    set timeout           " enable timeout of key codes and mappings(the default)
    set ttimeout          " enable timeout of key codes and mappings(the default)
    set timeoutlen=3000   " big timeout for key sequences
    set ttimeoutlen=10    " small timeout for key sequences since these will be normally scripted
    set termguicolors     " Enable true color.
    set updatetime=100    " How quickly, in ms, updates register
    set splitright        " make vertical splits open to the right
    set splitbelow        " make splits open below the current buffer
    set nofixendofline

    set autoread
    au FocusGained * :checktime
endfunction


" File type settings
function! VimrcLoadFiletypeSettings()
    augroup filetype_settings
        au!
        au BufNewFile,BufRead * setl noincsearch
        au FileType vim setl foldmethod=marker
        au BufNewFile,BufRead $MYVIMRC setl filetype=vim
        au VimResized * :wincmd =

        " Add in the sane file types for certain extensions
        au BufNewFile,BufFilePre,BufRead *.md setl filetype=markdown.pandoc
        au BufWrite *.md silent !touch /tmp/bufwrite

        au BufNewFile,BufRead $ZDOTDIR/functions/**/* setl filetype=zsh
        au BufNewFile,BufRead $ZDOTDIR/completion-functions/* setl filetype=zsh
        au BufNewFile,BufRead $ZDOTDIR/plugins/**/functions/* setl filetype=zsh
        au BufNewFile,BufRead httpd setl filetype=apache
        " au FileType sh,bash,zsh setl noexpandtab

        " Python
        au FileType python
                    \   setl softtabstop=2
                    \ | setl shiftwidth=2
                    \ | setl textwidth=79
        command! DocTest !python -m doctest %

        " Mail
        au FileType mail
                    \   setl foldmethod=indent
                    \ | setl spell
                    \ | setl spelllang=en
                    " \ | setl tw=72
                    \ | setl fo+=w

        " Conceal stuff is in nvim/after/syntax/haskell.vim
        au FileType haskell map = <Plug>(operator-neoformat)

        au Filetype pandoc setl nowrap
        " Improve syntax hl accuracy. Larger = more accuracy = slower
        " au BufEnter * :syntax sync fromstart
        au BufEnter * :syntax sync minlines=500
        au VimResized * :redraw!
    augroup END

    " Web Dev
    autocmd BufNewFile,BufRead *.html setl ft=html
    " au FileType javascript,php,css,html,gohtmltmpl imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

    " Dev Ops
    autocmd BufNewFile,BufRead *.stack setl ft=yaml
    autocmd BufNewFile,BufRead *.docker,*.dockerfile setl ft=Dockerfile

    let g:LargeFile = 1024 * 1024 * 1
    augroup LargeFile
        autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
    augroup END

    function LargeFile()
        " no syntax highlighting etc
        setlocal eventignore+=FileType
        " save memory when other file is viewed
        setlocal bufhidden=unload
        " no undo possible
        setlocal undolevels=-1
        " display message
        autocmd VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."
    endfunction
endfunction

" Colors
function! VimrcLoadColors()
    set background=dark
    let g:gruvbox_bold             = 1
    let g:gruvbox_italic           = 1
    let g:gruvbox_invert_selection = 0
    " This will only work if the terminal supports italic escape sequences
    highlight! Comment gui=italic
    colorscheme gruvbox
endfunction

" Initialization
call VimrcLoadPlugins()
call VimrcLoadPluginSettings()
call VimrcLoadMappings()
call VimrcLoadSettings()
call VimrcLoadFiletypeSettings()
call VimrcLoadColors()
