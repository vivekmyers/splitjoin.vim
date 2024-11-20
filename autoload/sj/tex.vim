function! sj#tex#SplitBlock()
  let arg_pattern = '[a-zA-Z*]'
  let opts_pattern = '\%(\%({.\{-}}\)\|\%(\[.\{-}]\)\)*'

  let lno = line('.')
  if searchpair('\\begin{'.arg_pattern.'\{-}}'.opts_pattern, '', '\\end{'.arg_pattern.'\{-}}', 'bc', '') != lno
    if search('\\end{', 'cW', lno + 1) > 0
      let value = getline('.')
      let lfirst = substitute(value, '^.*\zs\\end{'.arg_pattern.'\{-}}'.opts_pattern.'.*$', '', '')
      let lsecond = substitute(value, '\%(\(\t*\)\t\)\?.*\(\\end{'.arg_pattern.'\{-}}'.opts_pattern.'.*$\)', '\1\2', '')
      call setline('.', lfirst)
      call append('.', lsecond)
      return 1
    endif
    return 0
  endif

  let start = getpos('.')
  call searchpair('\\begin{'.arg_pattern.'\{-}}', '', '\\end{'.arg_pattern.'\{-}\zs}', '')
  let end = getpos('.')

  let block = sj#GetByPosition(start, end)

  let pattern = '^\(\\begin{'.arg_pattern.'\{-}}'.opts_pattern.'\)\(.\{-}\)\(\\end{'.arg_pattern.'\{-}}\)$'
  let match = matchlist(block, pattern)
  if empty(match)
    return 0
  endif

  let [_match, open, body, close; _rest] = match
  let body = substitute(body, '\\\\\ *\zs'."[^ \n\r%]", "\n&", 'g')
  let body = substitute(body, "[^ \n\r%]".'\ze *\\item', "&\n", 'g')
  let replacement = sj#Trim(open)."\n".sj#Trim(body)."\n".sj#Trim(close)

  call sj#ReplaceByPosition(start, end, replacement)
  return 1
endfunction

function! sj#tex#JoinBlock()
  let arg_pattern = '[a-zA-Z*]'
  let opts_pattern = '\%(\%({.\{-}}\)\|\%(\[.\{-}]\)\)*'

  if search('\s*\\begin{', 'bcW', line('.')) <= 0
    return 0
  endif
  call search('\\begin{', 'cW', line('.'))

  let start = getpos('.')
  if searchpair('\\begin{'.arg_pattern.'\{-}}', '', '\\end{'.arg_pattern.'\{-}\zs}') <= 0
    return 0
  endif
  let end = getpos('.')

  let block = sj#GetByPosition(start, end)

  let pattern = '^\(\\begin{'.arg_pattern.'\{-}}'.opts_pattern.'\)\_s\+\(.\{-}\)\_s\+\(\\end{'.arg_pattern.'\{-}}\)$'
  let match = matchlist(block, pattern)
  if empty(match)
    return 0
  endif

  let [_match, open, body, close; _rest] = match

  let lines = split(body, '\\\\\_s\+')
  let body = join(lines, '\\ ')

  if body =~ '\\item'
    let lines = sj#TrimList(split(body, '\\item'))
    if body =~ '^\s*\\item'
      let body = '\item '.join(lines, ' \item ')
    else
      let body = join(lines, ' \item ')
    endif
  endif

  let replacement =  sj#Trim(open)." ".body." ".sj#Trim(close)

  call sj#ReplaceByPosition(start, end, replacement)
  return 1
endfunction

function! sj#tex#SplitCommand()
  let lno = line('.')
  exe "silent! normal! va{o\e"
  let startno = getpos("'<")[1]
  if startno != lno
    return 0
  endif

  let contents = sj#GetMotion('vi{')->trim()
  call sj#ReplaceMotion('va{', "{%\n".contents."%\n}")
  return 1
endfunction

function! sj#tex#JoinCommand()
  exe "silent! normal! va{o\e"
  " if search('{\zs%\s*$', 'c', line('.')) <= 0
  "   return 0
  " endif
  let body = sj#GetMotion('Vi{')

  let lines = split(body, "\n")
  let lines = lines->map({_, v -> substitute(v, '%.*$', '', '')})
  let lines = sj#TrimList(lines)
  let body  = sj#Trim(join(lines, ' '))
  let body  = substitute(body, '%.*', '', '')

  call sj#ReplaceMotion('va{', '{' . body . '}')
endfunction
