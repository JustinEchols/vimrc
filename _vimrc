call plug#begin('~/vimfiles/plugged')
call plug#end()
"To install, add Plug line use PlugInstall 
"To delete, delete the Plug line and run PlugClean


let mapleader =" "

"Tweaks for file browsing
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
"let g:netrw_winsize=10

set noerrorbells
set incsearch
set tabstop=4 softtabstop=4
set shiftwidth=4
set smartindent
set noswapfile
set nowrap
set textwidth=80
set splitright
set nocompatible
set number relativenumber
set autoindent
set syntax=c
set tags=./tags,tags
set guioptions -=m
set guioptions -=T
set guioptions -=r
set guioptions -=R
set guioptions -=l
set guioptions -=L



"To create tags file: !ctags -R
map <leader>t :TagbarToggle<CR>

let v:colornames['khaki'] = '#bdb76b'
colorscheme evening
"set cc=81

set encoding=utf-8
syntax on

filetype plugin on
filetype indent on

"For stupid backspace problem
set backspace=2
set backspace=indent,eol,start

"Bash like tab completion
"set wildmode=list:longest

"Provides tab-completion for all file-relatied tasks
set path +=**

"For GLSL syntax highlighting. Requires plugin
"autocmd! BufNewFile,BufRead *.vs,*.fs set ft=glsl

"-----------------------------Termdebug plugin----------------------------------
packadd termdebug
let g:termdebug_popup = 0
let g:termdebug_wide = 1

"Display all matching files when we tab complete
set wildmenu

"Now we can:
"Hit tab to :find by partial match
"Use * to make it fuzzy

"Ensure the buffer for building code opens in a new view
"set switchbuf=useopen,vsplit
set switchbuf=useopen
 
"error message format
" Microsoft MSBuild
"set errorformat+=\\\ %#%f(%l\\\,%c):\ %m

" Microsoft compiler: cl.exe
set errorformat+=\\\ %#%f(%l)\ :\ %#%t%[A-z]%#\ %m

"compiler msvc

" Microsoft HLSL compiler: fxc.exe
"set errorformat+=\\\ %#%f(%l\\\,%c-%*[0-9]):\ %#%t%[A-z]%#\ %m
 
function! BatchFileBuild()
    " build.bat
    set makeprg=build
    " Make sure the output doesnt interfere with anything
   silent make
    " Open the output buffer
	copen
    echo 'Build Complete'
endfunction
 
" Set F7 build. Should we include saving the file?
autocmd FileType cpp nnoremap <buffer> <F7> :call BatchFileBuild()<CR><CR>
autocmd FileType c nnoremap <buffer> <F7> :call BatchFileBuild()<CR><CR>
 
"The next two commands cannot be for cpp buffers. Because the error window
"is a vim buffer. Not a cpp buffer
"
"Go to next error.
nnoremap <F6> :cn<CR>

"Go to previous error
nnoremap <F5> :cp<CR>

nnoremap ,n :bn<CR>
nnoremap ,b :bp<CR>


"Changing vim modes
inoremap kj <Esc>
cnoremap kj <Esc>
nnoremap ; :
vnoremap ; :


"Navigating Windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"---------------------------------Header Templates-----------------------------------------

autocmd BufNewFile *.py 0r ~/vimfiles/header_templates/header_py.txt
autocmd BufNewFile *.py exe "3," . 11 . "g/File Name:.*/s//File Name: " .expand("%")
autocmd BufNewFile *.py exe "3," . 11 . "g/Date Created:.*/s//Date Created: " .strftime("%m-%d-%Y %X")

"Remember cursor position using mark
autocmd BufWritePre,FileWritePre *.py exe "normal ma"

" Update Last Modified 
autocmd BufWritePre,FileWritePre *.py exe "3," . 11 . "g/Last Modified: /s/Last Modified: .*/Last Modified: " .. strftime("%m-%d-%Y %X")

" Jump back to cursor position using mark
autocmd BufWritePost,FileWritePost *.py exe "normal `a"


function! s:header_gates()
	let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
	execute "normal! i#if !defined(" . gatename . ")"
	execute "normal! o#define " . gatename
	execute "normal! Go#endif"
	normal! kk
	normal! o
endfunction

autocmd BufNewFile *.h call <SID>header_gates()


"--------------------------------------Latex-----------------------------------------------

let b:suppress_latex_suite=1
let b:tex_flavor='pdflatex'

let g:Tex_ViewRule_pdf='mupdf'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_FormatDependency_dvi='dvi,ps,pdf'
let g:Tex_CompileRule_dvi='latex --interaction=nonstopmode $*'
let g:Tex_CompileRule_ps='ps2pdf $*'
let g:Tex_CompileRule_dvi = 'latex --interaction=nonstopmode $*'

function! LatexFileBuild() 
	"Tried using batch file but does not work ?
	set makeprg=pdflatex\ -file-line-error\ -synctex=1\ -interaction=nonstopmode\ -shell-escape\ %
	silent make
	copen
	echo 'Build Complete'
endfunction

autocmd Filetype tex nnoremap <buffer> Z :call LatexFileBuild()<CR>
autocmd Filetype tex nnoremap <buffer> S :! start mupdf %<.pdf<CR><CR>

