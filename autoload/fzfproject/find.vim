function! s:switchToFile(lines)
  try
    let autochdir = &autochdir
    set noautochdir
    let l:query = a:lines[0]
    if(len(a:lines) > 1)
      let l:file = a:lines[1]
      execute 'edit ' . l:file
    else
      let s:yesNo = input("Create '" . l:query . "'? (y/n) ")
      if s:yesNo ==? 'y' || s:yesNo ==? 'yes'
        execute 'edit ' . l:query
        write
      endif
    endif
  finally
    let &autochdir = autochdir
  endtry
endfunction

function! fzfproject#find#file() 
  echom('foo')
  let l:opts = { 
        \ 'sink*' : function('s:switchToFile'),
        \ 'down': '40%',
        \ 'options': [
        \ '--print-query',
        \ '--header', 'Choose existing file, or enter the name of a new file',
        \ '--prompt', 'Filename> ' 
        \ ]
        \ }
  if FugitiveIsGitDir(getcwd() . '/.git') 
    let l:is_win = has('win32') || has('win64')
    let l:opts['source'] = 'git ls-files --others --exclude-standard --cached' . (l:is_win ? '' : ' | uniq')
  endif
  return fzf#run(l:opts)
endfunction
