" Vim-Xtract Plugin
" Author: caesar003
" Email: caesarmuksid@gmail.com
" Repo: https://github.com/caesar003/vim-xtract
" Last Modified: Sat Jul 12 2025, 07.36
"
" Description:
" A lightweight Vim plugin that automates extracting JavaScript/TypeScript 
" object properties into destructuring assignments. Simply select object 
" properties and generate clean destructuring code instantly.
" 
" Configuration:
" let g:vim_xtract_silent = 0        " Set to 1 to disable all messages
" let g:vim_xtract_use_notify = 1    " Set to 0 to disable notify (Neovim only)
" let g:vim_xtract_var_name = 'obj'  
" ----------------------------------------------------------------------------

" Prevent loading twice
if exists('g:loaded_vim_xtract') | finish | endif
let g:loaded_vim_xtract = 1

let s:save_cpo = &cpo
set cpo&vim

" Configuration defaults
if !exists('g:vim_xtract_silent')     | let g:vim_xtract_silent = 0     | endif
if !exists('g:vim_xtract_use_notify') | let g:vim_xtract_use_notify = 1 | endif
if !exists('g:vim_xtract_var_name')   | let g:vim_xtract_var_name = 'obj' | endif
if !exists('g:vim_xtract_template')
  let g:vim_xtract_template = "const {\n{{keys}}\n} = {{var}};"
endif

" Enhanced messaging system
function! s:Notify(msg, level) abort
  if g:vim_xtract_silent | return | endif

  if has('nvim') && g:vim_xtract_use_notify
    try
      let icons = {'info': '📋', 'warn': '⚠️', 'error': '❗'}
      call luaeval('require("notify")(_A.msg, vim.log.levels[_A.level], {
            \ "title": "vim-xtract",
            \ "icon": _A.icon,
            \ "timeout": 2000})', 
            \ {'msg': a:msg, 'level': toupper(a:level), 'icon': get(icons, a:level, '')})
      return
    catch | endtry
  endif

  execute 'echohl' . (a:level == 'info' ? 'None' : a:level == 'warn' ? 'WarningMsg' : 'ErrorMsg')
  echo a:msg | echohl None
endfunction

" Core extraction logic
function! s:Xtract() range abort
  let lines = getline(a:firstline, a:lastline)
  let matches = []

  " Find all valid property names (supports quoted and unquoted keys)
  for line in lines
    let pos = 0
    while pos < len(line)
      let [match, start, end] = matchstrpos(line, '\v([[:alpha:]_][[:alnum:]_]*|''\zs[^'']+\ze''|"\zs[^"]+\ze")\s*:', pos)
      if match == '' | break | endif
      let key = matchstr(match, '\v^([^:]+)')
      call add(matches, key)
      let pos = end
    endwhile
  endfor

  if empty(matches)
    call s:Notify('✗ No object properties found in selection', 'warn')
    return
  endif

  " Generate destructuring code
  let keys = join(map(matches, '"  " . v:val . ","'), "\n")
  let output = substitute(g:vim_xtract_template, '{{var}}', g:vim_xtract_var_name, 'g')
  let output = substitute(output, '{{keys}}', keys, 'g')

  " Copy to clipboard
  let @" = output
  if has('clipboard') | let @+ = output | endif

  call s:Notify('✓ Copied destructuring for ' . len(matches) . ' properties', 'info')
endfunction

" Register commands
command! -range Xtract <line1>,<line2>call s:Xtract()

let &cpo = s:save_cpo
unlet s:save_cpo
