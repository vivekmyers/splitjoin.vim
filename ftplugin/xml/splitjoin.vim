" Wrap them in conditions to avoid messing up erb

let b:splitjoin_split_callbacks = [
      \ 'sj#html#SplitTags'
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#html#JoinTags'
      \ ]
