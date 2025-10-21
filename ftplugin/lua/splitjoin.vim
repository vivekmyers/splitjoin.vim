let b:splitjoin_split_callbacks = [
      \ 'sj#lua#SplitTable',
      \ 'sj#lua#SplitFunction',
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#lua#JoinTable',
      \ 'sj#lua#JoinFunction',
      \ ]
