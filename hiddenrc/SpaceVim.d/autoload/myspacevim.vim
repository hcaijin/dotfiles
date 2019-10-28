" help: https://spacevim.org/documentation/#bootstrap-functions
function! myspacevim#before() abort
  " call SpaceVim#custom#SPCGroupName(['G'], '+TestGroup')
  " call SpaceVim#custom#SPC('nore', ['G', 't'], 'echom 1', 'echomessage 1', 1)
  " custom map config {{{
  let g:mapleader =";"
	set clipboard+=unnamedplus,unnamed
  tnoremap <silent><A-e>            <nop>
  tnoremap <silent><esc>            <c-\><c-n>
  tnoremap <silent><C-d>            <C-\><C-N>ZQ
  tnoremap <silent><C-h>            <C-\><C-N><C-w>h
  tnoremap <silent><C-j>            <C-\><C-N><C-w>j
  tnoremap <silent><C-k>            <C-\><C-N><C-w>k
  tnoremap <silent><C-l>            <C-\><C-N><C-w>l
  inoremap <silent>jj <esc>:w<cr>
  " <tab> move
  " nnoremap <TAB> <C-w>w
  nnoremap <silent><A-TAB> :tabnext<CR>
  " nnoremap <S-TAB> :tabprevious<CR>
	" quit file
	" nnoremap <silent><leader>q :q<cr>
	" !quit all file
	nnoremap <silent><leader>Q :qall!<cr>
	" save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
	" replace all is aliased to s.
	nnoremap S :%s//g<left><left>
	" save file
	nnoremap <silent><leader>w :w<cr>
	nnoremap <silent><leader>W :w!<cr>
  nnoremap <silent>[e  :<c-u>execute 'move -1-'. v:count1<cr>
  nnoremap <silent>]e  :<c-u>execute 'move +'. v:count1<cr>
  nnoremap <silent>[<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
  nnoremap <silent>]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>
  nnoremap <silent><leader>M  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>
  " }}}
endfunction

function! myspacevim#after() abort
endfunction
