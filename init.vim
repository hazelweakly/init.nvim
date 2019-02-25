" Speed improvements
let g:node_host_prog = '/usr/local/bin/neovim-node-host'
let g:ruby_host_prog = '/usr/local/bin/neovim-ruby-host'
let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python2'

" TODO: Apply this and filtch some ideas.
" https://vimways.org/2018/from-vimrc-to-vim/
" https://github.com/rafi/vim-config
" https://github.com/PegasusWang/vim-config

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
    Plug 'neoclide/coc-sources'
    Plug 'w0rp/ale'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'skywind3000/gutentags_plus'

    " Enhancements: TODO, split into improvements, vimlike, and additions
    Plug 'lambdalisue/suda.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'dhruvasagar/vim-table-mode'
    Plug 'farmergreg/vim-lastplace'
    " Plug 'jiangmiao/auto-pairs'
    Plug 'tmsvg/pear-tree'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
    Plug 'junegunn/vim-easy-align'
    Plug 'kana/vim-textobj-user'
    Plug 'kana/vim-operator-user'
    Plug 'idbrii/textobj-word-column.vim'
    Plug 'tmux-plugins/vim-tmux'
    Plug 'tommcdo/vim-exchange'
    Plug 'tpope/vim-commentary'
    Plug 'sickill/vim-pasta'
    Plug '907th/vim-auto-save'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'unblevable/quick-scope'
    Plug 'mattn/emmet-vim'
    " For coworker's sanity
    Plug 'mg979/vim-visual-multi', {'branch': 'test'}
    Plug 'tpope/vim-rsi'

    " Because I don't have a tiling WM at work
    Plug 'kassio/neoterm'

    " Look into caw (comment), vim-sandwich, sideways.vim
    Plug 'tpope/vim-repeat'
    " Plug 'tpope/vim-surround'
    Plug 'machakann/vim-sandwich'
    Plug 'wellle/targets.vim'
    Plug 'chaoren/vim-wordmotion'
    Plug 'romainl/vim-cool'

    Plug 'andymass/vim-matchup'
    Plug 'machakann/vim-highlightedyank'

    Plug 'dkasak/gruvbox' " Gruvbox with better haskell highlighting

    Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}

    " Languages
    Plug 'jonsmithers/vim-html-template-literals'
    Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
    Plug 'sheerun/vim-polyglot', {'do': './build'}
    Plug 'neoclide/jsonc.vim'
    " Plug 'neoclide/vim-jsx-improve'
    " Plug 'othree/yajs.vim'
    Plug 'maxmellon/vim-jsx-pretty'
    Plug 'HerringtonDarkholme/yats.vim'
    Plug 'hail2u/vim-css3-syntax'
    Plug 'cakebaker/scss-syntax.vim'
    Plug 'vim-pandoc/vim-pandoc'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    call plug#end()
    runtime macros/sandwich/keymap/surround.vim

    autocmd VimEnter *
                \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
                \|   PlugInstall --sync | q
                \| endif
endfunction