"-----------------------SNIPPETS------------------------------------------------

"Example to explain how the snippet works
"Read an empty HTML template and move cursor to title
"nnoremap ,html :!-1read $HOME\Users\justi\vimfiles\skeleton.html<CR>3jwf>a

"noremp tells vim dont let any of these commands invoke themselves
",html , is arbitrary character to prefix the mapping, the n 
"at the very beginning stands for normal which means this mapping will 
"onlybe used in normal mode(insert mode?)

"what remap means is that this series of keystrokes ,html
" results in this :-1read $/HOME/Vim/skeleton<CR>3jwf>a being
"automatically typed.

"What this snippet does is invoke the read command in Vim. The
""command reads from a file into the current vim buffer
"the -1 changes the line

"inoremap <Tab> <Esc>/<CR>"_c4l

"Might delte this first one and replace with larger snippet to use
"at the beggining of every latex doc.

autocmd Filetype tex inoremap <buffer> <Space><Space> <Esc>/<++><Enter>"_c4l 

"-------------------------ENVIRONMENT SNIPPETS--------------------
autocmd FileType tex inoremap <buffer>  ;doc \begin{document}<CR>\end{document}<Esc>O
autocmd FileType tex inoremap <buffer>  ;thm \begin{theorem}<CR>\end{theorem}<++><Esc>O
autocmd FileType tex inoremap <buffer>  ;def \begin{definition}<CR>\end{definition}<++><Esc>O
autocmd FileType tex inoremap <buffer>  ;fig \begin{figure}<CR>\end{figure}<++><Esc>O
autocmd FileType tex inoremap <buffer>  ;pf \begin{proof}<CR>\end{proof}<++><Esc>O
autocmd FileType tex inoremap <buffer>  ;ali \begin{align}<CR>\end{align}<++><Esc>O
autocmd FileType tex inoremap <buffer>  ;eq  \begin{equation*}<CR>\end{equation*}<++><Esc>O
autocmd FileType tex inoremap <buffer>  ;en \begin{enumerate}<CR>\end{enumerate}<++><Esc>O

autocmd FileType tex inoremap <buffer>  ;sp  \begin{split}<CR>\end{split}<++><Esc>O
autocmd FileType tex inoremap <buffer>  ;lem  \begin{lemma}<CR>\end{lemma}<++><Esc>O
autocmd FileType tex inoremap <buffer>  ;cor \begin{corollary}<CR>\end{corollary}<++><Esc>O

autocmd FileType tex inoremap <buffer>  ;min \begin{c}{minted}<CR>\end{minted}<++><Esc>O

"-------------------------TEXT SNIPPETS--------------------
autocmd FileType tex inoremap <buffer>  ;bf \textbf{}<++><Esc>F}i
autocmd FileType tex inoremap <buffer>  ;it \textit{}<++><Esc>F}i


autocmd FileType tex inoremap <buffer>  Beg \begin{<++>}<CR><Tab><++><CR>\end{<++>}

"-------------------------MATH RELATED SNIPPETS-----------------------------------------

"Inline math mode
autocmd FileType tex inoremap <buffer> mk $$<++><Esc>F$i
autocmd FileType tex inoremap <buffer> ^^ ^{}<++><Esc>F}i
autocmd FileType tex inoremap <buffer> __ _{}<++><Esc>F}i

"autocmd FileType tex inoremap <buffer> <Leader>R \mathBB{R}<++>


"Display math mode
autocmd FileType tex inoremap <buffer> dm \[<CR><++><CR>\]

"Limit shortcut
autocmd FileType tex inoremap <buffer> ;lim \lim_{<++>}<++>

"Summation shortcut
autocmd FileType tex inoremap <buffer> ;sum \sum_{<++>}^{<++>}<++>

"Integral snippet
autocmd FileType tex inoremap <buffer> ;int \int_{<++>}^{<++>}<++>

" Fraction snippet
autocmd FileType tex inoremap <buffer> // \frac{<++>}{<++>}<++>


"autocmd Filetype pmx nnoremap <buffer> <F7> :! musixtex -p %<.pmx<CR><CR> 

set efm+=%E!\ LaTeX\ %trror:\ %m,
			\%E!\ %m,
			\%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#,
			\%+W%.%#\ at\ lines\ %l--%*\\d,
			\%WLaTeX\ %.%#Warning:\ %m,
			\%Cl.%l\ %m,
			\%+C\ \ %m.,
			\%+C%.%#-%.%#,
			\%+C%.%#[]%.%#,
			\%+C[]%.%#,
			\%+C%.%#%[{}\\]%.%#,
			\%+C<%.%#>%.%#,
			\%C\ \ %m,
			\%-GSee\ the\ LaTeX%m,
			\%-GType\ \ H\ <return>%m,
			\%-G\ ...%.%#,
			\%-G%.%#\ (C)\ %.%#,
			\%-G(see\ the\ transcript%.%#),
			\%-G\\s%#,
			\%+O(%f)%r,
			\%+P(%f%r,
			\%+P\ %\\=(%f%r,
			\%+P%*[^()](%f%r,
			\%+P[%\\d%[^()]%#(%f%r,
			\%+Q)%r,
			\%+Q%*[^()])%r,
			\%+Q[%\\d%*[^()])%r



