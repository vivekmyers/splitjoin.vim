let b:splitjoin_split_callbacks = [
      \ 'sj#css#SplitMultilineSelector',
      \ 'sj#scss#SplitNestedDefinition',
      \ 'sj#css#SplitDefinition',
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#scss#JoinNestedDefinition',
      \ 'sj#css#JoinDefinition',
      \ 'sj#css#JoinMultilineSelector',
      \ ]
