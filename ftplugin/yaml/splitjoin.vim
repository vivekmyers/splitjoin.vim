let b:splitjoin_split_callbacks = [
      \ 'sj#yaml#SplitArray',
      \ 'sj#yaml#SplitMap'
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#yaml#JoinArray',
      \ 'sj#yaml#JoinMap'
      \ ]
