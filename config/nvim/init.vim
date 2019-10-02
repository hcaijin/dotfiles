" vimrc configure
let g:mapleader =";"

" help: https://github.com/junegunn/vim-plug
if ! filereadable(expand('~/.local/share/nvim/site/autoload/plug.vim'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent execute '!curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.local/share/nvim/plugged')
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'arcticicestudio/nord-vim'
Plug 'rakr/vim-one'
Plug 'Gabirel/molokai'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'jreybert/vimagit'
Plug 'Chiel92/vim-autoformat'
Plug 'lilydjwg/fcitx.vim'
Plug 'kshenoy/vim-signature'
Plug 'dyng/ctrlsf.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'scrooloose/nerdcommenter'
Plug 'Valloric/YouCompleteMe'
Plug 'SirVer/ultisnips'
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
Plug 'easymotion/vim-easymotion'
Plug 'gcmt/wildfire.vim'
Plug 'fholgado/minibufexpl.vim'
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'
call plug#end()

" 替换函数。参数说明：
" confirm：是否替换前逐一确认
" wholeword：是否整词匹配
" replace：被替换字符串
function! Replace(confirm, wholeword, replace)
    wa
    let flag = ''
    if a:confirm
        let flag .= 'gec'
    else
        let flag .= 'ge'
    endif
    let search = ''
    if a:wholeword
        let search .= '\<' . escape(expand('<cword>'), '/\.*$^~[') . '\>'
    else
        let search .= expand('<cword>')
    endif
    let replace = escape(a:replace, '/\&~')
    execute 'argdo %s/' . search . '/' . replace . '/' . flag . '| update'
endfunction

" setting {{{

	syntax on
	filetype plugin on
	" 自适应不同语言的智能缩进
	filetype indent on
	" 关闭vi兼容模式
	set nocompatible
	" 将制表符扩展为空格
	set expandtab
	" 设置编辑时制表符占用空格数
	set tabstop=4
	" 设置格式化时制表符占用空格数
	set shiftwidth=4
	" 让 vim 把连续数量的空格视为一个制表符
	set softtabstop=4
	" backgroud: light|dark
    set background=light
	set go=a
	" set mouse=v
	" 禁止折行,可以使用:set wrap使用折行
	set nowrap
	" 高亮显示当前行/列
	" set cursorline
	" set cursorcolumn
	" 可以与系统剪贴版通过y,p复制粘贴 h: clipboard-unnamedplus
	set clipboard+=unnamedplus,unnamed
	" 设置 gvim 显示字体
	"set guifont=Inconsolata-g\ for\ Powerline\ 11.5
	" Some basics:
	set encoding=utf-8
	set number relativenumber
	" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow splitright
	" 设置显示样式 :help :highlight | :h termguicolors
	" set hilighlight
	" 高亮显示搜索
	set hlsearch
	" 开启实时搜索功能
	set incsearch
	" 搜索时大小写不敏感
	set ignorecase
	" vim 自身命令行模式智能补全
	" set wildmenu
	" Enable autocompletion:
	set wildmode=longest,list,full
	" disable scanning included files
	set complete-=i
	" disable searching tags
	" 设置备份,保存成功删除
     set writebackup

" }}}

" :help mapping {{{

    " 禁用按键
    " noremap <home> <nop>
    " noremap <end> <nop>
    " noremap <insert> <nop>
    " noremap <delete> <nop>
    " 是否切换目录
    nnoremap <leader>a :set autochdir<cr>
    " 保存快捷键
    nnoremap <leader>ss :SaveSession!<cr>
    " 恢复快捷键
    nnoremap <leader>rs :OpenSession!<cr>
    " vsplit | split
    nnoremap <leader>v :vs<CR>
    nnoremap <leader>s :sp<CR>
    " buffers ls
    " nnoremap <leader><leader> :ls<CR>:bu<space>
    " <tab> move
    nnoremap <TAB> <C-w>w
    nnoremap <leader>tn :tabnew<CR>:edit<space>
    nnoremap <A-TAB> :tabnext<CR>
    nnoremap <S-TAB> :tabprevious<CR>
	" shortcutting split navigation, saving a keypress:
	nnoremap <c-h> <c-w>h
	nnoremap <c-j> <c-w>j
	nnoremap <c-k> <c-w>k
	nnoremap <c-l> <c-w>l
	" Spell-check set to <leader>o, 'o' for 'orthography':
	nnoremap <leader>o :setlocal spell! spelllang=en_us<CR>
	" quit file
	nnoremap <leader>q :q<cr>
	" !quit all file
	nnoremap <leader>Q :qall<cr>
	" save file
	nnoremap <leader>w :w<cr>
	" insert model save file
	inoremap jj <esc>:w<cr>
	" change insert model to format model
	inoremap jk <esc>
    " 插入模式禁用<ESC>
    inoremap <esc> <nop>
	" save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
	" replace all is aliased to s.
	nnoremap S :%s//g<left><left>
	" 帮助查询
	nnoremap <leader>h :helpgrep<space>
	" vsplit ~/.vimrc
	nnoremap <leader>ev :vsplit $MYVIMRC<cr>
	" source vimrc
	nnoremap <leader>sv :source $MYVIMRC<cr>
    " :help redraw!
    nnoremap <leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>
    " 快速移动当前行 Example: 2]e
    noremap [e  :<c-u>execute 'move -1-'. v:count1<cr>
    nnoremap ]e  :<c-u>execute 'move +'. v:count1<cr>
    " 快速添加空行 Example: 5[<space>
    nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
    nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>
    " 快速编辑自定义宏 就是在一个新的命令行窗口中读取某一个寄存器:reg（默认为 *）。当你修改完成后，只需要按下 回车 即可让它生效。
    nnoremap <leader>m  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>
    " :h gv
    xnoremap <  <gv
    xnoremap >  >gv
    " 检索光标所在字
    " nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr>
    " 不确认、非整词
    nnoremap <Leader>R :call Replace(0, 0, input('Replace '.expand('<cword>').' with: '))<CR>
    " 不确认、整词
    nnoremap <Leader>rw :call Replace(0, 1, input('Replace '.expand('<cword>').' with: '))<CR>
    " 确认、非整词
    nnoremap <Leader>rc :call Replace(1, 0, input('Replace '.expand('<cword>').' with: '))<CR>
    " 确认、整词
    nnoremap <Leader>rcw :call Replace(1, 1, input('Replace '.expand('<cword>').' with: '))<CR>
    nnoremap <Leader>rwc :call Replace(1, 1, input('Replace '.expand('<cword>').' with: '))<CR>

" }}}

" :help plug {{{

    "
    " -----------------------------------------------------------------------------
    "  <  vim-surround Press cs"' (that's c, s, double quote, single quote) insidectags >
    " -----------------------------------------------------------------------------

    " -----------------------------------------------------------------------------
	" < nerdtree >
    " -----------------------------------------------------------------------------
	nnoremap <leader>fl :NERDTreeToggle<CR>
	nnoremap <leader>gf :NERDTreeCWD<CR>
	inoremap <leader>gf <ESC>:NERDTreeCWD<CR>
    " 设置NERDTree子窗口宽度
    let NERDTreeWinSize=32
    " 设置NERDTree子窗口位置
    let NERDTreeWinPos="right"
    " 显示隐藏文件
    let NERDTreeShowHidden=1
    " NERDTree 子窗口中不显示冗余帮助信息
    let NERDTreeMinimalUI=1
    " 删除文件时自动删除文件对应 buffer
    let NERDTreeAutoDeleteBuffer=1
    " 在窗口里可以使用q退出
	autocmd bufenter * if (winnr("$") == 1 && exists("b:nerdtree") && b:nerdtree.istabtree()) | q | endif

    " -----------------------------------------------------------------------------
	" < vim-autoformat >
    " -----------------------------------------------------------------------------
	nnoremap <F6> :Autoformat<CR>
	let g:autoformat_autoindent = 0
	let g:autoformat_retab = 0
	let g:autoformat_remove_trailing_spaces = 0

    " -----------------------------------------------------------------------------
	" < colorscheme >
    " Plug 'arcticicestudio/nord-vim'
    " Plug 'rakr/vim-one'
    " Plug 'Gabirel/molokai'
    " Plug 'altercation/vim-colors-solarized'
    " -----------------------------------------------------------------------------
    "colorscheme nord

    " -----------------------------------------------------------------------------
	" < ultisnips > template url: https://github.com/honza/vim-snippets
    " -----------------------------------------------------------------------------
    " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<c-b>"
    let g:UltiSnipsJumpBackwardTrigger="<c-z>"
    " If you want :UltiSnipsEdit to split your window.
    let g:UltiSnipsEditSplit="vertical"

    " -----------------------------------------------------------------------------
	" < wildfire.vim >快速编辑结对符
    " -----------------------------------------------------------------------------
    " 快捷键
    map <SPACE> <Plug>(wildfire-fuel)
    vmap <S-SPACE> <Plug>(wildfire-water)
    " 适用于哪些结对符
    let g:wildfire_objects = ["i'", 'i"', "i)", "i]", "i}", "i>", "ip"]

    " -----------------------------------------------------------------------------
	" < minibufexpl.vim > 缓存窗口管理
    " -----------------------------------------------------------------------------
    " 默认关闭
    let g:miniBufExplAutoStart = 0
    let g:miniBufExplorerHideWhenDiff = 0
    " 显示/隐藏 MiniBufExplorer 窗口
    nnoremap <Leader><leader> :MBEToggle<cr>
    " buffer 切换快捷键
    nnoremap <leader>bn :MBEbn<cr>
    nnoremap <leader>bb :MBEbp<cr>
    nnoremap <leader>bd :MBEbd<cr>

    " -----------------------------------------------------------------------------
	" < vim-easymotion > 快速移动
    " -----------------------------------------------------------------------------
    let g:EasyMotion_do_mapping = 0 " Disable default mappings
    " Jump to anywhere you want with minimal keystrokes, with just one key binding.
    " `s{char}{label}`
    "nmap s <Plug>(easymotion-overwin-f)
    " or
    " `s{char}{char}{label}`
    " Need one more keystroke, but on average, it may be more comfortable.
    nmap s <Plug>(easymotion-overwin-f2)
    " Turn on case-insensitive feature
    let g:EasyMotion_smartcase = 1
    " JK motions: Line motions
    nmap <Leader>j <Plug>(easymotion-j)
    nmap <Leader>k <Plug>(easymotion-k)

    " -----------------------------------------------------------------------------
	" < vim-session > 恢复工作台环境 安装依赖vim-misc
    " -----------------------------------------------------------------------------
    " :SaveSession!
    " :OpenSession!

    " -----------------------------------------------------------------------------
	" < ctrlsf.vim > 搜索工具
    " -----------------------------------------------------------------------------
    " Preferred order is 'ag' > 'ack' > 'rg' > 'pt' > 'ack-grep'. You can also explicitly set it by
    let g:ctrlsf_ackprg = '/bin/ag'
    let g:ctrlsf_winsize = '30%'
    nnoremap <leader>ff :CtrlSF<CR>
    nmap     <leader>f <Plug>CtrlSFPrompt
    vmap     <leader>f <Plug>CtrlSFVwordPath
    vmap     <leader>F <Plug>CtrlSFVwordExec
    nmap     <leader>fn <Plug>CtrlSFCwordPath
    nmap     <leader>fp <Plug>CtrlSFPwordPath
    nnoremap <leader>fo :CtrlSFOpen<CR>
    nnoremap <leader>ft :CtrlSFToggle<CR>
    inoremap <leader>ft <Esc>:CtrlSFToggle<CR>

" }}}

" :help autocommand {{{

	" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
	" automatically deletes all trailing whitespace on save.
	autocmd bufwritepre * %s/\s\+$//e
	" 让配置变更立即生效 echo 'export MYVIMRC="$HOME/.vimrc"' >> ~/.zshrc
	" autocmd BufWritePost $MYVIMRC source $MYVIMRC
	" 打开文件时恢复光标位置
	autocmd BufReadPost *
	    \ if line("'\"") > 1 && line("'\"") <= line("$") |
	    \   exe "normal! g`\"" |
	    \ endif
    " 智能当前行高亮
    " autocmd InsertLeave,WinEnter * set cursorline
    " autocmd InsertEnter,WinLeave * set nocursorline

" }}}
