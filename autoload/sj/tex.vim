function! sj#tex#SplitBlock()
  let arg_pattern = '[a-zA-Z*]'
  let opts_pattern = '\%(\%({.\{-}}\)\|\%(\[.\{-}]\)\)*'

  call search('\\begin{'.arg_pattern.'*', 'bcW', line('.'))

  let lno = line('.')
  if search('\S.*\\begin{', 'ncbW', line('.')) > 0
    call search('\S.*\zs\\begin{', 'cbW', line('.'))
    normal i
  endif
  let start = getpos('.')
  if !searchpair('\\begin{'.arg_pattern.'\{-}}'.opts_pattern, '', '\\end{'.arg_pattern.'\{-}}', 'bcW', '')
    return 0
  endif
  call searchpair('\\begin{'.arg_pattern.'\{-}}', '', '\\end{'.arg_pattern.'\{-}\zs}', 'W', '')
  if search('\zs\S', 'W', line('.')) > 0
    normal ik$
  endif
  let end = getpos('.')

  let block = sj#GetByPosition(start, end)

  let pattern = '^\(\\begin{'.arg_pattern.'\{-}}'.opts_pattern.'\)\(.\{-}\)\(\\end{'.arg_pattern.'\{-}}\)$'
  let match = matchlist(block, pattern)
  if empty(match)
    return 0
  endif

  let [_match, open, body, close; _rest] = match
  let body = substitute(body, '\\\\\s*\(\[.*\]\)\?\zs'.'\(\w\|\\\)', "\n&", 'g')
  let body = substitute(body, "[^ \n\r%]".'\ze *\\item', "&\n", 'g')

  let body = body->split("\n")->map({_, v -> substitute(v, '\S.*\zs\\label', "\n&", 'g')})->join("\n")

  let replacement = sj#Trim(open)."\n".sj#Trim(body)."\n".sj#Trim(close)

  call sj#ReplaceByPosition(start, end, replacement)
  return 1
endfunction

function! sj#tex#JoinBlock()
  let arg_pattern = '[a-zA-Z*]'
  let opts_pattern = '\%(\%({.\{-}}\)\|\%(\[.\{-}]\)\)*'

  call search('\\begin{'.arg_pattern.'*', 'bcW', line('.'))

  if !searchpair('\\begin{'.arg_pattern.'\{-}}'.opts_pattern, '', '\\end{'.arg_pattern.'\{-}\zs}', 'bcW', '')
    return 0
  endif
  let start = getpos('.')
  call searchpair('\\begin{'.arg_pattern.'\{-}}', '', '\\end{'.arg_pattern.'\{-}\zs}', 'W', '')
  let end = getpos('.')

  let block = sj#GetByPosition(start, end)

  let pattern = '^\(\\begin{'.arg_pattern.'\{-}}'.opts_pattern.'\)\_s\+\(.\{-}\)\_s\+\(\\end{'.arg_pattern.'\{-}}\)$'
  let match = matchlist(block, pattern)
  if empty(match)
    return 0
  endif

  let [_match, open, body, close; _rest] = match

  let lines = split(body, '\s*\\\\\_s\+')
  let lines = lines->map({_, v -> substitute(v, '%.*$', '', '')})
  let body = join(lines, '\\ ')

  if body =~ '\\item'
    let lines = sj#TrimList(split(body, '\\item'))
    let lines = lines->map({_, v -> substitute(v, '%.*$', '', '')})
    let lines = lines->map({_, v -> substitute(v, '^\s*', '', '')->substitute('\s*$', '', 'g')})
    if body =~ '^\s*\\item'
      let body = '\item '.join(lines, ' \item ')
    else
      let body = join(lines, ' \item ')
    endif
  endif
  let open = open->substitute('%.*$', '', '')
  let spc1 = ' '
  let spc2 = ' '
  if body->split("\n")[0] =~ '^\s*$'
    let spc1 = "\n"
  endif
  if body->split("\n")[-1] =~ '^\s*$'
    let spc2 = "\n"
  endif

  let replacement =  sj#Trim(open).spc1.sj#Trim(body).spc2.sj#Trim(close)

  call sj#ReplaceByPosition(start, end, replacement)
  return 1
endfunction

function! sj#tex#SplitArgs()
  let lno = line('.')
  if searchpair('\[', '', '\]', 'cnW') < 1
    return 0
  endif
  let contents = sj#GetMotion('vi[')->trim()
  if empty(contents)
    return 0
  endif
  let contents = contents->split('\n')->map({_, v -> substitute(v, '%.*', '', 'g')})->join('')
  let contents = contents->substitute(',', ",%\n", 'g')
  call sj#ReplaceMotion('va[', "[%\n".contents."%\n]")
  normal vi]oj>
  return 1
endfunction

function! sj#tex#JoinArgs()
  let lno = line('.')
  if searchpair('\[', '', '\]', 'cnW') < 1
    return 0
  endif
  let body = sj#GetMotion('vi[')->trim()
  if empty(body)
    return 0
  endif
  let body = body->substitute('%[^\n]*\n\s*', '', 'g')
  let body = body->substitute('\n\s*,\|,\s*\n', ',', 'g')
  let lines = split(body, "\n")
  let lines = lines->map({_, v -> substitute(v, '%.*$', '', '')})
  let lines = sj#TrimList(lines)
  let body  = sj#Trim(join(lines, ' '))
  call sj#ReplaceMotion('va[', '[' . body . ']')
  return 1
endfunction


function! sj#tex#SplitCommand()
  let lno = line('.')
  if searchpair('{', '', '}', 'cW') < 1
    return 0
  endif

  let contents = sj#GetMotion('vi{')->trim()
  call sj#ReplaceMotion('va{', "{%\n".contents."%\n}")
  return 1
endfunction

function! sj#tex#JoinCommand()
  let lno = line('.')
  if searchpair('{', '', '}', 'cW') < 1
    return 0
  endif
  let body = sj#GetMotion('vi{')
  if empty(body)
    return 0
  endif
  let lines = split(body, "\n")
  let lines = lines->map({_, v -> substitute(v, '%.*$', '', '')})
  let lines = lines->map({_, v -> substitute(v, '^\s*', ' ', '')})
  let lines = sj#TrimList(lines)
  let body  = sj#Trim(join(lines, ' '))
  call sj#ReplaceMotion('va{', '{' . body . '}')
  return 1
endfunction
