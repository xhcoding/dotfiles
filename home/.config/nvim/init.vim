if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif


" 插件管理
" 指定插件的目录
call plug#begin('~/.local/share/nvim/plugged')
" 目录树插件
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" 状态栏
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" 文件查找
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

" 主题
Plug 'joshdick/onedark.vim'

" LSP
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Initialize plugin system
call plug#end() 

" 开启语法高亮
syntax on

" 主题设置
colorscheme onedark

"==========插件配置=================
" 目录树
let g:NERDTreeNotificationThreshold = 500

" airline
let g:airline_theme='onedark'

" LSP
let g:LanguageClient_serverCommands = {
    \ 'c': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'cpp': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'cuda': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'objc': ['ccls', '--log-file=/tmp/cc.log'],
    \ }

let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
let g:LanguageClient_settingsPath = '/home/xhcoding/.config/nvim/languageclient.json'
" https://github.com/autozimu/LanguageClient-neovim/issues/379 LSP snippet is not supported
let g:LanguageClient_hasSnippetSupport = 0

" 高亮当前文档
augroup LanguageClient_config
  au!
  au BufEnter * let b:Plugin_LanguageClient_started = 0
  au User LanguageClientStarted setl signcolumn=yes
  au User LanguageClientStarted let b:Plugin_LanguageClient_started = 1
  au User LanguageClientStopped setl signcolumn=auto
  au User LanguageClientStopped let b:Plugin_LanguageClient_stopped = 0
  au CursorMoved * if b:Plugin_LanguageClient_started | sil call LanguageClient#textDocument_documentHighlight() | endif
augroup END

" 使用clang-format格式化
fu! C_init()
  setl formatexpr=LanguageClient#textDocument_rangeFormatting()
endf
au FileType c,cpp,cuda,objc :call C_init()

" 补全设置
let g:deoplete#enable_at_startup = 1

"===================================



"==========快捷键配置===============
" 设置leader键
let mapleader="\<Space>"

" jk退出插入模式
ino <nowait> jk <Esc>
" 重新载入配置
nn <silent> <leader>hR :source ~/.vim/vimrc

" 窗口相关
nn <silent> <leader>wk :wincmd k<cr>
nn <silent> <leader>wj :wincmd j<cr>
nn <silent> <leader>wh :wincmd h<cr>
nn <silent> <leader>wl :wincmd l<cr>
nn <silent> <leader>wq :wincmd q<cr>
nn <silent> <leader>wv :vsplit<cr>
nn <silent> <leader>ws :split<cr>

" buffer相关
nn <silent> <leader>bs :write<cr>

" 文件相关
" 打开最近文件
nn <silent> <leader>fr :Leaderf mru<cr>
" 打开当前目录文件
nn <silent> <leader>f. :Leaderf file .<cr>


" 打开目录树
nn <silent> <leader>op :NERDTreeToggle<cr>

" LSP相关按键
nn <silent> gd :call LanguageClient#textDocument_definition()<cr>
nn <silent> gD :call LanguageClient#textDocument_references({'includeDeclaration': v:false})<cr>
nn <silent> K :call LanguageClient#textDocument_hover()<cr>
"===================================
