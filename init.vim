" speed improvements
let g:node_host_prog = '/usr/local/bin/neovim-node-host'
let g:ruby_host_prog = '/usr/local/bin/neovim-ruby-host'
let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python2'

" TODO: Apply this and filtch some ideas.
" https://vimways.org/2018/from-vimrc-to-vim/
" https://github.com/zSucrilhos/dotfiles

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
    Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
    " Plug 'kizza/actionmenu.nvim'

    " Enhancements: TODO, split into improvements, vimlike, and additions
    Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey','WhichKey!'] }
    Plug 'lambdalisue/suda.vim'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'tmux-plugins/vim-tmux'
    Plug 'dhruvasagar/vim-table-mode'
    Plug 'farmergreg/vim-lastplace'
    " Plug 'tmsvg/pear-tree'
    Plug 'cohama/lexima.vim'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --xdg --no-update-rc' }
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/vim-easy-align'
    " Plug 'sickill/vim-pasta'
    Plug '907th/vim-auto-save'
    Plug 'arp242/jumpy.vim'

    Plug 'tomtom/tcomment_vim'
    Plug 'kana/vim-textobj-user'
    Plug 'kana/vim-operator-user'
    Plug 'idbrii/textobj-word-column.vim'
    Plug 'tommcdo/vim-exchange'
    Plug 'machakann/vim-swap'
    Plug 'nelstrom/vim-visual-star-search'
    Plug 'airblade/vim-rooter'

    " Plug 'liuchengxu/vista.vim'
    Plug 'mg979/vim-visual-multi', {'branch': 'test'}
    " Plug 'tpope/vim-rsi'
    Plug 'dhruvasagar/vim-zoom'
    " Plug 'kassio/neoterm'

    Plug 'tpope/vim-repeat'
    Plug 'machakann/vim-sandwich'
    Plug 'wellle/targets.vim'
    Plug 'romainl/vim-cool'

    Plug 'andymass/vim-matchup'

    Plug 'laggardkernel/vim-one'

    Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}

    " Languages
    Plug 'lervag/vimtex'
    Plug 'hail2u/vim-css3-syntax'
    Plug 'cakebaker/scss-syntax.vim'

    Plug 'vim-pandoc/vim-pandoc'
    Plug 'vim-pandoc/vim-pandoc-syntax'

    Plug 'alvan/vim-closetag'

    Plug 'HerringtonDarkholme/yats.vim'
    Plug 'jxnblk/vim-mdx-js'
    Plug 'styled-components/vim-styled-components', {'branch': 'main'}
    Plug 'sheerun/vim-polyglot'
    call plug#end()
    runtime macros/sandwich/keymap/surround.vim

    autocmd VimEnter *
                \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
                \|   PlugInstall --sync | q
                \| endif
endfunction

