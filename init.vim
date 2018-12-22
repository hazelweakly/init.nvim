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
    Plug 'Shougo/neco-syntax'
    Plug 'Shougo/neco-vim'
    Plug 'neoclide/coc-neco'
    Plug 'neoclide/coc.nvim', {'do': 'yarn install'}
    Plug 'neoclide/jsonc.vim'
    " Plug 'wellle/tmux-complete.vim'
    Plug 'w0rp/ale'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'skywind3000/gutentags_plus'

    " Enhancements: TODO, split into improvements, vimlike, and additions
    Plug 'airblade/vim-gitgutter'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'dhruvasagar/vim-table-mode'
    Plug 'farmergreg/vim-lastplace'
    Plug 'jiangmiao/auto-pairs'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
    Plug 'junegunn/vim-easy-align'
    Plug 'kana/vim-textobj-user'
    Plug 'kana/vim-operator-user'
    Plug 'idbrii/textobj-word-column.vim'
    Plug 'tmux-plugins/vim-tmux'
    Plug 'tommcdo/vim-exchange'
    Plug 'tpope/vim-commentary'
    " Plug 'tomtom/tcomment_vim'
    " Look into caw
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'wellle/targets.vim'
    Plug 'kassio/neoterm'
    Plug 'markonm/traces.vim'
    Plug 'phpactor/phpactor', {'for': 'php', 'do': 'composer install'}
    Plug 'Raimondi/yaifa'
    Plug 'chaoren/vim-wordmotion'
    Plug 'tpope/vim-rsi'
    Plug 'google/vim-searchindex'

    Plug 'andymass/vim-matchup'
    Plug 'machakann/vim-highlightedyank'

    Plug 'dkasak/gruvbox' " Gruvbox with better haskell highlighting

    Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}

    " Languages
    Plug 'sheerun/vim-polyglot'
    " Plug 'mattn/emmet-vim'
    Plug 'othree/yajs.vim'
    Plug 'HerringtonDarkholme/yats.vim'
    Plug 'peitalin/vim-jsx-typescript'
    Plug 'othree/es.next.syntax.vim'
    Plug 'StanAngeloff/php.vim'
    Plug 'ekalinin/Dockerfile.vim'
    Plug 'hail2u/vim-css3-syntax'
    Plug 'styled-components/vim-styled-components', {'branch': 'main' }
    Plug 'ap/vim-css-color'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'vim-pandoc/vim-pandoc'
    Plug 'leafgarland/typescript-vim'
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

    " ale
    autocmd FileType html,scss,css,javascript,javascript.jsx,typescript,typescript.tsx ALEDisableBuffer

    " commentary.vim
    autocmd FileType jsonc,php setlocal commentstring=//\ %s

    " coc.nvim
    function! s:show_documentation()
        if &filetype == 'vim'
            execute 'h '.expand('<cword>')
        else
            call CocAction('doHover')
        endif
    endfunction

    call coc#add_extension('coc-css', 'coc-emmet', 'coc-eslint', 'coc-highlight',
                \ 'coc-html', 'coc-json', 'coc-omni', 'coc-prettier',
                \ 'coc-stylelint', 'coc-tag', 'coc-tslint', 'coc-tsserver',
                \ 'coc-yaml')

    " yarn global add eslint eslint-plugin-react eslint-plugin-import eslint-plugin-node prettier prettier-eslint eslint-plugin-babel eslint-plugin-jquery stylelint stylelint dockerfile-language-server-nodejs bash-language-server
    nmap <silent> gd <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-rename)
    nmap <silent> gs <Plug>(coc-definition)
    nmap <silent> <leader>f <Plug>(coc-format)
    vmap <silent> <leader>f <Plug>(coc-format-selected)
    nmap <silent> gR <Plug>(coc-references)
    nmap <silent> gh :call <SID>show_documentation()<CR>
    nmap <silent> ga <Plug>(coc-codeaction)
    nmap <silent> <C-n> <Plug>(coc-diagnostic-next)
    nmap <silent> <C-p> <Plug>(coc-diagnostic-prev)

    let g:coc_snippet_next = '<TAB>'
    let g:coc_snippet_prev = '<S-TAB>'

    autocmd BufNewFile,BufRead coc-settings.json,*eslintrc*.json setl ft=jsonc

    " Show signature help while editing
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call CocActionAsync('highlight')

    let g:coc_filetype_map = {
                \ '*ghost*': 'html'
                \ }

    " use <tab> for trigger completion and navigate next complete item
    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~ '\s'
    endfunction

    inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ coc#refresh()

    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    " Use <c-space> for trigger completion.
    inoremap <silent><expr> <c-space> coc#refresh()

    " Use <cr> for confirm completion.
    " Coc only does snippet and additional edit on confirm.
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

    " " emmet.vim
    " let g:user_emmet_expandabbr_key = '<c-e>'
    " let g:use_emmet_complete_tag = 1
    " let g:user_emmet_install_global = 0

    " let g:user_emmet_settings = {
    "             \  'javascript.jsx' : {
    "             \      'extends' : 'jsx',
    "             \  },
    "             \  'javascript' : {
    "             \      'extends' : 'jsx',
    "             \  },
    "             \}

    " autocmd FileType html,php,scss,css,javascript,javascript.jsx,typescript,typescript.tsx EmmetInstall

    " " tmux-complete.vim
    " let g:tmuxcomplete#trigger = ''
    " let g:tmuxcomplete#asyncomplete_source_options = {
    "             \ 'name':      'tmux',
    "             \ 'whitelist': ['*'],
    "             \ 'priority': -1,
    "             \ 'config': {
    "             \     'splitmode':      'words',
    "             \     'filter_prefix':   0,
    "             \     'show_incomplete': 1,
    "             \     'sort_candidates': 0,
    "             \     'scrollback':      0,
    "             \     'truncate':        0
    "             \     }
    "             \ }

    " vim-pandoc
    let g:pandoc#modules#disabled = ["folding"]
    let g:pandoc#completion#bib#mode = "citeproc"
    let g:pandoc#formatting#equalprg=''

    " vim-polygot
    let g:polygot_disabled = ['Dockerfile', 'markdown', 'graphql', 'javascript.jsx', 'typescript.tsx', 'typescript', 'css', 'javascript', 'jsx', 'tsx']
    let g:haskell_enable_quantification = 1
    let g:haskell_enable_pattern_synonyms = 1
    let g:haskell_indent_disable = 1
    let g:haskell_enable_typeroles = 1
    let g:php_html_load = 0

    "phpactor
    let g:phpactorBranch = "develop"
    autocmd BufEnter php setlocal omnifunc=phpactor#Complete

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

    " vim-gutter
    let g:gitgutter_map_keys = 0

    " vim-ghost
    autocmd BufNewFile,BufRead *ghost* setl ft=html

    " highlightedyank
    let g:highlightedyank_highlight_duration = 125

    " gutentags
    let g:gutentags_file_list_command = 'rg -l'

    " config project root markers.
    let g:gutentags_project_root = ['.git', '.idea', 'Makefile']

    " generate datebases in my cache directory, prevent gtags files polluting my project
    let g:gutentags_cache_dir = expand('~/.cache/tags')
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

    nnoremap <C-j> :m .+1<CR>==
    nnoremap <C-k> :m .-2<CR>==
    inoremap <C-j> <Esc>:m .+1<CR>==gi
    inoremap <C-k> <Esc>:m .-2<CR>==gi
    vnoremap <C-j> :m '>+1<CR>gv=gv
    vnoremap <C-k> :m '<-2<CR>gv=gv
endfunction


" Settings

function! VimrcLoadSettings()
    set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
    set hidden " Required for coc.nvim
    set completeopt=menu,menuone,noinsert
    set nrformats=bin,hex,octal,alpha
    set breakindent
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

    set synmaxcol=2000     " maximum length to apply syntax highlighting
    set timeout           " enable timeout of key codes and mappings(the default)
    set ttimeout          " enable timeout of key codes and mappings(the default)
    set timeoutlen=3000   " big timeout for key sequences
    set ttimeoutlen=10    " small timeout for key sequences since these will be normally scripted
    set termguicolors     " Enable true color.
    set updatetime=200    " How quickly, in ms, updates register
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
        au BufNewFile,BufRead * setl incsearch
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

        au Filetype pandoc setl nowrap

        " Improve syntax hl accuracy. Larger = more accuracy = slower
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
