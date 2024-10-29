function! sj#tex#SplitBlock()
  let arg_pattern = '[a-zA-Z*]'
  let opts_pattern = '\%(\%({.\{-}}\)\|\%(\[.\{-}]\)\)*'

  let lno = line('.')
  if searchpair('\s*\zs\\begin{'.arg_pattern.'\{-}}'.opts_pattern, '', '\\end{'.arg_pattern.'\{-}}', 'bc', '') != lno
    return 0
  endif

  let start = getpos('.')
  if searchpair('\\begin{'.arg_pattern.'\{-}}', '', '\\end{'.arg_pattern.'\{-}\zs}', '') != lno
    return 0
  endif
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
  let replacement = open."\n".sj#Trim(body)."\n".close

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
  let [start, end] = sj#LocateBracesOnLine('{', '}', ['texComment'])
  if start < 0
    return 0
  endif

  let contents = sj#GetCols(start + 1, end - 1)
  call sj#ReplaceCols(start + 1, end - 1, "%\n".contents."%\n")
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

  call sj#ReplaceMotion('va{', '{' . body . '}'."\n")
endfunction
