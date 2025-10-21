  let b:splitjoin_split_callbacks = [
        \ 'sj#cue#SplitStructLiteral',
        \ 'sj#cue#SplitArray',
        \ 'sj#cue#SplitArgs',
        \ 'sj#cue#SplitImports',
        \ ]

  let b:splitjoin_join_callbacks = [
        \ 'sj#cue#JoinStructLiteral',
        \ 'sj#cue#JoinArray',
        \ 'sj#cue#JoinArgs',
        \ ]
