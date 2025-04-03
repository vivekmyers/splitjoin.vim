let s:skip = sj#SkipSyntax(['tomlString', 'tomlComment'])

function! sj#toml#SplitDict()
  let [from, to] = sj#LocateBracesAroundCursor('{', '}', ['tomlString'])

  if from < 0 && to < 0
    return 0
  else
    let pairs = sj#ParseJsonObjectBody(from + 1, to - 1)
    let body  = "{\n".join(pairs, ",\n")."\n}"
    let body = substitute(body, ',\?\n}', ',\n}', '')
    call sj#ReplaceMotion('Va{', body)

    let body_start = line('.') + 1
    let body_end   = body_start + len(pairs)

    let base_indent = indent('.')
    for line in range(body_start, body_end)
      if base_indent == indent(line)
        " then indentation didn't work quite right, let's just indent it
        " ourselves
        exe line.'normal! >>>>'
      endif
    endfor

    exe body_start.','.body_end.'normal! =='

    return 1
  endif
endfunction

function! sj#toml#JoinDict()
  let line = getline('.')

  if line =~ '{\s*$'
    call search('{', 'c', line('.'))
    let body = sj#GetMotion('Vi{')

    let lines = sj#TrimList(split(body, "\n"))
    let lines = map(lines, 'substitute(v:val, "=\\s\\+", "= ", "")')

    let body = join(lines, ' ')
    let body = substitute(body, ',\?$', '', '')

    call sj#ReplaceMotion('Va{', '{'.body.'}')

    return 1
  else
    return 0
  endif
endfunction

function! sj#toml#SplitArray()
  return s:SplitList('\[.*]', '[', ']')
endfunction

function! sj#toml#JoinArray()
  return s:JoinList('\[[^]]*\s*$', '[', ']')
endfunction

function! sj#toml#SplitTuple()
  return s:SplitList('(.\{-})', '(', ')')
endfunction

function! sj#toml#JoinTuple()
  return s:JoinList('([^)]*\s*$', '(', ')')
endfunction



function! s:SplitList(regex, opening_char, closing_char)
  let [from, to] = sj#LocateBracesAroundCursor(a:opening_char, a:closing_char, ['tomlString'])
  if from < 0 && to < 0
    return 0
  endif

  call sj#PushCursor()

  let items = sj#ParseJsonObjectBody(from + 1, to - 1)
  if len(items) <= 1
    call sj#PopCursor()
    return 0
  endif

  let body = a:opening_char."\n".join(items, ",\n").",\n".a:closing_char

  call sj#PopCursor()
  call sj#ReplaceMotion('va'.a:opening_char, body)
  return 1
endfunction

function! s:JoinList(regex, opening_char, closing_char)
  if sj#SearchUnderCursor(a:regex) <= 0
    return 0
  endif

  let body = sj#GetMotion('va'.a:opening_char)
  let body = substitute(body, '\_s\+', ' ', 'g')
  let body = substitute(body, '^'.a:opening_char.'\s\+', a:opening_char, '')
    let body = substitute(body, ',\?\s\+'.a:closing_char.'$', a:closing_char, '')

  call sj#ReplaceMotion('va'.a:opening_char, body)

  return 1
endfunction

