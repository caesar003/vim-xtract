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
" Configuration:
" let g:vim_xtract_silent = 0        " Set to 1 to disable all messages
" let g:vim_xtract_use_notify = 1    " Set to 0 to disable notify (Neovim only)
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

" Default configuration
if !exists('g:vim_xtract_silent')
    let g:vim_xtract_silent = 0
endif

if !exists('g:vim_xtract_use_notify')
    let g:vim_xtract_use_notify = 1
endif

" Function to display messages (with notify support)
function! s:ShowMessage(message, level)
    if g:vim_xtract_silent
        return
    endif
    
    " Check if we're in Neovim and notify is available
    if has('nvim') && g:vim_xtract_use_notify
        try
            " Try to use notify
            if a:level == 'error'
                call luaeval('require("notify")(_A[1], vim.log.levels.ERROR, {title = "vim-xtract", icon = "⚠️", timeout = 3000})', [a:message])
            elseif a:level == 'warn'
                call luaeval('require("notify")(_A[1], vim.log.levels.WARN, {title = "vim-xtract", icon = "⚠️", timeout = 3000})', [a:message])
            else
                call luaeval('require("notify")(_A[1], vim.log.levels.INFO, {title = "vim-xtract", icon = "📋", timeout = 2000})', [a:message])
            endif
            return
        catch
            " Fallback to echo if notify is not available
        endtry
    endif
    
    " Default echo behavior
    if a:level == 'error'
        echohl ErrorMsg
    elseif a:level == 'warn'
        echohl WarningMsg
    else
        echohl None
    endif
    
    echo a:message
    echohl None
endfunction

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
        
        call s:ShowMessage("✓ Destructuring code copied to clipboard! (" . len(keys) . " properties)", "info")
    else
        call s:ShowMessage("✗ No object properties found in selection", "warn")
    endif
endfunction

" Create the command
command! -range Xtract <line1>,<line2>call s:ExtractObjectKeys()

" Restore compatible mode
let &cpo = s:save_cpo
unlet s:save_cpo
