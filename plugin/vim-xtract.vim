" Vim-Xtract Plugin
" Author: caesar003
" Email: caesarmuksid@gmail.com
" Repo: https://github.com/caesar003/vim-xtract
" Last Modified: Mon Jul 07 2025, 03.32
"
" Description:
" A lightweight Vim plugin that automates extracting JavaScript/TypeScript 
" object properties into destructuring assignments. Simply select object 
" properties and generate clean destructuring code instantly.
" 
" Why use Vim-Xtract?
" - Eliminates repetitive typing when creating destructuring assignments
" - Reduces errors in large object destructuring
" - Works with both JavaScript and TypeScript
" - Lightweight with no dependencies
" - Integrates seamlessly with system clipboard
"
" Usage:
" - Visual mode: Select object properties with vi{ then run :Xtract
"   Example: vi{ on "{ name: 'John', age: 30 }" 
"   Result: Copies "const { name, age, } = args;" to clipboard
"
" - Normal mode: Run :Xtract on current line containing object
"   Works on single-line objects
"
" - Paste anywhere: Use 'p' to paste the generated destructuring code
"   Perfect for function parameters and variable assignments
"
" - Optional mappings: Add to .vimrc for quick access
"   vnoremap <leader>x :Xtract<CR>
"   nnoremap <leader>x :Xtract<CR>
"
" ----------------------------------------------------------------------------

" Prevent loading twice
if exists('g:loaded_vim_xtract')
    finish
endif
let g:loaded_vim_xtract = 1

" Save compatible mode
let s:save_cpo = &cpo
set cpo&vim

function! s:ExtractObjectKeys() range
    " Get the selected text (works with visual selection or current line)
    let selected_text = join(getline(a:firstline, a:lastline), ' ')
    
    " Extract all property names using regex
    let keys = []
    let pattern = '\<\w\+\>\s*:'
    let start = 0
    
    while 1
        let match = matchstr(selected_text, pattern, start)
        if match == ''
            break
        endif
        
        let key = substitute(match, '\s*:', '', '')
        call add(keys, key)
        let start = start + len(match) + matchend(selected_text[start:], pattern)
    endwhile
    
    " Create destructuring syntax
    if len(keys) > 0
        let result = []
        call add(result, "const {")
        for key in keys
            call add(result, "  " . key . ",")
        endfor
        call add(result, "} = args;")
        
        " Copy to clipboard (both system and unnamed register)
        let destructuring_code = join(result, "\n")
        let @+ = destructuring_code
        let @" = destructuring_code
        
        echo "✓ Destructuring code copied to clipboard! (" . len(keys) . " properties)"
    else
        echo "✗ No object properties found in selection"
    endif
endfunction

" Create the command
command! -range Xtract <line1>,<line2>call s:ExtractObjectKeys()

" Restore compatible mode
let &cpo = s:save_cpo
unlet s:save_cpo
