" Darby's somewhat stolen .vimrc
"   which you totally should not feel guilty about stealing either
"   no, like seriously, go ahead
"   Originally stolen from DeMarko

" first clear any existing autocommands:
autocmd!

syntax on

" filetype detection on
filetype on

" screw vi compatibility, only geezers use vi
set nocompatible

" keeps a thousand lines of history
set history=1000

" display the current mode and partially-typed commands in the status line:
set showmode
set showcmd

" allows pattern matching with special characters
set magic

" shows line numbers, duh
set number

set laststatus=2

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set paste

" In many terminal emulators the mouse works just fine, thus enable it.
set mouse=a

"START of dannel's file formatting settings
" * Text Formatting -- General

" don't make it look like there are line breaks where there aren't:
"set nowrap

" use indents of 2 spaces, and have them copied down lines:
set shiftwidth=2
set softtabstop=2
set shiftround
set expandtab
set autoindent

" normally don't automatically format `text' as it is typed, IE only do this
" with comments, at 79 characters:
set formatoptions-=t
set textwidth=79

" get rid of the default style of C comments, and define a style with two stars
" at the start of `middle' rows which (looks nicer and) avoids asterisks used
" for bullet lists being treated like C comments; then define a bullet list
" style for single stars (like already is for hyphens):
set comments-=s1:/*,mb:*,ex:*/
set comments+=s:/*,mb:**,ex:*/
set comments+=fb:*

" treat lines starting with a quote mark as comments (for `Vim' files, such as
" this very one!), and colons as well so that reformatting usenet messages from
" `Tin' users works OK:
set comments+=b:\"
set comments+=n::

" * Text Formatting -- Specific File Formats

" recognize anything
" at all with a .txt extension as being human-language text [this clobbers the
" `help' filetype, but that doesn't seem to prevent help from working
" properly]:
augroup filetype
autocmd BufNewFile,BufRead *.txt set filetype=human
augroup END


" Put these in an autocmd group, so that we can delete them easily.
"augroup vimrcEx
"au!

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

" in human-language files, automatically format everything at 78 chars:
autocmd FileType mail,human set formatoptions+=t textwidth=78

" for C-like programming, have automatic indentation:
autocmd FileType c,cpp,slang set cindent

" for actual C (not C++) programming where comments have explicit end
" characters, if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
autocmd FileType c set formatoptions+=ro

" for Perl programming, have things in braces indenting themselves:
autocmd FileType perl set smartindent tabstop=2

autocmd FileType ruby set smartindent tabstop=2

" for CSS, also have things in braces indented:
autocmd FileType css set smartindent

" for HTML, generally format text, but if a long line has been created leave it
" alone when editing:
autocmd FileType html set formatoptions+=tl

" for both CSS and HTML, use genuine tab characters for indentation, to make
" files a few bytes smaller:
autocmd FileType html,css set noexpandtab tabstop=2

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif

" fuck error bells, who needs em?
set noerrorbells

" show brace matching for 3 ms
set showmatch
set matchtime=3

set wildmenu
set ruler

" * Search & Replace

" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase

" show the `best match so far' as search strings are typed:
set incsearch

" assume the /g flag on :s substitutions to replace all matches in a line:
set gdefault

set wildchar=<TAB>
" have command-line completion <Tab> (for filenames, help topics, option names)
" first list the available options and complete the longest common part, then
" have further <Tab>s cycle through the possibilities:
set wildmode=list:longest,full

" have the h and l cursor keys wrap between lines (like <Space> and <BkSpc> do
" by default), and ~ covert case over line breaks; also have the cursor keys
" wrap in insert mode:
set whichwrap=h,l,~,[,]

" use <F6> to cycle through split windows (and <Shift>+<F6> to cycle backwards,
" where possible):
nnoremap <F6> <C-W>w
nnoremap <S-F6> <C-W>W
          

if has("gui_running")
  set background=light
  colorscheme solarized
  "set guioptions=egmrt
else
"colorscheme elflord
  set background=dark
  colorscheme solarized
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
"command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
"	 	\ | wincmd p | diffthis

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

set diffopt+=iwhite

set guioptions=aAce