function! VimrcLoadPluginSettings()
    " vim-cool
    let g:CoolTotalMatches = 1

    " neoterm
    tnoremap <Esc> <C-\><C-n>
    nnoremap <silent> <F12> :botright Ttoggle<CR>
    let g:neoterm_autoinsert = 1
    let g:neoterm_size = 12

    " machup
    let g:matchup_transmute_enabled = 0
    let g:matchup_text_obj_enabled = 0
    let g:matchup_surround_enabled = 1
    let g:matchup_matchparen_deferred = 1
    let g:matchup_matchparen_status_offscreen = 0
    let g:matchup_delim_stopline = 2500

    " " pear-tree
    " let g:pear_tree_smart_openers = 1
    " let g:pear_tree_smart_closers = 1
    " let g:pear_tree_smart_backspace = 1

    " fzf.vim
    nnoremap <silent> <leader>f :Files<CR>
    nnoremap <silent> <leader>b :Buffers<CR>
    nnoremap <silent> <leader><space> :Rg<CR>
    xnoremap <silent> <leader><space> y:Rg <C-R>"<CR>

    " coc.nvim
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gr <Plug>(coc-rename)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gR <Plug>(coc-references)
    nmap <silent> gh :call CocActionAsync('doHover')<CR>
    nmap <silent> gz <Plug>(coc-refactor)

    nmap <silent> gl <Plug>(coc-codelens-action)
    nmap <silent> ga <Plug>(coc-codeaction)
    " nnoremap <silent> ga :call ActionMenuCodeActions()<CR>
    nmap <silent> gA <Plug>(coc-fix-current)
    nmap <silent> <C-n> <Plug>(coc-diagnostic-next)
    nmap <silent> <C-p> <Plug>(coc-diagnostic-prev)

    " Requires support from language server
    xmap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap if <Plug>(coc-funcobj-i)
    omap af <Plug>(coc-funcobj-a)

    let g:coc_filetype_map = {
                \ 'yaml.docker-compose': 'yaml',
                \ }

    let g:coc_snippet_next = '<M-n>'
    let g:coc_snippet_prev = '<M-p>'

    let g:coc_global_extensions = [
                \ 'coc-css',
                \ 'coc-diagnostic',
                \ 'coc-git',
                \ 'coc-highlight',
                \ 'coc-html',
                \ 'coc-json',
                \ 'coc-phpls',
                \ 'coc-prettier',
                \ 'coc-rls',
                \ 'coc-sh',
                \ 'coc-svg',
                \ 'coc-tslint-plugin',
                \ 'coc-tsserver',
                \ 'coc-vimlsp',
                \ 'coc-vimtex',
                \ 'coc-yaml',
                \ 'coc-xml',
                \ 'coc-emmet'
                \ ]

    if executable('docker-langserver')
        call coc#config('languageserver.docker.enable', v:true)
    endif

    if executable('hie-wrapper')
        call coc#config('languageserver.haskell.enable', v:true)
    endif

    augroup coc
        au!
        au CompleteDone * if pumvisible() == 0 | pclose | endif
        au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        au CursorHold * silent! call CocActionAsync('highlight')
        au User CocQuickfixChange :CocList --normal quickfix
    augroup END

    inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "\<Tab>"
    inoremap <expr> <S-Tab> "\<C-h>"

    nmap <silent> <TAB> <Plug>(coc-range-select)
    xmap <silent> <TAB> <Plug>(coc-range-select)
    xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

    nmap <silent> <leader>c :CocCommand<CR>
    nmap <silent> <leader>lo :<C-u>CocList outline<CR>
    nmap <silent> <leader>ls :<C-u>CocList -I symbols<CR>
    nmap <silent> <leader>ld :<C-u>CocList diagnostics<CR>

    nmap gp <Plug>(coc-git-prevchunk)
    nmap gn <Plug>(coc-git-nextchunk)

    " let s:code_actions = []

    " func! ActionMenuCodeActions() abort
    "     let s:code_actions = CocAction('codeActions')
    "     let l:menu_items = map(copy(s:code_actions), { index, item -> item['title'] })
    "     call actionmenu#open(l:menu_items, 'ActionMenuCodeActionsCallback')
    " endfunc
    "
    " func! ActionMenuCodeActionsCallback(index, item) abort
    "     if a:index >= 0
    "         let l:selected_code_action = s:code_actions[a:index]
    "         let l:response = CocAction('doCodeAction', l:selected_code_action)
    "     endif
    " endfunc

    " targets.vim
    autocmd User targets#mappings#user call targets#mappings#extend({
                \ 'a': {'argument': [{'o': '[({[]', 'c': '[]})]', 's': ','}]}
                \ })

    " plug.nvim
    let g:plug_rebase = 1

    " " vim-gitgutter
    " let g:gitgutter_map_keys = 0
    " let g:gitgutter_diff_args = '-w'
    " let g:gitgutter_grep = 'rg'
    " nmap <silent>gn <Plug>GitGutterNextHunk
    " nmap <silent>gp <Plug>GitGutterPrevHunk

    " vim-pandoc
    let g:pandoc#modules#disabled = ["folding", "formatting", "keyboard", "toc", "chdir"]
    let g:pandoc#completion#bib#mode = "citeproc"
    let g:pandoc#formatting#equalprg=''

    " vim-polyglot
    let g:polyglot_disabled = ['markdown', 'less', 'typescript', 'jsx']
    let g:haskell_enable_quantification = 1
    let g:haskell_enable_pattern_synonyms = 1
    let g:haskell_indent_disable = 1
    let g:haskell_enable_typeroles = 1
    let g:php_html_load = 1
    let g:vim_jsx_pretty_colorful_config = 1
    let g:vim_jsx_pretty_template_tags = []

    " " vim-jsx
    " augroup vim_jsx_pretty
    "     au!
    "     au FileType *.tsx,*.jsx call plug#load('vim-jsx-pretty') | au! vim_jsx_pretty
    " augroup END

    " vim-closetag
    let g:closetag_filenames = '*.html,*.jsx,*.tsx'
    let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.tsx'
    let g:closetag_xhtml_filetypes = 'xhtml,jsx,tsx'
    let g:closetag_regions =  {
                \ 'typescript.tsx': 'jsxRegion,tsxRegion',
                \ 'javascript.jsx': 'jsxRegion',
                \ }

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

    " vim-auto-save
    let g:auto_save = 1
    let g:auto_save_events = ["FocusLost"]

    " highlightedyank
    let g:highlightedyank_highlight_duration = 125

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
    let g:VM_maps["Undo"] = 'u'
    let g:VM_maps["Redo"] = '<C-r>'

    " " sideways.vim
    " nnoremap <silent> <leader><c-h> :SidewaysLeft<cr>
    " nnoremap <silent> <leader><c-l> :SidewaysRight<cr>

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


    " vim-which-key
    nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>

    " vim-swap
    omap i, <Plug>(swap-textobject-i)
    xmap i, <Plug>(swap-textobject-i)
    omap a, <Plug>(swap-textobject-a)
    xmap a, <Plug>(swap-textobject-a)