function! VimrcLoadPluginSettings()
    " quick-scope
    let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

    " vim-cool
    let g:CoolTotalMatches = 1

    " neoterm
    tnoremap <Esc> <C-\><C-n>
    nnoremap <silent> <F12> :botright Ttoggle<CR>
    let g:neoterm_autoinsert = 1
    let g:neoterm_size = 12

    " emmet-vim
    let g:user_emmet_settings = { 'html': { 'empty_element_suffix': ' />' } }
    let g:emmet_html5 = 1
    let g:user_emmet_install_global = 0
    autocmd FileType html,scss,css,javascript,javascript.jsx,typescript,typescript.tsx,php EmmetInstall
    autocmd FileType html,scss,css,javascript,javascript.jsx,typescript,typescript.tsx,php imap <C-e> <plug>(emmet-expand-abbr)
    autocmd FileType html,scss,css,javascript,javascript.jsx,typescript,typescript.tsx,php imap <M-n> <plug>(emmet-move-next)
    autocmd FileType html,scss,css,javascript,javascript.jsx,typescript,typescript.tsx,php imap <M-p> <plug>(emmet-move-prev)

    " machup
    let g:loaded_matchit = 1
    let g:matchup_transmute_enabled = 1
    let g:matchup_surround_enabled = 1
    let g:matchup_matchparen_deferred = 1
    let g:matchup_matchparen_status_offscreen = 0

    " ale
    let g:ale_sh_shellcheck_options = '-x'
    autocmd FileType html,scss,css,javascript,javascript.jsx,typescript,typescript.tsx ALEDisableBuffer
    hi link ALEError Error
    hi Warning term=underline cterm=underline ctermfg=Yellow gui=undercurl guisp=Gold
    hi link ALEWarning Warning
    hi link ALEInfo SpellCap
    let g:ale_set_signs = 0
    let g:ale_lint_delay = 0
    let g:ale_lint_on_text_changed = 'normal'
    let g:ale_lint_on_insert_leave = 1

    " commentary.vim
    augroup commentary
        au!
        au FileType jsonc,php setl commentstring=//\ %s
        au FileType resolv setl commentstring=#\ %s
        au FileType scss setl commentstring=/*\ %s\ */
    augroup END

    " " auto-pairs
    " let g:AutoPairsShortcutFastWrap = ''
    " let g:AutoPairsShortcutToggle = ''
    " let g:AutoPairsShortcutFastWrap = ''
    " let g:AutoPairsShortcutJump = ''
    " let g:AutoPairsShortcutBackInsert = ''
    " let g:AutoPairsCenterLine = 0
    " let g:AutoPairsMultilineClose = 0

    " pear-tree
    let g:pear_tree_smart_openers = 1
    let g:pear_tree_smart_closers = 1
    let g:pear_tree_smart_backspace = 1

    " jsx_improve
    let g:jsx_improve_motion_disable = 1

    " coc.nvim
    function! s:show_documentation()
        if &filetype == 'vim' || &filetype == 'help'
            execute 'h '.expand('<cword>')
        else
            call CocAction('doHover')
        endif
    endfunction

    call coc#add_extension('coc-css', 'coc-highlight',
                \ 'coc-html', 'coc-json', 'coc-omni', 'coc-prettier',
                \ 'coc-tag', 'coc-tslint', 'coc-tsserver', 'coc-rls',
                \ 'coc-yaml', 'coc-dictionary', 'coc-phpls', 'coc-vimtex')

    " yarn global add eslint eslint-plugin-react eslint-plugin-import eslint-plugin-node prettier prettier-eslint eslint-plugin-babel eslint-plugin-jquery stylelint stylelint dockerfile-language-server-nodejs bash-language-server
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gr <Plug>(coc-rename)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> <leader>f <Plug>(coc-format)
    vmap <silent> <leader>f <Plug>(coc-format-selected)
    nmap <silent> gR <Plug>(coc-references)
    nmap <silent> gh :call <SID>show_documentation()<CR>
    nmap <silent> ga <Plug>(coc-codeaction)
    nmap <silent> gA <Plug>(coc-fix-current)
    nmap <silent> <C-n> <Plug>(coc-diagnostic-next)
    nmap <silent> <C-p> <Plug>(coc-diagnostic-prev)

    let g:coc_snippet_next = '<M-n>'
    let g:coc_snippet_prev = '<M-p>'

    augroup coc
        au!
        au CompleteDone * if pumvisible() == 0 | pclose | endif
        au BufNewFile,BufRead coc-settings.json,*eslintrc*.json setl ft=jsonc
        au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        au CursorHoldI,CursorMovedI call CocActionAsync('showSignatureHelp')
        au CursorHold * silent call CocActionAsync('highlight')
    augroup END

    let g:coc_filetype_map = {
                \ 'ghost-*': 'html',
                \ 'javascript.jsx': 'javascriptreact',
                \ 'typescript.tsx' : 'typescriptreact'
                \ }

    inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "\<Tab>"
    inoremap <expr> <S-Tab> "\<C-h>"

    " vim-pandoc
    let g:pandoc#modules#disabled = ["folding", "formatting", "keyboard", "toc", "chdir"]
    let g:pandoc#completion#bib#mode = "citeproc"
    let g:pandoc#formatting#equalprg=''

    " vim-polygot
    let g:polygot_disabled = ['markdown']
    let g:haskell_enable_quantification = 1
    let g:haskell_enable_pattern_synonyms = 1
    let g:haskell_indent_disable = 1
    let g:haskell_enable_typeroles = 1
    let g:php_html_load = 1

    " vim-jsx-pretty
    let g:vim_jsx_pretty_colorful_config = 1

    " vim-table-mode
    let g:table_mode_motion_up_map = ''
    let g:table_mode_motion_down_map = ''
    let g:table_mode_motion_left_map = ''
    let g:table_mode_motion_right_map = ''

    " fzf
    augroup fzf
        au!
        autocmd FileType fzf set laststatus=0 noshowmode noruler
                    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
    augroup END

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

    " vim-auto-save
    let g:auto_save = 1
    let g:auto_save_events = ["FocusLost"]

    " vim-gutter
    let g:gitgutter_map_keys = 0

    " vim-ghost
    augroup ghost
        au!
        autocmd BufNewFile,BufRead ghost-* setl ft=html
    augroup END
    nnoremap <leader>g :GhostStart<CR>

    " highlightedyank
    let g:highlightedyank_highlight_duration = 125

    " gutentags
    let g:gutentags_file_list_command = 'rg -l'

    " config project root markers.
    let g:gutentags_project_root = ['.git', '.idea', 'Makefile']

    " generate datebases in my cache directory, prevent gtags files polluting my project
    let g:gutentags_cache_dir = expand('~/.cache/tags')

    " vim-better-whitespace
    let g:better_whitespace_enabled=1

    " vim-visual-multi (excessive maps by default are annoying)
    " as close as realistically possible to phpstorm mappings
    let g:VM_default_mappings = 0
    let g:VM_maps = {}
    let g:VM_maps['Find Under']         = ''
    let g:VM_maps['Find Subword Under'] = '<M-j>'
    let g:VM_maps["Find Next"]          = '<M-j>'
    let g:VM_maps["Find Prev"]          = '<M-J>'
    let g:VM_maps["Skip Region"]        = '<M-F3>'
    let g:VM_maps["Visual Subtract"]    = '<M-F3>'


    " sandwich.vim
    let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
    let g:sandwich#recipes += [
                \   {'buns': ['{ ', ' }'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['{']},
                \   {'buns': ['[ ', ' ]'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['[']},
                \   {'buns': ['( ', ' )'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['(']},
                \   {'buns': ['<?= ', ' ?>'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['-']},
                \   {'buns': ['{\s*', '\s*}'],   'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['{']},
                \   {'buns': ['\[\s*', '\s*\]'], 'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['[']},
                \   {'buns': ['(\s*', '\s*)'],   'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['(']},
                \   {'buns': ['<\?=\s*', '\s*\?>)'],   'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['-']},
                \ ]

    " surround.vim
    " augroup surround
    "     au!
    "     au FileType php let b:surround_45 = "<?php \r ?>"
    "     au FileType php let b:surround_61 = "<?= \r ?>"
    "     au FileType html,scss,css,javascript,javascript.jsx,typescript,typescript.tsx,php let b:surround_{char2nr("p")} = "<p>\n\t\r\n</p>"
    "     au FileType html,scss,css,javascript,javascript.jsx,typescript,typescript.tsx,php let b:surround_{char2nr("d")} = "<div\1div: \r^[^ ]\r &\1>\n\t\r\n</div>"
    "     au FileType html,scss,css,javascript,javascript.jsx,typescript,typescript.tsx,php let b:surround_{char2nr("u")} = "x \r x"
    " augroup END
endfunction

function! VimrcLoadMappings()
    " General thoughts: Operator + non-motion is an 'invalid operation' in vim
    "                   oprator + second operator is also 'invalid'
    "                   With those in mind, there are lots of empty binds in
    "                   vim available

    nnoremap <silent> <leader>s :noh<CR>

    " paste over a visual selection without nuking your paste
    function! RestoreRegister()
        if &clipboard != "unnamed" && &clipboard != "unnamedplus"
            let @" = s:restore_reg
        elseif &clipboard == "unnamed"
            let @* = s:restore_reg
        elseif &clipboard == "unnamedplus"
            let @+ = s:restore_reg
        endif
        return ''
    endfunction

    function! s:Repl()
        if &clipboard != "unnamed" && &clipboard != "unnamedplus"
            let s:restore_reg = @"
        elseif &clipboard == "unnamed"
            let s:restore_reg = @*
        elseif &clipboard == "unnamedplus"
            let s:restore_reg = @+
        endif
        return "p@=RestoreRegister()\<cr>"
    endfunction

    xnoremap <silent> <expr> p <sid>Repl()

    " BC calc from current line
    map <leader>c :.!bc<CR>
    "Insert new lines in normal mode
    nnoremap <silent> go :pu _<CR>:'[-1<CR>
    nnoremap <silent> gO :pu! _<CR>:']+1<CR>
    " J is 'join' so K is 'kut'
    nnoremap K i<CR><ESC>
    nnoremap Y y$

    " suda.vim: Write file with sudo
    command! W :w suda://%

    " Replace cursor under word. Pressing . will move to next match and repeat
    nnoremap c* /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgn
    nnoremap c# ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgN
    " Delete cursor under word. Pressing . will move to next match and repeat
    nnoremap d* /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``dgn
    nnoremap d# ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>``dgN

    " Search for current selection when pressing * or # in visual mode
    xnoremap <silent> * :call <SID>visualSearch('f')<CR>
    xnoremap <silent> # :call <SID>visualSearch('b')<CR>

    function!   s:visualSearch(direction)
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
    xnoremap <C-j> :m '>+1<CR>gv=gv
    xnoremap <C-k> :m '<-2<CR>gv=gv

    nnoremap Q <Nop>

    xnoremap < <gv
    xnoremap > >gv
endfunction

function! VimrcLoadSettings()
    set inccommand=nosplit
    set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
    set hidden " Required for coc.nvim
    set complete+=k
    set completeopt=menu,menuone,noinsert
    set nrformats=bin,hex,octal,alpha
    set breakindent
    set backspace=indent,eol,start
    set clipboard=unnamedplus
    set backup
    set undofile
    set lazyredraw
    set virtualedit=block
    set mouse=
    set dir=~/.config/nvim/backup//
    set undodir=~/.config/nvim/backup//
    set backupdir=~/.config/nvim/backup//
    set noerrorbells visualbell t_vb=
    set list
    set listchars=tab:▸\ ,extends:❯,precedes:❮,eol:¬,trail:⌴
    set showbreak=↪\ \ 
    set fillchars=diff:⣿,vert:│,fold:\
    set showcmd
    set cmdheight=1
    set scrolloff=2
    set sidescrolloff=2
    set number
    set shortmess+=caI

    set expandtab
    set softtabstop=2
    set shiftwidth=2
    set ignorecase
    set smartcase
    set hlsearch
    set noshowmatch
    set nowrap
    set nofoldenable

    set synmaxcol=250
    set timeout
    set ttimeout
    set timeoutlen=3000
    set ttimeoutlen=10
    set termguicolors
    set updatetime=100
    set splitright
    set splitbelow
    set nofixendofline

    set autoread
    augroup vimrc_settings
        au!
        au FocusGained * :checktime
        au BufWritePost $MYVIMRC nested source $MYVIMRC
    augroup END
endfunction

function! VimrcLoadFiletypeSettings()
    augroup filetype_settings
        au!
        au BufNewFile,BufRead * setl incsearch
        au FileType vim setl foldmethod=marker
        au BufNewFile,BufRead $MYVIMRC setl filetype=vim
        au VimResized * :wincmd =

        au BufNewFile,BufRead $ZDOTDIR/functions/**/* setl filetype=zsh
        au BufNewFile,BufRead $ZDOTDIR/completion-functions/* setl filetype=zsh
        au BufNewFile,BufRead $ZDOTDIR/plugins/**/functions/* setl filetype=zsh
        au BufNewFile,BufRead httpd setl filetype=apache

        " Improve syntax hl accuracy. Larger = more accuracy = slower
        au BufEnter * :syntax sync minlines=500
        au VimResized * :redraw!

        " Dev Ops
        au BufNewFile,BufRead *.stack setl ft=yaml
        au BufNewFile,BufRead *docker-compose.* setl ft=json
        au BufNewFile,BufRead *.css setl syntax=scss
        au BufNewFile,BufRead *.tex setl ft=tex
        au FileType scss,html,css setl iskeyword+=-

        au FileType php setl iskeyword+=$

        au FileType sql nmap <silent> <leader>f :%! sqlformat -i=lower -k=upper -r -<CR>
    augroup END

    let g:LargeFile = 1024 * 1024 * 1
    augroup LargeFile
        au!
        au BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
    augroup END

    function! LargeFile()
        setlocal eventignore+=FileType
        setlocal bufhidden=unload
        setlocal undolevels=-1
        autocmd VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."
    endfunction
endfunction

function! VimrcLoadColors()
    set background=dark
    let g:gruvbox_bold             = 1
    let g:gruvbox_italic           = 1
    let g:gruvbox_invert_selection = 0
    " This will only work if the terminal supports italic escape sequences
    highlight! Comment gui=italic
    colorscheme gruvbox
endfunction

call VimrcLoadPlugins()
call VimrcLoadPluginSettings()
call VimrcLoadMappings()
call VimrcLoadSettings()
call VimrcLoadFiletypeSettings()
call VimrcLoadColors()
