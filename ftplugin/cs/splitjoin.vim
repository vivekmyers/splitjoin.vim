" Use C syntax for C# for now

let b:splitjoin_split_callbacks = [
      \ 'sj#c#SplitIfClause',
      \ 'sj#c#SplitFuncall',
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#c#JoinFuncall',
      \ 'sj#c#JoinIfClause',
      \ ]