endfunction

function! VimrcLoadMappings()
    " General thoughts:
    "   Operator + non-motion is an 'invalid operation' in vim
    "   oprator + second operator is also 'invalid'
    "   With those in mind, there are lots of empty binds in
    "   vim available

    nnoremap <silent> <leader>s :noh<CR>

    " paste over a visual selection without nuking your paste
    xnoremap <expr> p Paste()
    xnoremap <expr> P Paste()

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
    xnoremap <silent> * :call VisualSearchCurrentSelection('f')<CR>
    xnoremap <silent> # :call VisualSearchCurrentSelection('b')<CR>

    call operator#user#define('adjust', 'Op_adjust_window_height')
    map _  <Plug>(operator-adjust)

    nnoremap <silent> <C-j> :m .+1<CR>==
    nnoremap <silent> <C-k> :m .-2<CR>==
    inoremap <silent> <C-j> <Esc>:m .+1<CR>==gi
    inoremap <silent> <C-k> <Esc>:m .-2<CR>==gi
    xnoremap <silent> <C-j> :m '>+1<CR>gv=gv
    xnoremap <silent> <C-k> :m '<-2<CR>gv=gv

    nnoremap Q <Nop>

    xnoremap < <gv
    xnoremap > >gv
endfunction

function! VimrcLoadSettings()
    set incsearch
    set nojoinspaces
    set inccommand=nosplit
    set pumblend=15
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
    set shortmess+=caIA
    set formatoptions+=j

    set expandtab
    set softtabstop=4
    set shiftwidth=4
    set ignorecase
    set smartcase
    set hlsearch
    set noshowmatch
    set nowrap
    set nofoldenable

    set redrawtime=10000
    set synmaxcol=200
    set timeout
    set ttimeout
    set timeoutlen=350
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
        au VimResized * :wincmd =
        au BufWritePost $MYVIMRC nested source $MYVIMRC
        au BufEnter * :syntax sync fromstart
        " au VimLeave * set guicursor=a:
    augroup END
endfunction

function! VimrcLoadFiletypeSettings()
    augroup filetype_settings
        au!
        au FileType sql nmap <silent> <leader>f :%! sqlformat -i=lower -k=upper -r -<CR>
    augroup END

    let g:LargeFile = 1024 * 768 * 1
    augroup LargeFile
        au!
        au BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
    augroup END
endfunction

function! VimrcLoadColors()
    colorscheme one
    let g:one_allow_italics = 1
    highlight! Comment gui=italic
    set background=light
endfunction

let g:mapleader = "\<Space>"
call VimrcLoadPlugins()
call VimrcLoadPluginSettings()
call VimrcLoadMappings()
call VimrcLoadSettings()
call VimrcLoadFiletypeSettings()
call VimrcLoadColors()
