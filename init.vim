" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

" debugovani aplikaci
" pip install neovim
" download lombok
" sudo mkdir /usr/local/share/lombok
" sudo wget https://projectlombok.org/downloads/lombok.jar -O /usr/local/share/lombok/lombok.jar
"
    Plug 'puremourning/vimspector'
" neovim plugin (dointalovat coc-java coc-explorer coc-java-debug, coc-java-vimspector)
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
" fuzzy finder
" apt install fzf silversearcher-ag
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
" automaticke ukoncovani zavorek
    Plug 'jiangmiao/auto-pairs'
" plugin pro swapovani oken
    Plug 'wesQ3/vim-windowswap'
" plugin pro vytvareni tabulek
    Plug 'dhruvasagar/vim-table-mode'
" dashboard
" je potreba vytvorit touch ~/.config/nvim/plug-config/start-screen.vim
    Plug 'mhinz/vim-startify'
" treesitter - pro barvicky v codu
    " Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'uiiaoo/java-syntax.vim'

call plug#end()

set number
set relativenumber
set nowrap
set mouse=
source ~/.config/nvim/java_getset.vim

" explorer na space+e
nnoremap <space>e :CocCommand explorer<CR>
nnoremap <C-e> :tabn<CR>
nnoremap <S-e> :tabp<CR>
"
" completition na tab
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<TAB>"

" zmena barev v assistantu
hi Pmenu ctermbg=black ctermfg=white
hi PmenuSel ctermbg=red

" uprava Ag aby nezobrazovala nazvy souboru
com! -bar -bang Ag call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter=: --nth=4..'}, 'right'), <bang>0)

" clear workspace
nmap <silent> <space>c :CocCommand java.clean.workspace<CR>

" compile workspace
nmap <silent> <space>C :CocCommand java.workspace.compile<CR>

" cocAction
nmap <silent> <space>o :CocCommand editor.action.organizeImport<CR>

" run application
nmap <silent> <space>r :CocList mainClassListRun<CR>

" put breakpoint
nmap <silent> <space>b :.call vimspector#ToggleBreakpoint()<CR>

" show all breakpoints
nmap <silent> <space>B :.call vimspector#ListBreakpoints()<CR>

" stop application
nmap <silent> <space>s :VimspectorReset<CR>

" step into
nmap <silent> <F5> :.call vimspector#StepInto()<CR>

" step out
nmap <silent> <F6> :.call vimspector#StepOut()<CR>

" step over
nmap <silent> <F7> :.call vimspector#StepOver()<CR>

" continue
nmap <silent> <F8> :.call vimspector#Continue()<CR>

" show diagnostics
nmap <silent> <space>d :CocList diagnostics<CR>

" hledani podle nazvu souboru
nmap <silent> <space>f :Files<CR>

" hledani textu v souborech
nmap <silent> <space>a :Ag<CR>

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" prikazy pro swapovani oken
let g:windowswap_map_keys = 0 "prevent default bindings
nnoremap <silent> ,yw :call WindowSwap#MarkWindowSwap()<CR>
nnoremap <silent> ,pw :call WindowSwap#DoWindowSwap()<CR>
nnoremap <silent> ,ww :call WindowSwap#EasyWindowSwap()<CR>


nnoremap <silent> <C-k> :resize -5<CR>
nnoremap <silent> <C-j> :resize +5<CR>
nnoremap <silent> <C-h> :vertical resize -5<CR>
nnoremap <silent> <C-l> :vertical resize +5<CR>

highlight link javaIdentifier NONE

" konfigurace dashboardu
let g:startify_lists = [
          \ { 'type': 'commands',  'header': ['   Bookmarks']       },
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ ]
let g:startify_commands = [
	\ { 'i': ['NeovimConfig', 'set title | set titlestring=NeovimConfig | e ~/.config/nvim/init.vim | cd ~/.config/nvim/' ]},
	\ { 'n': ['Notes', 'set title | set titlestring=Notes | e ~/Documents/notes/ | cd ~/Documents/notes/' ]},
	\ ]
let g:startify_session_dir = '~/.config/nvim/session'
let g:startify_session_autoload = 1
let g:startify_session_delete_buffers = 1
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_session_persistence = 1
let g:startify_enable_special = 0
let g:startify_custom_header = [
	\ '    _ __   ___  _____   _(_)_ __ ___  ',
	\ '   | `_ \ / _ \/ _ \ \ / / | `_ ` _ \ ',
	\ '   | | | |  __/ (_) \ V /| | | | | | |',
	\ '   |_| |_|\___|\___/ \_/ |_|_| |_| |_|',
	\]

function! s:buffFiles()
	for i in range(1,1000)
		silent! execute "buffer ".i
	endfor
endfunction

" Set the basic sizes
let g:vimspector_sidebar_width = 80
let g:vimspector_code_minwidth = 40
let g:vimspector_terminal_minwidth = 185

function! s:CustomiseUI()
  " Customise the basic UI...

  " Close the output window
  call win_gotoid( g:vimspector_session_windows.output )
  q
endfunction

function s:SetUpTerminal()
  " Customise the terminal window size/position
  " For some reasons terminal buffers in Neovim have line numbers
  call win_gotoid( g:vimspector_session_windows.terminal )
  set norelativenumber nonumber
endfunction

augroup MyVimspectorUICustomistaion
  autocmd!
  autocmd User VimspectorUICreated call s:CustomiseUI()
  autocmd User VimspectorTerminalOpened call s:SetUpTerminal()
augroup END

let b:javagetset_getterTemplate =
	\ "\n" . 
	\ "%modifiers% %type% %funcname%() {\n" .
	\ "    return %varname%;\n" .
	\ "}"
let b:javagetset_setterTemplate =
	\ "\n" . 
	\ "%modifiers% void %funcname%(%type% %varname%) {\n" .
	\ "    this.%varname% = %varname%;\n" .
	\ "}"

command! -nargs=* BuffFiles let current_dir = expand("%:p:h") | execute "args **/*" | argdo execute "buffer" fnameescape(expand("%")) | update
