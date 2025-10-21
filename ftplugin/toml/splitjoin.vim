let b:splitjoin_split_callbacks = [
      \ 'sj#toml#SplitTuple',
      \ 'sj#toml#SplitDict',
      \ 'sj#toml#SplitArray',
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#toml#JoinTuple',
      \ 'sj#toml#JoinDict',
      \ 'sj#toml#JoinArray',
      \ ]
