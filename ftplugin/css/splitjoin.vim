let b:splitjoin_split_callbacks = [
      \ 'sj#css#SplitDefinition',
      \ 'sj#css#SplitMultilineSelector',
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#css#JoinDefinition',
      \ 'sj#css#JoinMultilineSelector',
      \ ]
