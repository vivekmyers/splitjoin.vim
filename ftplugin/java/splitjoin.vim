let b:splitjoin_split_callbacks = [
      \ 'sj#java#SplitIfClauseBody',
      \ 'sj#java#SplitIfClauseCondition',
      \ 'sj#java#SplitLambda',
      \ 'sj#java#SplitFuncall',
      \ ]

if !exists('b:splitjoin_join_callbacks')
  let b:splitjoin_join_callbacks = [
        \ 'sj#java#JoinLambda',
        \ 'sj#java#JoinIfClauseCondition',
        \ 'sj#java#JoinFuncall',
        \ 'sj#java#JoinIfClauseBody',
        \ ]
