let b:splitjoin_split_callbacks = [
      \ 'sj#vim#SplitIfClause',
      \ 'sj#vim#Split',
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#vim#JoinIfClause',
      \ 'sj#vim#Join',
      \ ]
