function! VimrcLoadPlugins()
    " Install vim-plug if not available
    if &runtimepath !~# '/plug.vim'
        let s:plug_dir = expand('~/.local/share/nvim/site/autoload/plug.vim')
        if empty(glob(s:plug_dir))
            let s:plug_upstream = 'https://raw.githubusercontent.com/'
                        \ .  'junegunn/vim-plug/master/plug.vim'
            call system('curl -fLo '
                        \. shellescape(s:plug_dir) 
                        \ . ' --create-dirs ' . shellescape(s:plug_upstream))
            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif

        execute 'set runtimepath^=' . s:plug_dir
    endif

    call plug#begin('~/.local/share/nvim/plugged')
    " Linting + LSP
    Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
    Plug 'Shougo/neco-syntax'
    Plug 'wellle/tmux-complete.vim'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'w0rp/ale'

    " Enhancements: TODO, split into improvements, vimlike, and additions
    Plug 'airblade/vim-gitgutter'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'dhruvasagar/vim-table-mode'
    Plug 'ervandew/supertab'
    Plug 'farmergreg/vim-lastplace'
    Plug 'haya14busa/incsearch.vim'
    Plug 'haya14busa/incsearch-fuzzy.vim'
    Plug 'haya14busa/vim-asterisk'
    Plug 'jiangmiao/auto-pairs'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
    Plug 'junegunn/vim-easy-align'
    Plug 'kana/vim-operator-user'
    Plug 'matze/vim-move'
    Plug 'sbdchd/neoformat'
    Plug 'sickill/vim-pasta' " Smarter pasting with indention
    Plug 'tmux-plugins/vim-tmux'
    Plug 'tommcdo/vim-exchange'
    Plug 'tpope/vim-commentary'
    " Look into caw and https://github.com/Shougo/shougo-s-github/tree/master/vim/rc
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'triglav/vim-visual-increment'
    Plug 'wellle/targets.vim'
    Plug 'kassio/neoterm'
    Plug 'phpactor/phpactor', {'for': 'php', 'do': 'composer install'}

    Plug 'andymass/vim-matchup'
    Plug 'tpope/vim-endwise'
    Plug 'machakann/vim-highlightedyank'

    Plug 'dkasak/gruvbox' " Gruvbox with better haskell highlighting

    Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}
    Plug 'AndrewRadev/splitjoin.vim'

    " Languages
    Plug 'mattn/emmet-vim', { 'for': [ 'javascript.jsx', 'javascript', 'php', 'css', 'scss', 'html']}
    Plug 'sheerun/vim-polyglot'
    Plug 'StanAngeloff/php.vim', {'for': 'php'}
    Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'scss']}
    Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile' }
    Plug 'othree/yajs.vim', { 'for': ['javascript', 'javascript.jsx', 'typescript','typescript.tsx'] }
    Plug 'othree/es.next.syntax.vim', { 'for': ['javascript', 'javascript.jsx', 'typescript','typescript.tsx'] }
    Plug 'maxmellon/vim-jsx-pretty', { 'for': ['javascript', 'javascript.jsx', 'typescript','typescript.tsx'] }
    Plug 'Quramy/vim-js-pretty-template', { 'for': ['javascript', 'javascript.jsx', 'typescript','typescript.tsx'] }
    Plug 'leafgarland/typescript-vim', { 'for': ['typescript','typescript.tsx'] }
    Plug 'styled-components/vim-styled-components',{ 'branch': 'main' }
    Plug 'ap/vim-css-color', { 'for': ['css', 'scss', 'html', 'php', 'javascript', 'javascript.jsx'] }
    Plug 'vim-pandoc/vim-pandoc-syntax', { 'for': ['markdown.pandoc'] }
    Plug 'vim-pandoc/vim-pandoc', { 'for': ['markdown.pandoc'] }
    call plug#end()

    autocmd VimEnter *
                \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
                \|   PlugInstall --sync | q
                \| endif
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

    set hidden " Required for rename
    nmap <silent> gd <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-rename)
    nmap <silent> gs <Plug>(coc-definition)
    nmap <silent> <leader>f <Plug>(coc-format)
    nmap <silent> gR <Plug>(coc-references)
    nmap <silent> gh :call CocAction('doHover')<CR>
    nmap <silent> ga <Plug>(coc-codeaction)
    nmap <silent> <C-n> <Plug>(coc-diagnostic-next)
    nmap <silent> <C-p> <Plug>(coc-diagnostic-prev)

    " Show signature help while editing
    autocmd CursorHoldI * silent! call CocActionAsync('showSignatureHelp')

    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " supertab
    let g:SuperTabDefaultCompletionType = "<c-n>"

    " endwise + supertab chain/workaround
    let g:endwise_no_mappings = 1
    imap <C-X><CR>   <CR><Plug>AlwaysEnd
    imap <expr> <CR> (pumvisible() ? "\<C-Y>\<CR>\<Plug>DiscretionaryEnd" : "\<CR>\<Plug>DiscretionaryEnd")

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

    autocmd FileType html,php,scss,css,javascript,javascript.jsx,typescript,typescript.tsx EmmetInstall

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
    let g:polygot_disabled = ['Dockerfile', 'markdown', 'graphql', 'javascript.jsx', 'typescript.tsx', 'typescript', 'css']
    let g:haskell_enable_quantification = 1
    let g:haskell_enable_pattern_synonyms = 1
    let g:haskell_indent_disable = 1
    let g:haskell_enable_typeroles = 1
    let g:php_html_load = 0

    "phpactor
    let g:phpactorBranch = "develop"
    autocmd BufEnter php setlocal omnifunc=phpactor#Complete

    " vim web stuff
    autocmd FileType javascript JsPreTmpl html
    autocmd FileType typescript JsPreTmpl html
    autocmd FileType typescript syn clear foldBraces

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

    " vim-gutter
    let g:gitgutter_map_keys = 0

    " vim-ghost
    autocmd BufNewFile,BufRead *ghost* setl ft=html

    " vim-gutentags
    let g:gutentags_cache_dir = '~/.cache/gutentags'
    let g:gutentags_ctags_exclude = ['*.css', '*.html', '*.js', '*.json', '*.xml',
                \ '*.phar', '*.ini', '*.rst', '*.md',
                \ '*vendor/*/test*', '*vendor/*/Test*',
                \ '*vendor/*/fixture*', '*vendor/*/Fixture*',
                \ '*var/cache*', '*var/log*']

    " highlightedyank
    let g:highlightedyank_highlight_duration = 125
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
        au BufNewFile,BufFilePre,BufRead *.md setl nowrap
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

    " Dev Ops
    autocmd BufNewFile,BufRead *.stack setl ft=yaml
    autocmd BufNewFile,BufRead *.docker,*.dockerfile setl ft=Dockerfile
    autocmd BufNewFile,BufRead *docker-compose.* setl ft=json

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
