" Only do this when not done yet for this buffer
if exists("b:php_ftplugin_loaded")
    finish
endif
let b:php_ftplugin_loaded = 1

" Because I write it so often
imap <buffer> ` ->
imap <C-j> $this->

" Insert current class name
nmap <leader>pcn "%pdF.x:s#/#\\#<ESC>d/[A-Z]<CR>

" Insert current namespace at the top of the file
nmap <leader>pn ggo<CR><ESC>"%PdF/r;:s#/#\\#<CR>Inamespace  <ESC>d/[A-Z]<CR>

" Insert current namespace and opens php and create empty class
nmap <leader>pc ggO<?php<CR><CR><ESC>"%PdF/r;:s#/#\\#<CR>Inamespace  <ESC>d/[A-Z]<CR>Goclass <C-R>=expand("%:t:r")<CR><CR>{<CR>

" Public version:
" Insert current namespace and opens php and create empty class
"nmap <F9> ggO<?php<CR><CR><ESC>"%PdF/r;:s#/#\\#g<CR>Inamespace  <ESC>d/[A-Z]<CR>Goclass <C-R>=expand("%:t:r")<CR><CR>{<CR>

" PHP syntax options
let php_sql_query = 0 "Coloration des requetes SQL
let php_htmlInStrings = 0 "Coloration des balises HTML
let php_no_shorttags = 1
let php_folding = 0

" Indent whole PHP file
nmap <leader>i <Esc>mygg=G'y

" Use errorformat for parsing PHP error output
setlocal errorformat=%m\ in\ %f\ on\ line\ %l

" Map <ctrl>+p to single line mode documentation
nnoremap <buffer> <leader>pd :call PhpDocSingle()<CR>
" Map <ctrl>+p to multi line mode documentation (in visual mode)
vnoremap <buffer> <leader>pd :call PhpDocRange()<CR>

" Map <CTRL>-H to search phpm for the function name currently under the cursor (insert mode only)
inoremap <buffer> <C-H> <ESC>:!phpm <C-R>=expand("<cword>")<CR><CR>

vnoremap <buffer> <leader>pa :call PhpAlign()<CR>

let g:pdv_cfg_Author = "Thibault Duplessis <thibault.duplessis@gmail.com>"
let g:pdv_cfg_License = "MIT {@link http://opensource.org/licenses/mit-license.html}"
let g:pdv_cfg_Copyright = "2011"
let g:pdv_cfg_php4always = 0 " Ignore PHP4 tags

func! PhpAlign() range
    let l:paste = &g:paste
    let &g:paste = 0

    let l:line        = a:firstline
    let l:endline     = a:lastline
    let l:maxlength = 0
    while l:line <= l:endline
		" Skip comment lines
		if getline (l:line) =~ '^\s*\/\/.*$'
			let l:line = l:line + 1
			continue
		endif
		" \{-\} matches ungreed *
        let l:index = substitute (getline (l:line), '^\s*\(.\{-\}\)\s*\S\{0,1}=\S\{0,1\}\s.*$', '\1', "")
        let l:indexlength = strlen (l:index)
        let l:maxlength = l:indexlength > l:maxlength ? l:indexlength : l:maxlength
        let l:line = l:line + 1
    endwhile

	let l:line = a:firstline
	let l:format = "%s%-" . l:maxlength . "s %s %s"

	while l:line <= l:endline
		if getline (l:line) =~ '^\s*\/\/.*$'
			let l:line = l:line + 1
			continue
		endif
        let l:linestart = substitute (getline (l:line), '^\(\s*\).*', '\1', "")
        let l:linekey   = substitute (getline (l:line), '^\s*\(.\{-\}\)\s*\(\S\{0,1}=\S\{0,1\}\)\s\(.*\)$', '\1', "")
        let l:linesep   = substitute (getline (l:line), '^\s*\(.\{-\}\)\s*\(\S\{0,1}=\S\{0,1\}\)\s\(.*\)$', '\2', "")
        let l:linevalue = substitute (getline (l:line), '^\s*\(.\{-\}\)\s*\(\S\{0,1}=\S\{0,1\}\)\s\(.*\)$', '\3', "")

        let l:newline = printf (l:format, l:linestart, l:linekey, l:linesep, l:linevalue)
        call setline (l:line, l:newline)
        let l:line = l:line + 1
    endwhile
    let &g:paste = l:paste
endfunc
