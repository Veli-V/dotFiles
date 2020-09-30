set nocompatible
filetype plugin on
syntax on

set number relativenumber
set tabstop=4
set softtabstop=0 expandtab
set shiftwidth=4
set autoindent

set ruler

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END


colorscheme delek

" let g:vimwiki_list = [{'path': '~/vimwiki/',
                      "\ 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_list = [{
	\ 'path': '~/vimwiki',
	\ 'template_path': '~/vimwiki/templates/',
	\ 'template_default': 'default',
	\ 'syntax': 'markdown',
	\ 'ext': '.md',
	\ 'path_html': '~/vimwiki/site_html/',
	\ 'custom_wiki2html': 'vimwiki_markdown',
	\ 'template_ext': '.tpl',
	\ 'auto_diary_index': 1,
	\ 'vimwiki_global_ext': 0,
	\ 'list_margin': 0}]


autocmd FileType markdown setlocal shiftwidth=4 softtabstop=4 expandtab foldmethod=indent

"let g:vimwiki_folding = 'expr'
"
"
:nnoremap <F5> "=strftime("%c")<CR>P
:inoremap <F5> <C-R>=strftime("%c")<CR>
